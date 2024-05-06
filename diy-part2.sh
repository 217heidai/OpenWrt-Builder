#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Modify default IP
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate


# 原生插件
#sed -i "s///" .config
# 补齐中文界面
echo '
CONFIG_PACKAGE_luci-i18n-opkg-zh-cn=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
' >> .config
# CPU 跑分
sed -i "s/# CONFIG_PACKAGE_coremark is not set/CONFIG_PACKAGE_coremark=y/" .config
# CPU 温度
sed -i "s/# CONFIG_PACKAGE_lm-sensors-detect is not set/CONFIG_PACKAGE_lm-sensors-detect=y/" .config
# tcp bbr
sed -i "s/# CONFIG_PACKAGE_kmod-tcp-bbr is not set/CONFIG_PACKAGE_kmod-tcp-bbr=y/" .config
# nano 替代 vim
sed -i "s/# CONFIG_PACKAGE_nano is not set/CONFIG_PACKAGE_nano=y/" .config
# tty 终端
sed -i "s/# CONFIG_PACKAGE_luci-app-ttyd is not set/CONFIG_PACKAGE_luci-app-ttyd=y/" .config
# argon 主题
sed -i "s/# CONFIG_PACKAGE_luci-theme-argon is not set/CONFIG_PACKAGE_luci-theme-argon=y/" .config
# docker
sed -i "s/# CONFIG_PACKAGE_luci-app-dockerman is not set/CONFIG_PACKAGE_luci-app-dockerman=y/" .config
# passwall
#echo 'CONFIG_PACKAGE_luci-i18n-passwall-zh-cn=y' >> .config
sed -i "s/# CONFIG_PACKAGE_luci-app-passwall is not set/CONFIG_PACKAGE_luci-app-passwall=y/" .config
# upnp
#echo 'CONFIG_PACKAGE_luci-i18n-upnp-zh-cn=y' >> .config
sed -i "s/# CONFIG_PACKAGE_luci-app-upnp is not set/CONFIG_PACKAGE_luci-app-upnp=y/" .config
# USB 2.0 3.0 支持
sed -i "s/# CONFIG_PACKAGE_usbutils is not set/CONFIG_PACKAGE_usbutils=y/" .config
sed -i "s/# CONFIG_PACKAGE_usb-modeswitch is not set/CONFIG_PACKAGE_usb-modeswitch=y/" .config
sed -i "s/# CONFIG_PACKAGE_kmod-usb2 is not set/CONFIG_PACKAGE_kmod-usb2=y/" .config
sed -i "s/# CONFIG_PACKAGE_kmod-usb3 is not set/CONFIG_PACKAGE_kmod-usb3=y/" .config
# USB 共享网络支持
sed -i "s# CONFIG_PACKAGE_kmod-usb-net-cdc-ether is not set/CONFIG_PACKAGE_kmod-usb-net-cdc-ether=y/" .config
# iphone USB 网络共享
sed -i "s/# CONFIG_PACKAGE_kmod-usb-net-ipheth is not set/CONFIG_PACKAGE_kmod-usb-net-ipheth=y/" .config
# android USB 网络共享
sed -i "s/# CONFIG_PACKAGE_kmod-usb-net-rndis is not set/CONFIG_PACKAGE_kmod-usb-net-rndis=y/" .config
# 4G/5G 模块支持
sed -i "s/# CONFIG_PACKAGE_kmod-usb-serial is not set/CONFIG_PACKAGE_kmod-usb-serial=y/" .config
sed -i "s/# CONFIG_PACKAGE_kmod-usb-serial-option is not set/CONFIG_PACKAGE_kmod-usb-serial-option=y/" .config
sed -i "s/# CONFIG_PACKAGE_sms-tool is not set/CONFIG_PACKAGE_sms-tool=y/" .config
sed -i "s/# CONFIG_PACKAGE_luci-app-modemband is not set/CONFIG_PACKAGE_luci-app-modemband=y/" .config
sed -i "s/# CONFIG_PACKAGE_luci-app-3ginfo-lite is not set/CONFIG_PACKAGE_luci-app-3ginfo-lite=y/" .config

# 第三方插件
# 定时任务。重启、关机、重启网络、释放内存、系统清理、网络共享、关闭网络、自动检测断网重连、MWAN3负载均衡检测重连、自定义脚本等10多个功能
git clone https://github.com/sirpdboy/luci-app-autotimeset.git package/luci-app-autotimeset
echo 'CONFIG_PACKAGE_luci-app-autotimeset=y' >> .config
# 分区扩容。一键自动格式化分区、扩容、自动挂载插件，专为OPENWRT设计，简化OPENWRT在分区挂载上烦锁的操作
git clone https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp
echo 'CONFIG_PACKAGE_luci-app-partexp=y' >> .config


# 镜像生成
# 修改分区大小
#sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=32/CONFIG_TARGET_KERNEL_PARTSIZE=32/" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=160/CONFIG_TARGET_ROOTFS_PARTSIZE=1024/" .config
# 调整 GRUB_TIMEOUT
sed -i "s/CONFIG_GRUB_TIMEOUT=\"3\"/CONFIG_GRUB_TIMEOUT=\"1\"/" .config
## 不生成 EXT4 硬盘格式镜像
#sed -i "s/CONFIG_TARGET_ROOTFS_EXT4FS=y/# CONFIG_TARGET_ROOTFS_EXT4FS is not set/" .config
## 不生成非 EFI 镜像
sed -i "s/CONFIG_GRUB_IMAGES=y/# CONFIG_GRUB_IMAGES is not set/" .config
## 不生成 ISO
#sed -i "s/CONFIG_ISO_IMAGES=y/# CONFIG_ISO_IMAGES is not set/" .config
## 不生成 VHDX
#sed -i "s/CONFIG_VHDX_IMAGES=y/# CONFIG_VHDX_IMAGES is not set/" .config
## 不生成 VDI
#sed -i "s/CONFIG_VDI_IMAGES=y/# CONFIG_VDI_IMAGES is not set/" .config
## 不生成 VMDK
#sed -i "s/CONFIG_VMDK_IMAGES=y/# CONFIG_VMDK_IMAGES is not set/" .config
## 不生成 QCOW2
#sed -i "s/CONFIG_QCOW2_IMAGES=y/# CONFIG_QCOW2_IMAGES is not set/" .config