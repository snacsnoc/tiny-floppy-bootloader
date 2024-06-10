#!/bin/bash -e
# Tiny Linux Bootloader
# (c) 2014- Dr Gareth Owen (www.ghowen.me). All rights reserved.

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

INPUT="bflop.asm"
OUTPUT="disk.img"
KERN="./bzImage"
#RD="./big.init"
CROSS_COMPILE=${CROSS_COMPILE:-""}
GENERATE_OBJDUMP=false

# Parse Arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --objdump) GENERATE_OBJDUMP=true ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Determine stat command based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    STAT_COMMAND="stat -f%z"
else
    STAT_COMMAND="stat -c%s"
fi

#size of kern + ramdisk
K_SZ=$($STAT_COMMAND $KERN)

#R_SZ=`stat -c %s $RD`

#padding to make it up to a sector
K_PAD=$((512 - $K_SZ % 512))
#R_PAD=$((512 - $R_SZ % 512))

nasm -o $OUTPUT -D initRdSizeDef=$R_SZ $INPUT
cp $OUTPUT bootloader.bin

cat $KERN >> $OUTPUT
if [[ $K_PAD -lt 512 ]]; then
    dd if=/dev/zero bs=1 count=$K_PAD >> $OUTPUT
fi

#cat $RD >> $OUTPUT
#if [[ $R_PAD -lt 512 ]]; then
#    dd if=/dev/zero bs=1 count=$R_PAD >> $OUTPUT
#fi

# make an objdump of the bootloader for debugging purposes
if [ "$GENERATE_OBJDUMP" = true ]; then
    ${CROSS_COMPILE}objdump -b binary --adjust-vma=0x7c00 -D bootloader.bin -m i386 -M intel > objdump_out.objdump
fi

TOTAL=$($STAT_COMMAND $OUTPUT)
if [[ $TOTAL -gt 1474560 ]]; then
    echo "Warning: Floppy image exceeds 1.44mb!!!"
else
    dd if=/dev/zero bs=1 count=$((1474560 - $TOTAL)) >> $OUTPUT
fi
echo "concatenated bootloader, kernel and initrd into ::> $OUTPUT"
#echo "Note, your first partition must start after sector $(($TOTAL / 512))"

