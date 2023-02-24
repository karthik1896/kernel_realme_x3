#!/bin/bash

DEFCONFIG="x3_defconfig"

make -j"$(nproc --all)" O=out ARCH=arm64 SUBARCH=arm64 "$DEFCONFIG"
cp -af out/.config arch/arm64/configs/"$DEFCONFIG"
echo -e "\nSuccessfully regenerated defconfig at $DEFCONFIG"
