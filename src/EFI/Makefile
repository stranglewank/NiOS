CC=x86_64-w64-mingw32-gcc
GNUEFI=../../3rdParty/gnu-efi-3.0.5
CFLAGS=-ffreestanding -I$(GNUEFI)/inc -I$(GNUEFI)/inc/x86_64 -I$(GNUEFI)/inc/protocol
LDFLAGS=-nostdlib -Wl,-dll -shared -Wl,--subsystem,10 -e efi_main
LIBS=-lgcc

BOOTX64: efiboot.o data.o
	$(CC) $(LDFLAGS) -o BOOTX64.EFI efiboot.o data.o $(LIBS)

efiboot.o: efiboot.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

data.o: data.c
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm data.o efiboot.o BOOTX64.EFI
