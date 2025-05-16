verdiSetActWin -dock widgetDock_<Decl._Tree>
simSetSimulator "-vcssv" -exec "./build/simv" -args "+UVM_TESTNAME=test"
debImport "-dbdir" "./build/simv.daidir"
debLoadSimResult /home/hedu22/dev/0515_uvm_adder/build/wave.fsdb
wvCreateWindow
verdiWindowResize -win $_Verdi_1 "830" "370" "900" "700"
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "830" "370" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("a_if(adder_if)" 0)}
wvRenameGroup -win $_nWave2 {G1} {a_if(adder_if)}
wvAddSignal -win $_nWave2 "/tb_adder/a_if/clk" "/tb_adder/a_if/a\[7:0\]" \
           "/tb_adder/a_if/b\[7:0\]" "/tb_adder/a_if/y\[8:0\]"
wvSetPosition -win $_nWave2 {("a_if(adder_if)" 0)}
wvSetPosition -win $_nWave2 {("a_if(adder_if)" 4)}
wvSetPosition -win $_nWave2 {("a_if(adder_if)" 4)}
wvSetPosition -win $_nWave2 {("G2" 0)}
verdiSetActWin -win $_nWave2
wvSelectGroup -win $_nWave2 {G2}
wvSelectSignal -win $_nWave2 {( "a_if(adder_if)" 4 )} 
wvSelectSignal -win $_nWave2 {( "a_if(adder_if)" 3 )} 
wvSelectSignal -win $_nWave2 {( "a_if(adder_if)" 2 )} 
wvSelectSignal -win $_nWave2 {( "a_if(adder_if)" 2 3 4 )} 
wvSelectSignal -win $_nWave2 {( "a_if(adder_if)" 2 3 4 )} 
wvSetRadix -win $_nWave2 -format UDec
wvSetCursor -win $_nWave2 147.485145 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 1448.415436 -snap {("a_if(adder_if)" 1)}
wvSetCursor -win $_nWave2 1554.159502 -snap {("a_if(adder_if)" 1)}
wvSetCursor -win $_nWave2 1652.946722 -snap {("a_if(adder_if)" 1)}
wvSetCursor -win $_nWave2 1746.168465 -snap {("a_if(adder_if)" 1)}
wvSetCursor -win $_nWave2 1851.912531 -snap {("a_if(adder_if)" 1)}
wvSetCursor -win $_nWave2 1957.656598 -snap {("a_if(adder_if)" 1)}
schCreateWindow -delim "." -win $_nSchema1 -scope "tb_adder"
verdiSetActWin -win $_nSchema_3
schSelect -win $_nSchema3 -inst "dut"
schDeselectAll -win $_nSchema3
schZoomIn -win $_nSchema3 -pos 8590 2118
schZoomIn -win $_nSchema3 -pos 8590 2119
schZoomIn -win $_nSchema3 -pos 8581 2119
schZoomOut -win $_nSchema3 -pos 8580 2118
schZoomOut -win $_nSchema3 -pos 8581 2118
schZoomOut -win $_nSchema3 -pos 8581 2118
schSelect -win $_nSchema3 -inst "tb_adder:Always0:249:249:Combo"
schSelect -win $_nSchema3 -inst "dut"
