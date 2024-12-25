# OpenWrt-Builder
基于 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 定制编译的主路由、旁路网关，跟随 ImmortalWrt 23.05 分支代码更新自动编译。

# 主路由
***支持 4/5G 模块拨号上网。***

## 定制内容
### 精简
1. 精简全部音频组件。

### 添加
1. 升级 golang 版本（geodata、xray 等依赖高版本 go）。
2. 更换 argon 主题。
3. 添加 ttyd 终端。
4. 添加 docker 服务。
5. 添加 upnp 服务。
6. 添加 kms 服务。
7. 添加 passwall。
8. 添加 usb、pci 4/5G 模块拨号、短信、基站锁定等功能。
9. 添加多功能定时任务。
10. 添加 iStore 应用市场。

## 安装
此处不再赘述。

## 配置
1. 默认账号 `root`，密码 `password`。
2. 默认 LAN 口 IP 为 `192.168.3.1`。通过 `/etc/config/network` 修改，重启后生效。
3. 推荐单独部署高级 DNS 服务。可参考 [NestingDNS](https://github.com/217heidai/NestingDNS)，一款尝试 AdGuardHome、MosDNS、SmartDNS 套娃使用最佳实践的 DNS 服务。


# 旁路网关
***仅能虚拟机安装（精简了实体卡驱动）。***

## 定制内容
### 精简
本着够用原则，非必要组件全部精简。
1. 精简 block-mount、automount 磁盘挂载相关组件。
2. 精简全部实体网卡组件，仅保留 e1000、e1000e、vmxnet3 虚拟网卡组件。
3. 精简 ppp 拨号组建。旁路网关不负责拨号。
3. 精简全部音频组件。
4. 精简全部 usb 组件。

### 添加
1. 升级 golang 版本（geodata、xray 等依赖高版本 go）。
2. 更换 argon 主题。
3. 添加 upnp 服务。
4. 添加定时重启。
5. 添加 passwall。

## 安装
注意：
1. 由于精简了实体网卡组件，仅支持虚拟机安装。
2. 作为旁路网关，仅需分配一张网卡用作 LAN 口即可。

### PVE LXC 容器安装方式
推荐使用 PVE LXC 容器安装，占用资源极少。  
WEB 页面无法直接创建 OpenWrt LXC 容器，此处需要使用 shell 命令进行创建。
1. 上传 `immortalwrt-X.X-x86-64-generic-rootfs.tar.gz` 文件至 PVE `/var/lib/vz/template/cache` 目录。
2. 使用 shell 命令创建 LXC 容器
    ```bash
    pct create 100 \
        local:vztmpl/immortalwrt-X.X-x86-64-generic-rootfs.tar.gz \
        --rootfs local-lvm:2 \
        --ostype unmanaged \
        --hostname OpenWrt \
        --arch amd64 \
        --cores 4 \
        --memory 2048 \
        --swap 0 \
        -net0 bridge=vmbr0,name=eth0
    ```
    参数说明：
    ```bash
    100		
        容器编号，请根据实际情况设置。
    local:vztmpl/immortalwrt-X.X-x86-64-generic-rootfs.tar.gz	
        容器模板，local:vztmpl 指向 /var/lib/vz/template/cache 目录，是 PVE 默认 CT 模板存放目录。immortalwrt-X.X.X-x86-64-generic-rootfs.tar.gz 为待安装文件。
    rootfs local-lvm:2
        根磁盘位置，local-lvm 可以根据实际情况修改为其他存储位置，2 表示磁盘大小为 2G。
    ostype unmanaged
        系统类型。
    hostname ImmortalWrt
        容器名称。
    arch amd64
        系统架构，amd64。
    cores 4
        分配给容器的 CPU 核心数。
    memory 2048
        分配给容器的内存大小，这里是 2G。
    swap 0
        分配给容器的交换区大小，建议设置为 0。
    net0 bridge=vmbr0,name=eth0
        容器网络设置，为容器中增加网卡 eth0 ，桥接到主机的 vmbr0 网卡。
    ```
3. 修改 LXC 容器配置文件 `/etc/pve/lxc/100.conf`（100 为以上创建容器时的容器编号），在文末增加：
    ```bash
    onboot: 1
    features: fuse=1,nesting=1
    lxc.include: /usr/share/lxc/config/openwrt.common.conf
    lxc.cgroup2.devices.allow: c 108:0 rwm
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
    lxc.cap.drop:
    ```
    参数说明：
    ```bash
    onboot: 1
        开机自启动。
    features: fuse=1,nesting=1
        特权容器，允许嵌套。不开特权容器会出现各种奇怪问题，如 dnsmasq 无法启动。
    lxc.include: /usr/share/lxc/config/openwrt.common.conf
        引用 PVE 自带的 OpenWrt 配置。
    lxc.cgroup2.devices.allow: c 108:0 rwm
        lxc 运行一些服务类的系统必须的。
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
        挂载 tun 到 lxc 内。
    lxc.cap.drop:
        取消 openwrt.common.conf 里面 对 cap 的限制，否则 openclash 等服务无法使用。
    ```

### 其它虚拟机安装方式
此处不再赘述。

## 配置
1. 默认账号 `root`，密码 `password`。
2. 默认 LAN 口 IP 为 `192.168.1.5`。通过 `/etc/config/network` 修改，重启后生效。
3. LAN 口网关修改为主路由 IP 地址。
4. LAN 口 DNS 修改为主路由 IP 地址。推荐单独部署高级 DNS 服务，将旁路网关的 DNS 指过去即可。可参考 [NestingDNS](https://github.com/217heidai/NestingDNS)，一款尝试 AdGuardHome、MosDNS、SmartDNS 套娃使用最佳实践的 DNS 服务。
5. 作为旁路网关，需关闭 LAN 口 DHCP，由主路由进行 DHCP。（如开启 DHCP 服务，则变为旁路路由模式）