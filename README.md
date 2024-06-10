tiny-floppy-bootloader
=====================

A fork of [tiny-linux-bootloader](https://github.com/owenson/tiny-linux-bootloader) that is floppy-bootable and still fits in the first sector. This bootloader expects to find the kernel immediately after it at sector 1.  

For a more generally compatible fork of the original project, please see [w98qi-tiny-floppy-bootloader ](https://github.com/oerg866/w98qi-tiny-floppy-bootloader)

## Differences and tips
* The boot sector is designed to fit within the first sector of a floppy disk. If you're booting from a floppy, it's assumed that the kernel is located directly after the bootloader in subsequent sectors.
* Separate initrd support has been commented out (you could add it back in) -- to get around this, compile your kernel with the initrd embedded using `CONFIG_INITRAMFS_SOURCE`
* By default `build.sh` and `config.inc` makes 1.44mb floppy images -- if you want to use 1.722mb or other sizes, you will have to edit `config.inc` and `build.sh` to accomodate


## Features/Purpose

* No partition table needed 
* Easy to convert to an obfuscated loader (think anti-forensics for crypted disks)
* Easy to modify for a custom experience
* Useful in embedded devices

## Building

To build, you need to:

1. Edit `build.sh` and set paths to your kernel
2. Edit `config.inc` to set your kernel cmd line (keep it <15chars for the moment, disabling debug makes more room)
3. Run `build.sh`
    - Use `build.sh --objdump` to generate an objdump of `bootloader.bin`
4. Now you can dd this onto your disk, if you have a partition table already, then do not overwrite bytes 446-510 on the first sector (so use dd twice).

Your system should now boot with the new kernel.

# Troubleshooting

You can use qemu to boot the image by running:

    qemu-system-i386 -fda disk.img

and you can also connect the VM to gdb for actual debugging.  There's an included gdb script to get you started.
