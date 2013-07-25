rm bootstrap.bin 2> /dev/null

TARGET=/Users/bloggins/bin/ndk/toolchains/arm-linux-androideabi-4.7/prebuilt/darwin-x86_64/bin/arm-linux-androideabi
$TARGET-as -march=armv7-a startup.s -o startup.o
$TARGET-as -march=armv7-a bootstrap.s -o bootstrap.o
$TARGET-ld -T bootstrap.ld startup.o bootstrap.o -o bootstrap.elf
$TARGET-objcopy -O binary bootstrap.elf bootstrap.bin

rm bootstrap.elf
rm startup.o
rm bootstrap.o

qemu-system-arm -machine versatilepb -nographic -kernel bootstrap.bin
