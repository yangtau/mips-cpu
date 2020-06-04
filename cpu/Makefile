ic = iverilog

mips: mips.v alu.v  im.v pc.v reg.v extend.v cop.v control.v peripheral.v \
 	  seven_segs.v keypad.v segs_ctrl.v clock_div.v
	$(ic) -Wall -o mips mips.v alu.v  im.v pc.v reg.v extend.v cop.v control.v peripheral.v seven_segs.v keypad.v segs_ctrl.v clock_div.v

clean:
	rm -f mips
	rm -f *.vcd
	rm -f *.txt
	rm -f *.exe *.wdb *.html *.xml *.cmd *.xmsgs *.gise *.ini