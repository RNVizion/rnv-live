sed -i 's|https://instagram.com/Chris_The_O.O.O|https://www.instagram.com/chris_the.o.o.o/|g' src/pages/index.astro
sed -i 's|href="https://rnvizion.dev"|href="https://rnvizion.dev/blog/"|g' src/pages/index.astro
sed -i 's|Every card sold here will tie to the moment it was pulled on camera.|Every item sold here will tie to its moment on camera: the pull, the make, the reveal.|' src/pages/index.astro
git add -A && git commit -m "fix: IG handle, blog links, shop copy generalized" && git push
