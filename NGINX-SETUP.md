# ShardUI-2-Maps - Configuration Nginx

## Installation

### Option 1: Installation système (recommandée pour production)

```bash
cd /home/azerxim/Documents/ShardUI-2-Maps
sudo bash install-nginx.sh
```

Cette commande va:
- Installer nginx et PHP-FPM si nécessaire
- Configurer les règles de redirection
- Activer le service nginx
- Démarrer le serveur

### Option 2: Développement local (sans sudo)

```bash
cd /home/azerxim/Documents/ShardUI-2-Maps
chmod +x start-nginx-local.sh
./start-nginx-local.sh 8080
```

Accédez à: `http://localhost:8080`

Pour changer le port: `./start-nginx-local.sh 3000`

## Configuration

Les fichiers de configuration sont:
- `nginx.conf` - Configuration du site (automatiquement utilisée par les scripts)
- `install-nginx.sh` - Script d'installation système
- `start-nginx-local.sh` - Script de développement local

## Règles de redirection converties

Voici les correspondances entre les règles `.htaccess` et nginx:

### Cartes (simple name)
```
/tetrago  → index.html?data=tetrago
/nether_toit → index.html?data=nether_toit
/nether_toit_light → index.html?data=nether_toit_light
```

### Embed
```
/tetrago-embed → embed.html?data=tetrago
/nether_toit-embed → embed.html?data=nether_toit
```

### Embedplus
```
/tetrago-embedplus → embedplus.html?data=tetrago
/nether_toit-embedplus → embedplus.html?data=nether_toit
```

### Éditeur
```
/tetrago-editor → editor.html?data=tetrago
/nether_toit-editor → editor.html?data=nether_toit
```

### Avec options
```
/tetrago-dark → index.html?data=tetrago
/tetrago-embed-dark → embed.html?data=tetrago
/tetrago-editor-light → editor.html?data=tetrago
```

### API
```
/api/get/civilisations → api/get/civilisations.php
/api/put/civilisations → api/put/civilisations.php
/api → error.html
```

## Gestion du service

### Vérifier le statut
```bash
sudo systemctl status nginx
```

### Redémarrer après modifications
```bash
sudo systemctl restart nginx
```

### Afficher les logs
```bash
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### Arrêter
```bash
sudo systemctl stop nginx
```

### Démarrer
```bash
sudo systemctl start nginx
```

## Avantages de nginx

✓ Plus rapide que Apache  
✓ Configuration plus simple et lisible  
✓ Meilleure gestion de la mémoire  
✓ Meilleure performance sous forte charge  
✓ Compatible avec les routes PHP via PHP-FPM  
✓ Support natif des regex pour les redirections  

## Suppression du .htaccess

Une fois nginx configuré et testé, vous pouvez supprimer ou renommer le fichier `.htaccess`:
```bash
rm /home/azerxim/Documents/ShardUI-2-Maps/.htaccess
# ou
mv /home/azerxim/Documents/ShardUI-2-Maps/.htaccess /home/azerxim/Documents/ShardUI-2-Maps/.htaccess.backup
```

nginx prendra entièrement en charge les redirections.

## Dépannage

### nginx: [error] open() "/run/nginx.pid" failed
```bash
sudo mkdir -p /run/nginx
sudo touch /run/nginx/nginx.pid
sudo chown -R www-data:www-data /run/nginx
```

### Permission denied (port 80)
Utilisez `sudo` ou changez le port dans la configuration:
```nginx
listen 8080;  # au lieu de listen 80;
```

### PHP-FPM ne répond pas
```bash
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
```

### Configuration invalide
```bash
sudo nginx -t
```

Cela affichera l'erreur exacte de configuration.
