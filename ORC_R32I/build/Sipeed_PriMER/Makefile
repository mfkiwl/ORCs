PROJ = ORC_R32I
PIN_DEF = PriMER
DEVICE = EG4S20
PACKAGE = b256
PLACE_AND_ROUTE = td
SEED_0 = 607
SEED_1 = 107
SEED_2 = 207
SEED_3 = 307
SEED_4 = 407
SEED_5 = 507
SEED_6 = 0
SEED_7 = 707
SEED_8 = 807
SEED_9 = 907
SEED_10 = 1007
SEED_11 = 1107

all: clean blif

blif:
	yosys -ql $(PROJ)_$(DEVICE)_syn.log syn_anlogic.ys $^


clean:
	rm -f $(PROJ)_syn.blif $(PROJ)_syn.edif $(PROJ).asc $(PROJ).rpt $(PROJ).bin $(PROJ)_syn.json $(PROJ)_$(DEVICE)_syn.log $(PROJ)_*.asc Timming_Report_* $(PROJ)_$(DEVICE)_*_pnr.log

.SECONDARY:
.PHONY: all pnr rpt prog sudo-prog clean
