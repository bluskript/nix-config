#!/bin/sh
(
    echo "<!-- File auto-generated by $0 -->"
    virsh -c qemu:///system dumpxml win11
) > win11.xml
