#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 使用 O2 级别的优化
sed -i 's,Os,O2 -march=x86-64-v2,g' include/target.mk

# 关闭 Spectre & Meltdown 补丁
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-efi.cfg
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-iso.cfg
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-pc.cfg

# 自定义 feed 必须置于官方 feed 之前：feeds install 同名包先到先得
{ echo 'src-git zz_openwrtpackages https://github.com/217heidai/OpenWrt-Packages.git;openwrt-25.12'
  echo 'src-git qmodem https://github.com/FUjr/QModem.git;main'
  cat feeds.conf.default; } > feeds.conf.default.tmp && mv feeds.conf.default.tmp feeds.conf.default