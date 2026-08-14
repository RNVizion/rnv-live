#!/usr/bin/env python3
"""rnv-live signal dot: split the ring off the fill so only the fill breathes.

Built against rnv-live/src/pages/index.astro @ main, fetched 2026-08-14
(10985 bytes). Fails loudly if the base has moved. Run from repo root.

WHY: rnvizion.dev took this split on 2026-08-14. The two dots are meant to read
as one mark across two mediums, and that parity is the stated justification for
a fill sitting at 2.37:1 -- so a structural change to one is a change to both or
the claim stops being true.

WHAT IT BUYS, same as on the site: the gold ring stops dimming with the fill, so
it holds 10.68:1 on --rnv-bg at every frame rather than at its worst frame. The
0.5 floor in `breathe` existed because the ring animated; it no longer does.

TWO THINGS THIS FILE HAS THAT THE SITE DOES NOT, both preserved:
  - The dot has two states. Default fill is signal-offline; `.pill.live .dot`
    swaps it to signal-live. Both selectors move to ::after together, or the
    live state silently stops applying.
  - Sizing is 0.45rem (7.2px) here and 8px on the site. NOT touched. That
    divergence predates today and the two pills have different type sizes and
    padding, so identical pixels would not mean identical appearance. If you
    want them matched, it is `width`/`height` on .dot and nothing else.
"""
import pathlib

P = pathlib.Path("src/pages/index.astro")
s = P.read_text(encoding="utf-8")

EDITS = [
    # ------------------------------------------- 1. ring keeps .dot, fill leaves
    (
        """  .dot {
    width: 0.45rem;
    height: 0.45rem;
    border-radius: 50%;
    background: var(--rnv-signal-offline);
    /* box-shadow, not border: `* { box-sizing: border-box }` means a 1px border
       would eat the 7.2px dot down to 5.2px of fill. This ring sits outside the
       box and costs no layout. It is the thing carrying the WCAG 1.4.11 boundary
       at 3:1 -- the fill deliberately does not, which is why it can be a deep
       wine. Do not remove it to "simplify"; it is load-bearing. */
    box-shadow: 0 0 0 1px var(--rnv-gold);
  }
  /* Add `live` to the pill and change the label when the stream is up. Both, or
     the colour is claiming something the word contradicts. */
  .pill.live .dot { background: var(--rnv-signal-live); }""",
        """  /* Two elements on purpose. .dot is the ring -- static chrome. ::after is the
     fill -- the state. Separating them is what lets the fill breathe while the
     boundary holds still. Do not put the fill back on .dot to "simplify"; that
     re-couples the ring to the animation and re-imposes a floor on the keyframe. */
  .dot {
    position: relative;
    width: 0.45rem;
    height: 0.45rem;
    border-radius: 50%;
    background: transparent;
    /* box-shadow, not border: `* { box-sizing: border-box }` means a 1px border
       would eat the 7.2px dot down to 5.2px of fill. This ring sits outside the
       box and costs no layout. It is the thing carrying the WCAG 1.4.11 boundary
       -- 10.68:1 on --rnv-bg, and since 2026-08-14 it does not dim, so it holds
       at every frame. The fill deliberately does not carry it, which is why it
       can be a deep wine. Do not remove it to "simplify"; it is load-bearing.
       1px is the floor: sub-pixel rings vanish on a 1x display. */
    box-shadow: 0 0 0 1px var(--rnv-gold);
  }
  .dot::after {
    content: "";
    position: absolute;
    inset: 0;
    border-radius: 50%;
    background: var(--rnv-signal-offline);
  }
  /* Add `live` to the pill and change the label when the stream is up. Both, or
     the colour is claiming something the word contradicts. The state lives on
     ::after now, with the fill -- not on .dot, which is only the ring. */
  .pill.live .dot::after { background: var(--rnv-signal-live); }""",
    ),
    # ------------------------------------------------- 2. animation follows fill
    (
        """  @media (prefers-reduced-motion: no-preference) {
    .dot { animation: breathe 3s ease-in-out infinite; }
    @keyframes breathe {
      0%, 100% { opacity: 0.5; }
      50% { opacity: 1; }
    }
  }""",
        """  @media (prefers-reduced-motion: no-preference) {
    /* On the fill, not the dot. The 0.5 dip used to be a floor -- the ring
       animated too, and dipping further put it under the 3:1 UI minimum. The
       ring no longer animates, so 0.5 is now an aesthetic choice held in common
       with rnvizion.dev rather than a constraint. Change it here and there
       together, or the two dots stop reading as one mark. */
    .dot::after { animation: breathe 3s ease-in-out infinite; }
    @keyframes breathe {
      0%, 100% { opacity: 0.5; }
      50% { opacity: 1; }
    }
  }""",
    ),
]

for i, (old, new) in enumerate(EDITS, 1):
    n = s.count(old)
    assert n == 1, f"edit {i}: expected 1 match, found {n}. Base has moved:\n{old[:100]}"
    s = s.replace(old, new)

assert s.count(".dot::after") == 3, "expected 3 ::after selectors (base fill, live state, animation)"
assert ".pill.live .dot {" not in s, "the live state is still targeting the ring"

P.write_text(s, encoding="utf-8")
print("rnv-live: ring static, fill on ::after, both states moved")
