# Configurable price-list template

A general-purpose price-list and receipt template. It is not tied to Auto Exotic or to a mechanic business. You can configure the business name, labels, currency, categories, and priced items in the administrator page. The default sample is generic; set `"preset": "mechanic"` and replace the example categories/items with workshop services and parts if you want to configure it for a mechanic business.

## Start without Supabase (default)

1. Publish `index.html` to GitHub Pages or another static host, or open it in a browser.
2. On the first visit in that browser, create the local administrator account. The first screen asks for a name and a password of at least eight characters.
3. Sign in, open **Administration**, and edit the JSON configuration. Local configuration and saved receipts are kept in that browser's `localStorage`; they are not shared across browsers or devices.

**Local-mode limitation:** the administrator account is a convenience for a single-browser installation, not server-side security. A person with access to the browser or its developer tools can access or change local data. Use Supabase mode for shared accounts and server-enforced access controls.

## Optional Supabase mode

Supabase is not contacted when both settings are blank. To opt in to shared login, configuration, and receipt data:

1. Create a Supabase project and run `supabase-shared-setup.sql` in its SQL editor.
2. In `index.html`, fill both `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` near the start of the script. Use the publishable key (or legacy anon key), **never** the service-role/secret key.
3. In Supabase **Authentication → Users**, create accounts. Public sign-up is intentionally not provided by this template.
4. Assign the initial administrator from the Supabase SQL editor, replacing the UUID with the Auth user ID:

   ```sql
   insert into public.user_roles (user_id, role)
   values ('AUTH-USER-UUID-HERE', 'admin')
   on conflict (user_id) do update set role = 'admin';
   ```

5. Create any other staff accounts in Supabase Auth and assign them the `employee` role. Supabase Row Level Security allows only admins to update the shared app configuration.

## Configuration

The administration screen edits one JSON object. Example:

```json
{
  "businessName": "My business",
  "tagline": "Price list",
  "currency": "kr",
  "customerLabel": "Customer",
  "referenceLabel": "Reference",
  "receiptLabel": "Estimate",
  "preset": "general",
  "categories": [
    { "name": "Services", "items": [{ "name": "Example service", "price": 100 }] },
    { "name": "Products", "items": [{ "name": "Example product", "price": 50 }] }
  ]
}
```

`preset` is descriptive only and can be `general`, `mechanic`, or another label. Categories and items determine what appears on the price list. Back up the configuration before substantial edits.

## Security

- Browser-only mode stores data locally and does not provide server-enforced account security.
- Supabase mode uses only a publishable/anon key in the browser. RLS policies enforce access; never put a service-role key in the HTML.
- Create Supabase users through the dashboard or a trusted server-side invitation flow. Do not enable client-side self-assignment of administrator privileges.
