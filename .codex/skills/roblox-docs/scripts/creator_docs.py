#!/usr/bin/env python3
"""Manage and query a cached local checkout of Roblox creator-docs."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import statistics
import subprocess
import sys
import time
from dataclasses import asdict, dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Iterable, Sequence


REPO_URL = "https://github.com/Roblox/creator-docs.git"
SKILL_DIR = Path(__file__).resolve().parent.parent
DEFAULT_REPO_PATH = SKILL_DIR / "creator-docs"
CACHE_DIR = SKILL_DIR / ".cache"
INDEX_PATH = CACHE_DIR / "index-v1.json"
SEARCH_SUFFIXES = {".md", ".markdown", ".yaml", ".yml"}
INDEX_CANDIDATES = ("index.md", "README.md")
CONTENT_ROOT = "content/en-us"
REFERENCE_ROOT = f"{CONTENT_ROOT}/reference"
METADATA_READ_BYTES = 32768
TOPIC_ALIASES = {
    "opencloud": "content/en-us/cloud",
    "open cloud": "content/en-us/cloud",
    "cloud api": "content/en-us/cloud",
    "openapi": "content/en-us/cloud/reference/openapi.md",
    "httpservice": "content/en-us/cloud-services/http-service.md",
    "http service": "content/en-us/cloud-services/http-service.md",
    "datastore": "content/en-us/cloud-services/data-stores",
    "data store": "content/en-us/cloud-services/data-stores",
    "data stores": "content/en-us/cloud-services/data-stores",
    "memorystore": "content/en-us/cloud-services/memory-stores",
    "memory store": "content/en-us/cloud-services/memory-stores",
    "memory stores": "content/en-us/cloud-services/memory-stores",
    "engine reference": "content/en-us/reference/engine",
    "cloud reference": "content/en-us/reference/cloud",
}


@dataclass(slots=True)
class FileEntry:
    path: str
    normalized_path: str
    title: str
    summary: str
    kind: str


@dataclass(slots=True)
class TopicEntry:
    key: str
    path: str
    title: str
    summary: str
    aliases: list[str]
    children: list[str]
    index_file: str | None


def run_command(
    args: Sequence[str],
    *,
    cwd: Path | None = None,
    capture_output: bool = True,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        list(args),
        cwd=cwd,
        text=True,
        capture_output=capture_output,
        check=False,
    )


def run_git(args: Sequence[str], repo_path: Path | None = None) -> subprocess.CompletedProcess[str]:
    cmd = ["git"]
    if repo_path is not None:
        cmd.extend(["-C", str(repo_path)])
    cmd.extend(args)
    return run_command(cmd)


def repo_is_installed(repo_path: Path) -> bool:
    return (repo_path / ".git").is_dir()


def normalize_text(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "", value.lower())


def tokenize_text(value: str) -> list[str]:
    return [token.lower() for token in re.split(r"[^A-Za-z0-9]+", value) if token.strip()]


def relative_path(path: Path, repo_path: Path) -> str:
    return path.relative_to(repo_path).as_posix()


def parse_markdown_metadata(text: str) -> tuple[str, str]:
    title = ""
    summary = ""
    lines = text.splitlines()

    if lines and lines[0].strip() == "---":
        frontmatter: dict[str, str] = {}
        for line in lines[1:80]:
            stripped = line.strip()
            if stripped == "---":
                break
            if ":" not in line:
                continue
            key, value = line.split(":", 1)
            frontmatter[key.strip().lower()] = value.strip().strip("\"'")
        title = frontmatter.get("title", "")
        summary = frontmatter.get("description", "")

    if not title:
        for line in lines[:80]:
            stripped = line.strip()
            if stripped.startswith("#"):
                title = stripped.lstrip("#").strip()
                break

    if not summary:
        for line in lines[:120]:
            stripped = line.strip()
            if not stripped:
                continue
            if stripped.startswith(("#", "---", "<", "`")):
                continue
            if stripped.lower().startswith(("title:", "description:")):
                continue
            summary = stripped
            break

    return title, summary


def parse_yaml_metadata(text: str) -> tuple[str, str]:
    title = ""
    summary = ""
    lines = text.splitlines()

    for index, line in enumerate(lines[:120]):
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if stripped.startswith("name:") and not title:
            title = stripped.split(":", 1)[1].strip().strip("\"'")
        elif stripped.startswith("title:") and not title:
            title = stripped.split(":", 1)[1].strip().strip("\"'")
        elif stripped.startswith("summary:") and not summary:
            if stripped.endswith("|"):
                collected = []
                for next_line in lines[index + 1 : index + 12]:
                    if not next_line.startswith("  "):
                        break
                    collected.append(next_line.strip())
                summary = " ".join(collected).strip()
            else:
                summary = stripped.split(":", 1)[1].strip().strip("\"'")
        elif stripped.startswith("description:") and not summary:
            summary = stripped.split(":", 1)[1].strip().strip("\"'")
        if title and summary:
            break

    return title, summary


def sniff_file_metadata(path: Path) -> tuple[str, str]:
    try:
        with path.open("r", encoding="utf-8") as handle:
            text = handle.read(METADATA_READ_BYTES)
    except UnicodeDecodeError:
        return path.stem, ""

    if path.suffix.lower() in {".md", ".markdown"}:
        title, summary = parse_markdown_metadata(text)
    else:
        title, summary = parse_yaml_metadata(text)

    return title or path.stem, summary


def ensure_repo(repo_path: Path, *, quiet: bool = False) -> int:
    if repo_is_installed(repo_path):
        if not quiet:
            print(repo_path)
        return 0

    if repo_path.exists() and any(repo_path.iterdir()):
        print(
            f"Refusing to clone into non-empty path without .git metadata: {repo_path}",
            file=sys.stderr,
        )
        return 1

    repo_path.parent.mkdir(parents=True, exist_ok=True)
    result = run_git(["clone", "--depth", "1", REPO_URL, str(repo_path)])
    if result.returncode != 0:
        sys.stderr.write(result.stderr)
        return result.returncode

    invalidate_index()
    if not quiet:
        print(repo_path)
    return 0


def invalidate_index() -> None:
    if INDEX_PATH.exists():
        INDEX_PATH.unlink()


def update_repo(repo_path: Path) -> int:
    status = ensure_repo(repo_path, quiet=True)
    if status != 0:
        return status

    result = run_git(["pull", "--ff-only"], repo_path=repo_path)
    if result.returncode != 0:
        sys.stderr.write(result.stderr)
        return result.returncode

    invalidate_index()
    if result.stdout.strip():
        print(result.stdout.strip())
    return 0


def iter_source_files(repo_path: Path) -> Iterable[Path]:
    for path in repo_path.rglob("*"):
        if path.is_file() and path.suffix.lower() in SEARCH_SUFFIXES:
            yield path


def get_repo_revision(repo_path: Path) -> str:
    result = run_git(["rev-parse", "HEAD"], repo_path=repo_path)
    if result.returncode != 0:
        return "unknown"
    return result.stdout.strip() or "unknown"


def topic_alias_candidates(relative: str) -> list[str]:
    path = Path(relative)
    aliases = {relative, relative.replace("-", " "), path.name, path.stem}
    aliases.add(path.name.replace("-", " "))
    aliases.add(path.stem.replace("-", " "))
    aliases = {alias.strip().lower() for alias in aliases if alias.strip()}
    aliases.add(normalize_text(relative))
    return sorted(aliases)


def build_topic_entry(repo_path: Path, topic_path: Path) -> TopicEntry:
    relative = relative_path(topic_path, repo_path)
    children = sorted(child.name for child in topic_path.iterdir())
    index_file: Path | None = None
    for candidate in INDEX_CANDIDATES:
        maybe = topic_path / candidate
        if maybe.is_file():
            index_file = maybe
            break

    title = topic_path.name.replace("-", " ").title()
    summary = ""
    if index_file:
        title, summary = sniff_file_metadata(index_file)

    aliases = topic_alias_candidates(relative)
    if index_file:
        aliases.extend(topic_alias_candidates(relative_path(index_file, repo_path)))
    aliases = sorted({alias for alias in aliases if alias})

    return TopicEntry(
        key=normalize_text(relative),
        path=relative,
        title=title,
        summary=summary,
        aliases=aliases,
        children=children,
        index_file=relative_path(index_file, repo_path) if index_file else None,
    )


def collect_topics(repo_path: Path) -> list[TopicEntry]:
    topics: list[TopicEntry] = []
    content_root = repo_path / CONTENT_ROOT
    reference_root = repo_path / REFERENCE_ROOT

    if content_root.is_dir():
        for child in sorted(content_root.iterdir(), key=lambda item: item.name.lower()):
            if child.is_dir():
                topics.append(build_topic_entry(repo_path, child))

    if reference_root.is_dir():
        for child in sorted(reference_root.iterdir(), key=lambda item: item.name.lower()):
            if child.is_dir():
                topics.append(build_topic_entry(repo_path, child))

    return topics


def build_file_entries(repo_path: Path) -> list[FileEntry]:
    entries: list[FileEntry] = []
    for path in iter_source_files(repo_path):
        relative = relative_path(path, repo_path)
        title, summary = sniff_file_metadata(path)
        entries.append(
            FileEntry(
                path=relative,
                normalized_path=normalize_text(relative),
                title=title,
                summary=summary,
                kind=path.suffix.lower().lstrip("."),
            )
        )
    return entries


def build_index(repo_path: Path) -> dict[str, object]:
    started = time.perf_counter()
    files = build_file_entries(repo_path)
    topics = collect_topics(repo_path)
    duration_ms = (time.perf_counter() - started) * 1000

    return {
        "version": 1,
        "repo_path": str(repo_path.resolve()),
        "repo_revision": get_repo_revision(repo_path),
        "generated_at": datetime.now(UTC).isoformat(),
        "build_ms": round(duration_ms, 3),
        "file_count": len(files),
        "topic_count": len(topics),
        "files": [asdict(item) for item in files],
        "topics": [asdict(item) for item in topics],
    }


def load_index() -> dict[str, object] | None:
    if not INDEX_PATH.is_file():
        return None
    with INDEX_PATH.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def save_index(index_data: dict[str, object]) -> None:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    with INDEX_PATH.open("w", encoding="utf-8") as handle:
        json.dump(index_data, handle, indent=2, ensure_ascii=True)


def ensure_index(repo_path: Path, *, force_rebuild: bool = False) -> dict[str, object]:
    status = ensure_repo(repo_path, quiet=True)
    if status != 0:
        raise RuntimeError("Could not ensure creator-docs checkout.")

    current_revision = get_repo_revision(repo_path)
    if not force_rebuild:
        existing = load_index()
        if existing:
            if (
                existing.get("version") == 1
                and existing.get("repo_path") == str(repo_path.resolve())
                and existing.get("repo_revision") == current_revision
            ):
                return existing

    index_data = build_index(repo_path)
    save_index(index_data)
    return index_data


def resolve_topic_alias(query: str) -> str | None:
    lowered = query.strip().lower()
    normalized = normalize_text(query)
    if lowered in TOPIC_ALIASES:
        return TOPIC_ALIASES[lowered]
    if normalized in TOPIC_ALIASES:
        return TOPIC_ALIASES[normalized]
    return None


def score_topic(topic: dict[str, object], query: str) -> int:
    lowered_query = query.strip().lower()
    normalized_query = normalize_text(query)
    tokens = tokenize_text(query)

    score = 0
    path_value = str(topic["path"]).lower()
    title_value = str(topic["title"]).lower()
    summary_value = str(topic["summary"]).lower()
    aliases = [alias.lower() for alias in topic["aliases"]]

    if lowered_query in aliases:
        score += 300
    if normalized_query and normalized_query == str(topic["key"]):
        score += 280
    if normalized_query and normalized_query in normalize_text(path_value):
        score += 120
    if normalized_query and normalized_query in normalize_text(title_value):
        score += 100

    for token in tokens:
        if token in path_value:
            score += 18
        if token in title_value:
            score += 14
        if token in summary_value:
            score += 6
        if any(token in alias for alias in aliases):
            score += 20

    return score


def find_topic_matches(index_data: dict[str, object], query: str, limit: int) -> list[dict[str, object]]:
    topics = list(index_data["topics"])
    alias_target = resolve_topic_alias(query)
    if alias_target:
        direct = [topic for topic in topics if topic["path"] == alias_target]
        if direct:
            return direct[:1]

    ranked = []
    for topic in topics:
        score = score_topic(topic, query)
        if score > 0:
            ranked.append((score, topic["path"], topic))

    ranked.sort(key=lambda item: (-item[0], item[1]))
    return [topic for _, _, topic in ranked[:limit]]


def score_file(entry: dict[str, object], query: str) -> int:
    lowered_query = query.strip().lower()
    normalized_query = normalize_text(query)
    tokens = tokenize_text(query)

    path_value = str(entry["path"]).lower()
    title_value = str(entry["title"]).lower()
    summary_value = str(entry["summary"]).lower()
    normalized_path = str(entry["normalized_path"])

    score = 0
    stem = Path(path_value).stem.lower()
    if lowered_query == stem:
        score += 320
    if lowered_query == title_value:
        score += 260
    if normalized_query and normalized_query == normalized_path:
        score += 240
    if normalized_query and normalized_query in normalized_path:
        score += 110
    if normalized_query and normalized_query in normalize_text(title_value):
        score += 90

    for token in tokens:
        if token in path_value:
            score += 16
        if token in title_value:
            score += 14
        if token in summary_value:
            score += 4

    return score


def find_file_matches(index_data: dict[str, object], query: str, limit: int) -> list[dict[str, object]]:
    ranked = []
    for entry in index_data["files"]:
        score = score_file(entry, query)
        if score > 0:
            ranked.append((score, str(entry["path"]), entry))

    ranked.sort(key=lambda item: (-item[0], item[1]))
    return [entry for _, _, entry in ranked[:limit]]


def search_with_rg(
    repo_path: Path,
    query: str,
    *,
    path_fragment: str | None,
    regex: bool,
    limit: int,
) -> tuple[int, str, str]:
    cmd = [
        "rg",
        "--no-heading",
        "--line-number",
        "--color",
        "never",
        "--max-count",
        str(limit),
        "--glob",
        "*.md",
        "--glob",
        "*.markdown",
        "--glob",
        "*.yaml",
        "--glob",
        "*.yml",
    ]
    if not regex:
        cmd.append("--fixed-strings")
    cmd.append(query)
    cmd.append(str(repo_path))

    cmd[-1] = "."
    result = run_command(cmd, cwd=repo_path)
    if path_fragment:
        filtered_lines = []
        fragment = path_fragment.replace("\\", "/").lower()
        for line in result.stdout.splitlines():
            if fragment in line.split(":", 1)[0].replace("\\", "/").lower():
                filtered_lines.append(line)
            if len(filtered_lines) >= limit:
                break
        stdout = "\n".join(filtered_lines)
        if stdout:
            stdout += "\n"
        return (0 if filtered_lines else 1), stdout, result.stderr
    return result.returncode, result.stdout, result.stderr


def search_with_python(
    repo_path: Path,
    query: str,
    *,
    path_fragment: str | None,
    regex: bool,
    limit: int,
) -> tuple[int, str]:
    normalized_fragment = path_fragment.replace("\\", "/").lower() if path_fragment else None
    if regex:
        pattern = re.compile(query, re.IGNORECASE)
    else:
        lowered_query = query.lower()
        pattern = None

    lines: list[str] = []
    for path in iter_source_files(repo_path):
        relative = relative_path(path, repo_path)
        if normalized_fragment and normalized_fragment not in relative.lower():
            continue
        try:
            with path.open("r", encoding="utf-8") as handle:
                for line_number, line in enumerate(handle, start=1):
                    matched = bool(pattern.search(line)) if pattern else lowered_query in line.lower()
                    if matched:
                        lines.append(f"{relative}:{line_number}: {line.rstrip()}")
                        if len(lines) >= limit:
                            return 0, "\n".join(lines) + "\n"
        except UnicodeDecodeError:
            continue

    if lines:
        return 0, "\n".join(lines) + "\n"
    return 1, ""


def search_docs(
    repo_path: Path,
    query: str,
    *,
    path_fragment: str | None,
    regex: bool,
    limit: int,
) -> int:
    status = ensure_repo(repo_path, quiet=True)
    if status != 0:
        return status

    if shutil.which("rg"):
        code, stdout, stderr = search_with_rg(
            repo_path,
            query,
            path_fragment=path_fragment,
            regex=regex,
            limit=limit,
        )
        if stdout:
            sys.stdout.write(stdout)
            return 0
        if stderr and code not in {0, 1}:
            sys.stderr.write(stderr)
            return code

    code, stdout = search_with_python(
        repo_path,
        query,
        path_fragment=path_fragment,
        regex=regex,
        limit=limit,
    )
    if stdout:
        sys.stdout.write(stdout)
        return 0

    print("No matches found.", file=sys.stderr)
    return 1 if code == 1 else code


def resolve_show_path(repo_path: Path, index_data: dict[str, object], requested_path: str) -> Path:
    normalized = requested_path.replace("\\", "/").strip("/")
    direct = repo_path / normalized
    if direct.is_file():
        return direct

    lowered = normalized.lower()
    matches = [entry["path"] for entry in index_data["files"] if str(entry["path"]).lower().endswith(lowered)]
    if not matches:
        raise FileNotFoundError(f"Could not find file in creator-docs: {requested_path}")
    if len(matches) > 1:
        joined = "\n".join(matches[:20])
        raise FileNotFoundError(
            "Multiple files matched the requested path. Use a more specific repo-relative path:\n"
            f"{joined}"
        )
    return repo_path / matches[0]


def show_doc(repo_path: Path, requested_path: str, line_numbers: bool) -> int:
    try:
        index_data = ensure_index(repo_path)
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    try:
        path = resolve_show_path(repo_path, index_data, requested_path)
    except FileNotFoundError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    with path.open("r", encoding="utf-8") as handle:
        if line_numbers:
            for line_number, line in enumerate(handle, start=1):
                print(f"{line_number:>5}: {line.rstrip()}")
        else:
            sys.stdout.write(handle.read())
    return 0


def print_topic_map(repo_path: Path, query: str, limit: int) -> int:
    try:
        index_data = ensure_index(repo_path)
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    matches = find_topic_matches(index_data, query, limit)
    if not matches:
        print("No topic matches found.", file=sys.stderr)
        return 1

    for position, topic in enumerate(matches, start=1):
        summary = str(topic["summary"]).strip()
        print(f"{position:02d}. {topic['path']}")
        print(f"    title: {topic['title']}")
        if summary:
            print(f"    summary: {summary}")
    return 0


def print_topic_overview(repo_path: Path, query: str, child_limit: int, show_index: bool) -> int:
    try:
        index_data = ensure_index(repo_path)
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    matches = find_topic_matches(index_data, query, 1)
    if not matches:
        print("No topic matches found.", file=sys.stderr)
        return 1

    topic = matches[0]
    print(f"topic: {topic['path']}")
    print(f"title: {topic['title']}")
    if topic["summary"]:
        print(f"summary: {topic['summary']}")
    if topic["index_file"]:
        print(f"index: {topic['index_file']}")

    children = list(topic["children"])[:child_limit]
    if children:
        print("children:")
        for child in children:
            print(f"- {child}")

    if show_index and topic["index_file"]:
        print()
        return show_doc(repo_path, str(topic["index_file"]), line_numbers=False)
    return 0


def print_lookup(repo_path: Path, query: str, limit: int) -> int:
    try:
        index_data = ensure_index(repo_path)
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    matches = find_file_matches(index_data, query, limit)
    if not matches:
        print("No file matches found.", file=sys.stderr)
        return 1

    for position, entry in enumerate(matches, start=1):
        print(f"{position:02d}. {entry['path']}")
        print(f"    title: {entry['title']}")
        if entry["summary"]:
            print(f"    summary: {entry['summary']}")
    return 0


def print_topics(repo_path: Path, limit: int) -> int:
    try:
        index_data = ensure_index(repo_path)
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    topics = sorted(index_data["topics"], key=lambda item: str(item["path"]))
    for topic in topics[:limit]:
        print(f"{topic['path']}: {topic['title']}")
    return 0


def benchmark_operation(fn, repeat: int = 5) -> dict[str, float]:
    samples = []
    for _ in range(repeat):
        started = time.perf_counter()
        fn()
        samples.append((time.perf_counter() - started) * 1000)
    return {
        "min_ms": round(min(samples), 3),
        "median_ms": round(statistics.median(samples), 3),
        "max_ms": round(max(samples), 3),
    }


def legacy_topic_scan(repo_path: Path, query: str) -> str | None:
    tokens = tokenize_text(query)
    normalized_query = normalize_text(query)
    scored: list[tuple[int, int, str]] = []

    for path in repo_path.rglob("*"):
        relative = relative_path(path, repo_path)
        lowered = relative.lower()
        normalized_relative = normalize_text(relative)
        score = 0
        if normalized_query and normalized_query in normalized_relative:
            score += 10
        if lowered.endswith("/index.md") or lowered.endswith("/readme.md"):
            score += 3
        if path.is_dir():
            score += 2
        score += sum(2 for token in tokens if token in lowered)
        if score > 0:
            scored.append((score, relative.count("/"), relative))

    scored.sort(key=lambda item: (-item[0], item[1], item[2]))
    return scored[0][2] if scored else None


def run_benchmarks(repo_path: Path, topic_query: str, search_query: str, repeat: int) -> int:
    status = ensure_repo(repo_path, quiet=True)
    if status != 0:
        return status

    cold_started = time.perf_counter()
    cold_index = ensure_index(repo_path, force_rebuild=True)
    cold_build_ms = (time.perf_counter() - cold_started) * 1000
    warm_index = ensure_index(repo_path)

    results = {
        "repo_revision": warm_index["repo_revision"],
        "file_count": warm_index["file_count"],
        "topic_count": warm_index["topic_count"],
        "cold_index_build_ms": round(cold_build_ms, 3),
        "warm_index_load": benchmark_operation(lambda: ensure_index(repo_path), repeat=repeat),
        "legacy_topic_scan": benchmark_operation(lambda: legacy_topic_scan(repo_path, topic_query), repeat=repeat),
        "indexed_topic_lookup": benchmark_operation(
            lambda: find_topic_matches(warm_index, topic_query, 1),
            repeat=repeat,
        ),
        "indexed_symbol_lookup": benchmark_operation(
            lambda: find_file_matches(warm_index, search_query, 5),
            repeat=repeat,
        ),
        "rg_search": None,
        "python_search": benchmark_operation(
            lambda: search_with_python(
                repo_path,
                search_query,
                path_fragment=None,
                regex=False,
                limit=20,
            ),
            repeat=repeat,
        ),
    }

    if shutil.which("rg"):
        results["rg_search"] = benchmark_operation(
            lambda: search_with_rg(
                repo_path,
                search_query,
                path_fragment=None,
                regex=False,
                limit=20,
            ),
            repeat=repeat,
        )

    print(json.dumps(results, indent=2))
    return 0


def print_index_status(repo_path: Path) -> int:
    try:
        index_data = ensure_index(repo_path)
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    payload = {
        "repo_revision": index_data["repo_revision"],
        "generated_at": index_data["generated_at"],
        "build_ms": index_data["build_ms"],
        "file_count": index_data["file_count"],
        "topic_count": index_data["topic_count"],
        "index_path": str(INDEX_PATH.resolve()),
    }
    print(json.dumps(payload, indent=2))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--repo-path",
        default=os.environ.get("ROBLOX_CREATOR_DOCS_PATH", str(DEFAULT_REPO_PATH)),
        help="Path to the cached creator-docs checkout.",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("ensure", help="Install creator-docs locally if missing.")
    subparsers.add_parser("update", help="Fast-forward update the cached local checkout.")
    subparsers.add_parser("index-status", help="Show metadata about the cached local index.")

    search_parser = subparsers.add_parser("search", help="Search the local creator-docs checkout.")
    search_parser.add_argument("query", help="Search term or regex.")
    search_parser.add_argument("--regex", action="store_true", help="Interpret query as regex.")
    search_parser.add_argument(
        "--path-fragment",
        help="Limit search to files whose repo-relative path contains this fragment.",
    )
    search_parser.add_argument("--limit", type=int, default=80, help="Maximum number of matches.")

    map_parser = subparsers.add_parser("map", help="Rank canonical topics for a broad query.")
    map_parser.add_argument("query", help="Topic to resolve.")
    map_parser.add_argument("--limit", type=int, default=10, help="Maximum number of topics.")

    topic_parser = subparsers.add_parser(
        "topic",
        help="Show the best matching canonical topic with metadata and children.",
    )
    topic_parser.add_argument("query", help="Topic to inspect.")
    topic_parser.add_argument("--child-limit", type=int, default=20, help="Maximum child entries.")
    topic_parser.add_argument(
        "--show-index",
        action="store_true",
        help="Also print the raw index file after the topic summary.",
    )

    lookup_parser = subparsers.add_parser(
        "lookup",
        help="Resolve exact or near-exact symbols to the most relevant files using the local index.",
    )
    lookup_parser.add_argument("query", help="Class, service, enum, or file-like symbol to resolve.")
    lookup_parser.add_argument("--limit", type=int, default=10, help="Maximum matches to print.")

    topics_parser = subparsers.add_parser("topics", help="List canonical top-level topics.")
    topics_parser.add_argument("--limit", type=int, default=200, help="Maximum topics to print.")

    show_parser = subparsers.add_parser("show", help="Print an exact local file from creator-docs.")
    show_parser.add_argument("path", help="Repo-relative path or unique suffix to show.")
    show_parser.add_argument("--line-numbers", action="store_true", help="Prefix output with lines.")

    benchmark_parser = subparsers.add_parser("benchmark", help="Run internal performance benchmarks.")
    benchmark_parser.add_argument("--topic-query", default="open cloud", help="Broad topic benchmark query.")
    benchmark_parser.add_argument(
        "--search-query",
        default="HumanoidDescription",
        help="Text search benchmark query.",
    )
    benchmark_parser.add_argument("--repeat", type=int, default=5, help="Number of benchmark repetitions.")

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    repo_path = Path(args.repo_path).resolve()

    if args.command == "ensure":
        return ensure_repo(repo_path)
    if args.command == "update":
        return update_repo(repo_path)
    if args.command == "index-status":
        return print_index_status(repo_path)
    if args.command == "search":
        return search_docs(
            repo_path,
            args.query,
            path_fragment=args.path_fragment,
            regex=args.regex,
            limit=args.limit,
        )
    if args.command == "map":
        return print_topic_map(repo_path, args.query, args.limit)
    if args.command == "topic":
        return print_topic_overview(repo_path, args.query, args.child_limit, args.show_index)
    if args.command == "lookup":
        return print_lookup(repo_path, args.query, args.limit)
    if args.command == "topics":
        return print_topics(repo_path, args.limit)
    if args.command == "show":
        return show_doc(repo_path, args.path, args.line_numbers)
    if args.command == "benchmark":
        return run_benchmarks(repo_path, args.topic_query, args.search_query, args.repeat)

    parser.error(f"Unknown command: {args.command}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
