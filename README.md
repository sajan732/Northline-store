# Northline Goods — ecommerce starter

A starter storefront for a small reselling business. Frontend: React/Vite. Backend/auth/database: Supabase.

## Included
- Customer product catalogue, search and cart
- Order form (orders begin in `pending` status)
- Owner login, dashboard metrics, product CRUD and order status updates
- Basic page-visit logging
- Supabase row-level security policies

## Setup
1. Create a Supabase project at https://supabase.com (free tier availability/limits can change).
2. In Supabase SQL Editor, run `supabase.sql`.
3. Create an owner user in Supabase Authentication (email/password). Confirm email if project settings require it.
4. Copy that user's UUID from Authentication > Users. In SQL editor run `insert into public.owner_users(user_id) values ('YOUR_UUID');`.
5. Copy Project URL and anon/public key from Supabase project API settings into `.env` (copy `.env.example` to `.env`). Do not put a service-role key in frontend code.
6. Install Node.js LTS. In this folder run `npm install`, then `npm run dev`. For a build, run `npm run build`.
7. Deploy the static build (`dist`) on a static hosting service such as Netlify. Add the two `VITE_SUPABASE_*` environment variables to the host.

## Important limitations / privacy
- This is a starter, not production-audited software. Test it before accepting real orders.
- No payment gateway is included. Don't mark orders `paid` unless payment is actually verified. Integrate a payment provider with server-side verification before using online payments.
- The visit counter records page-hit events, not unique people; it can overcount. Add a privacy notice and avoid collecting identifying tracking data unnecessarily.
- Order form inserts are publicly available by design; spam controls, rate limits, validation and CAPTCHA should be added before launch. Supabase RLS protects owner reads/updates.
- Public order insertion currently allows the submitted order's total and items to be supplied by the client. For production, calculate prices and totals server-side and validate product IDs/quantities using a trusted server or database function before accepting orders.
- Use a real secure payment provider; never store card numbers, CVV, or payment credentials yourself.
- Only owner users manually added to `owner_users` can access the dashboard's data. Keep your email/password secure and enable MFA.
