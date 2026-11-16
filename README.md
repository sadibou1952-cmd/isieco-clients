# ISIECO Clients

Client Web de la plateforme ISIECO. Ce dépôt ne contient **aucune API, aucun serveur métier et aucune base de données**. Il consomme exclusivement l'API NestJS existante du dépôt [fadellba/isieco-report](https://github.com/fadellba/isieco-report), sous le préfixe `/api/v1`.

## Architecture

- **Interface** : React, TypeScript, Vite.
- **Authentification** : Supabase Auth côté navigateur ; le jeton d'accès est transmis en `Authorization: Bearer` aux routes API.
- **Données métier** : lues et modifiées uniquement par les endpoints de l'API existante.
- **Hébergement** : Render Static Site.
- **Aucun accès PostgreSQL direct** depuis ce client. Aucune clé Supabase privilégiée ou variable serveur ne doit être publiée dans le bundle.

## Construire sur Render

Le code source applicatif est stocké sous forme d'archive tar.xz fragmentée dans `.render-source/`. Le script `build-client.sh` la reconstitue dans `client/`, installe les dépendances puis exécute le build TypeScript/Vite. Le dossier publié est `client/dist`.

Commande de build Render : `bash build-client.sh`.

## Variables publiques du site

Configurer ces variables dans Render :

- `VITE_API_BASE_URL` : URL de base de l'API, par exemple `https://isieco-api-staging.onrender.com/api/v1`.
- `VITE_SUPABASE_URL` : URL du projet Supabase Auth utilisé par l'API.
- `VITE_SUPABASE_ANON_KEY` : clé publique `anon` ou `publishable` du projet Supabase. Ne jamais utiliser `service_role` ou une clé secrète.
- `VITE_MAP_TILE_URL` : modèle URL des tuiles cartographiques.
- `VITE_MAP_ATTRIBUTION` : attribution cartographique affichée.

L'interface peut être construite sans la clé publique, mais les formulaires de connexion resteront désactivés tant que `VITE_SUPABASE_ANON_KEY` n'est pas configurée.

## Configuration CORS de l'API

Après création du site Render, ajouter son origine HTTPS à `WEB_ORIGIN` sur le service API existant. Ne pas créer une deuxième API pour cela.

## Parcours métier

Les écrans s'appuient sur les rôles et statuts retournés par l'API. Les vérifications d'autorisation, de propriété, d'appartenance d'équipe, d'auteur d'intervention et de transition d'état restent du ressort exclusif du backend.
