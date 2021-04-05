# toolchain
CC = sdcc
OBJCOPY = objcopy
PACK_HEX = packihx
WCHISP = ch552isptool

# Adjust the XRAM location and size to leave space for the USB DMA buffers
XRAM_SIZE = 0x00C0
XRAM_LOC = 0x0140

C_FILES = \
	main.c \
	include/debug.c

PSX_C_FILE = fourplay.c
SNES_C_FILE = fournsnes.c

ifndef FREQ_SYS
FREQ_SYS = 6000000
endif

CFLAGS = -V -mmcs51 --model-small \
	--xram-size $(XRAM_SIZE) --xram-loc $(XRAM_LOC) \
	--code-size 0x2800 \
	-I./include -DFREQ_SYS=$(FREQ_SYS) \
	$(EXTRA_FLAGS)

LFLAGS = $(CFLAGS)

RELS := $(C_FILES:.c=.rel)
PSX_RELS := $(PSX_C_FILE:.c=.rel)
SNES_RELS := $(SNES_C_FILE:.c=.rel)

print-%  : ; @echo $* = $($*)

%.rel : %.c
	$(CC) -c $(CFLAGS) $<

# Note: SDCC will dump all of the temporary files into this one, so strip the paths from RELS
# For now, get around this by stripping the paths off of the RELS list.

2snes:
	$(eval TARGET = 2nes2snes)
	$(eval EXTRA_FLAGS = -DCONTROLLER_TYPE_SNES -DNUM_GAMEPADS=2)
	$(eval EXTRA_RELS = $(SNES_RELS))
	$(CC) -c $(CFLAGS) fournsnes.c

4snes:
	$(eval TARGET = 4nes4snes)
	$(eval EXTRA_FLAGS = -DCONTROLLER_TYPE_SNES)
	$(eval EXTRA_RELS = $(SNES_RELS))
	$(CC) -c $(CFLAGS) fournsnes.c

4play:
	$(eval TARGET = 4play)
	$(eval EXTRA_FLAGS = -DCONTROLLER_TYPE_PSX)
	$(eval EXTRA_RELS = $(PSX_RELS))
	$(CC) -c $(CFLAGS) fourplay.c

ihx: $(RELS)
	$(CC) $(notdir $(RELS)) $(notdir $(EXTRA_RELS)) $(LFLAGS) -o $(TARGET).ihx

hex: ihx
	$(PACK_HEX) $(TARGET).ihx > $(TARGET).hex

bin: ihx
	$(OBJCOPY) -I ihex -O binary $(TARGET).ihx $(TARGET).bin

flash: $(TARGET).bin pre-flash
	$(WCHISP) $(TARGET).bin

build4play: 4play bin clean2

build2snes: 2snes bin clean2

build4snes: 4snes bin clean2

.DEFAULT_GOAL := all
all: build2snes

clean2:
	rm -f \
	*.asm \
	*.lst \
	*.rst \
	*.sym \
	*.rel \
	*.lk \
	*.map \
	*.mem \
	*.hex

clean: clean2
	rm -f \
	*.bin \
	*.ihx