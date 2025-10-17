#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

find /tmp/rpms

rpm-ostree cliwrap install-to-root /

QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(\d+\.\d+\.\d+)' | sed -E 's/kernel-//')"
INCOMING_KERNEL_VERSION="$(basename -s .rpm $(ls /tmp/rpms/kernel/kernel-[0-9]*.rpm 2>/dev/null | grep -P 'kernel-(\d+\.\d+\.\d+)' | sed -E 's/kernel-//'))"

echo "Qualified kernel: $QUALIFIED_KERNEL"
echo "Incoming kernel version: $INCOMING_KERNEL_VERSION"


if [[ "$INCOMING_KERNEL_VERSION" != "$QUALIFIED_KERNEL" ]]; then
    echo "Installing kernel rpm from kernel-cache."
    rpm-ostree override replace \
        --experimental \
        --install=zstd \
        /tmp/rpms/kernel/kernel-[0-9]*.rpm \
        /tmp/rpms/kernel/kernel-core-*.rpm \
        /tmp/rpms/kernel/kernel-modules-*.rpm \
        /tmp/rpms/kernel/kernel-tools-[0-9]*.rpm \
        /tmp/rpms/kernel/kernel-tools-libs-[0-9]*.rpm \
        /tmp/rpms/kernel/kernel-devel-*.rpm \
        /tmp/rpms/rpms/kmods/*kvmfr*.rpm \
        /tmp/rpms/rpms/kmods/*xone*.rpm \
        /tmp/rpms/rpms/kmods/*openrazer*.rpm \
        /tmp/rpms/rpms/kmods/*v4l2loopback*.rpm \
        /tmp/rpms/rpms/kmods/*wl*.rpm \
        /tmp/rpms/rpms/kmods/*framework-laptop*.rpm \
        /tmp/rpms/rpms-extra/kmods/*nct6687*.rpm \
        /tmp/rpms/rpms-extra/kmods/*gcadapter_oc*.rpm \
        /tmp/rpms/rpms-extra/kmods/*zenergy*.rpm \
        /tmp/rpms/rpms-extra/kmods/*vhba*.rpm \
        /tmp/rpms/rpms-extra/kmods/*gpd-fan*.rpm \
        /tmp/rpms/rpms-extra/kmods/*ayaneo-platform*.rpm \
        /tmp/rpms/rpms-extra/kmods/*ayn-platform*.rpm \
        /tmp/rpms/rpms-extra/kmods/*bmi260*.rpm \
        /tmp/rpms/rpms-extra/kmods/*ryzen-smu*.rpm
else
    echo "Installing kernel files from kernel-cache."
    cd /tmp
    rpm2cpio /tmp/rpms/kernel/kernel-core-*.rpm | cpio -idmv
    cp ./lib/modules/*/vmlinuz /usr/lib/modules/*/vmlinuz
    cd /
fi
