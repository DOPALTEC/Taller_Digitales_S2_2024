
BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

# The path to the source files
SRC_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_II/Ejercicio_II/Proto/src
BUILD_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_II/Ejercicio_II/Proto/src/build
CST_FILE = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_II/Ejercicio_II/Proto/cst/hex_matrix.cst

all: $(BUILD_DIR)/TOP_Leds.fs

# Synthesis
synth: $(SRC_DIR)
	@mkdir -p $(BUILD_DIR)
	yosys -p "read_verilog $(SRC_DIR) ; synth_gowin -top top -json $(BUILD_DIR)/Proto.json"

# Place and Route
pnr: $(BUILD_DIR)/Proto_pnr.json
	nextpnr-gowin --json $(BUILD_DIR)/Proto.json --freq 27 --write $(BUILD_DIR)/Proto_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${CST_FILE}

# Generate Bitstream
fs: $(BUILD_DIR)/Proto_pnr.json
	gowin_pack -d ${FAMILY} -o $(BUILD_DIR)/Proto.fs $(BUILD_DIR)/Proto_pnr.json

# Program Board
load: $(BUILD_DIR)/Proto.fs
	openFPGALoader -b ${BOARD} $(BUILD_DIR)/Proto.fs -f

.PHONY: load
.INTERMEDIATE: $(BUILD_DIR)/Proto_pnr.json $(BUILD_DIR)/Proto.json