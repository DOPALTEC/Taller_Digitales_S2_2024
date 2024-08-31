
BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

# The path to the source files
SRC_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_III/src/MUX_4_1.v
BUILD_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_III/src/build
CST_FILE = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_III/cst/MUX_4_1.cst

all: $(BUILD_DIR)/TOP_Leds.fs

# Synthesis
synth: $(SRC_DIR)
	@mkdir -p $(BUILD_DIR)
	yosys -p "read_verilog $(SRC_DIR) ; synth_gowin -top top -json $(BUILD_DIR)/MUX_4_1.json"

# Place and Route
pnr: $(BUILD_DIR)/MUX_4_1.json
	nextpnr-gowin --json $(BUILD_DIR)/MUX_4_1.json --freq 27 --write $(BUILD_DIR)/TOP_Leds_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${CST_FILE}

# Generate Bitstream
fs: $(BUILD_DIR)/MUX_4_1_pnr.json
	gowin_pack -d ${FAMILY} -o $(BUILD_DIR)/MUX_4_1.fs $(BUILD_DIR)/MUX_4_1_pnr.json

# Program Board
load: $(BUILD_DIR)/MUX_4_1.fs
	openFPGALoader -b ${BOARD} $(BUILD_DIR)/MUX_4_1.fs -f

.PHONY: load
.INTERMEDIATE: $(BUILD_DIR)/MUX_4_1_pnr.json $(BUILD_DIR)/MUX_4_1.json
