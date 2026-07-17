# Ayni Ruta mobile

## Environments

By default the app runs with `APP_ENV=mock`: Flow 0 is offline, accepts any
locally valid credentials, and keeps the profile only in memory. This is the
fastest way to develop the UI without Supabase or backend secrets:

```powershell
flutter run -d chrome
```

Use the real Supabase and Nest API only with the explicit production setting:

```powershell
flutter run -d chrome `
  --dart-define=APP_ENV=production `
  --dart-define=SUPABASE_URL=https://<project>.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=<publishable-key> `
  --dart-define=API_BASE_URL=http://localhost:3000/api/v1
```

## Flow 0 with real services

The client uses Supabase for registration and login, then calls the Nest API
with the Supabase access token to bootstrap, read, and update the profile.

Complete `backend/.env` and run the Supabase SQL seeds before testing an
authenticated flow. The mobile app needs only the Supabase public key, never
the service-role key or JWT secret.

For an Android emulator, use `http://10.0.2.2:3000/api/v1` as
`API_BASE_URL`. A physical device must use the computer's LAN address.

The endpoints used by Flow 0 are `POST /users/me/bootstrap`, `GET /users/me`,
and `PATCH /users/me`.
