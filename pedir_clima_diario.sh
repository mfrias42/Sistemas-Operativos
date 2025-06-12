#!/bin/bash
# Script para obtener el clima actual de ciudades capitales
# Se ejecuta automáticamente y guarda el informe en un archivo único

API_KEY="7639f81d873b42afb0b133535252105" #


API_URL="http://api.weatherapi.com/v1/current.json"


CAPITAL_CITIES=(
	"Berlin,DE"
	"Buenos Aires,AR"
	"Tokyo,JP"
	"Washington,US"
	"London,UK"
	"Paris,FR"
)

# Directorio donde se guardará el archivo (ajusta si es necesario)
OUTPUT_DIR="/home/manuel/Desktop/Ejecutables" # RUTA DESEADA
OUTPUT_FILENAME="clima_diario_capitales.txt"
OUTPUT_FILE="$OUTPUT_DIR/$OUTPUT_FILENAME"

# Crear el directorio si no existe
mkdir -p "$OUTPUT_DIR"

# Obtener la fecha y hora actual para el encabezado del informe
CURRENT_DATETIME_REPORT=$(date +"%Y-%m-%d %H:%M:%S")

# Iniciar la generación del informe

{
	echo "===================================================="
	echo "Informe del Clima de Capitales - Generado el: $CURRENT_DATETIME_REPORT"
	echo "===================================================="
	echo ""

	for city in "${CAPITAL_CITIES[@]}"; do
    	echo "--- Clima para: $city ---"

    	# Realizar la llamada a la API usando curl
    	weather_data=$(curl -sS -G "$API_URL" \
        	--data-urlencode "key=$API_KEY" \
        	--data-urlencode "q=$city" \
        	--data-urlencode "lang=es") # Solicitamos la respuesta en español

    	# Verificar si la llamada a la API fue exitosa
    	if echo "$weather_data" | jq -e '.error' >/dev/null; then
        	error_message=$(echo "$weather_data" | jq -r '.error.message')
        	echo "  Error de la API para $city: $error_message"
        	echo "  (Puede que la ciudad no sea reconocida o la API Key sea inválida/limitada)"
    	elif [ -z "$weather_data" ]; then
        	echo "  Error: No se recibió ninguna respuesta de la API para $city."
    	else
        	# Extraer y mostrar la información del clima usando jq
        	city_response=$(echo "$weather_data" | jq -r '.location.name // "N/A"') 
        	country_response=$(echo "$weather_data" | jq -r '.location.country // "N/A"')
        	temperature=$(echo "$weather_data" | jq -r '.current.temp_c // "N/A"')
        	feels_like=$(echo "$weather_data" | jq -r '.current.feelslike_c // "N/A"')
        	condition_text=$(echo "$weather_data" | jq -r '.current.condition.text // "N/A"')
        	humidity=$(echo "$weather_data" | jq -r '.current.humidity // "N/A"')
        	wind_kph=$(echo "$weather_data" | jq -r '.current.wind_kph // "N/A"')

        	echo "  Ciudad: $city_response, $country_response"
        	echo "  Temperatura: $temperature°C (Sensación: $feels_like°C)"
        	echo "  Condición: $condition_text"
        	echo "  Humedad: $humidity%"
        	echo "  Viento: $wind_kph km/h"
    	fi
    	echo ""
	done
	echo "===================================================="
	echo ""
} >> "$OUTPUT_FILE" # '>>' para añadir al final del archivo existente.

echo "Informe de clima de capitales agregado a: $OUTPUT_FILE"
