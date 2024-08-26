#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# ttyd自动登录
sed -i "s?/bin/login?/usr/libexec/login.sh?g" feeds/packages/utils/ttyd/files/ttyd.config

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile

# Modify some code adaptation
#sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set DISTRIB_REVISION
sed -i "s/OpenWrt /Deng Build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# Modify default IP（FROM 192.168.1.1 CHANGE TO 10.10.10.1）
sed -i 's/192.168.1.1/192.168.31.31/g' package/base-files/files/bin/config_generate

# Modify system hostname（FROM OpenWrt CHANGE TO OpenWrt-N1）
sed -i 's/OpenWrt/OpenWrt-N1/g' package/base-files/files/bin/config_generate

sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template

# 修复部分插件自启动脚本丢失可执行权限问题
sed -i '/exit 0/i\chmod +x /etc/init.d/*' package/lean/default-settings/files/zzz-default-settings

# 拉取软件包

rm -rf feeds/luci/themes/luci-theme-argon

## DDNSGO 
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo


# 修改插件名字
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
sed -i 's/"带宽监控"/"带宽"/g' `grep "带宽监控" -rl ./`
sed -i 's/"TTYD 终端"/"终端"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"Aria2 配置"/"Aria2"/g' `grep "Aria2 配置" -rl ./`
sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
sed -i 's/"FTP 服务器"/"FTP"/g' `grep "FTP 服务器" -rl ./`
sed -i 's/"Alist 文件列表"/"Alist"/g' `grep "Alist 文件列表" -rl ./`
