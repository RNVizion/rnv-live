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
