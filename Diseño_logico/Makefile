# target: prerequisites
# 	commando to build target

# Archivos
# modulos.v código de verilog
# testbench_modulos.v código de verilog
# testbench_modulos.vcd código para lectura de ondas

# Crear los comandos de compilación
# iverilog -g2012 -Wall -Wextra archivo.v -o bin/archivo 
# iverilog -g2012 -Wall -Wextra -t null archivo.v
# vvp bin/testbench_modulos
# gtkwave gtkwave/archivo.vcd

# Variables
IVERILOG=iverilog
VVP=vvp
GTKWAVE=gtkwave
VERSION=-g2012
VFLAGS=-Wall
VSYNTAX=-t null
# Variables para reglas
VSOURCES=$(wildcard *.v)
MODULES=$(filter-out testbench_%,$(VSOURCES))
TESTBENCHES=$(filter testbench_%,$(VSOURCES))
EXE_TESTBENCHES=$(TESTBENCHES:.v=_vvp)
GTK_FILES=$(TESTBENCHES:.v=.vcd)

# Directorios
BIN_FOLDER=bin
TEST_FOLDER=test
GTKWAVE_FOLDER=gtkwave

# Reglas
all:

mkdir:
	@echo 'make mkdir'
	mkdir -p $(BIN_FOLDER) $(TEST_FOLDER) $(GTKWAVE_FOLDER)

# Regla para verificar sintaxis de los modulos sin generar ejecutables
$(MODULES): mkdir
	@echo 'make $$(MODULES)'
	@echo -e "make $@\n"
	$(IVERILOG) $(VERSION) $(VFLAGS) $(VSYNTAX) $@

# Regla para verificar sintaxis de los testbenches sin generar ejecutables
$(TESTBENCHES): mkdir
	@echo 'make $$(TESTBENCHES)'
	@echo -e "make $@\n"
	$(IVERILOG) $(VERSION) $(VFLAGS) $@ -o $(BIN_FOLDER)/$(@:.v=_vvp)

# Regla para ejecutar simulaciones con vvp
$(EXE_TESTBENCHES):
	@echo 'make $$(EXE_TESTBENCHES)'
	@echo -e "make $@\n"
	$(VVP) $(BIN_FOLDER)/$@

# Regla para ejecutar archivos de onda .vcd con gtkwave
$(GTK_FILES):
	@echo 'make $$(GTK_FILES)'
	@echo -e "make $@\n"
	$(GTKWAVE) $(GTKWAVE_FOLDER)/$@

clean:
	rm -rf $(BIN_FOLDER)/*
	rm -rf $(GTKWAVE_FOLDER)/*

mostrar_archivos:
	@echo "Modulos:"
	@echo "$(MODULES)"
	@echo -e "\nTestbenches:"
	@echo "$(TESTBENCHES)"
	@echo -e "\nExe_Testbenches:"
	@echo "$(EXE_TESTBENCHES)"
	@echo -e "\nGTK FILES:"
	@echo "$(GTK_FILES)"

.PHONY: mostrar_archivos $(MODULES)\
		$(TESTBENCHES) mkdir\
		$(EXE_TESTBENCHES) clean\
		$(GTK_FILES)\