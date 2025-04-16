FROM php:8.0-apache

# Enable mod_rewrite (if needed)
RUN a2enmod rewrite

# Set the ServerName to localhost to suppress warnings
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copy the application code into Apache's document root
COPY public/ /var/www/html/

# Copy the flag file from the build context (same directory as Dockerfile) into the image
COPY flag ../flag

# Set correct permissions and create logs directory
RUN chmod -R 755 /var/www/html && mkdir -p /var/www/html/logs && chmod 777 /var/www/html/logs

EXPOSE 80