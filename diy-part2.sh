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

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.101/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.1.101/g' package/base-files/luci2/bin/config_generate
sed -i 's/192.168.1.1/192.168.1.101/g' package/base-files/Makefile
sed -i 's/192.168.1.1/192.168.1.101/g' package/base-files/image-config.in

########### 更改默认主题（可选）###########
# 删除主题
rm -rf feeds/luci/themes/luci-theme-argon

# 拉取 argone 源码
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

# 修改主题配置
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-ssl-nginx/Makefile

# 更改Argon主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

########### 更改默认主题（可选）###########

# 为 armvirt 架构添加 autocore 支持
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# 设置OpenWrt 发行版的修订版本
sed -i "s/OpenWrt /Deng Build $(TZ=UTC-8 date "+%Y.%m") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# 设置samba4权限
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template

# 修复部分插件自启动脚本丢失可执行权限问题
sed -i '/exit 0/i\chmod +x /etc/init.d/*' package/lean/default-settings/files/zzz-default-settings

# 在线用户
git clone --depth=1 https://github.com/danchexiaoyang/luci-app-onliner.git package/luci-app-onliner

## DDNSGO 
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

# 调整终端到系统菜单
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3a \		"order": 10,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's,终端,终端管理,g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po

# 调整nlbwmon带宽监控调整菜单位置到网络
sed -i 's/services/network/g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's/services/network/g' feeds/luci/applications/luci-app-nlbwmon/htdocs/luci-static/resources/view/nlbw/config.js

# 调整alist到nas菜单
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json

# 修改插件名字
sed -i 's/"管理权"/"管理"/g' `grep "管理权" -rl ./`
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
sed -i 's/"AdGuard Home"/"AdGuard"/g' `grep "AdGuard Home" -rl ./`
sed -i 's/"NAS"/"存储"/g' `grep "NAS" -rl ./`
sed -i 's/"Aria2 配置"/"Aria2"/g' `grep "Aria2 配置" -rl ./`
sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
sed -i 's/"frp 客户端"/"Frp"/g' `grep "frp 客户端" -rl ./`
sed -i 's/"Alist 文件列表"/"Alist"/g' `grep "Alist 文件列表" -rl ./`
sed -i 's/"挂载点"/"磁盘挂载"/g' `grep "挂载点" -rl ./`

# 调整部分插件名字
sed -i '/msgid "Reboot"/{n;s/重启/重启设备/;}' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i '/msgid "Software"/{n;s/软件包/软件管理/;}' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i '/msgid "Startup"/{n;s/启动项/启动管理/;}' feeds/luci/modules/luci-base/po/zh_Hans/base.po

# 调整部分插件菜单
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/aria2.lua
sed -i 's/services/nas/g' /usr/lib/lua/luci/view/aria2/overview_status.htm
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/hd_idle.lua
# sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/samba4.lua

