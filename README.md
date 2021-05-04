# Arduino-Makefile-Project
This is a simple makefile setup for Arduino development.

# Prequisities:
- Have the Arduino software installed on your device.
- Have the `make` build system installed on your device.
- Have knowledge and skills on:
  - Using and creating Makefiles.
  - Using the command line/terminal.
  - Programming in C/C++.
- Have an Arduino Board (OPTIONAL).
- Have `rm` and `mv` commands available on your system. (OPTIONAL).
# Getting Started:
1. At the start of the Makefile, change the `ARDUINO_DIR` value to the topmost directory of the Arduino installation.
2. Change the value of `MAIN_SKETCH` to be the name of your sketch. 
3. Change the `COM` port number in the `upload` target to the port in which the Arduino is connected to your device.
4. If the `rm` and `mv` commands are not available on your system, make sure to replace all occurences of `rm` with the command that deletes files and `mv` with the command that moves files.
5. Use one of the 4 basic `make` depending on the need:

- `make`: creates certain directories, compiles the core library, compiles your code, and cleans some stuff up (not to be confused with `make clean`).
- `make upload`: uploads the compiled sketch to your Arduino board (which is located at COM3 if the default settings are preserved).
- `make clean`: removes the generated files by `make` except for the core library and the directories created by it (not to be confused with `make full_clean`).
- `make full_clean`: removes generated files by `make`, including the core library and the directories created by it as well (not to be confused with `make clean`).

# TODO:
- Implement support for the other Arduino libraries.
- Implement support for other Arduino variants.
- Clean up the code and improve it in some places.
