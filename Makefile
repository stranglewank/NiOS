ALL = src src/EFI

all:
	for dir in $(ALL); do \
	  $(MAKE) -C $$dir; \
	done

clean:
	for dir in $(ALL); do \
	  $(MAKE) clean -C $$dir; \
	done
	@rm -f fat.img hdd.img cd.iso
	@rm -rf iso/
fat:
	dd if=/dev/zero of=fat.img bs=1k count=1440
	mformat -i fat.img -f 1440 ::
	mmd -i fat.img ::/EFI
	mmd -i fat.img ::/EFI/BOOT
	mcopy -i fat.img src/EFI/BOOTX64.EFI ::/EFI/BOOT

hdd:
	mkgpt -o hdd.img --image-size 4096 --part fat.img --type system

iso:
	mkdir iso
	cp fat.img iso
	xorriso -as mkisofs -R -f -e fat.img -no-emul-boot -o cd.iso iso

runusb:
	qemu-system-x86_64 -L 3rdParty/OVMF/ -bios OVMF.fd -usb -usbdevice disk::fat.img

runhdd:
	qemu-system-x86_64 -L 3rdParty/OVMF/ -bios OVMF.fd -hda hdd.img

runiso:
	qemu-system-x86_64 -L 3rdParty/OVMF/ -bios OVMF.fd -cdrom cd.iso
