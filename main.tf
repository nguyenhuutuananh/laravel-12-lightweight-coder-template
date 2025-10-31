terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
}

provider "coder" {
}

data "coder_workspace" "me" {
}

data "coder_parameter" "php_version" {
  name         = "PHP Version"
  description  = "Select the PHP version to use"
  type         = "string"
  default      = "8.2"
  mutable      = false
  icon         = "https://www.php.net/images/logos/new-php-logo.svg"

  option {
    name  = "PHP 8.1"
    value = "8.1"
  }
  option {
    name  = "PHP 8.2"
    value = "8.2"
  }
  option {
    name  = "PHP 8.3"
    value = "8.3"
  }
  option {
    name  = "PHP 8.4"
    value = "8.4"
  }
}

data "coder_parameter" "dotfiles_url" {
  name         = "Dotfiles URL"
  description  = "Personalize your workspace"
  type         = "string"
  default      = ""
  mutable      = true
  icon         = "https://git-scm.com/images/logos/downloads/Git-Icon-1788C.png"
}

data "coder_parameter" "init_laravel_project" {
  name         = "Initialize Laravel Project"
  description  = "Automatically create a new Laravel 12 project in the workspace if none exists"
  type         = "bool"
  default      = false
  mutable      = false
  icon         = "https://laravel.com/img/logomark.min.svg"
}

resource "coder_agent" "main" {
  os   = "linux"
  arch = "arm64"  # Changed from "amd64"
  startup_script = <<-EOT
    set -e

    # Create workspace directory
    mkdir -p ~/workspace
    cd ~/workspace

    # Install dotfiles if provided
    if [ -n "${data.coder_parameter.dotfiles_url.value}" ]; then
      echo "Installing dotfiles from ${data.coder_parameter.dotfiles_url.value}"
      coder dotfiles -y ${data.coder_parameter.dotfiles_url.value}
    fi

    # Create a sample Laravel project if parameter is enabled and workspace is empty
    if [ "${data.coder_parameter.init_laravel_project.value}" = "true" ]; then
      if [ ! -f "composer.json" ] && [ ! -d "laravel-app" ]; then
        echo "Creating new Laravel 12 project..."
        composer create-project laravel/laravel laravel-app --prefer-dist
        cd laravel-app

        # Set proper permissions
        chmod -R 775 storage bootstrap/cache

        # Install frontend dependencies
        npm install

        # Generate application key
        php artisan key:generate

        # Run initial migration (SQLite by default)
        php artisan migrate --force

        echo "Laravel project created successfully!"
        echo "Navigate to ~/workspace/laravel-app to start developing"
        echo "Run 'php artisan serve --host=0.0.0.0 --port=8000' to start the development server"
      else
        echo "Laravel project already exists or init_laravel_project is disabled"
      fi
    else
      echo "Laravel project initialization is disabled. Set 'Initialize Laravel Project' to true to auto-create a project."
    fi
  EOT

  env = {
    GIT_AUTHOR_NAME     = "coder"
    GIT_COMMITTER_NAME  = "coder"
    GIT_AUTHOR_EMAIL    = "coder@example.com"
    GIT_COMMITTER_EMAIL = "coder@example.com"
  }

  dir = "/home/coder"
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "VS Code"
  url          = "http://localhost:13337?folder=/home/coder/workspace"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "laravel" {
  agent_id     = coder_agent.main.id
  slug         = "laravel"
  display_name = "Laravel App"
  url          = "http://localhost:8000"
  icon         = "https://laravel.com/img/logomark.min.svg"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:8000"
    interval  = 10
    threshold = 5
  }
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.id}-home"
  lifecycle {
    ignore_changes = all
  }
}

resource "docker_image" "main" {
  name = "coder-${data.coder_workspace.me.id}"
  build {
    context = "./build"
    dockerfile = "Dockerfile"
    build_args = {
      USER        = "coder"
      PHP_VERSION = data.coder_parameter.php_version.value
    }
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "build/*") : filesha1(f)]))
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.main.name
  name = "coder-${data.coder_workspace.me.id}-${lower(data.coder_workspace.me.name)}"
  hostname = data.coder_workspace.me.name
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
  volumes {
    container_path = "/home/coder"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }
}

resource "coder_metadata" "container_info" {
  count       = data.coder_workspace.me.start_count
  resource_id = docker_container.workspace[0].id

  item {
    key   = "image"
    value = docker_image.main.name
  }
  item {
    key   = "container"
    value = docker_container.workspace[0].name
  }
  item {
    key   = "PHP Version"
    value = data.coder_parameter.php_version.value
  }
}
