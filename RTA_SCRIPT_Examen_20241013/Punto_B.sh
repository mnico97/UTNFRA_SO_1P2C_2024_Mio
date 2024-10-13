#!/bin/bash

# Identifico disco 10 GiB
DISCO=/dev/sdc

# Crear particiones
sudo fdisk $DISCO << EOF
n
p
1

+1000M
n
p
2

+1000M
n
p
3

+1000M
n
p
4

e
n
l
5

+1000M
n
l
6

+1000M
n
l
7

+1000M
n
l
8

+1000M
n
l
9

+1000M
n
l
10

+1000M
w
EOF

# Mostrar particiones
sudo fdisk -l $DISCO

# Formatear las particiones
for i in {1..4}; do
    sudo mkfs.ext4 -F ${DISCO}${i}
done

for i in {5..10}; do
    sudo mkfs.ext4 -F ${DISCO}p${i}
done

# Inicializar índice de disco
INDICE_DISCO=1

# Montar particiones
for carpeta in alumno_1/parcial_1 alumno_1/parcial_2 alumno_1/parcial_3 alumno_2/parcial_1 alumno_2/parcial_2 alumno_2/parcial_3 alumno_3/parcial_1 alumno_3/parcial_2 alumno_3/parcial_3 profesores
do
    if [ $INDICE_DISCO -le 4 ]; then
        DISPOSITIVO=${DISCO}${INDICE_DISCO}
    else
        DISPOSITIVO=${DISCO}p$((INDICE_DISCO - 4))
    fi

    DIR="/Examenes-UTN/${carpeta}"

    echo "Montando disco ${DISPOSITIVO} en ${DIR}"

    # Asegurarse de que el directorio existe
    sudo mkdir -p $DIR

    # Agregar a fstab
    echo "${DISPOSITIVO} ${DIR} ext4 defaults 0 2" | sudo tee -a /etc/fstab

    # Aumento contador de disco
    INDICE_DISCO=$((INDICE_DISCO + 1))
done

# Montar todos los dispositivos
sudo mount -a
