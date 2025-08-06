# Assembly-OS-breaker
all will do is make an os and say hello world
for x86
## How to run
```bash
nasm -f bin boot.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin
cat boot.bin kernel.bin > os.img
qemu-system-i386 -drive format=raw,file=os.img
```
