%define cmdLineDef "auto"

; these set the number of cylinders and sectors assumed for the drive
; these settings are correct for your typical 1.44mb floppy
; but if you are using 1.722mb you should use 82 cylinders / 21 sectors
; for more info see https://en.wikipedia.org/wiki/List_of_floppy_disk_formats
; although they call cylinders "tracks"
%define nCylindersPerHeadDef 80 
%define nSectorsPerTrackDef 18 

; qemu emulates a 2.88mb floppy drive by default -- if you get "read err", try this:
; (i haven't figured out how to get it to use 1.44mb
;%define nSectorsPerTrackDef 36

;initRdSizeDef - defined in build script automatically

