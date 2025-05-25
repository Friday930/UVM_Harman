simSetSimulator "-vcssv" -exec "./build/simv" -args "+UVM_TESTNAME=test"
debImport "-dbdir" "./build/simv.daidir"
debLoadSimResult /home/hedu22/dev/SPI_I2C_UVM/build/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "8" "31" "1924" "1061"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
verdiSetActWin -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_SPI"
wvGetSignalSetScope -win $_nWave2 "/tb_SPI/dut"
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_SPI/dut/MISO} \
{/tb_SPI/dut/MOSI} \
{/tb_SPI/dut/SCLK} \
{/tb_SPI/dut/SS} \
{/tb_SPI/dut/clk} \
{/tb_SPI/dut/cpha} \
{/tb_SPI/dut/cpol} \
{/tb_SPI/dut/done} \
{/tb_SPI/dut/ready} \
{/tb_SPI/dut/reset} \
{/tb_SPI/dut/rx_data\[7:0\]} \
{/tb_SPI/dut/start} \
{/tb_SPI/dut/tx_data\[7:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 )} 
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_SPI/dut/MISO} \
{/tb_SPI/dut/MOSI} \
{/tb_SPI/dut/SCLK} \
{/tb_SPI/dut/SS} \
{/tb_SPI/dut/clk} \
{/tb_SPI/dut/cpha} \
{/tb_SPI/dut/cpol} \
{/tb_SPI/dut/done} \
{/tb_SPI/dut/ready} \
{/tb_SPI/dut/reset} \
{/tb_SPI/dut/rx_data\[7:0\]} \
{/tb_SPI/dut/start} \
{/tb_SPI/dut/tx_data\[7:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 )} 
wvSetPosition -win $_nWave2 {("G1" 13)}
wvGetSignalClose -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 48448471.577726 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 40412659.512761 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 48168152.552204 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 40506099.187935 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 56157244.779582 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 64333216.357309 -snap {("G1" 11)}
wvSetCursor -win $_nWave2 64520095.707657 -snap {("G1" 11)}
wvSetCursor -win $_nWave2 72649347.447796 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 49195988.979118 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 48728790.603248 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 40599538.863109 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 280319.025522 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 327038.863109 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 8409570.765661 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 16351943.155452 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 24714794.083527 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 32470287.122970 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 40179060.324826 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 48401751.740139 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 56484283.642691 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 56390843.967517 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 64800414.733179 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 72369028.422274 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 67463445.475638 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 51859019.721578 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 326659.907300 -snap {("G1" 9)}
debExit
