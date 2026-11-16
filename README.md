# ISIECO Clients

Dépôt destiné aux interfaces Web et Mobile de la plateforme ISIECO, consommatrices de l'API REST `isieco-report` (`/api/v1`).

## Périmètre prévu

- `apps/web` : back-office React/Vite, centre de commandement et modules métiers selon habilitations.
- `apps/mobile` : application Expo destinée aux citoyens et agents de terrain.
- `packages/api-client` : client HTTP partagé avec transmission du jeton Supabase.
- `packages/shared` : contrats de rôles, statuts et types partagés.

## Sécurité API

Les clients doivent s'authentifier via Supabase Auth, puis transmettre le jeton d'accès à l'API. Aucun client ne se connecte directement à PostgreSQL. Aucune clé Supabase privilégiée, aucun `DATABASE_URL` ou `DIRECT_URL` ne doivent être intégrés au bundle client.

## État du dépôt

Le dépôt a été initialisé. **Le code applicatif n'a pas encore été poussé dans cette branche** : la source prête à intégrer est fournie séparément sous forme d'archive de projet dans la conversation. Le déploiement Render n'a pas été lancé depuis ce dépôt.

Avant publication, configurer les variables publiques `VITE_API_BASE_URL`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, puis autoriser l'origine Render dans `WEB_ORIGIN` côté API.
