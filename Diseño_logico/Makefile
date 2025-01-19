# target: prerrequisites
# command to build target

# Crear el comando de compilación
# verificar sintaxis
# iverilog -g2012 -Wall -Wextra -t null archivo.v

# Verificar lógica y crear ejecutable
# iverilog -g2012 -Wall -Wextra archivo.v -o bin/archivo

# verificar testbench
# iverilog -g2012 -Wall -Wextra archivo.v -o bin/archivo

# ARCHIVOS -> FFD_posedge.v -> FFD_posedge -> testbench_FFD_posedge.v

# Variables
IVERILOG=iverilog
VVP=vvp
GTKWAVE=gtkwave
VERSION=-g2012
VSINTAX=-t null
VFLAGS=-Wall
SOURCES=$(wildcard *.v)
MODULES=$(filter-out testbench_%, $(SOURCES))
EXE_MODULES=$(patsubst %.v,%,$(MODULES))
TESTBENCHES=$(filter testbench_%, $(SOURCES))
EXE_TESTBENCHES=$(patsubst %.v,%,$(TESTBENCHES))
EXE_VVP=$(EXE_TESTBENCHES:=_vvp)
EXE_GTK=$(EXE_TESTBENCHES:=_gtk)

# Direcciones
BIN_FOLDER=bin
TEST_FOLDER=test
SRC_FOLDER=src
GTKWAVE_FOLDER=gtkwave

# Reglas
all:

# Crear carpetas
mkdir:
	mkdir -p $(BIN_FOLDER)
	mkdir -p $(TEST_FOLDER)
	mkdir -p $(GTKWAVE_FOLDER)

# Revisar sintaxis de modulo.v sin generar ejecutables
$(MODULES):
	@echo -n 'Regla $$(MODULES)'
	@echo " -> make $@"
	$(IVERILOG) $(VERSION) $(VSINTAX) $(VFLAGS) $@

# Regla para compilar archivos testbench.v
$(TESTBENCHES): mkdir
	@echo -n 'Regla $$(TESTBENCHES)'
	@echo " -> make $@"
	$(IVERILOG) $(VERSION) $(VFLAGS) $@ -o $(BIN_FOLDER)/$(@:.v=_vvp)

# Regla para compilar archivos testbench (sin extensión)
$(EXE_TESTBENCHES): mkdir
	@echo -n 'Regla $$(EXE_TESTBENCHES)'
	@echo " -> make $@"
	$(IVERILOG) $(VERSION) $(VFLAGS) $@.v -o $(BIN_FOLDER)/$@_vvp

# Regla para ejecutar salida del comando de compilación
$(EXE_VVP):
	@echo -n 'Regla $$(EXE_VVP)'
	@echo " -> make $@"
	$(VVP) $(BIN_FOLDER)/$<

# Regla para ver las salidas de onda con el programa GTKWAVE
$(EXE_GTK):
	@echo -n 'Regla $$(EXE_GTK)'
	@echo " -> make $@"
	$(GTKWAVE) $(GTKWAVE_FOLDER)/$(@:=.vcd)

clean:
	rm -rf $(BIN_FOLDER)/*

mostrar_archivos:
	@echo "Modulos:"
	@echo "$(MODULES)"
# $(foreach file, $(SOURCES), $(info $(file)) )
	@echo -e "\nEXE_Modulos sin .v:"
	@echo "$(EXE_MODULES)"
	@echo -e "\nTestbench:"
	@echo "$(TESTBENCHES)"
	@echo -e "\nEXE_Testbench sin .v:"
	@echo "$(EXE_TESTBENCHES)"
	@echo -e "\nArchivos TEST_VARIABLES"
	@echo "$(TEST_VARIABLE)"
	@echo -e "\nArchivos EXE_VVPS"
	@echo "$(EXE_VVP:=.vcd)"
	@echo -e "\nArchivos EXE_GTKS"
	@echo "$(EXE_GTK:=.vcd)"

.PHONY: all mostrar_archivos $(MODULES) \
		$(TESTBENCHES) $(EXE_TESTBENCHES) \
		$(EXE_VVP) $(EXE_GTK) mkdir clean