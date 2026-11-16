# ISIECO Clients

Interfaces Web et Mobile de la plateforme ISIECO, consommatrices de l'API REST `isieco-report` (`/api/v1`).

- `apps/web` : back-office React/Vite, centre de commandement et modules métiers selon habilitations.
- `apps/mobile` : application Expo destinée aux citoyens et agents de terrain.
- `packages/api-client` : client HTTP partagé avec transmission du jeton Supabase.
- `packages/shared` : contrats de rôles, statuts et types partagés.

Les clients s'authentifient avec Supabase Auth et transmettent le jeton d'accès à l'API. Aucun client ne se connecte directement à PostgreSQL et aucune clé privilégiée Supabase ne doit être ajoutée au bundle.

Voir `.env.example` pour les variables publiques à configurer. Les écrans et parcours métier sont alignés sur les contrôleurs, DTO et règles de l'API source.
