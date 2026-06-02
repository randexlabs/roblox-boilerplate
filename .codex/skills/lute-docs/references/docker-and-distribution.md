# Docker and Distribution

## Release Channels

Lute is distributed through:

- stable semantic-versioned releases
- nightly builds
- official container images on stable releases
- toolchain-manager installation via Rokit and Foreman

## Stable vs Nightly

### Stable

- stable releases follow semantic versioning
- they are available on the GitHub releases page
- they are the basis for official container publication

### Nightly

- nightlies are unstable builds
- they can still be installed via the same toolchain-manager flows
- version strings follow a nightly form such as `0.1.0-nightly.2024-06-01`

## Toolchain Manager Distribution

### Rokit

```bash
rokit add luau-lang/lute@1.0.0
```

### Foreman

```toml
[tools]
lute = { github = "luau-lang/lute", version = "1.0.0" }
```

Then:

```bash
foreman install
```

## Official Docker Images

The docs state that official images are published to GitHub Container Registry on every stable, non-nightly release.

Supported architectures:

- `linux/amd64`
- `linux/arm64`

## Image Variants

| Image                               | Base                            | Recommended use                                    |
| ----------------------------------- | ------------------------------- | -------------------------------------------------- |
| `ghcr.io/luau-lang/lute`            | `debian:stable-slim`            | Default image with shell and common utilities.     |
| `ghcr.io/luau-lang/lute:distroless` | `gcr.io/distroless/cc-debian13` | Minimal runtime image with smaller attack surface. |
| `ghcr.io/luau-lang/lute:bin`        | `scratch`                       | Binary-only image intended for multi-stage builds. |

## Tag Strategy

For a release `X.Y.Z`, the docs say the workflow publishes:

### Default Debian Variant

- `latest`
- `X`
- `X.Y`
- `X.Y.Z`
- `debian`
- `debian-X`
- `debian-X.Y`
- `debian-X.Y.Z`

### Distroless Variant

- `distroless`
- `distroless-X`
- `distroless-X.Y`
- `distroless-X.Y.Z`

### Binary-Only Variant

- `bin`
- `bin-X`
- `bin-X.Y`
- `bin-X.Y.Z`

## Pinning Guidance

The docs provide explicit reproducibility guidance:

- pin `X.Y.Z` for reproducible builds
- pin `X.Y` to receive patch updates
- pin `X` to receive minor and patch updates within a major line

## Running Lute in Containers

Show the CLI help using the default container `CMD`:

```bash
docker run --rm ghcr.io/luau-lang/lute
```

Run a script from the current directory:

```bash
docker run --init --rm -it -v "$PWD:/app" -w /app ghcr.io/luau-lang/lute run script.luau
```

Open a shell in the Debian variant:

```bash
docker run --rm -it ghcr.io/luau-lang/lute sh
```

Operational note preserved from the docs:

- `--init` is recommended so signals like `Ctrl+C` are forwarded correctly to `lute`

Mounting details preserved:

- `-v "$PWD:/app"` mounts the current directory into the container
- `-w /app` sets it as the working directory

## Dockerfile Patterns

### Extend the Default Runtime Image

```dockerfile
FROM ghcr.io/luau-lang/lute:1

WORKDIR /app
COPY . .

CMD ["run", "server.luau"]
```

### Copy the Binary Into Another Base Image

```dockerfile
FROM ubuntu:24.04

COPY --from=ghcr.io/luau-lang/lute:bin /lute /usr/local/bin/

CMD ["lute", "--help"]
```
