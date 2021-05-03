# Root directory of the Arduino installation. Make sure to change this.
ARDUINO_DIR = C:/Arduino/

# various programs
CC = "$(ARDUINO_DIR)hardware/tools/avr/bin/avr-gcc"
CPP = "$(ARDUINO_DIR)hardware/tools/avr/bin/avr-g++"
AR = "$(ARDUINO_DIR)hardware/tools/avr/bin/avr-ar"
OBJ_COPY = "$(ARDUINO_DIR)hardware/tools/avr/bin/avr-objcopy"
OBJS = ./obj/
BIN = ./bin/
OBJ_DIR = obj
BIN_DIR = bin
LIB = lib

# change as needed
MAIN_SKETCH = sketch.cpp

# compile flags for g++ and gcc

# may need to change these
F_CPU = 16000000
MCU = atmega328p

# compile flags
GENERAL_FLAGS = -c -g -Os -Wall -ffunction-sections -fdata-sections -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -MMD -DUSB_VID=null -DUSB_PID=null -DARDUINO=106
CPP_FLAGS = $(GENERAL_FLAGS) -fno-exceptions
CC_FLAGS  = $(GENERAL_FLAGS)
HID_DIR = $(ARDUINO_DIR)/hardware/arduino/avr/libraries/HID/src/

# location of include files
INCLUDE_FILES = "-I$(ARDUINO_DIR)hardware/arduino/avr/cores/arduino" "-I$(ARDUINO_DIR)hardware/arduino/avr/variants/standard"

# library sources
LIBRARY_DIR = "$(ARDUINO_DIR)hardware/arduino/avr/cores/arduino/"

all: $(OBJS) $(BIN) $(LIB) $(LIB)/core.a build

$(OBJS):
	mkdir $(OBJ_DIR)
$(BIN):
	mkdir $(BIN_DIR)
$(LIB):
	mkdir lib

# Core library.
$(LIB)/core.a: $(LIB) $(OBJS)
	$(CC) $(CC_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)hooks.c -o hooks.c.o
	$(CC) $(CC_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)WInterrupts.c -o WInterrupts.c.o
	$(CC) $(CC_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)wiring.c -o wiring.c.o
	$(CC) $(CC_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)wiring_analog.c -o wiring_analog.c.o
	$(CC) $(CC_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)wiring_digital.c -o wiring_digital.c.o
	$(CC) $(CC_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)wiring_pulse.c -o wiring_pulse.c.o
	$(CC) $(CC_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)wiring_shift.c -o wiring_shift.c.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)CDC.cpp -o CDC.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)HardwareSerial.cpp -o HardwareSerial.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(HID_DIR)HID.cpp -o HID.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)IPAddress.cpp -o IPAddress.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)main.cpp -o main.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)new.cpp -o new.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)Print.cpp -o Print.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)Stream.cpp -o Stream.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)Tone.cpp -o Tone.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)USBCore.cpp -o USBCore.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)WMath.cpp -o WMath.cpp.o
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(LIBRARY_DIR)WString.cpp -o WString.cpp.o
# Move the object files into the obj directory and delete the .d files.
	mv *.o $(OBJ_DIR)
	rm *.d

	$(AR) rcs core.a $(OBJS)WInterrupts.c.o
	$(AR) rcs core.a $(OBJS)wiring.c.o
	$(AR) rcs core.a $(OBJS)wiring_analog.c.o
	$(AR) rcs core.a $(OBJS)wiring_digital.c.o
	$(AR) rcs core.a $(OBJS)wiring_pulse.c.o
	$(AR) rcs core.a $(OBJS)wiring_shift.c.o
	$(AR) rcs core.a $(OBJS)CDC.cpp.o
	$(AR) rcs core.a $(OBJS)HardwareSerial.cpp.o
	$(AR) rcs core.a $(OBJS)HID.cpp.o
	$(AR) rcs core.a $(OBJS)IPAddress.cpp.o
	$(AR) rcs core.a $(OBJS)main.cpp.o
	$(AR) rcs core.a $(OBJS)new.cpp.o
	$(AR) rcs core.a $(OBJS)Print.cpp.o
	$(AR) rcs core.a $(OBJS)Stream.cpp.o
	$(AR) rcs core.a $(OBJS)Tone.cpp.o
	$(AR) rcs core.a $(OBJS)USBCore.cpp.o
	$(AR) rcs core.a $(OBJS)WMath.cpp.o
	$(AR) rcs core.a $(OBJS)WString.cpp.o
	$(AR) rcs core.a $(OBJS)hooks.c.o
	mv core.a $(LIB)

build:
	$(CPP) $(CPP_FLAGS) $(INCLUDE_FILES) $(MAIN_SKETCH) -o $(MAIN_SKETCH).o
	mv *.o obj/
	rm *.d
	$(CC) -Os -Wl,--gc-sections -mmcu=$(MCU) -o $(MAIN_SKETCH).elf $(OBJS)$(MAIN_SKETCH).o $(LIB)/core.a -lm
	$(OBJ_COPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $(MAIN_SKETCH).elf $(MAIN_SKETCH).eep
	$(OBJ_COPY) -O ihex -R .eeprom $(MAIN_SKETCH).elf $(MAIN_SKETCH).hex
	mv $(MAIN_SKETCH).elf $(BIN)
	mv $(MAIN_SKETCH).hex $(BIN)

upload:
	avrdude -C"$(ARDUINO_DIR)hardware\tools\avr\etc\avrdude.conf" -F -V -c arduino -p ATMEGA328P -PCOM3 -b 115200 -U flash:w:$(BIN)sketch.cpp.hex
clean: eep_clean obj_clean bin_clean

eep_clean:
	-rm *.eep

obj_clean:
	-rm $(OBJS)*.o

bin_clean: $(BIN)*.*
	-rm $(BIN)*.*

full_clean: clean bin_dir_clean obj_dir_clean lib_clean


bin_dir_clean:
	-rmdir $(BIN_DIR)

obj_dir_clean:
	-rmdir $(OBJ_DIR)

lib_clean:
	-rm $(LIB)/*.a
	-rmdir $(LIB)
