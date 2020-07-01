#!/bin/bash

function diskor()
{
    while [[ true ]]; do
    lsblk
    read -p "Введите имя диска, куда булет установлен Archlinux.
    Пример sda, sdb ...
    Или введит 'q' для выхода: " disk_name
    if [[ $disk_name == 'q' ]]; then
        return 0
    read -p "Выбран диск $disk_name подтвердить" disk_on
    elif [[ $disk_on == 'y' ]] || [[ $disk_on == 'yes' ]]; then 


        echo 'создание разделов'
        (
        echo g;

        echo n;
        echo;
        echo;
        echo +512M;
        echo y;
        echo t;
        echo 1;

        echo n;
        echo;
        echo;
        echo +30G;
        echo y;
        
        
        echo n;
        echo;
        echo;
        echo;
        echo y;
        
        echo w;
        ) | fdisk /dev/$disk_name 

        echo 'Форматирование дисков'
        sd_1=$disk_name'1'
        sd_2=$disk_name'2'
        sd_3=$disk_name'3'
        mkfs.fat -F32 /dev/$sd_1 &&
        mkfs.ext4  /dev/$sd_2 &&
        mkfs.ext4  /dev/$sd_3 &&

        echo 'Монтирование дисков' &&
        mount /dev/$sd_2 /mnt &&
        mkdir /mnt/home &&
        mkdir -p /mnt/boot/efi &&
        mount /dev/$sd_1 /mnt/boot/efi &&
        mount /dev/$sd_3 /mnt/home && 
        return 0
    
    fi
    done

   return 1
}

function mirrors()
{
    echo 'Выбор зеркал для загрузки.'
    rm -rf /etc/pacman.d/mirrorlist &&
    wget https://github.com/AlexeyKozma/test/raw/master/mirrorlist && 
    mv -f ~/mirrorlist /etc/pacman.d/mirrorlist &&
    return 0
}

function install_base()
{   
    count=1
    while [ $count -lt 5 ]; do
        pacstrap /mnt base base-devel btrfs-progs dmidecode dosfstools e2fsprogs efibootmgr exfat-utils 
        f2fs-tools fakeroot findutils gptfdisk grep grub haveged hdparm intel-ucode ipw2100-fw 
        ipw2200-fw less linux linux-atm linux-firmware linux-headers lsb-release lvm2 memtest86+ 
        ntfs-3g os-prober refind-efi reiserfsprogs rsync shadow smartmontools syslinux  
        systemd-sysvcompat tar tlp upower usb_modeswitch usbutils util-linux wget wireless_tools 
        wireless-regdb wvdial x264 xfsprogs
        if [[ $? ]]; then
            genfstab -pU /mnt >> /mnt/etc/fstab
            return 0
        fi
        let $count+=1 
    done
}

# menu 1) Информация облочных устройствых (Дисках)


function menu_install()
{
    local result
    # Этапы установки 
    # Вывод инвормации 
    while [[ true ]]
    do
    printf "############# \n# 1) разметка жесткого диска\n# 2) Выбор зекал\n# 3) Установка основных пакетов \n# 
    4) Выход \n############# Ввод: "
    read -p "  " exit_e
        case $exit_e in 
        1) diskor ;;
        2) mirrors ;;
        3) install_base ;;
        4) ;;
        5) break ;;
        esac
    done
} 


menu_install