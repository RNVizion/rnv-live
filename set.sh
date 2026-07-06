sed -i "s|base: '/live'|base: '/rnv-live'|" astro.config.mjs
git add -A && git commit -m "base: /rnv-live to match repo name" && git push
