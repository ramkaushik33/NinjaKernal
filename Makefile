# Makefile

# Use cross-compiler (replace this with your own GCC cross-compiler if necessary)
CXX := i686-elf-g++
AS := nasm

# Build flags
CXXFLAGS := -ffreestanding -O2 -nostdlib -fno-exceptions -fno-rtti

# Kernel and bootloader sources
KERNEL_SRC := kernel/kernel.cpp
BOOT_SRC := boot/boot.asm

# Output binaries
KERNEL_BIN := kernel.bin
ISO := myos.iso

# Build kernel object file
kernel.o: $(KERNEL_SRC)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Assemble bootloader
boot.o: $(BOOT_SRC)
	$(AS) -f elf $< -o $@

# Link kernel and bootloader
$(KERNEL_BIN): boot.o kernel.o
	i686-elf-ld -o $(KERNEL_BIN) -Ttext 0x1000 $^ --oformat binary

# Create ISO file with GRUB bootloader
$(ISO): $(KERNEL_BIN)
	mkdir -p iso/boot/grub
	cp $(KERNEL_BIN) iso/boot/
	cp grub/grub.cfg iso/boot/grub/
	grub-mkrescue -o $(ISO) iso

# Clean up generated files
clean:
	rm -rf *.o iso *.iso $(KERNEL_BIN)

# Run in QEMU
run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)
