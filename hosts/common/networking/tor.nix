{pkgs, ...}: let
  subnet = "10.200.1";
  transPort = 9041;
  dnsPort = 9054;
  nsName = "torjail";
  inIf = "in-${nsName}";
  outIf = "out-${nsName}";
in {
  boot.kernelModules = ["veth" "ipt_tcp"];

  services.tor = {
    enable = true;
    settings = {
      TransPort = [
        {
          addr = "${subnet}.1";
          port = transPort;
        }
      ];
      DNSPort = [
        {
          addr = "${subnet}.1";
          port = dnsPort;
        }
      ];
    };
  };

  systemd.services = {
    torjail-ns = with pkgs; {
      script = ''
        # Create a new network namespace named torjail
        ${iproute2}/bin/ip netns add torjail

        # Create two virtual ethernet interfaces
        ${iproute2}/bin/ip link add ${outIf} type veth peer name ${inIf}

        # Bind one interface to torjail network namespace
        ${iproute2}/bin/ip link set ${inIf} netns torjail

        # Set interfaces ip and default routing
        ${iproute2}/bin/ip addr add ${subnet}.1/24 dev ${outIf}
        ${iproute2}/bin/ip link set ${outIf} up
        ${iproute2}/bin/ip netns exec torjail ${iproute2}/bin/ip addr add ${subnet}.2/24 dev ${inIf}
        ${iproute2}/bin/ip netns exec torjail ${iproute2}/bin/ip link set ${inIf} up
        ${iproute2}/bin/ip netns exec torjail ${iproute2}/bin/ip route add default via ${subnet}.1

        # Forward all dns traffic to tor DNSPort
        ${iptables}/bin/iptables -t nat -A PREROUTING -i ${outIf} -p udp -d ${subnet}.1 --dport 53 -j DNAT --to-destination ${subnet}.1:${
          toString dnsPort
        }

        # Forward all traffic to tor TransPort
        ${iptables}/bin/iptables -t nat -A PREROUTING -i ${outIf} -p tcp --syn -j DNAT --to-destination ${subnet}.1:${
          toString transPort
        }

        # Accept established connection
        ${iptables}/bin/iptables -A OUTPUT -m state -o ${outIf} --state ESTABLISHED,RELATED -j ACCEPT

        # Accept only forwarded traffic
        ${iptables}/bin/iptables -A INPUT -i ${outIf} -p udp --destination ${subnet}.1 --dport ${
          toString dnsPort
        } -j ACCEPT
        ${iptables}/bin/iptables -A INPUT -i ${outIf} -p tcp --destination ${subnet}.1 --dport ${
          toString transPort
        } -j ACCEPT
        ${iptables}/bin/iptables -A INPUT -i ${outIf} -p udp --destination ${subnet}.1 --dport ${
          toString transPort
        } -j ACCEPT
        ${iptables}/bin/iptables -A INPUT -i ${outIf} -j DROP
      '';
      serviceConfig = {Type = "oneshot";};
      restartIfChanged = false;
      stopIfChanged = false;
    };
    tor.requires = ["torjail-ns.service"];
  };

  networking.firewall = {
    allowedTCPPorts = [transPort];
    allowedUDPPorts = [dnsPort];
  };

  environment.etc."resolv-torjail.conf".text = "nameserver ${subnet}.1";
}
