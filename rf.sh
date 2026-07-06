mkdir -p src/content/items public/items && cat > src/content.config.ts << 'CFGEOF'
import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

// Shop items. One markdown file per item in src/content/items/.
// Files starting with _ are ignored (templates, drafts).
const items = defineCollection({
  loader: glob({ pattern: '**/[^_]*.md', base: './src/content/items' }),
  schema: z.object({
    kind: z.enum(['card', 'apparel', 'other']),
    title: z.string(),
    set: z.string().optional(),
    number: z.string().optional(),
    grade: z.string().optional(),
    cert_no: z.string().optional(),
    detail: z.string().optional(),
    price_usd: z.number(),
    status: z.enum(['available', 'pending', 'sold']),
    sold_on: z.coerce.date().optional(),
    stripe_url: z.string().url().optional(),
    images: z.array(z.string()).default([]),
    origin_on: z.coerce.date().optional(),
    origin_url: z.string().url().optional(),
  }),
});

export const collections = { items };
CFGEOF
cat > src/content/items/_template.md << 'TPLEOF'
---
kind: card
title: Example Card Name
set: Example Set
number: "EX-001"
grade: raw
price_usd: 25
status: available
stripe_url: https://buy.stripe.com/test_replace_me
images:
  - items/example-front.jpg
origin_on: 2026-11-01
origin_url: https://www.twitch.tv/videos/replace_me
---
Copy this file, drop the leading underscore from the name, and fill it in.
Underscore files never render. Images live in public/items/.
For apparel: kind: apparel, use detail (size, materials) instead of set/number/grade.
TPLEOF
echo "content model in place"
