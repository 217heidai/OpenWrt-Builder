# OpenWrt-Builder
Custom-compiled main routers and side gateways based on [ImmortalWrt](https://github.com/immortalwrt/immortalwrt), with automatic compilation following ImmortalWrt code updates.

## Supported ImmortalWrt Versions
* [x] ImmortalWrt-25.12
* [x] ImmortalWrt-24.10
* [x] ImmortalWrt-23.05

# Main Router
***Supports 4G/5G module dialing for internet access.***

## Customizations
### Slimming
1. Removed all audio components.

### Additions
1. Upgraded golang version (geodata, xray, etc., depend on a higher version of go).
2. Replaced theme with Argon.
3. Added ttyd terminal.
4. Added Docker service.
5. Added UPnP service.
6. Added KMS service.
7. Added Passwall.
8. Added USB/PCI 4G/5G module dialing, SMS, cell tower locking, and other features.

## Installation
Omitted here for brevity.

## Configuration
1. Default username `root`, password `password`.
2. Default LAN IP is `192.168.3.1`. Modify via `/etc/config/network` and restart to take effect.
3. It is recommended to deploy a separate advanced DNS service. Refer to [NestingDNS](https://github.com/217heidai/NestingDNS), a DNS service that attempts best practices for nesting AdGuardHome, MosDNS, and SmartDNS.


# Side Gateway
***Only for virtual machine installation (physical card drivers have been removed).***

## Customizations
### Slimming
Following the principle of "enough is enough," all non-essential components have been removed.
1. Removed block-mount and automount disk mounting components.
2. Removed all physical network card components; only e1000, e1000e, and vmxnet3 virtual network card components are retained.
3. Removed PPP dialing components. Side gateways are not responsible for dialing.
4. Removed all audio components.
5. Removed all USB components.

### Additions
1. Upgraded golang version (geodata, xray, etc., depend on a higher version of go).
2. Replaced theme with Argon.
3. Added UPnP service.
4. Added scheduled reboot.
5. Added Passwall.

## Installation
Note:
1. Due to the removal of physical network card components, it only supports VM installation.
2. As a side gateway, you only need to assign one network card as the LAN port.

### PVE LXC Container Installation Method
PVE LXC container installation is recommended as it consumes very few resources.
OpenWrt LXC containers cannot be created directly via the WEB UI; shell commands must be used.
1. Upload the `immortalwrt-X.X-x86-64-generic-rootfs.tar.gz` file to the PVE `/var/lib/vz/template/cache` directory.
2. Use shell commands to create the LXC container:
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
    Parameter explanation:
    ```bash
    100		
        Container ID, please set according to your actual situation.
    local:vztmpl/immortalwrt-X.X-x86-64-generic-rootfs.tar.gz	
        Container template. local:vztmpl points to the /var/lib/vz/template/cache directory, which is the default PVE CT template storage directory. immortalwrt-X.X.X-x86-64-generic-rootfs.tar.gz is the file to be installed.
    rootfs local-lvm:2
        Root disk location. local-lvm can be modified to other storage locations as needed. 2 indicates a disk size of 2G.
    ostype unmanaged
        System type.
    hostname ImmortalWrt
        Container name.
    arch amd64
        System architecture, amd64.
    cores 4
        Number of CPU cores assigned to the container.
    memory 2048
        Amount of memory assigned to the container, 2G in this case.
    swap 0
        Amount of swap space assigned to the container; it is recommended to set to 0.
    net0 bridge=vmbr0,name=eth0
        Container network settings, adding network card eth0 to the container and bridging it to the host's vmbr0 network card.
    ```
3. Modify the LXC container configuration file `/etc/pve/lxc/100.conf` (100 is the container ID used above), and add the following to the end of the file:
    ```bash
    onboot: 1
    unprivileged: 0
    features: fuse=1,nesting=1
    lxc.include: /usr/share/lxc/config/openwrt.common.conf
    lxc.cgroup2.devices.allow: c 108:0 rwm
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
    lxc.cap.drop:
    ```
    Parameter explanation:
    ```bash
    onboot: 1
        Enable auto-start on boot.
    unprivileged: 0
        Enable privileged container. Without privileges, various strange issues may occur, such as dnsmasq failing to start.
    features: fuse=1,nesting=1
        Enable FUSE and allow nesting.
    lxc.include: /usr/share/lxc/config/openwrt.common.conf
        Reference the built-in PVE OpenWrt configuration.
    lxc.cgroup2.devices.allow: c 108:0 rwm
        Necessary for LXC to run some service-oriented systems.
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
        Mount tun into LXC.
    lxc.cap.drop:
        Remove the cap restrictions in openwrt.common.conf, otherwise services like OpenClash cannot be used.
    ```

### Other Virtual Machine Installation Methods
Omitted here for brevity.

## Configuration
1. Default username `root`, password `password`.
2. Default LAN IP is `192.168.1.5`. Modify via `/etc/config/network` and restart to take effect.
3. Change the LAN gateway to the IP address of the main router.
4. Change the LAN DNS to the IP address of the main router. It is recommended to deploy a separate advanced DNS service and point the side gateway's DNS there. Refer to [NestingDNS](https://github.com/217heidai/NestingDNS), a DNS service that attempts best practices for nesting AdGuardHome, MosDNS, and SmartDNS.
5. As a side gateway, the LAN DHCP must be disabled, leaving DHCP to be handled by the main router. (If DHCP is enabled, it becomes a side-router mode).
