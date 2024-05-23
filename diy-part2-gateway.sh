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
sed -i "s/CONFIG_PACKAGE_block-mount=y/# CONFIG_PACKAGE_block-mount is not set/" .config
# Extra packages
sed -i "s/CONFIG_PACKAGE_automount=y/# CONFIG_PACKAGE_automount is not set/" .config
# Network Devices
sed -i "s/CONFIG_PACKAGE_kmod-8139cp=y/# CONFIG_PACKAGE_kmod-8139cp is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-8139too=y/# CONFIG_PACKAGE_kmod-8139too is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-amazon-ena=y/# CONFIG_PACKAGE_kmod-amazon-ena is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-amd-xgbe=y/# CONFIG_PACKAGE_kmod-amd-xgbe is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-bnx2=y/# CONFIG_PACKAGE_kmod-bnx2 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-forcedeth=y/# CONFIG_PACKAGE_kmod-forcedeth is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-i40e=y/# CONFIG_PACKAGE_kmod-i40e is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-igb=y/# CONFIG_PACKAGE_kmod-igb is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-igbvf=y/# CONFIG_PACKAGE_kmod-igbvf is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-igc=y/# CONFIG_PACKAGE_kmod-igc is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-ixgbe=y/# CONFIG_PACKAGE_kmod-ixgbe is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-macvlan=y/# CONFIG_PACKAGE_kmod-macvlan is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-mdio-devres=y/# CONFIG_PACKAGE_kmod-mdio-devres is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-mii=y/# CONFIG_PACKAGE_kmod-mii is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-net-selftests=y/# CONFIG_PACKAGE_kmod-net-selftests is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-pcnet32=y/# CONFIG_PACKAGE_kmod-pcnet32 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-phy-ax88796b=y/# CONFIG_PACKAGE_kmod-phy-ax88796b is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-r8101=y/# CONFIG_PACKAGE_kmod-r8101 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-r8125=y/# CONFIG_PACKAGE_kmod-r8125 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-r8168=y/# CONFIG_PACKAGE_kmod-r8168 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-tg3=y/# CONFIG_PACKAGE_kmod-tg3 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-tulip=y/# CONFIG_PACKAGE_kmod-tulip is not set/" .config
# Network Support
sed -i "s/CONFIG_PACKAGE_kmod-ppp=y/# CONFIG_PACKAGE_kmod-ppp is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-mppe=y/# CONFIG_PACKAGE_kmod-mppe is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-pppoe=y/# CONFIG_PACKAGE_kmod-pppoe is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-pppox=y/# CONFIG_PACKAGE_kmod-pppox is not set/" .config
# Sound Support
sed -i "s/CONFIG_PACKAGE_kmod-sound-core=y/# CONFIG_PACKAGE_kmod-sound-core is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-ac97=y/# CONFIG_PACKAGE_kmod-ac97 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-core=y/# CONFIG_PACKAGE_kmod-sound-hda-core is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-codec-hdmi=y/# CONFIG_PACKAGE_kmod-sound-hda-codec-hdmi is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-codec-realtek=y/# CONFIG_PACKAGE_kmod-sound-hda-codec-realtek is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-codec-via=y/# CONFIG_PACKAGE_kmod-sound-hda-codec-via is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-intel=y/# CONFIG_PACKAGE_kmod-sound-hda-intel is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-i8x0=y/# CONFIG_PACKAGE_kmod-sound-i8x0 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-mpu401=y/# CONFIG_PACKAGE_kmod-sound-mpu401 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-via82xx=y/# CONFIG_PACKAGE_kmod-sound-via82xx is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-audio=y/# CONFIG_PACKAGE_kmod-usb-audio is not set/" .config
# USB Support
sed -i "s/CONFIG_PACKAGE_kmod-usb-core=y/# CONFIG_PACKAGE_kmod-usb-core is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-hid=y/# CONFIG_PACKAGE_kmod-usb-hid is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-net=y/# CONFIG_PACKAGE_kmod-usb-net is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-net-asix=y/# CONFIG_PACKAGE_kmod-usb-net-asix is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-net-asix-ax88179=y/# CONFIG_PACKAGE_kmod-usb-net-asix-ax88179 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-net-rtl8150=y/# CONFIG_PACKAGE_kmod-usb-net-rtl8150 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-net-rtl8152-vendor=y/# CONFIG_PACKAGE_kmod-usb-net-rtl8152-vendor is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-storage=y/# CONFIG_PACKAGE_kmod-usb-storage is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-storage-extras=y/# CONFIG_PACKAGE_kmod-usb-storage-extras is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-storage-uas=y/# CONFIG_PACKAGE_kmod-usb-storage-uas is not set/" .config

# 新增
# luci
sed -i "s/# CONFIG_PACKAGE_luci is not set/CONFIG_PACKAGE_luci=y/" .config
sed -i "s/# CONFIG_PACKAGE_default-settings-chn is not set/CONFIG_PACKAGE_default-settings-chn=y/" .config
# coremark cpu 跑分
sed -i "s/# CONFIG_PACKAGE_coremark is not set/CONFIG_PACKAGE_coremark=y/" .config
# autocore + lm-sensors-detect： cpu 频率、温度
sed -i "s/# CONFIG_PACKAGE_autocore is not set/CONFIG_PACKAGE_autocore=y/" .config
sed -i "s/# CONFIG_PACKAGE_lm-sensors-detect is not set/CONFIG_PACKAGE_lm-sensors-detect=y/" .config
# nano 替代 vim
sed -i "s/# CONFIG_PACKAGE_nano is not set/CONFIG_PACKAGE_nano=y/" .config
# upnp
sed -i "s/# CONFIG_PACKAGE_luci-app-upnp is not set/CONFIG_PACKAGE_luci-app-upnp=y/" .config
# 定时重启
sed -i "s/# CONFIG_PACKAGE_luci-app-autoreboot is not set/CONFIG_PACKAGE_luci-app-autoreboot=y/" .config

# 第三方软件包
mkdir -p package/custom
git clone --depth 1  https://github.com/217heidai/OpenWrt-Packages.git package/custom
clean_packages package/custom
# golang
rm -rf feeds/packages/lang/golang
mv package/custom/golang feeds/packages/lang/
# argon 主题
sed -i "s/# CONFIG_PACKAGE_luci-theme-argon is not set/CONFIG_PACKAGE_luci-theme-argon=y/" .config
## passwall
sed -i "s/# CONFIG_PACKAGE_luci-app-passwall is not set/CONFIG_PACKAGE_luci-app-passwall=y/" .config
sed -i "s/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client is not set/" .config

# 镜像生成
# 修改分区大小
#sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=32/CONFIG_TARGET_KERNEL_PARTSIZE=32/" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=160/CONFIG_TARGET_ROOTFS_PARTSIZE=1024/" .config
# 调整 GRUB_TIMEOUT
sed -i "s/CONFIG_GRUB_TIMEOUT=\"3\"/CONFIG_GRUB_TIMEOUT=\"1\"/" .config
## 不生成 EXT4 硬盘格式镜像
sed -i "s/CONFIG_TARGET_ROOTFS_EXT4FS=y/# CONFIG_TARGET_ROOTFS_EXT4FS is not set/" .config
## 不生成非 EFI 镜像
sed -i "s/CONFIG_GRUB_IMAGES=y/# CONFIG_GRUB_IMAGES is not set/" .config