## DO NOT MODIFY ANYTHING IN THIS FILE WITHOUT PERMISSION FROM THE INSTRUCTOR OR TAs

# Path to the repository root
REPO_ROOT ?= $(shell git rev-parse --show-toplevel)

# If you have the tools installed in a non-standard path,
# you can override these to specify the path to the executable.
NEXTPNR ?= nextpnr-ice40
ICEPROG ?= iceprog
ICEPACK ?= icepack
ICETIME ?= icetime

# This is the default location for the icebreaker Pin Constraints File
# (PCF) Each part may use a different pcf file, so check in the partX
# directory first! Derived from
# https://github.com/icebreaker-fpga/icebreaker-verilog-examples/blob/main/icebreaker/icebreaker.pcf
PCF_PATH ?= $(REPO_ROOT)/provided/icebreaker.pcf
prog: ice40.bin
	$(ICEPROG) $<

# Placement & Route. Depends on synth.mk
ice40.asc: ice40.json $(PCF_PATH)
	$(NEXTPNR) -ql ice40.nplog --up5k --package sg48 --freq 12 --asc $@ --pcf $(PCF_PATH) --json $< --top top

# Bitstream generation.
bitstream: ice40.bin
ice40.bin: ice40.asc
	$(ICEPACK) $< $@

# Timing analysis
ice40.rpt: ice40.asc
	$(ICETIME) -d up5k -c 12 -mtr $@ $<

fpga-clean:
	rm -rf ice40.bin
	rm -rf ice40.rpt
	rm -rf ice40.asc
	rm -rf ice40.nplog

fpga-help:
	@echo "  bitstream: Build the FPGA program (bitstream)"
	@echo "  prog: Flash the bistream to your FPGA (If running locally)"

fpga-vars-help:
	@echo "    NEXTPNR: Override this variable to set the location of your nextpnr executable."
	@echo "    ICEPROG: Override this variable to set the location of your Icebreaker Programmer executable."
	@echo "    ICEPACK: Override this variable to set the location of your icepack executable."
	@echo "    ICETIME: Override this variable to set the location of your icetime executable."

clean: fpga-clean
targets-help: fpga-help
vars-help: fpga-vars-help

.PHONY: prog fpga-help fpga-clean fpga-vars-help vars-help targets-help clean
