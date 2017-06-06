ALL = src src/EFI

all:
	for dir in $(ALL); do \
	  $(MAKE) -C $$dir; \
	done

clean:
	for dir in $(ALL); do \
	  $(MAKE) clean -C $$dir; \
	done
	rm fat.img
fat:
	dd if=/dev/zero of=fat.img bs=1k count=1440
	mformat -i fat.img -f 1440 ::
	mmd -i fat.img ::/EFI
	mmd -i fat.img ::/EFI/BOOT
	mcopy -i fat.img src/EFI/BOOTX64.EFI ::/EFI/BOOT

run:
	qemu-system-x86_64 -L 3rdParty/OVMF/ -bios OVMF.fd -usb -usbdevice disk::fat.img
