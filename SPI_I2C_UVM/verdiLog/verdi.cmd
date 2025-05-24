simSetSimulator "-vcssv" -exec "./build/simv" -args "+UVM_TESTNAME=test"
debImport "-dbdir" "./build/simv.daidir"
debLoadSimResult /home/hedu22/dev/SPI_I2C_UVM/build/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "8" "31" "1920" "1009"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_<Inst._Tree>
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
verdiSetActWin -win $_nWave2
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
debExit
