#!/bin/bash

# Script de démarrage local de nginx (sans sudo, pour développement)
# Utilise un port alternative si 80 n'est pas disponible

PORT=3005

echo "=========================================="
echo "Démarrage local de nginx"
echo "=========================================="

# Créer un dossier temporaire pour les fichiers de nginx
NGINX_TEMP="/tmp/nginx-local"
mkdir -p "$NGINX_TEMP"/{cache,pid,logs}

# Arrêter les processus existants sur le port
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo "⚠ Le port $PORT est déjà utilisé, arrêt des processus existants..."
    PID=$(lsof -Pi :$PORT -sTCP:LISTEN -t)
    if [ ! -z "$PID" ]; then
        kill -9 $PID 2>/dev/null
        sleep 1
        echo "✓ Processus arrêté"
    fi
fi

# Créer la configuration locale avec le bon port
    cat > "$NGINX_TEMP/nginx.local.conf" << EOF
worker_processes auto;
pid $NGINX_TEMP/pid/nginx.pid;
error_log $NGINX_TEMP/logs/error.log warn;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log $NGINX_TEMP/logs/access.log;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 100M;

    server {
        listen $PORT;
        server_name _;
        root /home/azerxim/Documents/ShardUI-2-Maps;

        # Index files
        index index.html;

        # Gzip compression
        gzip on;
        gzip_types text/plain text/css text/javascript application/javascript text/xml application/xml application/xml+rss;
        gzip_min_length 1000;

        # Serve files and directories that exist
        location / {
            try_files \$uri \$uri/ @rewrite;
        }

        # Maps location - rewrite to maps location
        location /maps/ {
            try_files \$uri \$uri/ @maps_rewrite;
        }

        # Maps location - rewrite to maps location
        location /viewer/ {
            try_files \$uri \$uri/ @viewer_rewrite;
        }

        location @viewer_rewrite {
            # About page
            rewrite ^/viewer/about$ /viewer/about.html break;

            # Embed routes (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embed$ /viewer/embed.html?data=\$1_\$2_\$3 break;
            # Embed routes (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-embed$ /viewer/embed.html?data=\$1_\$2 break;
            # Embed routes (1 part)
            rewrite ^/viewer/([a-z]+?)-embed$ /viewer/embed.html?data=\$1 break;

            # Embedfull routes (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedfull$ /viewer/embedfull.html?data=\$1_\$2_\$3 break;
            # Embedfull routes (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-embedfull$ /viewer/embedfull.html?data=\$1_\$2 break;
            # Embedfull routes (1 part)
            rewrite ^/viewer/([a-z]+?)-embedfull$ /viewer/embedfull.html?data=\$1 break;

            # Embedplus routes (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedplus$ /viewer/embedplus.html?data=\$1_\$2_\$3 break;
            # Embedplus routes (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-embedplus$ /viewer/embedplus.html?data=\$1_\$2 break;
            # Embedplus routes (1 part)
            rewrite ^/viewer/([a-z]+?)-embedplus$ /viewer/embedplus.html?data=\$1 break;

            # Editor routes (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-editor$ /viewer/editor.html?data=\$1_\$2_\$3 break;
            # Editor routes (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-editor$ /viewer/editor.html?data=\$1_\$2 break;
            # Editor routes (1 part)
            rewrite ^/viewer/([a-z]+?)-editor$ /viewer/editor.html?data=\$1 break;

            # Embed with options (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embed-([a-z_]+?)$ /viewer/embed.html?data=\$1_\$2_\$3 break;
            # Embed with options (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-embed-([a-z_]+?)$ /viewer/embed.html?data=\$1_\$2 break;
            # Embed with options (1 part)
            rewrite ^/viewer/([a-z]+?)-embed-([a-z_]+?)$ /viewer/embed.html?data=\$1 break;
            # Embedfull with options (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedfull-([a-z_]+?)$ /viewer/embedfull.html?data=\$1_\$2_\$3 break;
            # Embedfull with options (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-embedfull-([a-z_]+?)$ /viewer/embedfull.html?data=\$1_\$2 break;
            # Embedfull with options (1 part)
            rewrite ^/viewer/([a-z]+?)-embedfull-([a-z_]+?)$ /viewer/embedfull.html?data=\$1 break;
            # Embedplus with options (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedplus-([a-z_]+?)$ /viewer/embedplus.html?data=\$1_\$2_\$3 break;
            # Embedplus with options (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-embedplus-([a-z_]+?)$ /viewer/embedplus.html?data=\$1_\$2 break;
            # Embedplus with options (1 part)
            rewrite ^/viewer/([a-z]+?)-embedplus-([a-z_]+?)$ /viewer/embedplus.html?data=\$1 break;

            # Editor with options (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-editor-([a-z_]+?)$ /viewer/editor.html?data=\$1_\$2_\$3 break;
            # Editor with options (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-editor-([a-z_]+?)$ /viewer/editor.html?data=\$1_\$2 break;
            # Editor with options (1 part)
            rewrite ^/viewer/([a-z]+?)-editor-([a-z_]+?)$ /viewer/editor.html?data=\$1 break;
            # Options routes (with options parameter) (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-([a-z_]+?)$ /viewer/index.html?data=\$1_\$2_\$3 break;
            # Options routes (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)-([a-z_]+?)$ /viewer/index.html?data=\$1_\$2 break;
            # Options routes (1 part)
            rewrite ^/viewer/([a-z]+?)-([a-z]+?)$ /viewer/index.html?data=\$1 break;

            # Carte routes (simple names) (3 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)$ /viewer/index.html?data=\$1_\$2_\$3 break;
            # Carte routes (2 parts)
            rewrite ^/viewer/([a-z_]+?)_([a-z_]+?)$ /viewer/index.html?data=\$1_\$2 break;
            # Carte routes (1 part)
            rewrite ^/viewer/([a-z]+?)$ /viewer/index.html?data=\$1 break;
            # Default fallback
            rewrite ^ /viewer/index.html break;
        }

        location @maps_rewrite {
            # About page
            rewrite ^/maps/about$ /maps/about.html break;

            # Embed routes (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embed$ /maps/embed.html?data=\$1_\$2_\$3 break;
            # Embed routes (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-embed$ /maps/embed.html?data=\$1_\$2 break;
            # Embed routes (1 part)
            rewrite ^/maps/([a-z]+?)-embed$ /maps/embed.html?data=\$1 break;

            # Embedfull routes (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedfull$ /maps/embedfull.html?data=\$1_\$2_\$3 break;
            # Embedfull routes (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-embedfull$ /maps/embedfull.html?data=\$1_\$2 break;
            # Embedfull routes (1 part)
            rewrite ^/maps/([a-z]+?)-embedfull$ /maps/embedfull.html?data=\$1 break;

            # Embedplus routes (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedplus$ /maps/embedplus.html?data=\$1_\$2_\$3 break;
            # Embedplus routes (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-embedplus$ /maps/embedplus.html?data=\$1_\$2 break;
            # Embedplus routes (1 part)
            rewrite ^/maps/([a-z]+?)-embedplus$ /maps/embedplus.html?data=\$1 break;

            # Editor routes (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-editor$ /maps/editor.html?data=\$1_\$2_\$3 break;
            # Editor routes (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-editor$ /maps/editor.html?data=\$1_\$2 break;
            # Editor routes (1 part)
            rewrite ^/maps/([a-z]+?)-editor$ /maps/editor.html?data=\$1 break;

            # Embed with options (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embed-([a-z_]+?)$ /maps/embed.html?data=\$1_\$2_\$3 break;
            # Embed with options (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-embed-([a-z_]+?)$ /maps/embed.html?data=\$1_\$2 break;
            # Embed with options (1 part)
            rewrite ^/maps/([a-z]+?)-embed-([a-z_]+?)$ /maps/embed.html?data=\$1 break;

            # Embedfull with options (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedfull-([a-z_]+?)$ /maps/embedfull.html?data=\$1_\$2_\$3 break;
            # Embedfull with options (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-embedfull-([a-z_]+?)$ /maps/embedfull.html?data=\$1_\$2 break;
            # Embedfull with options (1 part)
            rewrite ^/maps/([a-z]+?)-embedfull-([a-z_]+?)$ /maps/embedfull.html?data=\$1 break;

            # Embedplus with options (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedplus-([a-z_]+?)$ /maps/embedplus.html?data=\$1_\$2_\$3 break;
            # Embedplus with options (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-embedplus-([a-z_]+?)$ /maps/embedplus.html?data=\$1_\$2 break;
            # Embedplus with options (1 part)
            rewrite ^/maps/([a-z]+?)-embedplus-([a-z_]+?)$ /maps/embedplus.html?data=\$1 break;

            # Editor with options (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-editor-([a-z_]+?)$ /maps/editor.html?data=\$1_\$2_\$3 break;
            # Editor with options (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-editor-([a-z_]+?)$ /maps/editor.html?data=\$1_\$2 break;
            # Editor with options (1 part)
            rewrite ^/maps/([a-z]+?)-editor-([a-z_]+?)$ /maps/editor.html?data=\$1 break;

            # Options routes (with options parameter) (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-([a-z_]+?)$ /maps/index.html?data=\$1_\$2_\$3 break;
            # Options routes (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)-([a-z_]+?)$ /maps/index.html?data=\$1_\$2 break;
            # Options routes (1 part)
            rewrite ^/maps/([a-z]+?)-([a-z]+?)$ /maps/index.html?data=\$1 break;

            # Carte routes (simple names) (3 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)$ /maps/index.html?data=\$1_\$2_\$3 break;
            # Carte routes (2 parts)
            rewrite ^/maps/([a-z_]+?)_([a-z_]+?)$ /maps/index.html?data=\$1_\$2 break;
            # Carte routes (1 part)
            rewrite ^/maps/([a-z]+?)$ /maps/index.html?data=\$1 break;

            # Default fallback
            rewrite ^ /maps/index.html break;
        }

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|json|stamp|bin|meta|php)$ {
            expires 30d;
            add_header Cache-Control "public, immutable";
        }

        # API routes - PHP backend
        location ~ ^/maps/api/(get|put)/(.+)$ {
            rewrite ^/maps/api/(get|put)/([a-z]+?)$ /maps/api/\$1/\$2.php break;
        }

        # Error pages for API endpoints
        location ~ ^/maps/api/?$ {
            rewrite ^ /maps/error.html break;
        }

        location ~ ^/maps/api/(get|put)/?$ {
            rewrite ^ /maps/error.html break;
        }

        # Deny access to sensitive files
        location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
        }

        # Rewrite rules using named location
        location @rewrite {
            # Embed routes (3 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embed$ /embed.html?data=\$1_\$2_\$3 break;
            # Embed routes (2 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)-embed$ /embed.html?data=\$1_\$2 break;
            # Embed routes (1 part)
            rewrite ^/([a-z]+?)-embed$ /embed.html?data=\$1 break;

            # Embedplus routes (3 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedplus$ /embedplus.html?data=\$1_\$2_\$3 break;
            # Embedplus routes (2 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)-embedplus$ /embedplus.html?data=\$1_\$2 break;
            # Embedplus routes (1 part)
            rewrite ^/([a-z]+?)-embedplus$ /embedplus.html?data=\$1 break;

            # Editor routes (3 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-editor$ /editor.html?data=\$1_\$2_\$3 break;
            # Editor routes (2 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)-editor$ /editor.html?data=\$1_\$2 break;
            # Editor routes (1 part)
            rewrite ^/([a-z]+?)-editor$ /editor.html?data=\$1 break;

            # Embed with options (3 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embed-([a-z_]+?)$ /embed.html?data=\$1_\$2_\$3 break;
            # Embed with options (2 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)-embed-([a-z_]+?)$ /embed.html?data=\$1_\$2 break;
            # Embed with options (1 part)
            rewrite ^/([a-z]+?)-embed-([a-z_]+?)$ /embed.html?data=\$1 break;

            # Embedplus with options (3 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-embedplus-([a-z_]+?)$ /embedplus.html?data=\$1_\$2_\$3 break;
            # Embedplus with options (2 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)-embedplus-([a-z_]+?)$ /embedplus.html?data=\$1_\$2 break;
            # Embedplus with options (1 part)
            rewrite ^/([a-z]+?)-embedplus-([a-z_]+?)$ /embedplus.html?data=\$1 break;

            # Editor with options (3 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-editor-([a-z_]+?)$ /editor.html?data=\$1_\$2_\$3 break;
            # Editor with options (2 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)-editor-([a-z_]+?)$ /editor.html?data=\$1_\$2 break;
            # Editor with options (1 part)
            rewrite ^/([a-z]+?)-editor-([a-z_]+?)$ /editor.html?data=\$1 break;

            # Options routes (with options parameter) (3 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)-([a-z_]+?)$ /index.html?data=\$1_\$2_\$3 break;
            # Options routes (2 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)-([a-z_]+?)$ /index.html?data=\$1_\$2 break;
            # Options routes (1 part)
            rewrite ^/([a-z]+?)-([a-z]+?)$ /index.html?data=\$1 break;

            # Carte routes (simple names) (3 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)_([a-z_]+?)$ /index.html?data=\$1_\$2_\$3 break;
            # Carte routes (2 parts)
            rewrite ^/([a-z_]+?)_([a-z_]+?)$ /index.html?data=\$1_\$2 break;
            # Carte routes (1 part)
            rewrite ^/([a-z]+?)$ /index.html?data=\$1 break;

            # Default fallback
            rewrite ^ /index.html break;
        }
    }
}
EOF

echo "✓ Démarrage sur le port $PORT"
echo "✓ Racine: /home/azerxim/Documents/ShardUI-2-Maps"
echo ""
echo "Accédez à: http://localhost:$PORT"
echo ""
echo "Pour arrêter: Ctrl+C"
echo ""

# Démarrer nginx
/usr/sbin/nginx -c "$NGINX_TEMP/nginx.local.conf" -g "daemon off;"
