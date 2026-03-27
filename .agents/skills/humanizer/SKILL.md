---

name: humanizer
description: |
  Remove common AI-writing patterns and rewrite text to sound natural and human-written. Use when editing/reviewing prose (docs, READMEs, blog posts, emails, PRDs) that feels LLM-ish: inflated significance, promotional tone, vague attributions, repetitive rhythm, over-hedging, em dash abuse, template conclusions, and generic filler.
---

---

# Humanizer

## Goal

Rewrite text so it reads like a competent human wrote it: specific, grounded, and with a real voice—without changing meaning.

## When to use

Use when the text:

- sounds like a press release or Wikipedia summary
- overstates importance (“pivotal”, “testament”, “groundbreaking”)
- relies on vague actors (“industry experts”, “research suggests”)
- uses filler scaffolding (“In conclusion”, “It is worth noting”, “At its core”)
- repeats patterns (rule-of-three, synonym cycling, same sentence shape)

Avoid when you need exact wording (legal/compliance) or strict neutrality.

## Workflow

1. Clarify the target voice (if unclear): casual / formal / technical / spicy / neutral.
2. Mark AI-ish spans, then rewrite with concrete nouns/verbs and fewer qualifiers.
3. Replace vague attribution with: a specific source, a named role with context, or a clear “I think / I’m not sure” for opinions.
4. Fix rhythm: mix sentence lengths; remove template-y transitions.
5. Final pass: remove chatbot artifacts (“Let me know if…”), emoji, and excessive formatting unless requested.

## Rules

- Preserve facts and intent; do not invent sources, numbers, or quotes.
- Keep citations/links unless the user asks to remove them.

## Output

- Revised text.
- Optional short “changes made” list when helpful.

## Reference

Use `.agents/skills/humanizer/references/full-guide.md` as the full pattern catalog and examples.

