#!/bin/bash
# yml 传入的路由器型号 PROFILE
echo "构建文件: $PROFILE"
echo "是否包含Docker: $INCLUDE_DOCKER"
echo "构建固件打小: $ROOTSIZE"

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始构建..."


# 定义所需安装的包列表 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"

#24.10.1
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
# 增加几个必备组件 方便用户安装iStore
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"


# 判断是否需要编译 Docker 插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    echo "添加软件包: luci-i18n-dockerman-zh-cn"
fi


# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - 构建镜像（包含下列软件包):"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 构建失败！"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - 构建完成。"
