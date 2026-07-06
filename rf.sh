python3 << 'PYEOF'
from pathlib import Path
p = Path('src/pages/index.astro')
s = p.read_text()
before = s

s = s.replace(
    '<span class="pill"><span class="dot"></span>OFFLINE</span>',
    '<a class="pill" href="https://www.twitch.tv/chris_the_ooo"><span class="dot"></span>OFFLINE</a>'
)

s = s.replace(
    '''<a href="https://github.com/RNVizion">GitHub</a> ·
          <a href="https://huggingface.co/RNVizion">Hugging Face</a> ·
          <a href="https://www.instagram.com/chris_the.o.o.o/">Instagram</a> ·
          <a href="https://rnvizion.dev/blog/">Blog</a>''',
    '''<a href="https://www.twitch.tv/chris_the_ooo">Twitch</a> ·
          <a href="https://www.tiktok.com/@chris_the_.o.o.o">TikTok</a> ·
          <a href="https://www.instagram.com/chris_the.o.o.o/">Instagram</a> ·
          <a href="https://github.com/RNVizion">GitHub</a> ·
          <a href="https://huggingface.co/RNVizion">Hugging Face</a> ·
          <a href="https://rnvizion.dev/blog/">Blog</a>'''
)

s = s.replace(
    '''  .pill {
    display: inline-flex;''',
    '''  .pill {
    text-decoration: none;
    display: inline-flex;'''
)

assert s != before, 'no replacements applied'
p.write_text(s)
print('patched')
PYEOF

git add -A && git commit -m "socials: content layer added, pill links to channel" && git push
