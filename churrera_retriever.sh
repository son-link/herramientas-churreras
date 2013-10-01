#!/bin/bash
# Churrera
# (c) 2013 Alfonso Saavedra "Son Link"
# Script para automatizar la creación de un nuevo proyecto para la churrera o actualizar uno existente.
OIFS="$IFS"
IFS=$'\n'

function ayuda {
	echo "Churrera Retriever"
	echo '(c) 2013 Alfonso Saavedra "Son Link"'
	echo ' '
	echo "Crea un nuevo proyecto para la Churrera o actualiza uno a la nueva versión"
	echo " "
	echo "Opciones:"
	echo "-h, --help		muestra esta ayuda"
	echo "-u, --update DIR	actualiza un proyecto existente en la ruta especificada"
	echo "-n, --new NAME DIR	crea un nuevo proyecto con el nombre y en la ruta especificada"
	exit 0
}

function new_proyect {
	cd /tmp
	wget -nc https://dl.dropboxusercontent.com/u/58286032/programas/Churrera3.99.1.tar.gz
	if [ ! -d $2 ]; then
		mkdir -p $2
	fi
	tar xzfv Churrera3.99.1.tar.gz
	cp Churrera3.99.1/* -r $2
	cd $2/dev
	mv churromain.c $1.c
	sed -i s/NAME=/NAME=${1}/ make.sh
	IFS="$OIFS"
	exit 0
}

function update_proyect {
	if [ ! -d "$1" ]; then
		echo -e "\e[31mEl directorio $1 no existe o no es un directorio.\e[0m"
	elif [ -d "$1-viejo" ]; then
		echo -e "\e[31mEl directorio $1-viejo ya existe. Por favor, bórrelo o muévalo a otro directorio.\e[0m"
	else
		PROYECTDIR="$1"
		echo -e "\e[32mActualizando el proyecto. Espere un momento ...\e[0m"
		cd /tmp
		wget -nc https://dl.dropboxusercontent.com/u/58286032/programas/Churrera3.99.1.tar.gz
		tar xzfv Churrera3.99.1.tar.gz
		cd Churrera3.99.1
		NAME=$(grep "NAME=" ${PROYECTDIR}/dev/make.sh | sed s/NAME=//)
		mv dev/churromain.c dev/$NAME.c
		mv script/churromain.spt script/$NAME.spt
		DIRS2COPY=('gfx' 'map' 'enems')
		for dir in  "${DIRS2COPY[@]}"; do
			cp -r ${PROYECTDIR}/${dir}/* ${dir}/
		done
		mv dev/config.h dev/confih.h.bak
		cp -f ${PROYECTDIR}/dev/* dev
		mv dev/config.h.bak confih.h
		mv ${PROYECTDIR} ${PROYECTDIR}-viejo
		cd /tmp
		mv Churrera3.99.1 $1
		echo -e "\e[32mActualización terminada.\e[0m"
		echo "Edite el archivo dev/config.h segun lo tiene en ${PROYECTDIR}-viejo/dev/config.h"
		echo "Una vez editado y comprobado que esta todo correcto puede borrar ${PROYECTDIR}-viejo si lo desea."
		IFS="$OIFS"
	fi
}

if [ $# -ge 1 ]; then
	case "$1" in
		-h|--help)
			ayuda
			;;
		-u|--update)
			update_proyect $2
			;;
		-n|--new)
			if [ $# -eq 3 ]; then
				new_proyect $2 $3
			else
				ayuda
			fi
			;;
		*)
			ayuda
			;;
	esac
else
	ayuda
fi
