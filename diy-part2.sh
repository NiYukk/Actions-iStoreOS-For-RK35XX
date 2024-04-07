#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 移植黑豹x2

# rm -f target/linux/rockchip/image/rk35xx.mk
# cp -f $GITHUB_WORKSPACE/file/rk35xx.mk target/linux/rockchip/image/rk35xx.mk


# rm -f target/linux/rockchip/rk35xx/base-files/lib/board/init.sh
# cp -f $GITHUB_WORKSPACE/file/init.sh target/linux/rockchip/rk35xx/base-files/lib/board/init.sh


# rm -f target/linux/rockchip/rk35xx/base-files/etc/board.d/02_network
# cp -f $GITHUB_WORKSPACE/file/02_network target/linux/rockchip/rk35xx/base-files/etc/board.d/02_network


sed -i "s/option\s*script_timeout\s*60/option script_timeout 360/g" package/network/services/uhttpd/files/uhttpd.config




# 修改内核配置文件
# rm -f target/linux/rockchip/rk35xx/config-5.10
# cp -f $GITHUB_WORKSPACE/file/config-5.10 target/linux/rockchip/rk35xx/config-5.10
sed -i "/# CONFIG_ROCKCHIP_RGA2 is not set/d" target/linux/rockchip/rk35xx/config-5.10
sed -i "/CONFIG_ROCKCHIP_RGA2_DEBUGGER=y/d" target/linux/rockchip/rk35xx/config-5.10
sed -i "/CONFIG_ROCKCHIP_RGA2_DEBUG_FS=y/d" target/linux/rockchip/rk35xx/config-5.10
sed -i "/CONFIG_ROCKCHIP_RGA2_PROC_FS=y/d" target/linux/rockchip/rk35xx/config-5.10




# 替换dts文件
cp -f $GITHUB_WORKSPACE/file/rk3566-jp-tvbox.dts target/linux/rockchip/dts/rk3568/rk3566-jp-tvbox.dts

cp -f $GITHUB_WORKSPACE/file/rk3566-panther-x2.dts target/linux/rockchip/dts/rk3568/rk3566-panther-x2.dts







# 增加ido3568 DG NAS
echo -e "\\ndefine Device/dg_nas
\$(call Device/rk3568)
  DEVICE_VENDOR := DG
  DEVICE_MODEL := NAS
  DEVICE_DTS := rk3568-firefly-roc-pc-se
  SUPPORTED_DEVICES += dg,nas
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core
endef
TARGET_DEVICES += dg_nas" >> target/linux/rockchip/image/rk35xx.mk



sed -i "s/panther,x2|\\\/panther,x2|\\\\\n	dg,nas|\\\/g" target/linux/rockchip/rk35xx/base-files/lib/board/init.sh

sed -i "s/panther,x2|\\\/panther,x2|\\\\\n	dg,nas|\\\/g" target/linux/rockchip/rk35xx/base-files/etc/board.d/02_network


cp -f $GITHUB_WORKSPACE/file/rk3568-firefly-roc-pc-se-core.dtsi target/linux/rockchip/dts/rk3568/rk3568-firefly-roc-pc-se-core.dtsi

cp -f $GITHUB_WORKSPACE/file/rk3568-firefly-roc-pc-se.dts target/linux/rockchip/dts/rk3568/rk3568-firefly-roc-pc-se.dts

# adguardhome
svn export https://github.com/kenzok8/openwrt-packages/luci-app-adguardhome package/luci-app-adguardhome
svn export https://github.com/kenzok8/openwrt-packages/adguardhome package/adguardhome
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome package/luci-app-adguardhome
# svn export https://github.com/kiddin9/openwrt-packages/trunk/adguardhome package/adguardhome

# openclash
svn export https://github.com/kenzok8/openwrt-packages/luci-app-openclash  package/luci-app-openclash
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-openclash  package/luci-app-openclash
# 加入OpenClash核心
chmod -R a+x $GITHUB_WORKSPACE/preset-clash-core.sh
if [ "$1" = "rk33xx" ]; then
    $GITHUB_WORKSPACE/preset-clash-core.sh arm64
elif [ "$1" = "rk35xx" ]; then
    $GITHUB_WORKSPACE/preset-clash-core.sh arm64
elif [ "$1" = "x86" ]; then
    $GITHUB_WORKSPACE/preset-clash-core.sh amd64
fi
