# Usar uma imagem base estável com PHP 7.4, Nginx e FPM
FROM webdevops/php-nginx:7.4

# Definir variáveis de ambiente
# O WEB_DOCUMENT_ROOT é /app/public por defeito nesta imagem, o que é correto para Laravel.
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
# Outras variáveis como APP_KEY, DATABASE_URL serão definidas no painel da Render.

# Copiar o código da aplicação para o diretório /app da imagem
COPY . /app

# Copiar o script de deploy para o diretório de scripts de inicialização da imagem.
# Os scripts em /docker-entrypoint.d/ são executados na inicialização do container.
# O nome começa com um número para controlar a ordem de execução.
COPY ./scripts/runonce/01-laravel-deploy.sh /docker-entrypoint.d/30-laravel-deploy.sh

# Tornar o script de deploy executável
RUN chmod +x /docker-entrypoint.d/30-laravel-deploy.sh

# Ajustar permissões para os diretórios de storage e cache do Laravel.
# A imagem webdevops/php-nginx usa o utilizador 'application' (UID 1000).
RUN chown -R application:application /app/storage /app/bootstrap/cache && \
    chmod -R 775 /app/storage /app/bootstrap/cache

# A imagem base webdevops/php-nginx já lida com a instalação de dependências do Composer
# e inicia o Nginx e PHP-FPM. Não é necessário um CMD aqui.

