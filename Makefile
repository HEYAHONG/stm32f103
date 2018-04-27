ifndef CROSS_PREFIXE
CROSS_PREFIX =arm-none-eabi-
endif


ifndef PROJECT
PROJECT=usart
endif

CC=$(CROSS_PREFIX)gcc
LD=$(CROSS_PREFIX)ld
AR=$(CROSS_PREFIX)ar
OBJCOPY =  $(CORSS_PREFIX)objcopy
SIZE=$(CROSS_PREFIX)size


CFLAGS=  -nostdlib  -mcpu=cortex-m3 -mthumb -ffunction-sections -fdata-sections
LDFLAGS=   -EL -e Reset_Handler -T stm32_rom.ld 
OBJCOPYFLAGS=  -I elf32-little  -O binary 

#use std_periph_driver
CFLAGS+= -I./STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/STM32F10x_StdPeriph_Driver/inc -DUSE_STDPERIPH_DRIVER -DSTM32F10X_HD 
CFLAGS+= -I./STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/CoreSupport
CFLAGS+= -I./STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x
CFLAGS+= -I./

SRC=$(wildcard *.s) $(wildcard *.c) $(wildcard ./STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/STM32F10x_StdPeriph_Driver/src/*.c) $(wildcard ././STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/CoreSupport/*.c) 

OBJ1_SRC=$(patsubst %.c,%.o,$(SRC))
OBJ_SRC=$(patsubst %.s,%.o,$(OBJ1_SRC))
LDOBJ_SRC=$(addprefix ./objs/,$(OBJ_SRC))


all: $(PROJECT).bin


$(PROJECT).axf:$(OBJ_SRC)
	$(LD) $(LDFLAGS)  $(LDOBJ_SRC) -o $@
	$(SIZE) $@

%.bin:%.axf
	$(OBJCOPY) $(OBJCOPYFLAGS) $^ $@

%.o:%.c
	$(CC) $(CFLAGS) -c  $^ -o ./objs/$@
%.o:%.s
	$(CC) $(CFLAGS) -c  $^ -o ./objs/$@
clean:
	-rm -rf $(LDOBJ_SRC)
	-rm -rf $(PROJECT).axf $(PROJECT).bin
burn:$(PROJECT).bin
	sudo stm32flash -w $(PROJECT).bin /dev/ttyUSB0
