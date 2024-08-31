BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

# The path to the source files
SRC_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_II/src
BUILD_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_II/src/build
CST_FILE = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_II/cst/TOP_Leds.cst

all: $(BUILD_DIR)/TOP_Leds.fs

# Synthesis
synth: $(SRC_DIR)/TOP_Leds.v $(SRC_DIR)/Complemento_a_2.v
	@mkdir -p $(BUILD_DIR)
	yosys -p "read_verilog $(SRC_DIR)/TOP_Leds.v $(SRC_DIR)/Complemento_a_2.v; synth_gowin -top top -json $(BUILD_DIR)/TOP_Leds.json"

# Place and Route
pnr: $(BUILD_DIR)/TOP_Leds.json
	nextpnr-gowin --json $(BUILD_DIR)/TOP_Leds.json --freq 27 --write $(BUILD_DIR)/TOP_Leds_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${CST_FILE}

# Generate Bitstream
fs: $(BUILD_DIR)/TOP_Leds_pnr.json
	gowin_pack -d ${FAMILY} -o $(BUILD_DIR)/TOP_Leds.fs $(BUILD_DIR)/TOP_Leds_pnr.json

# Program Board
load: $(BUILD_DIR)/TOP_Leds.fs
	openFPGALoader -b ${BOARD} $(BUILD_DIR)/TOP_Leds.fs -f

.PHONY: load
.INTERMEDIATE: $(BUILD_DIR)/TOP_Leds_pnr.json $(BUILD_DIR)/TOP_Leds.json