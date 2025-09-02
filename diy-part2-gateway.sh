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

function config_del(){
    yes="CONFIG_$1=y"
    no="# CONFIG_$1 is not set"

    sed -i "s/$yes/$no/" .config
}

function config_add(){
    yes="CONFIG_$1=y"
    no="# CONFIG_$1 is not set"

    sed -i "s/${no}/${yes}/" .config

    if ! grep -q "$yes" .config; then
        echo "$yes" >> .config
    fi
}

function config_package_del(){
    package="PACKAGE_$1"
    config_del $package
}

function config_package_add(){
    package="PACKAGE_$1"
    config_add $package
}

function drop_package(){
    if [ "$1" != "golang" ];then
        # feeds/base -> package
        find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
        find feeds/ -follow -name $1 -not -path "feeds/base/custom/*" | xargs -rt rm -rf
    fi
}
function clean_packages(){
    path=$1
    dir=$(ls -l ${path} | awk '/^d/ {print $NF}')
    for item in ${dir}
        do
            drop_package ${item}
        done
}

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.5/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 删除
# Base system
config_package_del block-mount
# Extra packages
config_package_del automount
# Firmware
config_package_del bnx2-firmware
config_package_del i915-firmware-dmc
# Network Devices
config_package_del kmod-8139cp
config_package_del kmod-8139too
config_package_del kmod-amazon-ena
config_package_del kmod-amd-xgbe
config_package_del kmod-bnx2
config_package_del kmod-dwmac-intel
config_package_del kmod-forcedeth
config_package_del kmod-i40e
config_package_del kmod-igb
config_package_del kmod-igbvf
config_package_del kmod-igc
config_package_del kmod-ixgbe
config_package_del kmod-ixgbevf
config_package_del kmod-libphy
config_package_del kmod-macvlan
config_package_del kmod-mdio-devres
config_package_del kmod-mii
config_package_del kmod-net-selftests
config_package_del kmod-pcnet32
config_package_del kmod-pcs-xpcs
config_package_del kmod-phy-ax88796b
config_package_del kmod-phylink
config_package_del kmod-r8101
config_package_del kmod-r8125
config_package_del kmod-r8126
config_package_del kmod-r8168
config_package_del kmod-stmmac-core
config_package_del kmod-tg3
config_package_del kmod-tulip
# Network Support
config_package_del kmod-ppp
config_package_del kmod-mppe
config_package_del kmod-pppoe
config_package_del kmod-pppox
# Sound Support
config_package_del kmod-sound-core
# USB Support
config_package_del kmod-usb-core
config_package_del kmod-usb-hid
config_package_del kmod-usb-net
config_package_del kmod-usb-net-asix
config_package_del kmod-usb-net-asix-ax88179
config_package_del kmod-usb-net-rtl8150
config_package_del kmod-usb-net-rtl8152-vendor
config_package_del kmod-usb-storage
config_package_del kmod-usb-storage-extras
config_package_del kmod-usb-storage-uas
# Video Support
config_package_del kmod-acpi-video
config_package_del kmod-backlight
config_package_del kmod-drm
config_package_del kmod-drm-buddy
config_package_del kmod-drm-display-helper
config_package_del kmod-drm-exec
config_package_del kmod-drm-i915
config_package_del kmod-drm-kms-helper
config_package_del kmod-drm-suballoc-helper
config_package_del kmod-drm-ttm
config_package_del kmod-drm-ttm-helper
config_package_del kmod-fb
config_package_del kmod-fb-cfb-copyarea
config_package_del kmod-fb-cfb-fillrect
config_package_del kmod-fb-cfb-imgblt
config_package_del kmod-fb-sys-fops
config_package_del kmod-fb-sys-ram
# Other
config_package_del luci-app-rclone_INCLUDE_rclone-webui
config_package_del luci-app-rclone_INCLUDE_rclone-ng

# 新增
# luci
config_package_add luci
config_package_add default-settings-chn
# bbr
config_package_add kmod-tcp-bbr
# coremark cpu 跑分
config_package_add coremark
# autocore + lm-sensors-detect： cpu 频率、温度
config_package_add autocore
config_package_add lm-sensors-detect
# nano 替代 vim
config_package_add nano
# upnp
config_package_add luci-app-upnp
# autoreboot
config_package_add luci-app-autoreboot
# python3
#config_package_add python3
#config_package_add python3-base
#config_package_add python3-pip

# 第三方软件包
mkdir -p package/custom
git clone --depth 1  https://github.com/217heidai/OpenWrt-Packages.git package/custom
clean_packages package/custom
## golang
rm -rf feeds/packages/lang/golang
mv package/custom/golang feeds/packages/lang/
## argon 主题
config_package_add luci-theme-argon
## passwall
config_package_add luci-app-passwall
config_package_add luci-app-passwall_Nftables_Transparent_Proxy
config_package_del luci-app-passwall_Iptables_Transparent_Proxy
config_package_del luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client
config_package_del luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server
config_package_del luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client
config_package_del luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server
config_package_del luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client
config_package_del luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Server
## luci-app-easytier
config_package_add luci-app-easytier

# 镜像生成
# 修改分区大小
sed -i "/CONFIG_TARGET_KERNEL_PARTSIZE/d" .config
echo "CONFIG_TARGET_KERNEL_PARTSIZE=32" >> .config
sed -i "/CONFIG_TARGET_ROOTFS_PARTSIZE/d" .config
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=1024" >> .config
# 调整 GRUB_TIMEOUT
sed -i "s/CONFIG_GRUB_TIMEOUT=\"3\"/CONFIG_GRUB_TIMEOUT=\"1\"/" .config
## 不生成 EXT4 硬盘格式镜像
config_del TARGET_ROOTFS_EXT4FS
## 不生成非 EFI 镜像
config_del GRUB_IMAGES