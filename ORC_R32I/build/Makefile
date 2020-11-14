PROJ = ORC_R32I
PIN_DEF = hx8kboard
DEVICE = hx8k
PACKAGE = ct256
PLACE_AND_ROUTE = nextpnr-ice40

all: clean blif asc bin rpt

blif:
	yosys syn_ice40.ys

asc: blif
	$(PLACE_AND_ROUTE) --$(DEVICE) --package $(PACKAGE) --json $(PROJ)_syn.json --pcf $(PIN_DEF).pcf --pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 0 --asc $(PROJ).asc

bin: asc
	icepack $(PROJ).asc $(PROJ).bin

rpt: bin
	icetime -d $(DEVICE) -p $(PIN_DEF).pcf -P $(PACKAGE) -t -r Timming_Report.txt -c 12 $(PROJ).asc

prog: $(PROJ).bin
	iceprog $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprog $<

clean:
	rm -f $(PROJ)_syn.blif $(PROJ)_syn.edif $(PROJ).asc $(PROJ).rpt $(PROJ).bin $(PROJ)_syn.json Syn_Log.txt PnR_Log.txt Timming_Report.txt

.SECONDARY:
.PHONY: all prog sudo-prog clean
