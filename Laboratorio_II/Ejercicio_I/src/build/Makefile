BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

# The path to the source files
SRC_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_II/Ejercicio_I/src/top_module.v
BUILD_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_II/Ejercicio_I/src/build
CST_FILE = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_II/Ejercicio_I/cst/top.cst

all: $(BUILD_DIR)/Ejercicio_I.fs

# Synthesis
synth: $(SRC_DIR)
	@mkdir -p $(BUILD_DIR)
	yosys -p "read_verilog $(SRC_DIR) ; synth_gowin -top top -json $(BUILD_DIR)/Ejercicio_I.json"

# Place and Route
pnr: $(BUILD_DIR)/Ejercicio_I.json
	nextpnr-gowin --json $(BUILD_DIR)/Ejercicio_I.json --freq 27 --write $(BUILD_DIR)/Ejercicio_I_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${CST_FILE}

# Generate Bitstream
fs: $(BUILD_DIR)/Ejercicio_I_pnr.json
	gowin_pack -d ${FAMILY} -o $(BUILD_DIR)/Ejercicio_I.fs $(BUILD_DIR)/Ejercicio_I_pnr.json

# Program Board
load: $(BUILD_DIR)/Ejercicio_I.fs
	openFPGALoader -b ${BOARD} $(BUILD_DIR)/Ejercicio_I.fs -f

.PHONY: load
.INTERMEDIATE: $(BUILD_DIR)/Ejercicio_I_pnr.json $(BUILD_DIR)/Ejercicio_I.json
