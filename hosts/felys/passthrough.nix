{pkgs, ...}: let
  # pipewireEnv = "PIPEWIRE_RUNTIME_DIR=/run/user/1000 PIPEWIRE_LATENCY=512/48000 LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/run/current-system/sw/lib/pipewire LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/run/current-system/sw/lib/pipewire'";
  # gamingVM = ''
  #   ${pipewireEnv}
  #   ${pkgs.qemu-vfio}/bin/qemu-system-x86_64
  #   -name guest=gaming,debug-threads=on
  #   -blockdev '{"driver":"file","filename":"${pkgs.OVMF.fd}/FV/OVMF_CODE.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}'
  #   -blockdev '{"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}' -blockdev '{"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/win11_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"}'
  #   -blockdev '{"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","file":"libvirt-pflash1-storage"}'
  #   -machine pc-q35-8.0,usb=off,vmport=off,kernel_irqchip=on,dump-guest-core=off,memory-backend=pc.ram,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format,hpet=off,acpi=on
  #   -accel kvm
  #   -cpu host,migratable=on,topoext=on,hv-time=on,hv-relaxed=on,hv-vapic=on,hv-spinlocks=0x1fff,hv-vpindex=on,hv-runtime=on,hv-synic=on,hv-stimer=on,hv-vendor-id=randomid,hv-frequencies=on,hv-tlbflush=on,hv-ipi=on,kvm=off
  #   -m 32768
  #   -object '{"qom-type":"memory-backend-ram","id":"pc.ram","size":34359738368}'
  #   -overcommit mem-lock=off
  #   -smp 16,sockets=1,dies=1,cores=8,threads=2
  #   -object '{"qom-type":"iothread","id":"iothread1"}'
  #   -uuid 88b03555-6910-43bf-b176-e6c477abbecsmbios 'type=0,vendor=American Megatrends Inc.,version=F31o,date=12/03/2020' -smbios 'type=1,manufacturer=ASRock,product=B550M PG Riptide,version=x.x,serial=M80-F3003700605,uuid=88b03555-6910-43bf-b176-e6c477abbecf,family=X570 MB'
  #   -display none
  #   -chardev socket,id=charmonitor,path=/var/lib/libvirt/qemu/domain--1-gaming/monitor.sock,server=on,wait=off
  #   -mon chardev=charmonitor,id=monitor,mode=contrortc base=localtime,driftfix=slew
  #   -global kvm-pit.lost_tick_policy=delay
  #   -no-shutdown
  #   -global ICH9-LPC.disable_s3=1
  #   -global ICH9-LPC.disable_s4=1
  #   -boot strict=on
  #   -device '{"driver":"pcie-root-port","port":16,"chassis":1,"id":"pci.1","bus":"pcie.0","multifunction":true,"addr":"0x2"}'
  #   -device '{"driver":"pcie-root-port","port":17,"chassis":2,"id":"pci.2","bus":"pcie.0","addr":"0x2.0x1"}'
  #   -device '{"driver":"pcie-root-port","port":18,"chassis":3,"id":"pci.3","bus":"pcie.0","addr":"0x2.0x2"}'
  #   -device '{"driver":"pcie-root-port","port":19,"chassis":4,"id":"pci.4","bus":"pcie.0","addr":"0x2.0x3"}'
  #   -device '{"driver":"pcie-root-port","port":20,"chassis":5,"id":"pci.5","bus":"pcie.0","addr":"0x2.0x4"}'
  #   -device '{"driver":"pcie-root-port","port":21,"chassis":6,"id":"pci.6","bus":"pcie.0","addr":"0x2.0x5"}'
  #   -device '{"driver":"pcie-root-port","port":22,"chassis":7,"id":"pci.7","bus":"pcie.0","addr":"0x2.0x6"}'
  #   -device '{"driver":"pcie-root-port","port":23,"chassis":8,"id":"pci.8","bus":"pcie.0","addr":"0x2.0x7"}'
  #   -device '{"driver":"pcie-root-port","port":24,"chassis":9,"id":"pci.9","bus":"pcie.0","multifunction":true,"addr":"0x3"}'
  #   -device '{"driver":"pcie-root-port","port":25,"chassis":10,"id":"pci.10","bus":"pcie.0","addr":"0x3.0x1"}'
  #   -device '{"driver":"pcie-root-port","port":26,"chassis":11,"id":"pci.11","bus":"pcie.0","addr":"0x3.0x2"}'
  #   -device '{"driver":"pcie-root-port","port":27,"chassis":12,"id":"pci.12","bus":"pcie.0","addr":"0x3.0x3"}'
  #   -device '{"driver":"pcie-root-port","port":28,"chassis":13,"id":"pci.13","bus":"pcie.0","addr":"0x3.0x4"}'
  #   -device '{"driver":"pcie-root-port","port":29,"chassis":14,"id":"pci.14","bus":"pcie.0","addr":"0x3.0x5"}'
  #   -device '{"driver":"pcie-root-port","port":30,"chassis":15,"id":"pci.15","bus":"pcie.0","addr":"0x3.0x6"}'
  #   -device '{"driver":"pcie-pci-bridge","id":"pci.16","bus":"pci.7","addr":"0x0"}'
  #   -device '{"driver":"pcie-root-port","port":31,"chassis":17,"id":"pci.17","bus":"pcie.0","addr":"0x3.0x7"}'
  #   -device '{"driver":"qemu-xhci","p2":15,"p3":15,"id":"usb","bus":"pci.2","addr":"0x0"}'
  #   -device '{"driver":"virtio-scsi-pci","iothread":"iothread1","id":"scsi0","num_queues":8,"bus":"pci.10","addr":"0x0"}'
  #   -device '{"driver":"virtio-serial-pci","id":"virtio-serial0","bus":"pci.3","addr":"0x0"}' -blockdev '{"driver":"file","filename":"/var/lib/libvirt/images/win11.img","aio":"native","node-name":"libvirt-3-storage","cache":{"direct":true,"no-flush":false},"auto-read-only":true,"discard":"unmap"}' -blockdev '{"node-name":"libvirt-3-format","read-only":false,"discard":"unmap","cache":{"direct":true,"no-flush":false},"driver":"raw","file":"libvirt-3-storage"}'
  #    -device '{"driver":"virtio-blk-pci","num-queues":8,"bus":"pci.11","addr":"0x0","drive":"libvirt-3-format","id":"virtio-disk0","bootindex":1,"write-cache":"on"}' -blockdev '{"driver":"file","filename":"/persist/home/blusk/isos/Win11_22H2_English_x64v2.iso","node-name":"libvirt-2-storage","auto-read-only":true,"discard":"unmap"}' -blockdev '{"node-name":"libvirt-2-format","read-only":true,"driver":"raw","file":"libvirt-2-storage"}'
  #    -device '{"driver":"ide-cd","bus":"ide.0","drive":"libvirt-2-format","id":"sata0-0-0"}' -blockdev '{"driver":"file","filename":"/persist/home/blusk/isos/virtio-win-0.1.229.iso","node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"}' -blockdev '{"node-name":"libvirt-1-format","read-only":true,"driver":"raw","file":"libvirt-1-storage"}'
  #   -device '{"driver":"ide-cd","bus":"ide.1","drive":"libvirt-1-format","id":"sata0-0-1"}' -netdev '{"type":"tap","fd":"26","vhost":true,"vhostfd":"29","id":"hostnet0"}'
  #   -device '{"driver":"virtio-net-pci","netdev":"hostnet0","id":"net0","mac":"52:54:00:d4:78:5c","bus":"pci.1","addr":"0x0"}' -chardev pty,id=charserial0
  #   -device '{"driver":"isa-serial","chardev":"charserial0","id":"serial0","index":0}' -chardev null,id=chrtptpmdev emulator,id=tpm-tpm0,chardev=chrtpm
  #   -device '{"driver":"tpm-crb","tpmdev":"tpm-tpm0","id":"tpm0"}' -object '{"qom-type":"input-linux","id":"input0","evdev":"/dev/input/by-id/usb-Logitech_G502_HERO_Gaming_Mouse_157439713733-event-mouse"}' -object '{"qom-type":"input-linux","id":"input1","evdev":"/dev/input/by-id/usb-Heng_Yu_Technology_POKER_3C-event-kbd","repeat":true,"grab_all":true,"grab-toggle":"ctrl-ctrl"}'
  #   -device '{"driver":"virtio-mouse-pci","id":"input2","bus":"pci.8","addr":"0x0"}'
  #   -device '{"driver":"virtio-keyboard-pci","id":"input3","bus":"pci.9","addr":"0x0"}' -audiodev '{"id":"audio2","driver":"pa","server":"/run/user/1000/pulse/native","in":{"mixing-engine":false,"latency":20000},"out":{"mixing-engine":false,"latency":20000}}'
  #   -device '{"driver":"qxl-vga","id":"video0","max_outputs":1,"ram_size":67108864,"vram_size":67108864,"vram64_size_mb":0,"vgamem_mb":16,"bus":"pcie.0","addr":"0x1"}'
  #   -device '{"driver":"ich9-intel-hda","id":"sound0","bus":"pci.16","addr":"0x1"}'
  #   -device '{"driver":"hda-duplex","id":"sound0-codec0","bus":"sound0.0","cad":0,"audiodev":"audio2"}' -global ICH9-LPC.noreboot=ofwatchdog-action reset
  #   -device '{"driver":"vfio-pci","host":"0000:01:00.1","id":"hostdev0","bus":"pci.5","addr":"0x0"}'
  #   -device '{"driver":"vfio-pci","host":"0000:01:00.0","id":"hostdev1","bus":"pci.6","addr":"0x0","rombar":1}'
  #   -device '{"driver":"vfio-pci","host":"0000:10:00.0","id":"hostdev2","bus":"pci.4","addr":"0x0"}'
  #   -device '{"driver":"vfio-pci","host":"0000:0a:00.0","id":"hostdev3","bus":"pci.12","addr":"0x0"}'
  #   -device '{"driver":"vfio-pci","host":"0000:0b:00.0","id":"hostdev4","bus":"pci.13","addr":"0x0"}'
  #   -device '{"driver":"vfio-pci","host":"0000:0c:00.0","id":"hostdev5","bus":"pci.14","addr":"0x0"}'
  #   -device '{"driver":"vfio-pci","host":"0000:00:04.0","id":"hostdev6","bus":"pci.17","addr":"0x0"}' -fw_cfg opt/ovmf/X-PciMmio64Mb,string=65536
  #   -device '{"driver":"ivshmem-plain","id":"shmem0","memdev":"looking-glass"}' -object '{"qom-type":"memory-backend-file","id":"looking-glass","mem-path":"/dev/shm/kvmfr0","size":134217728,"share":true}'
  #   -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
  #   -msg timestamp=on
  # '';
  startVM = pkgs.writeScriptBin "startVM" ''
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-23
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-23
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-23
    virsh start $1
  '';
  stopVM = pkgs.writeScriptBin "stopVM" ''
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-31
    virsh shutdown $1
  '';
  resetUSBs = pkgs.writeScriptBin "resetusbs" ''
    # Resets all USB host controllers of the system.
    # This is useful in case one stopped working
    # due to a faulty device having been connected to it.

    base="/sys/bus/pci/drivers"
    sleep_secs="1"

    # This might find a sub-set of these:
    # * 'ohci_hcd' - USB 3.0
    # * 'ehci-pci' - USB 2.0
    # * 'xhci_hcd' - USB 3.0
    echo "Looking for USB standards ..."
    for usb_std in "$base/"?hci[-_]?c*
    do
        echo "* USB standard '$usb_std' ..."
        for dev_path in "$usb_std/"*:*
        do
            dev="$(basename "$dev_path")"
            echo "  - Resetting device '$dev' ..."
            printf '%s' "$dev" | sudo tee "$usb_std/unbind" > /dev/null
            sleep "$sleep_secs"
            printf '%s' "$dev" | sudo tee "$usb_std/bind" > /dev/null
            echo "    done."
        done
        echo "  done."
    done
    echo "done."
  '';
in {
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        # runAsRoot = false;
        # Full is needed for TPM and secure boot emulation
        ovmf.packages = [pkgs.OVMFFull.fd];
        swtpm.enable = true;
        verbatimConfig = ''
          namespaces = []
          user = "blusk"
          group = "libvirtd"
        '';
      };
    };
    vfio = {
      enable = true;
      IOMMUType = "amd";
      devices = [
        "10de:2203" # GPU
        "10de:1aef" # audio controller
        "1912:0015" # USB controller
      ];
      blacklistNvidia = true;
      ignoreMSRs = true;
      applyACSpatch = false;
      disableEFIfb = false;
    };
    kvmfr = {
      enable = true;
      devices = [
        {
          dimensions = {
            width = 3840;
            height = 2160;
          };
          permissions = {
            user = "blusk";
            group = "kvm";
            mode = "0660";
          };
        }
      ];
    };
  };

  hardware.opengl.enable = true;
  environment.systemPackages = [
    pkgs.virt-manager
    pkgs.virtiofsd
    startVM
    stopVM
    resetUSBs
  ];
  # virt-manager saves settings here
  programs.dconf.enable = true;
}
