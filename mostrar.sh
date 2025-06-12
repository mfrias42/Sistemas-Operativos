#!/bin/bash

# ===============================================
# Script para leer y mostrar el informe de clima diario de capitales
# ===============================================

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

cat "$REPORT_FILE"

echo ""
echo "==============================================="
echo "Fin del Informe"
echo "==============================================="

