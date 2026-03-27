# Embedding: interrupts (CPU limits)

## When to read this

- You need to stop runaway scripts or enforce execution time limits.

## Key points

- Embedders can install a VM-level interrupt handler.
- The VM guarantees that long-running scripts eventually hit interrupt check points (e.g. at calls/loop iterations).

## Typical usage

- A watchdog enforces a per-script time budget (e.g. “10 seconds in Studio” style setups).
- Shutdown sequences can interrupt all scripts after a grace period.

