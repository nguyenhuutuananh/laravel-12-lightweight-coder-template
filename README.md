# Laravel 12 Lightweight Coder Template

A minimal Coder template for Laravel 12 development.

## What's Included

- PHP 8.2 with essential extensions
- Laravel 12
- Node.js 20 LTS
- Composer & Git
- VS Code (code-server)
- SQLite database

## Quick Start

1. Create a workspace using this template
2. Open VS Code from workspace apps
3. A Laravel project is auto-created at `~/workspace/laravel-app` (or your custom directory name)

### Start Development Server

```bash
cd ~/workspace/laravel-app
php artisan serve --host=0.0.0.0 --port=8000
```

Access your app via the "Laravel App" in your workspace.

### Run Migrations

```bash
php artisan migrate
```

### Frontend Development

```bash
npm run dev
```

## Using Existing Projects

```bash
cd ~/workspace
git clone <your-repo-url>
cd <your-project>
composer install
npm install
cp .env.example .env
php artisan key:generate
```

## Requirements

- Coder v2.0+
- Docker provider
- Recommended: 1 CPU core, 2GB RAM
