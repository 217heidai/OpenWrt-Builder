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
    find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
    find feed/ -follow -name $1 | xargs -rt rm -rf
}
function clean_packages() {
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
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 删除
# 音频驱动
sed -i "s/CONFIG_PACKAGE_alsa-utils=y/# CONFIG_PACKAGE_alsa-utils is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-ac97=y/# CONFIG_PACKAGE_kmod-ac97 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-codec-hdmi=y/# CONFIG_PACKAGE_kmod-sound-hda-codec-hdmi is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-codec-realtek=y/# CONFIG_PACKAGE_kmod-sound-hda-codec-realtek is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-codec-via=y/# CONFIG_PACKAGE_kmod-sound-hda-codec-via is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-core=y/# CONFIG_PACKAGE_kmod-sound-hda-core is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-hda-intel=y/# CONFIG_PACKAGE_kmod-sound-hda-intel is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-i8x0=y/# CONFIG_PACKAGE_kmod-sound-i8x0 is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-sound-via82xx=y/# CONFIG_PACKAGE_kmod-sound-via82xx is not set/" .config
sed -i "s/CONFIG_PACKAGE_kmod-usb-audio=y/# CONFIG_PACKAGE_kmod-usb-audio is not set/" .config

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
# tty 终端
sed -i "s/# CONFIG_PACKAGE_luci-app-ttyd is not set/CONFIG_PACKAGE_luci-app-ttyd=y/" .config
# argon 主题
sed -i "s/# CONFIG_PACKAGE_luci-theme-argon is not set/CONFIG_PACKAGE_luci-theme-argon=y/" .config
# docker
sed -i "s/# CONFIG_PACKAGE_luci-app-dockerman is not set/CONFIG_PACKAGE_luci-app-dockerman=y/" .config
# upnp
sed -i "s/# CONFIG_PACKAGE_luci-app-upnp is not set/CONFIG_PACKAGE_luci-app-upnp=y/" .config
# kms
sed -i "s/# CONFIG_PACKAGE_luci-app-vlmcsd is not set/CONFIG_PACKAGE_luci-app-vlmcsd=y/" .config
# ip 绑定 mac
sed -i "s/# CONFIG_PACKAGE_luci-app-arpbind is not set/CONFIG_PACKAGE_luci-app-arpbind=y/" .config
# usb 2.0 3.0 支持
sed -i "s/# CONFIG_PACKAGE_kmod-usb2 is not set/CONFIG_PACKAGE_kmod-usb2=y/" .config
sed -i "s/# CONFIG_PACKAGE_kmod-usb3 is not set/CONFIG_PACKAGE_kmod-usb3=y/" .config
# usb 网络支持
sed -i "s/# CONFIG_PACKAGE_usbutils is not set/CONFIG_PACKAGE_usbutils=y/" .config
sed -i "s/# CONFIG_PACKAGE_usb-modeswitch is not set/CONFIG_PACKAGE_usb-modeswitch=y/" .config
sed -i "s/# CONFIG_PACKAGE_kmod-usb-serial is not set/CONFIG_PACKAGE_kmod-usb-serial=y/" .config
sed -i "s/# CONFIG_PACKAGE_kmod-usb-serial-option is not set/CONFIG_PACKAGE_kmod-usb-serial-option=y/" .config
sed -i "s/# CONFIG_PACKAGE_kmod-usb-net-rndis is not set/CONFIG_PACKAGE_kmod-usb-net-rndis=y/" .config

# 第三方软件包
mkdir -p package/custom
git clone --depth 1  https://github.com/217heidai/OpenWrt-Packages.git package/custom
clean_packages package/custom
## passwall
sed -i "s/# CONFIG_PACKAGE_luci-app-passwall is not set/CONFIG_PACKAGE_luci-app-passwall=y/" .config
### shadowsocks_rust 替代 shadowsocks_libev，否则无法正常编译
sed -i "s/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server is not set/" .config
sed -i "s/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client is not set/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=y/" .config
sed -i "s/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server is not set/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server=y/" .config
## 4G/5G 支持：FM350-GL USB RNDIS
### Siriling/5G-Modem-Support
echo 'CONFIG_PACKAGE_luci-app-modem=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-sms-tool=y' >> .config
### luci-app-modemband
sed -i "s/# CONFIG_PACKAGE_luci-app-modemband is not set/CONFIG_PACKAGE_luci-app-modemband=y/" .config
### luci-app-3ginfo-lite
sed -i "s/# CONFIG_PACKAGE_luci-app-3ginfo-lite is not set/CONFIG_PACKAGE_luci-app-3ginfo-lite=y/" .config
## 定时任务。重启、关机、重启网络、释放内存、系统清理、网络共享、关闭网络、自动检测断网重连、MWAN3负载均衡检测重连、自定义脚本等10多个功能
echo 'CONFIG_PACKAGE_luci-app-autotimeset=y' >> .config
sed -i "s/# CONFIG_PACKAGE_luci-lib-ipkg is not set/CONFIG_PACKAGE_luci-lib-ipkg=y/" .config
## 分区扩容。一键自动格式化分区、扩容、自动挂载插件，专为OPENWRT设计，简化OPENWRT在分区挂载上烦锁的操作
echo 'CONFIG_PACKAGE_luci-app-partexp=y' >> .config
## iStore 应用市场
echo 'CONFIG_PACKAGE_luci-app-store=y' >> .config


# 镜像生成
# 修改分区大小
#sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=32/CONFIG_TARGET_KERNEL_PARTSIZE=32/" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=160/CONFIG_TARGET_ROOTFS_PARTSIZE=2048/" .config
# 调整 GRUB_TIMEOUT
sed -i "s/CONFIG_GRUB_TIMEOUT=\"3\"/CONFIG_GRUB_TIMEOUT=\"1\"/" .config
## 不生成 EXT4 硬盘格式镜像
sed -i "s/CONFIG_TARGET_ROOTFS_EXT4FS=y/# CONFIG_TARGET_ROOTFS_EXT4FS is not set/" .config
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
## 生成 QCOW2
#sed -i "s/# CONFIG_QCOW2_IMAGES=y/CONFIG_QCOW2_IMAGES is not set/" .config