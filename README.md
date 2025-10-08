# Laravel 12 Lightweight Coder Template

A lightweight Coder template for Laravel 12 development with minimal dependencies.

## Features

- **PHP 8.2** - Required for Laravel 12
- **Laravel 12** - Latest version of the Laravel framework
- **Node.js 20 LTS** - For frontend asset compilation
- **Composer** - PHP dependency manager
- **VS Code (code-server)** - Web-based IDE
- **Git** - Version control
- **SQLite** - Default database (lightweight)

## What's Included (Lightweight)

### Core Components
- PHP 8.2 CLI with essential extensions (zip, pdo, pdo_sqlite)
- Node.js 20 LTS
- Composer
- Laravel installer
- Git
- VS Code (code-server)

### Applications
- **VS Code**: Accessible at the "VS Code" app in your workspace
- **Laravel App**: Accessible at the "Laravel App" app (when running `php artisan serve`)

## Getting Started

1. **Create a workspace** using this template in Coder
2. **Open VS Code** from the workspace applications
3. **Navigate to the workspace directory**:
   ```bash
   cd ~/workspace
   ```

### For New Laravel Projects

A Laravel project will be automatically created during workspace startup:

```bash
cd ~/workspace/laravel-app
```

### For Existing Projects

1. Clone your existing Laravel project:
   ```bash
   cd ~/workspace
   git clone <your-repo-url>
   cd <your-project>
   ```

2. Install dependencies:
   ```bash
   composer install
   npm install
   ```

3. Set up environment:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

## Running Your Laravel Application

1. **Start the development server**:
   ```bash
   cd ~/workspace/laravel-app
   php artisan serve --host=0.0.0.0 --port=8000
   ```

2. **Access your app** via the "Laravel App" application in your Coder workspace

3. **For frontend development**:
   ```bash
   npm run dev
   ```

## Database Setup

### SQLite (Default - Lightweight)
Laravel 12 uses SQLite by default. Run migrations:
```bash
php artisan migrate
```

## Useful Commands

```bash
# Laravel commands
php artisan make:controller UserController
php artisan make:model User
php artisan migrate
php artisan serve

# Composer commands
composer install
composer require package/name

# NPM commands
npm install
npm run dev
npm run build

# Git commands
git status
git add .
git commit -m "Your message"
git push
```

## Lightweight Design

This template is designed to be minimal and fast:
- Uses official PHP Docker image (smaller size)
- Only essential PHP extensions included
- No additional development tools pre-installed
- SQLite for lightweight database
- Minimal system dependencies

## Template Structure

```
laravel-12-lightweight/
├── main.tf              # Terraform configuration
├── build/
│   ├── Dockerfile       # Lightweight container image
│   └── config.yaml      # Code-server configuration
├── .coder/
│   └── template.yaml    # Template metadata
└── README.md           # This file
```

## Requirements

- Coder v2.0+
- Docker provider
- Minimal resources (recommended: 1 CPU core, 2GB RAM)

This lightweight template provides a fast, efficient Laravel 12 development environment with minimal overhead.
