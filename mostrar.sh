#!/bin/bash

# ===============================================
# Script para leer y mostrar el informe de clima diario de capitales
# ===============================================

# Directorio donde se guarda el archivo generado por el script anterior
# ¡ASEGÚRATE DE QUE ESTA RUTA COINCIDA CON OUTPUT_DIR DEL SCRIPT ANTERIOR!
REPORT_DIR="/home/manuel/Desktop/Ejecutables"
REPORT_FILENAME="clima_diario_capitales.txt"
REPORT_FILE="$REPORT_DIR/$REPORT_FILENAME"

# Validar que el archivo exista
if [ ! -f "$REPORT_FILE" ]; then
    echo "Error: El archivo de informe '$REPORT_FILE' no se encontró."
    echo "Asegúrate de que el script de generación haya sido ejecutado y que la ruta sea correcta."
    exit 1
fi

echo "==============================================="
echo "Mostrando Informe Diario de Clima de Capitales"
echo "Archivo: $REPORT_FILE"
echo "==============================================="
echo ""

# Leer el archivo y mostrar su contenido
# Puedes usar 'cat' para simplemente mostrar todo el contenido
# o 'tail -n 50' para mostrar solo las últimas 50 líneas (últimas entradas)
# Para este caso, mostraremos el archivo completo.

cat "$REPORT_FILE"

# Si el archivo es muy grande y solo quieres la última entrada (o las últimas N), podrías usar:
# echo "--- Último Informe ---"
# tail -n 25 "$REPORT_FILE" # Ajusta el número de líneas según la extensión de tu informe por día

echo ""
echo "==============================================="
echo "Fin del Informe"
echo "==============================================="

