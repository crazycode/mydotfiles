#!/bin/sh

# 2010-3-28 前使用的
sudo pacman -S --needed xfce4-notifyd gksu dhclient wpa_supplicant python-notify python-wpactrl python-iwscan \
     firefox firefox-i18n conkeror-git stardict \
     emacs emacs-muse openoffice-zh-CN \
     mysql \
     jdk maven apache-ant \
     zsh screen rxvt-unicode-256color \
     git subversion cvs tk \
     pidgin pidgin-encryption purple-plugin-pack \
     ttf-dejavu wqy-bitmapfont wqy-zenhei ttf-arphic-ukai ttf-arphic-uming ttf-fireflysung ttf-ms-fonts \
     rdesktop libvncserver \
     hsetroot \
     fcitx rar unzip tree

# for awesome
sudo pacman -S luafilesystem

# 2010-3-29起。。。
sudo pacman -S xlockmore xautolock scrot dmenu

sudo pacman -S pmount  # 使用普通用户挂载移动设备
sudo pacman -S graphviz # 用于生成railroad图片

yaourt -S google-chrome-dev grdc proxychains sdcv calibre
yaourt -S dropbox

yaourt -S halevt  # 自动挂载USB/移动硬盘 需要测试一下

# for org-mode
yaourt -S emacs-org-mode
