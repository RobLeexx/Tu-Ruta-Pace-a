# Ayni Ruta mobile

## Flow 0 with real services

The client uses Supabase for registration and login, then calls the Nest API
with the Supabase access token to bootstrap, read, and update the profile.

Complete `backend/.env` and run the Supabase SQL seeds before testing an
authenticated flow. The mobile app needs only the Supabase public key, never
the service-role key or JWT secret.

Run in Chrome:

```powershell
flutter run -d chrome `
  --dart-define=SUPABASE_URL=https://<project>.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=<publishable-key> `
  --dart-define=API_BASE_URL=http://localhost:3000/api/v1
```

For an Android emulator, use `http://10.0.2.2:3000/api/v1` as
`API_BASE_URL`. A physical device must use the computer's LAN address.

The endpoints used by Flow 0 are `POST /users/me/bootstrap`, `GET /users/me`,
and `PATCH /users/me`.
