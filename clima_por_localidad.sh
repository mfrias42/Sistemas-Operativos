#!/bin/bash

# ==================================
# Script para obtener el clima actual y pronóstico con WeatherAPI.com y guardar en un log
# ==================================

API_KEY="7639f81d873b42afb0b133535252105"
# URLs de la API de WeatherAPI.com
FORECAST_API_URL="http://api.weatherapi.com/v1/forecast.json"

# Nombre del archivo de log
LOG_FILE="weather_log.txt"
DEBUG_FILE="weather_debug.json"

# Validar que la API Key esté presente
if [ -z "$API_KEY" ]; then
    echo "Error: La variable de entorno WEATHER_API_KEY no está configurada."
    echo "Por favor, configúrala en tu ~/.bashrc o ~/.zshrc (ej: export WEATHER_API_KEY=\"TU_CLAVE\")."
    exit 1
fi

# Solicitar la ciudad al usuario
read -p "Ingrese el nombre de la ciudad (ej: Cordoba, Buenos Aires, London): " city_name

# Validar que se haya ingresado una ciudad
if [ -z "$city_name" ]; then
    echo "Error: Debes ingresar el nombre de una ciudad."
    exit 1
fi

echo "Obteniendo el clima actual y pronóstico para $city_name..."

# Realizar la llamada a la API de pronóstico usando curl
weather_data=$(curl -sS -G "$FORECAST_API_URL" \
    --data-urlencode "key=$API_KEY" \
    --data-urlencode "q=$city_name" \
    --data-urlencode "days=3" \
    --data-urlencode "lang=es" \
    --data-urlencode "aqi=no" \
    --max-time 10)

# Guardar la respuesta completa para debug
echo "$weather_data" > "$DEBUG_FILE"
echo "Respuesta completa de la API guardada en $DEBUG_FILE"

# Verificar si la llamada a la API fue exitosa
if echo "$weather_data" | jq -e '.error' >/dev/null; then
    error_message=$(echo "$weather_data" | jq -r '.error.message')
    echo "Error de la API: $error_message"
    exit 1
fi

if [ -z "$weather_data" ]; then
    echo "Error: No se recibió ninguna respuesta de la API."
    exit 1
fi

# Verificar la estructura de la respuesta
echo "Verificando estructura de la respuesta..."
if ! echo "$weather_data" | jq -e '.forecast.forecastday[0]' >/dev/null; then
    echo "Error: La respuesta no contiene datos de pronóstico."
    echo "Respuesta recibida:"
    echo "$weather_data" | jq '.'
    exit 1
fi

# Extraer la información del clima actual usando jq
city_response=$(echo "$weather_data" | jq -r '.location.name')
country_response=$(echo "$weather_data" | jq -r '.location.country')
current_temp=$(echo "$weather_data" | jq -r '.current.temp_c')
current_condition=$(echo "$weather_data" | jq -r '.current.condition.text')
current_humidity=$(echo "$weather_data" | jq -r '.current.humidity')
current_wind=$(echo "$weather_data" | jq -r '.current.wind_kph')
current_feelslike=$(echo "$weather_data" | jq -r '.current.feelslike_c')

# Obtener la fecha y hora actual para el log
current_datetime=$(date +"%Y-%m-%d %H:%M:%S")

# Mostrar información actual
echo "==================================="
echo "CLIMA ACTUAL EN $city_response, $country_response"
echo "==================================="
echo "Temperatura: ${current_temp}°C (Sensación térmica: ${current_feelslike}°C)"
echo "Condición: $current_condition"
echo "Humedad: $current_humidity%"
echo "Viento: $current_wind km/h"
echo "==================================="

# Mostrar pronóstico para los próximos 3 días
echo -e "\nPRONÓSTICO PRÓXIMOS 3 DÍAS"
echo "==================================="

# Procesar el pronóstico de los próximos días
for i in {0..2}; do
    # Extraer datos del día
    date=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].date")
    
    # Datos del clima diario
    maxtemp=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.maxtemp_c")
    mintemp=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.mintemp_c")
    avgtemp=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.avgtemp_c")
    maxwind=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.maxwind_kph")
    totalprecip=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.totalprecip_mm")
    avghumidity=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.avghumidity")
    condition=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.condition.text")
    rain_chance=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.daily_chance_of_rain")
    will_it_rain=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.daily_will_it_rain")
    uv=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].day.uv")
    
    # Datos astronómicos
    sunrise=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].astro.sunrise")
    sunset=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].astro.sunset")
    moonrise=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].astro.moonrise")
    moonset=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].astro.moonset")
    moon_phase=$(echo "$weather_data" | jq -r ".forecast.forecastday[$i].astro.moon_phase")
    
    echo "Fecha: $date"
    echo "TEMPERATURAS:"
    echo "  - Máxima: ${maxtemp}°C"
    echo "  - Mínima: ${mintemp}°C"
    echo "  - Promedio: ${avgtemp}°C"
    echo "CONDICIONES:"
    echo "  - Estado: $condition"
    echo "  - Viento máximo: $maxwind km/h"
    echo "  - Humedad promedio: $avghumidity%"
    echo "  - Índice UV: $uv"
    echo "PRECIPITACIONES:"
    echo "  - Probabilidad de lluvia: $rain_chance%"
    echo "  - ¿Lloverá?: $([ "$will_it_rain" = "1" ] && echo "Sí" || echo "No")"
    echo "  - Precipitación total: ${totalprecip}mm"
    echo "DATOS ASTRONÓMICOS:"
    echo "  - Amanecer: $sunrise"
    echo "  - Atardecer: $sunset"
    echo "  - Fase lunar: $moon_phase"
    echo "-----------------------------------"
    
    # Agregar pronóstico al log
    forecast_log="[$current_datetime] PRONÓSTICO $date - Ciudad: $city_response, País: $country_response"
    forecast_log+=" - Temp: Máx ${maxtemp}°C, Mín ${mintemp}°C, Prom ${avgtemp}°C"
    forecast_log+=" - Condición: $condition, Prob. lluvia: $rain_chance%, Precip: ${totalprecip}mm"
    forecast_log+=" - Humedad: $avghumidity%, Viento máx: $maxwind km/h, UV: $uv"
    echo "$forecast_log" >> "$LOG_FILE"
done

# Guardar la información actual en el archivo de log
current_log="[$current_datetime] ACTUAL - Ciudad: $city_response, País: $country_response"
current_log+=" - Temp: ${current_temp}°C (ST: ${current_feelslike}°C)"
current_log+=" - Condición: $current_condition, Humedad: $current_humidity%, Viento: $current_wind km/h"
echo "$current_log" >> "$LOG_FILE"
echo -e "\nDatos guardados en '$LOG_FILE'."


