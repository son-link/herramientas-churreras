#!/bin/bash

# Churrera installer 0.1
# (c) 2013 Alfonso Saavedra "Son Link"
# Churrera (c) 2013 The Mojon twins
# Script bash para instalar los componentes de la Churrera para crear juegos para las Zx Spectrum
# Script bajo licencia GPLv3

echo -e "\e[1m\e[32mChurrera installer 0.1\e[0m"
echo -e "Bienvenid@ al instalador de las utilidades para la \e[1mChurrera\e[0m de los Mojon Twins."
echo "A lo largo del proceso se instalaran los componentes necesarios para el uso."
echo -e "Por favor, lea el \e[31mINSTALL\e[0m para conocer los programas y librerías necesarias para la compilación y uso de los componentes."
echo -e "\e[1m\e[31mALERTA: no ejecute este script con permisos de root por motivos de seguridad.\e[0m"
echo "Pulse una tecla para seguir con la instalación ..."
read -n 1 -s

if [ ! -d /tmp/churrera ]; then
	mkdir -p /tmp/churrera
fi
cd /tmp/churrera

echo -e "\e[1m\e[32mCompilando z88dk\e[0m"
wget -nc https://dl.dropboxusercontent.com/u/58286032/aur/z88dk-splib2-1.10.1.tar.gz
tar xzf z88dk-splib2-1.10.1.tar.gz
cd z88dk-splib2-1.10.1
make
echo -e "\e[1m\e[32mInstalando z88dk\e[0m"
sudo make prefix=/usr DESTDIR=/usr install

echo -e "\e[1mAñada las siguientes lineas en el fichero .bashrc de su carpeta HOME, /etc/profile o cree un fichero ejecutable en /etc/profile.d/:\e[0m"
echo "export ZCCCFG=/usr/share/z88dk/lib/config/"
echo "export Z80_OZFILES=/usr/share/z88dk/lib/"
echo "Pulse una tecla para seguir"
echo ""
read -n 1 -s

echo -e "\e[1m\e[32mCompilando bin2tap\e[0m"
wget -nc http://zeroteam.sk/files/bin2tap13.zip
unzip -p bin2tap13.zip bin2tap/bin2tap.c > bin2tap.c
gcc bin2tap.c -o bin2tap
echo -e "\e[1m\e[32mInstalando bin2tap\e[0m"
sudo cp bin2tap /usr/bin

echo -e "\e[1m\e[32mCompilando bas2tap\e[0m"
wget -nc ftp://ftp.worldofspectrum.org/pub/sinclair/tools/generic/bas2tap26-generic.zip
unzip bas2tap26-generic.zip
gcc -Wall -O2 bas2tap.c -o bas2tap -lm ; strip bas2tap
echo -e "\e[1m\e[32mInstalando bas2tap\e[0m"
sudo cp bas2tap /usr/bin
