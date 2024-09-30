# Makefile for assembling and linking an assembly project

# Define the assembler and linker
AS = nasm
LD = ld

# Define the source and target files
SRC_DIR = src
BUILD_DIR = src
BIN_DIR = bin

SRC = $(SRC_DIR)/asm_xor.asm
OBJ = $(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.o, $(SRC))
BIN = $(BIN_DIR)/asm_xor
DEBUG = gdb

# Define the assembler and linker flags
ASFLAGS = -f elf64
LDFLAGS =

# Default target to build the program
all: $(BIN)

# Rule to assemble the source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	$(AS) $(ASFLAGS) -o $@ $<

# Rule to link the object files
$(BIN): $(OBJ)
	mkdir -p $(BIN_DIR)
	$(LD) $(LDFLAGS) -o $@ $^

# Clean up the build artifacts
clean:
	rm -f $(BUILD_DIR)/*.o $(BIN_DIR)/$(notdir $(BIN))

# Run the program with gdb if errors occur
debug: $(BIN)
	$(DEBUG) ./$(BIN)

# Target to automatically run debug if errors occur
run:
	./$(BIN) || $(MAKE) debug

.PHONY: all clean debug run
