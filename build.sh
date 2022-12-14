#!/bin/bash

#set -e

K=/home/karthik/ok
rm -rf out
rm -rf Zeus*.zip
rm -rf transfer
export ARCH=arm64
export SUBARCH=arm64
mkdir -p out
make x3_defconfig O=out
echo Building
make -j$(nproc --all) O=out LLVM=1\

		ARCH=arm64 \
		AS="$K/clang/bin/llvm-as" \
		CC="$K/clang/bin/clang" \
		LD="$K/clang/bin/ld.lld" \
		AR="$K/clang/bin/llvm-ar" \
		NM="$K/clang/bin/llvm-nm" \
		STRIP="$K/clang/bin/llvm-strip" \
		OBJCOPY="$K/clang/bin/llvm-objcopy" \
		OBJDUMP="$K/clang/bin/llvm-objdump" \
		CLANG_TRIPLE=aarch64-linux-gnu- \
		CROSS_COMPILE="$K/clang/bin/clang" \
                CROSS_COMPILE_COMPAT="$K/clang/bin/clang" \
                CROSS_COMPILE_ARM32="$K/clang/bin/clang"


kernel="$K/kernel_x3/out/arch/arm64/boot/Image.gz"
dtb="$K/kernel_x3/out/arch/arm64/boot/dts/qcom/sm8150-v2.dtb"
dtbo="$K/kernel_x3/out/arch/arm64/boot/dtbo.img"

AK3_DIR="$K/AnyKernel3"
ZIPNAME="Zeus-X3-$(date '+%Y%m%d-%H%M').zip"

if [ -f "$kernel" ] && [ -f "$dtb" ] && [ -f "$dtbo" ]; then
	echo -e "\nKernel compiled succesfully! Zipping up...\n"
	if [ -d "$AK3_DIR" ]; then
		cp -r $AK3_DIR AnyKernel3
	cp $kernel $dtbo AnyKernel3
	cp $dtb AnyKernel3/dtb
	rm -rf out/arch/arm64/boot
	cd AnyKernel3
	git checkout x3 &> /dev/null
	zip -r9 "../$ZIPNAME" * -x .git README.md *placeholder
	cd ..
	rm -rf AnyKernel3
	echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
	echo "Zip: $ZIPNAME"
		curl -sL https://git.io/file-transfer | sh
                ./transfer wet Zeus*.zip
			echo
fi
fi
