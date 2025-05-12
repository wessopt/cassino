FROM richarvey/nginx-php-fpm:php74

# Copy application code first
COPY . /var/www/html

# Set permissions for storage and bootstrap/cache
# Ensure www-data user (used by php-fpm and nginx) can write.
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Environment variables for the base image and Laravel
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1 # Enable execution of scripts in /var/www/html/scripts/run-once
ENV REAL_IP_HEADER 1 # If behind a load balancer like Render's

# Laravel specific environment variables (will be primarily set in Render dashboard)
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# APP_KEY, DATABASE_URL, DB_CONNECTION etc. should be set in Render's environment variables.
# The base image CMD ["/start.sh"] will:
# 1. Run composer install (if SKIP_COMPOSER=0, which is default, and vendor dir is not complete)
# 2. Run scripts in /var/www/html/scripts/runonce (if RUN_SCRIPTS=1)
# 3. Start supervisord (nginx, php-fpm)
