#!/bin/bash

loadkeys ru
setfont cyr-sun16

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo 'Ваша разметка диска'
fdisk -l
read -p "Select a disk sd.. " sd_disk
echo "selected a disk $sd_disk.."


echo '2.4.2 Форматирование дисков'
sd_1=$sd_disk'1'
#sd_2=$sd_disk'2'
mkfs.ext4  /dev/$sd_1
#mkfs.ext4  /dev/$sd_2

echo '2.4.3 Монтирование дисков'
mkdir /mnt
mount /dev/$sd_1 /mnt
#mkdir /mnt/home
#mount /dev/$sd_2 /mnt/home

echo '3.1 Выбор зеркал для загрузки.'
rm -rf /etc/pacman.d/mirrorlist
curl https://raw.githubusercontent.com/AlexeyKozma/test/master/mirrorlist >> /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL github.com/AlexeyKozma/test/raw/master/archuefi2.sh)"
