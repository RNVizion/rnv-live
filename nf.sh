python3 << 'PYEOF'
from pathlib import Path
p = Path('src/pages/index.astro')
s = p.read_text()
before = s

s = s.replace(
    """---
import '../styles/tokens.css';""",
    """---
import { getCollection } from 'astro:content';
import '../styles/tokens.css';""",
    1
)
s = s.replace(
    """import '@fontsource/instrument-serif/400-italic.css';
---""",
    """import '@fontsource/instrument-serif/400-italic.css';

const statusOrder = { available: 0, pending: 1, sold: 2 };
const items = (await getCollection('items')).sort(
  (a, b) =>
    statusOrder[a.data.status] - statusOrder[b.data.status] ||
    a.data.title.localeCompare(b.data.title)
);
const base = import.meta.env.BASE_URL.replace(/\\/+$/, '');
const withBase = (p) => `${base}/${String(p).replace(/^\\/+/, '')}`;
const metaLine = (d) =>
  d.kind === 'card'
    ? [d.set, d.number, d.grade && (d.cert_no ? `${d.grade} · cert ${d.cert_no}` : d.grade)]
        .filter(Boolean)
        .join(' · ')
    : d.detail;
---""",
    1
)

s = s.replace(
    """      <section>
        <p class="kicker">SHOP</p>
        <h2>The shop opens soon.</h2>
        <p class="dek">Every item sold here will tie to its moment on camera: the pull, the make, the reveal.</p>
      </section>""",
    """      <section>
        <p class="kicker">SHOP</p>
        {items.length === 0 ? (
          <>
            <h2>The shop opens soon.</h2>
            <p class="dek">Every item sold here will tie to its moment on camera: the pull, the make, the reveal.</p>
          </>
        ) : (
          <>
            <h2>The shop.</h2>
            <p class="dek">Every item ties to its moment on camera: the pull, the make, the reveal.</p>
            <div class="grid">
              {items.map((item) => (
                <article class={`item ${item.data.status}`}>
                  {item.data.images[0] && (
                    <img
                      src={withBase(item.data.images[0])}
                      alt={`${item.data.title}${item.data.grade ? ', ' + item.data.grade : ''}`}
                      loading="lazy"
                    />
                  )}
                  <h3>{item.data.title}</h3>
                  {metaLine(item.data) && <p class="item-meta">{metaLine(item.data)}</p>}
                  <p class={`price ${item.data.status === 'sold' ? 'struck' : ''}`}>
                    ${item.data.price_usd}
                    {item.data.status === 'sold' && <span class="sold-tag">SOLD</span>}
                  </p>
                  {item.data.origin_url && (
                    <a class="origin" href={item.data.origin_url}>the moment, on camera</a>
                  )}
                  {item.data.status === 'available' && item.data.stripe_url ? (
                    <a class="buy" href={item.data.stripe_url}>BUY</a>
                  ) : item.data.status === 'available' ? (
                    <span class="buy soon">SOON</span>
                  ) : item.data.status === 'pending' ? (
                    <span class="buy soon">PENDING</span>
                  ) : null}
                </article>
              ))}
            </div>
          </>
        )}
      </section>""",
    1
)

s = s.replace(
    """  a:focus-visible {""",
    """  .grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1rem;
    margin-top: 1.5rem;
  }
  @media (min-width: 520px) {
    .grid { grid-template-columns: 1fr 1fr; }
  }
  .item {
    background: var(--rnv-bg-1);
    border: 1px solid var(--rnv-border-soft);
    border-radius: 6px;
    padding: 1rem;
  }
  .item img {
    width: 100%;
    height: auto;
    border-radius: 4px;
    margin-bottom: 0.75rem;
  }
  .item h3 {
    font-family: var(--rnv-font-display), system-ui, sans-serif;
    font-weight: 600;
    font-size: 1.05rem;
    margin: 0 0 0.25rem;
  }
  .item-meta {
    color: var(--rnv-text-dim);
    font-size: 0.85rem;
    margin: 0 0 0.5rem;
  }
  .price {
    font-family: var(--rnv-font-mono), ui-monospace, monospace;
    color: var(--rnv-gold);
    font-weight: 700;
    margin: 0 0 0.75rem;
  }
  .price.struck { text-decoration: line-through; color: var(--rnv-text-faint); }
  .sold-tag {
    text-decoration: none;
    display: inline-block;
    margin-left: 0.6rem;
    color: var(--rnv-gold);
    letter-spacing: 0.18em;
    font-size: 0.7rem;
  }
  .origin {
    display: block;
    font-family: var(--rnv-font-mono), ui-monospace, monospace;
    font-size: 0.72rem;
    letter-spacing: 0.08em;
    color: var(--rnv-text-dim);
    text-decoration: none;
    margin-bottom: 0.75rem;
  }
  .origin:hover { color: var(--rnv-gold); }
  .buy {
    display: block;
    text-align: center;
    font-family: var(--rnv-font-mono), ui-monospace, monospace;
    font-weight: 700;
    letter-spacing: 0.14em;
    font-size: 0.8rem;
    padding: 0.6rem 0;
    border-radius: 4px;
    background: var(--rnv-gold);
    color: var(--rnv-bg-0);
    text-decoration: none;
  }
  .buy.soon {
    background: transparent;
    color: var(--rnv-text-faint);
    border: 1px solid var(--rnv-border);
  }
  a:focus-visible {""",
    1
)

assert s != before and 'getCollection' in s, 'patch failed; stop and report'
p.write_text(s)
print('grid wired')
PYEOF

git add -A && git commit -m "w2: content model + shop grid, dormant until first item" && git push
