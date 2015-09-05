
# Put your stlink folder here so make burn will work.
STLINK=/opt/STM/stlink

STM_COMMON = $(WORKSPACE)/stm32/STM32F4-Discovery_FW_V1.1.0

# Sources
SRCS = main.c stm32f4xx_it.c stm32f4_discovery.c 

# USB
SRCS += usb_bsp.c usb_dcd_int.c usbd_hid_core.c usbd_usr.c
SRCS += usb_core.c usbd_core.c usbd_ioreq.c
SRCS += usb_dcd.c usbd_desc.c usbd_req.c


# Library code
SRCS += system_stm32f4xx.c misc.c	stm32f4xx_exti.c  stm32f4xx_gpio.c  stm32f4xx_rcc.c  stm32f4xx_syscfg.c  stm32f4xx_tim.c


# add startup file to build
SRCS += cmsis_boot/startup/startup_stm32f4xx.c


# Project name
PROJ_NAME=stm32f4_usb_bdir
OUTPATH=build

###################################################

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
SIZE=arm-none-eabi-size


# Choose debug or release...
CFLAGS = -g -O2           # Normal
#CFLAGS = -ggdb -O0       # RSW - for GDB debugging, disable optimizer

CFLAGS += -Wall -Tstm32_flash.ld
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -mlittle-endian -mthumb -mthumb-interwork -nostartfiles -mcpu=cortex-m4
CFLAGS += -msoft-float

###################################################

vpath %.c \
cmsis_boot \
cmsis_lib/source \
usb_hid_lib/src



# Includes
CFLAGS += -I.
CFLAGS += -Icmsis
CFLAGS += -Icmsis_boot
CFLAGS += -Icmsis_lib/include
CFLAGS += -Iusb_hid_lib/inc

#use OTG mode
#CFLAGS += -DUSE_DEVICE_MODE
OBJS = $(SRCS:.c=.o)

###################################################

.PHONY: lib proj dir_tree

all:  dir_tree proj

dir_tree:
	mkdir -p $(OUTPATH)

proj: $(OUTPATH)/$(PROJ_NAME).elf
	$(SIZE) $(OUTPATH)/$(PROJ_NAME).elf

$(OUTPATH)/$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@ $(LIBPATHS) $(LIBS)
	$(OBJCOPY) -O ihex $(OUTPATH)/$(PROJ_NAME).elf $(OUTPATH)/$(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(OUTPATH)/$(PROJ_NAME).elf $(OUTPATH)/$(PROJ_NAME).bin

clean:
	find . -name \*.o -type f -delete
	find . -name \*.lst -type f -delete
	rm -f $(OUTPATH)/$(PROJ_NAME).elf
	rm -f $(OUTPATH)/$(PROJ_NAME).hex
	rm -f $(OUTPATH)/$(PROJ_NAME).bin

# Flash the STM32F4
burn: proj
	$(STLINK)/st-flash write $(OUTPATH)/$(PROJ_NAME).bin 0x8000000
