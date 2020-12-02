PROJ = ORC_R32I
PIN_DEF = hx8kboard
DEVICE = hx8k
PACKAGE = ct256
PLACE_AND_ROUTE = nextpnr-ice40

all: clean asc_0 asc_1 asc_2 asc_3 rpt

blif:
	yosys -q -p "synth_ice40 -abc2 -relut -retime -device hx -json ORC_R32I_syn.json -top ORC_R32I" "../source/ORC_R32I.v"

asc_0: blif
	$(PLACE_AND_ROUTE) --$(DEVICE) --package $(PACKAGE) --json $(PROJ)_syn.json --pcf $(PIN_DEF).pcf --pcf-allow-unconstrained --timing-allow-fail --pre-pack pre_pack.py --opt-timing --seed 0 --asc $(PROJ).asc

asc_1: blif
	$(PLACE_AND_ROUTE) --$(DEVICE) --package $(PACKAGE) --json $(PROJ)_syn.json --pcf $(PIN_DEF).pcf --pcf-allow-unconstrained --timing-allow-fail --pre-pack pre_pack.py --opt-timing --seed 77 --asc $(PROJ)_111.asc

asc_2: blif
	$(PLACE_AND_ROUTE) --$(DEVICE) --package $(PACKAGE) --json $(PROJ)_syn.json --pcf $(PIN_DEF).pcf --pcf-allow-unconstrained --timing-allow-fail --pre-pack pre_pack.py --opt-timing --seed 999 --asc $(PROJ)_222.asc

asc_3: blif
	$(PLACE_AND_ROUTE) --$(DEVICE) --package $(PACKAGE) --json $(PROJ)_syn.json --pcf $(PIN_DEF).pcf --pcf-allow-unconstrained --timing-allow-fail --pre-pack pre_pack.py --opt-timing --seed 3579 --asc $(PROJ)_333.asc

bin_0: asc_0
	icepack $(PROJ).asc $(PROJ).bin

bin_1: asc_1
	icepack $(PROJ)_111.asc $(PROJ)_111.bin

bin_2: asc_2
	icepack $(PROJ)_222.asc $(PROJ)_222.bin

bin_3: asc_3
	icepack $(PROJ)_333.asc $(PROJ)_333.bin

rpt: asc_0 asc_1 asc_2 asc_3
	icetime -d $(DEVICE) -p $(PIN_DEF).pcf -P $(PACKAGE) -t -r Timming_Report.txt -c 12 $(PROJ).asc
	icetime -d $(DEVICE) -p $(PIN_DEF).pcf -P $(PACKAGE) -t -r Timming_Report_111.txt -c 12 $(PROJ)_111.asc
	icetime -d $(DEVICE) -p $(PIN_DEF).pcf -P $(PACKAGE) -t -r Timming_Report_222.txt -c 12 $(PROJ)_222.asc
	icetime -d $(DEVICE) -p $(PIN_DEF).pcf -P $(PACKAGE) -t -r Timming_Report_333.txt -c 12 $(PROJ)_333.asc

prog: $(PROJ).bin
	iceprog $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprog $<

clean:
	rm -f $(PROJ)_syn.blif $(PROJ)_syn.edif $(PROJ).asc $(PROJ).rpt $(PROJ).bin $(PROJ)_syn.json Syn_Log.txt PnR_Log.txt Timming_Report.txt

.SECONDARY:
.PHONY: all prog sudo-prog clean
