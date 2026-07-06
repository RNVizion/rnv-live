rm -rf tmp-astro
mkdir -p src/pages src/styles

cat > package.json << 'PKGEOF'
{
  "name": "live",
  "type": "module",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "astro dev",
    "build": "astro build",
    "preview": "astro preview"
  },
  "dependencies": {
    "astro": "^5.0.0"
  }
}
PKGEOF

cat > astro.config.mjs << 'CFGEOF'
import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://rnvizion.dev',
  base: '/live',
});
CFGEOF

cat > tsconfig.json << 'TSEOF'
{
  "extends": "astro/tsconfigs/base"
}
TSEOF

cat > src/pages/index.astro << 'PAGEEOF'
---
import '../styles/tokens.css';
---
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>RNVizion · live</title>
  </head>
  <body>
    <main>
      <p class="kicker">RNVIZION</p>
      <h1>The page is alive.</h1>
      <p class="note">Portfolio, shop, and live embed land here.</p>
    </main>
  </body>
</html>
<style>
  body {
    margin: 0;
    min-height: 100vh;
    background: var(--rnv-bg-0);
    color: var(--rnv-text);
    font-family: system-ui, sans-serif;
    display: grid;
    place-items: center;
  }
  main {
    text-align: center;
    padding: 2rem;
  }
  .kicker {
    color: var(--rnv-gold);
    font-family: ui-monospace, monospace;
    letter-spacing: 0.3em;
    font-size: 0.8rem;
  }
  h1 {
    font-weight: 600;
  }
  .note {
    color: var(--rnv-text-dim);
    border-top: 1px solid var(--rnv-rule);
    padding-top: 1rem;
  }
</style>
PAGEEOF

cat > .gitignore << 'GIEOF'
node_modules/
dist/
.astro/
src/styles/tokens.css
rnv-brand/
GIEOF

npm install
git clone https://github.com/RNVizion/rnv-brand
python3 rnv-brand/engine/brand.py --css web > src/styles/tokens.css
