#!/bin/bash

# Gestor de archivos

# Función para mostrar un menú
mostrar_menu() {
    echo "========= GESTOR DE ARCHIVOS ========="
    echo "1) Crear un archivo"
    echo "2) Copiar archivos"
    echo "3) Listar permisos del archivo"
    echo "4) Listar usuario y grupo del archivo"
    echo "5) Borrar un archivo"
    echo "6) Limpiador de archivos inútiles"
    echo "7) Obtener clima por localidad"
    echo "8) Generar informe de clima diario de capitales"
    echo "9) Salir"
    echo "======================================"
}

# Crear archivo (indicando nombre y tipo)
crear_archivo() {
    read -p "Ingrese el nombre del archivo (sin extensión): " nombre
    read -p "Ingrese el tipo/extensión del archivo (ej: txt, sh, log, etc.): " tipo
    archivo="${nombre}.${tipo}"

    if [[ -e "$archivo" ]]; then 
        echo "Error: el archivo '$archivo' ya existe." 
    else
        touch "$archivo"
        echo "Archivo '$archivo' de tipo '$tipo' creado." 
    fi
}



# Copiar archivo
copiar_archivo() {
    read -p "Ingrese el archivo origen: " origen
    read -p "Ingrese el destino: " destino
    if [[ ! -e "$origen" ]]; then 
        echo "Error: el archivo origen no existe." 
    else
        cp "$origen" "$destino"
        echo "Archivo copiado a '$destino'." 
    fi
}

# Listar permisos del archivo
listar_permisos() {
    read -p "Ingrese el nombre del archivo: " archivo
    if [[ ! -e "$archivo" ]]; then 
        echo "Error: el archivo no existe." 
    else
        ls -l "$archivo" | awk '{print $1}' 
    fi
}

# Listar usuario y grupo del archivo
listar_usuario_grupo() {
    read -p "Ingrese el nombre del archivo: " archivo
    if [[ ! -e "$archivo" ]]; then 
        echo "Error: el archivo no existe." 
    else
        ls -l "$archivo" | awk '{print "Usuario: " $3 ", Grupo: " $4}' 
    fi
}

# Borrar un archivo
borrar_archivo() {
    read -p "Ingrese el nombre del archivo a borrar: " archivo
    if [[ ! -e "$archivo" ]]; then 
        echo "Error: el archivo no existe." 
    else
        rm -i "$archivo"
        echo "Archivo eliminado (si se confirmó)." 
    fi
}

# Limpiador de archivos inútiles
limpiar_archivos_inutiles() {
    read -p "Ingrese la carpeta a limpiar: " carpeta
    if [[ ! -d "$carpeta" ]]; then 
        echo "Error: la carpeta no existe." 
        return
    fi

    echo "Buscando archivos inútiles en '$carpeta'..."
    find "$carpeta" \( -name '*.tmp' -o -name '*.bak' -o -name '*~' -o -empty -o -atime +180 \) -print > /tmp/lista_inutiles.txt

    if [[ ! -s /tmp/lista_inutiles.txt ]]; then 
        echo "No se encontraron archivos inútiles." 
        return
    fi

    echo "Se encontraron los siguientes archivos:"
    cat /tmp/lista_inutiles.txt

    read -p "¿Desea eliminar todos estos archivos? (s/n): " respuesta
    if [[ "$respuesta" == "s" ]]; then 
        xargs rm -f < /tmp/lista_inutiles.txt
        echo "Archivos eliminados." 
    else
        echo "No se eliminó ningún archivo." 
    fi

    rm /tmp/lista_inutiles.txt
}

# Nueva función para obtener el clima por localidad
obtener_clima_localidad() {
    # Asegúrate de que el script 'clima_por_localidad.sh' esté en el mismo directorio o proporciona la ruta completa.
    # Por ejemplo, si está en /home/user/scripts/, usa /home/user/scripts/clima_por_localidad.sh
    ./clima_por_localidad.sh
}

# Nueva función para generar el informe de clima diario de capitales
generar_informe_clima_diario() {
    # Asegúrate de que el script 'pedir_clima_diario.sh' esté en el mismo directorio o proporciona la ruta completa.
    ./mostrar.sh
}


# Programa principal
verificar_git 
while true; do
    mostrar_menu
    read -p "Seleccione una opción: " opcion
    case $opcion in
        1) crear_archivo ;; 
        2) copiar_archivo ;;
        3) listar_permisos ;;
        4) listar_usuario_grupo ;;
        5) borrar_archivo ;;
        6) limpiar_archivos_inutiles ;;
        7) obtener_clima_localidad ;;
        8) generar_informe_clima_diario ;;
        9) echo "Saliendo..."; break ;; 
        *) echo "Opción inválida. Intente nuevamente." ;;
    esac
    echo
done

