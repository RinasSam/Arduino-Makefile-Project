# Arduino-Makefile-Project
This is a simple makefile setup for Arduino development.

# Getting Started:
1- At the start of the Makefile, change the `ARDUINO_DIR` value to the topmost directory of the Arduino installation.

2- Change the value of `MAIN_SKETCH` to be the name of your sketch. 

3- Change the `COM` port number in the `upload` target to the port in which the Arduino is connected to your device.

There are 4 basic make commands that can be used:

- `make`: creates certain directories, compiles the core library, compiles your code, and cleans some stuff up (not to be confused with `make clean`).
- `make upload`: uploads the compiled sketch to your Arduino board (which is located at COM3 if the default settings are preserved).
- `make clean`: removes the generated files by `make` except for the core library (and the directories created by it).
- `make full_clean`: removes generated files by `make`, including the core library and the directories created by it as well.

# TODO:
- Implement support for the other Arduino libraries.
- Implement support for other Arduino variants.
- Clean up the code and improve it in some places.
