# Sistema de Inventario Tecnológico — Minas del Noroeste S.A. de C.V.

Proyecto final de **Servidores II** (Universidad de Sonora, Ingeniería en Sistemas de Información) · **Equipo 2**.

Inventario web de equipos y activos tecnológicos y de operación de una organización ficticia dedicada a la extracción y procesamiento de minerales en Sonora. Los equipos se registran, consultan, editan y eliminan desde el navegador. Todos los datos son ficticios.

## Arquitectura

```
Navegador ──:80──▶ nginx ──:5000──▶ app (Flask + Gunicorn) ──:3306──▶ db (MySQL 8.4) ──▶ volumen datos_mysql
```

| Servicio | Imagen | Puerto |
|---|---|---|
| `nginx` | `nginx:1.28-alpine` | 80 (único publicado) |
| `app` | `equipo2servidores/inventario-app:1.0` | 5000 (interno) |
| `db` | `mysql:8.4` | 3306 (interno) |

Los servicios se comunican por la red interna `inventario_red_interna`. Los datos de MySQL se guardan en el volumen `inventario_datos_mysql`.

## Requisitos

- Linux (probado en Ubuntu Server 26.04 LTS) con **Docker Engine**, **Docker Compose** y **Git**.
- Acceso a internet y puerto 80 libre.
- Al menos 4 GB de RAM y 10 GB de disco libres.

## Cómo recrear el sistema

```bash
git clone https://github.com/equipo2-servidores/inventario.git
cd inventario
cp .env.ejemplo .env        # (o .env.example)
nano .env                   # cambiar MYSQL_ROOT_PASSWORD y MYSQL_PASSWORD
docker compose up -d
docker compose ps           # esperar a que db esté "healthy"
curl http://localhost/salud # debe responder "estado":"ok"
```

Abrir `http://IP-del-servidor` en el navegador.

> Las contraseñas no deben contener `$`, `#` ni espacios. El archivo `.env` **nunca** se sube al repositorio.

Para detener el sistema sin perder datos: `docker compose down`. **No** usar `docker compose down -v`, que elimina el volumen con los datos.

## Variables de entorno

Ver `.env.ejemplo` (`.env.example` es una copia idéntica). Variables: `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` y `ORGANIZACION`. Sin valores reales de contraseña.

## Respaldo y restauración

```bash
bash respaldo.sh            # genera ~/respaldos/inventario_FECHA_HORA.sql
```

Restaurar (en una sola línea):

```bash
docker compose exec -T db sh -c 'mysql -u root -p"$MYSQL_ROOT_PASSWORD"' < ~/respaldos/inventario_FECHA.sql
```

Los respaldos contienen datos de la organización y **no** se agregan al repositorio.

## Validación automática (Jenkins)

El archivo `Jenkinsfile` define un pipeline que verifica: archivos del proyecto, protección de `.env`, estructura de `compose.yaml`, historial de Git y disponibilidad de `/salud`.

```bash
docker run -d --name jenkins -p 8080:8080 -v jenkins_home:/var/jenkins_home \
  --network inventario_red_interna jenkins/jenkins:lts
```

Tarea `validar-inventario`: *Pipeline script from SCM*, repositorio de este proyecto, rama `*/main`, script `Jenkinsfile`.

## Estructura del repositorio

| Ruta | Contenido |
|---|---|
| `compose.yaml` | Servicios, red y volumen |
| `.env.ejemplo` / `.env.example` | Plantilla de variables (sin contraseñas) |
| `app/` | Aplicación Flask, Dockerfile y plantillas |
| `db/init.sql` | Tabla `equipos` y registros de ejemplo de la mina |
| `nginx/default.conf` | Proxy inverso hacia `app` |
| `Jenkinsfile` | Pipeline de validación |
| `respaldo.sh` | Script de respaldo de la base de datos |

## Versiones

- Imagen publicada: `equipo2servidores/inventario-app:1.0` (Docker Hub).
- Etiquetas de Git: `v1.0` y `v1.0-final` (versión evaluada).

## Integrantes

Bernal Calvo Francisco Javier · Dávila Arenas Joaquín · Miranda Coronado Juraz Gael · Vargas Encinas Victoria
