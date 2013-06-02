#!/system/bin/sh

#
# Kernel customizations post initialization
# Created by Christopher83
#

# Backup last custom_init.log
mv /data/custom_init.log /data/custom_init.log.old

# Start logging
exec >>/data/custom_init.log
exec 2>&1

echo "*********************************************"
echo "| Kernel customizations post initialization |"
echo "*********************************************"
echo

# Print kernel version
cat /proc/version
echo

# Mount system for read and write
echo "Mount system for read and write"
mount -o rw,remount /system

#
# Fast Random Generator (frandom) support at boot
#
if [ -f "/lib/modules/frandom.ko" ]; then
	# Load frandom module if not built inside the zImage
	echo "Fast Random Generator (frandom): Loading module..."
	insmod /lib/modules/frandom.ko
fi
if [ -c "/dev/frandom" ]; then
	# Redirect random and urandom generation to frandom char device
	echo "Fast Random Generator (frandom): Initializing..."
	rm -f /dev/random
	rm -f /dev/urandom
	ln /dev/frandom /dev/random
	ln /dev/frandom /dev/urandom
	chmod 0666 /dev/random
	chmod 0666 /dev/urandom
	echo "Fast Random Generator (frandom): Ready!"
else
	echo "Fast Random Generator (frandom): Not supported!"
fi

# Mount system read-only
echo "Mount system read-only"
mount -o ro,remount /system
