#!/bin/bash

# Churrera installer 0.1
# (c) 2013 Alfonso Saavedra "Son Link"
# Churrera (c) 2013 The Mojon twins
# Script bash para instalar los componentes de la Churrera para crear juegos para las Zx Spectrum
# Script bajo licencia GPLv3

COMMANDS=('wget' 'unzip' 'gcc'  'make' 'automake')
ERRORS=0
USED=()

# Funciones para cada tarea. Es para tener un poco de orden en el código

function z88dk {
	echo -e "\e[1m\e[32mCompilando z88dk\e[0m"
	wget -nc https://dl.dropboxusercontent.com/u/58286032/churrera/z88dk-splib2-1.10.1.tar.gz
	tar xzf z88dk-splib2-1.10.1.tar.gz
	cd z88dk-splib2-1.10.1
	make
	echo -e "\e[1m\e[32mInstalando z88dk\e[0m"
	sudo make prefix=/usr install

	echo -e "\e[1mAñada las siguientes lineas en el fichero .bashrc de su carpeta HOME, /etc/profile o cree un fichero ejecutable en /etc/profile.d/:\e[0m"
	echo "export ZCCCFG=/usr/share/z88dk/lib/config/"
	echo "export Z80_OZFILES=/usr/share/z88dk/lib/"
	echo -e "Pulse una tecla para seguir\n"
	read -n 1 -s
}

function bin2 {
	echo -e "\e[1m\e[32mCompilando bin2tap\e[0m"
	wget -nc http://zeroteam.sk/files/bin2tap13.zip
	unzip -p bin2tap13.zip bin2tap/bin2tap.c > bin2tap.c
	gcc bin2tap.c -o bin2tap
	echo -e "\e[1m\e[32mInstalando bin2tap\e[0m"
	sudo cp bin2tap /usr/bin
}

function bas2 {
	echo -e "\e[1m\e[32mCompilando bas2tap\e[0m"
	wget -nc ftp://ftp.worldofspectrum.org/pub/sinclair/tools/generic/bas2tap26-generic.zip
	unzip bas2tap26-generic.zip
	gcc -Wall -O2 bas2tap.c -o bas2tap -lm ; strip bas2tap
	echo -e "\e[1m\e[32mInstalando bas2tap\e[0m"
	sudo cp bas2tap /usr/bin
}

function sevenup {
	echo -e "\e[1m\e[32mCompilando SevenuP\e[0m"
	wget -nc http://metalbrain.speccy.org/SevenuP-v1.21src_WIP.zip
	unzip SevenuP-v1.21src_WIP.zip
	cd SRC
	make -f makefile.unx CC=g++
	echo -e "\e[1m\e[32mInstalando SevenuP\e[0m"
	sudo cp SevenuP /usr/bin
}

function mojonas {
	echo -e "\e[1m\e[32mInstalando las utilidades mojonas\e[0m"
	wget -nc https://dl.dropboxusercontent.com/u/58286032/churrera/utilidades-mojonas-linux.tar.gz
	tar xvfz utilidades-mojonas-linux.tar.gz
	sudo mkdir -p /opt/churrera/bin
	sudo cp utilidades-mojonas/* /opt/churrera/bin
	echo "Añada la ruta /opt/churrera/bin al PATH"
	read -n 1 -s
}

function map {
	echo -e "\e[1m\e[32mInstalando Mappy\e[0m"
	wget -nc http://www.mojontwins.com/churrera/mt-mappy.zip
	unzip mt-mappy.zip
	sudo cp -r Mappy /opt/churrera
	sudo echo "#!bin/bash" > sudo /usr/bin/mappy
	sudo echo "cd /opt/churrera/Mappy && wine mapwin.exe" >> sudo /usr/bin/mappy
	sudo chmod +x /usr/bin/mappy
}
#Comprobamos si esta instalado lo necesario
for comm in  "${COMMANDS[@]}"; do
	command -v $comm >/dev/null 2>&1 || { echo >&2 "No se encuentra ${comm}."; ERRORS=$[$ERRORS+1];}
done

# Si no esta al menos unos de los programas se muestra un mensaje y salimos
if [ $ERRORS -gt 0 ]; then
	echo -e "\e[1m\e[31mUno o mas programas requeridos para la instalación no están instalados.\e[0m\nPor favor, instálelos y vuelva a intentar"; exit 1
fi

echo -e "\e[1m\e[32mChurrera installer 0.1\e[0m"
echo -e "Bienvenid@ al instalador de las utilidades para la \e[1mChurrera\e[0m de los Mojon Twins."
echo "A lo largo del proceso se instalaran los componentes necesarios para el uso."
echo -e "Por favor, lea el \e[31mINSTALL\e[0m para conocer los programas y librerías necesarias para la compilación y uso de los componentes."
echo -e "\e[1m\e[31mALERTA: no ejecute este script con permisos de root por motivos de seguridad.\e[0m"
echo -e "Seleccione los componentes a instalar escribiendo el numero separado por espacios:\nEjemplo: 1 4\n"
echo -e "\e[1m1: z88dk		2: bin2tap"
echo -e "3: bas2tap		4: SevenuP"
echo -e "5: Utilidades mojonas	6: Mappy"
echo -e "0: todo"
read -a OPTIONS -p 'Escriba su selección: ' -t 120
echo -e "\e[0m"

if [ -z $OPTIONS ]; then
	exit
fi

if [ ! -d /tmp/churrera ]; then
	mkdir -p /tmp/churrera
fi
cd /tmp/churrera

for opt in  "${OPTIONS[@]}"; do
	if [[ " ${used[*]} " == *" $opt "* ]]; then
		continue
	fi
	case $opt in
		1)
			z88dk
			USED+=(1)
			;;
		2)
			bin2
			USED+=(2)
			;;
		3)
			bas2
			USED+=(3)
			;;
		4)
			sevenup
			USED+=(4)
			;;
		5)
			mojonas
			USED+=(5)
			;;
		6)
			map
			USED+=(6)
			;;

		0)
			z88dk
			bin2
			bas2
			sevenup
			mojonas
			map
			exit
			;;
	esac
done

echo "Instalación terminada."
echo "Gracias por usarlo y esperamos que disfrutes haciendo tus juegos."
echo "Pulse una tecla para terminar."
read -n 1 -s
rm -rf /tmp/churrera
