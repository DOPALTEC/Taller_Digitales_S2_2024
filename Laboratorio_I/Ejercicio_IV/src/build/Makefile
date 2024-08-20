BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

# The path to the source files
SRC_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_IV/src/Ejercicio_IV.v
BUILD_DIR = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_IV/src/build
CST_FILE = /Users/gabrielgonzalez/Taller_Digitales_S2_2024/Laboratorio_I/Ejercicio_IV/cst/pwm_generador.cst

all: $(BUILD_DIR)/Ejercicio_IV.fs

# Synthesis
synth: $(SRC_DIR)
	@mkdir -p $(BUILD_DIR)
	yosys -p "read_verilog $(SRC_DIR) ; synth_gowin -top top -json $(BUILD_DIR)/Ejercicio_IV.json"

# Place and Route
pnr: $(BUILD_DIR)/Ejercicio_IV.json
	nextpnr-gowin --json $(BUILD_DIR)/Ejercicio_IV.json --freq 27 --write $(BUILD_DIR)/Ejercicio_IV.json --device ${DEVICE} --family ${FAMILY} --cst ${CST_FILE}

# Generate Bitstream
fs: $(BUILD_DIR)/Ejercicio_IV_pnr.json
	gowin_pack -d ${FAMILY} -o $(BUILD_DIR)/Ejercicio_IV.fs $(BUILD_DIR)/Ejercicio_IV.json

# Program Board
load: $(BUILD_DIR)/Ejercicio_IV.fs
	openFPGALoader -b ${BOARD} $(BUILD_DIR)/Ejercicio_IV.fs -f

clean:
	$(RM) $(BUILD_DIR)/*.json $(BUILD_DIR)/*.fs $(BUILD_DIR)/*.o

.PHONY: load
.INTERMEDIATE: $(BUILD_DIR)/Ejercicio_IV.json $(BUILD_DIR)/Ejercicio_IV.json