python3 << 'PYEOF'
from pathlib import Path
p = Path('src/pages/index.astro')
s = p.read_text()
before = s

s = s.replace(
    '<span class="pillar-desc">Tools, engines, and MCP servers, built in public.</span>',
    '<span class="pillar-desc">Crafting a thought.</span>'
)
s = s.replace(
    '<span class="pillar-desc">Essays on building with intention.</span>',
    '<span class="pillar-desc">A moment of thought.</span>'
)
s = s.replace(
    '''<a href="https://huggingface.co/RNVizion">
            <span class="pillar-title">Making</span>
            <span class="pillar-desc">Live demos and models on Hugging Face.</span>
          </a>''',
    '''<a href="https://www.instagram.com/chris_the.o.o.o/">
            <span class="pillar-title">Making</span>
            <span class="pillar-desc">Thought in motion.</span>
          </a>'''
)
s = s.replace(
    '''<a href="https://www.instagram.com/chris_the.o.o.o/">
            <span class="pillar-title">Fashion</span>
            <span class="pillar-desc">The render-to-reality lane.</span>
          </a>''',
    '''<a href="https://www.instagram.com/rnv_apparel/">
            <span class="pillar-title">Fashion</span>
            <span class="pillar-desc">From render to reality.</span>
          </a>'''
)

assert s != before and s.count('rnv_apparel') == 1, 'replacement check failed'
p.write_text(s)
print('patched')
PYEOF

sed -i 's|From render to reality.|A thought you can wear.|' src/pages/index.astro


git add -A && git commit -m "pillars: thought motif + link retargets" 

git commit -m "fashion pillar: a thought you can wear" 

git push
