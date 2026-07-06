sed -i 's|https://www.tiktok.com/@chris_the_.o.o.o|https://www.tiktok.com/@chris_the.o.o.o|' src/pages/index.astro
git add -A && git commit -m "fix: tiktok handle matched to canonical" && git push
