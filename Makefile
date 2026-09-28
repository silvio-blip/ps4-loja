TARGET = MinhaLojaPS4
TITLE_ID = LOJA00001
APP_TITLE = Loja Privada Silvanio
APP_VERSION = 01.00
OO_PS4_TOOLCHAIN ?= /opt/pacbrew/ps4
CC := clang++
CFLAGS := -target x86_64-pc-freebsd12-elf -fPIC -funwind-tables -I$(OO_PS4_TOOLCHAIN)/include -I$(OO_PS4_TOOLCHAIN)/include/SDL2 -I$(OO_PS4_TOOLCHAIN)/include/c++/v1
LDFLAGS := -m elf_x86_64_fbsd -pie --script $(OO_PS4_TOOLCHAIN)/link.x -L$(OO_PS4_TOOLCHAIN)/lib
LIBS := -lSceVideoOut -lScePad -lSceAudioOut -lSceSysmodule -lSceNet -lSceNetCtl -lSceHttp -lSceSsl -lcurl -lSDL2 -lc -lkernel -lc++
SRCS := src/main.cpp
OBJS := src/main.o
all: $(TARGET).pkg
$(TARGET).elf: $(OBJS)
	ld.lld $(LDFLAGS) -o $@ $^ $(LIBS)
%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@
$(TARGET).pkg: $(TARGET).elf
	$(OO_PS4_TOOLCHAIN)/bin/create-fself $(TARGET).elf eboot.bin
	$(OO_PS4_TOOLCHAIN)/bin/create-pkg -title_id $(TITLE_ID) -title "$(APP_TITLE)" -version $(APP_VERSION) -app_type 1 -passcode 00000000000000000000000000000000 -elf eboot.bin -out $@
clean:
	rm -f $(OBJS) $(TARGET).elf eboot.bin $(TARGET).pkg
