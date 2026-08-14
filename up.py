#!/usr/bin/env python3
"""rnv-live signal dot: align the ring to 0.75px, matching rnvizion.dev.

Built against rnv-live/src/pages/index.astro @ main, fetched 2026-08-14.
Fails loudly if the base has moved. Run from repo root.

WHY ALIGN RATHER THAN HOLD AT 1px: the two dots are meant to read as one mark
across two mediums, and that parity is the stated justification for a fill
sitting under the contrast floor. A divergence retires the justification while
leaving the sentence in place -- which is the exact failure this ecosystem keeps
recording. It also costs less: one revert later instead of a tracked mismatch
that becomes intentional by age.

WHAT BOTH SURFACES NOW CARRY, measured through rnv-color-mcp:

    surface           ring     ground   composited   boundary
    rnvizion.dev      0.75px   bg-2     #a19174      6.09:1
    rnv-live          0.75px   bg       #a08f72      6.27:1

Both clear the 3:1 UI floor by roughly 2x, down from 3.4x at 1px. Sub-pixel
spread antialiases rather than vanishing, and partial coverage costs contrast
in proportion. 0.5px was rejected at ~3.35:1 -- a bare pass with no margin, on
the one element carrying the boundary for a fill that cannot.

[confirm/fill] UNVERIFIED BELOW 3x, on both surfaces now. Observed only on a 3x
phone, where 0.75px renders 2.25 device pixels. If the ring reads absent rather
than merely finer on a 1x display, revert BOTH to 1px in one pass -- the fills
at 2.43:1 and 2.56:1 cannot replace it.

ALSO ADDED: flex-shrink: 0. The site's hero dot was rendering as an ellipse at
every viewport width, squeezed on the main axis by its flex parent while its
height stayed pinned. `.pill` here is the same shape of container. It has not
been observed distorted, but the fix is one declaration and the failure is
invisible until someone looks at the proportions rather than the colour.
"""
import pathlib

P = pathlib.Path("src/pages/index.astro")
s = P.read_text(encoding="utf-8")

OLD = """  .dot {
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
  }"""

NEW = """  .dot {
    position: relative;
    width: 0.45rem;
    height: 0.45rem;
    border-radius: 50%;
    /* .pill is a flex container and flex-shrink defaults to 1, so without this
       the dot is squeezed on the main axis while its height stays pinned -- a
       circle becomes an ellipse and the ring traces the distortion. That is not
       hypothetical: it was live on rnvizion.dev's hero dot at every viewport
       width, unnoticed because everyone was looking at the colour. */
    flex-shrink: 0;
    background: transparent;
    /* box-shadow, not border: `* { box-sizing: border-box }` means a border
       would eat into the 7.2px dot rather than sitting outside it. This ring
       costs no layout, and it is the thing carrying the WCAG 1.4.11 boundary --
       since 2026-08-14 it does not dim, so it holds at every frame. The fill
       deliberately does not carry it, which is why it can be a deep wine. Do
       not remove it to "simplify"; it is load-bearing.

       0.75px, matching rnvizion.dev, and the match is the point: the two dots
       read as one mark across two mediums, which is what licenses a fill under
       the floor. Sub-pixel spread antialiases rather than vanishing, and partial
       coverage costs contrast in proportion -- 6.27:1 here on --rnv-bg, 6.09:1
       on the site's --bg-2, both roughly 2x the 3:1 minimum. 0.5px was rejected
       at ~3.35:1, a bare pass with no margin.

       [confirm/fill] Unverified below 3x. If the ring reads absent rather than
       finer on a 1x display, revert BOTH surfaces to 1px in one pass. */
    box-shadow: 0 0 0 0.75px var(--rnv-gold);
  }"""

n = s.count(OLD)
assert n == 1, f"expected 1 match, found {n}. Base has moved."
s = s.replace(OLD, NEW)

assert "0 0 0 0.75px var(--rnv-gold)" in s, "the thinner ring did not land"
assert "1px is the floor" not in s, "the overstated claim survives"
assert s.count("flex-shrink: 0;") == 1, "flex-shrink did not land exactly once"
assert s.count(".dot::after") == 3, "the ring/fill split was disturbed"

P.write_text(s, encoding="utf-8")
print("rnv-live: ring 1px -> 0.75px, aligned with rnvizion.dev; flex-shrink added")
