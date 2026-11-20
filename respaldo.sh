#!/bin/bash
# Respaldo lógico de la base de datos "inventario" (Equipo 2 - Servidores II)
# Uso: bash respaldo.sh   (desde cualquier carpeta; el script entra a la del proyecto)
set -euo pipefail
cd "$(dirname "$0")"
DESTINO="$HOME/respaldos"
ARCHIVO="$DESTINO/inventario_$(date +%F_%H%M).sql"
mkdir -p "$DESTINO"
docker compose exec -T db sh -c 'mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --databases inventario' > "$ARCHIVO"
if [ ! -s "$ARCHIVO" ]; then
  echo "ERROR: el respaldo quedó vacío" >&2
  rm -f "$ARCHIVO"
  exit 1
fi
echo "Respaldo generado: $ARCHIVO"
ls -lh "$ARCHIVO"
