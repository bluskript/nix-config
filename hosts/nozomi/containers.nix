{ ... }: {
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp1s0";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };

}
