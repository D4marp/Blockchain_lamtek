# Heroku Deployment Configuration
# Using procfile dan Docker buildpacks

# ==================================================
# Web process for Frontend
# ==================================================
web-frontend: node_modules/.bin/next start -p $PORT

# ==================================================
# Web process for Backend API
# ==================================================
api: node dist/main

# ==================================================
# Worker process for background jobs
# ==================================================
worker: node dist/worker
