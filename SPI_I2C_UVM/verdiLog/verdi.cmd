simSetSimulator "-vcssv" -exec "./build/simv" -args "+UVM_TESTNAME=test"
debImport "-dbdir" "./build/simv.daidir"
debLoadSimResult /home/hedu22/dev/SPI_I2C_UVM/build/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
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
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectGroup -win $_nWave2 {G2}
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 )} 
wvSetPosition -win $_nWave2 {("G1" 6)}
wvSetPosition -win $_nWave2 {("G1" 8)}
wvSetPosition -win $_nWave2 {("G1" 9)}
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 10)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetCursor -win $_nWave2 7856384.389425 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 77800028.745279 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 69452620.331515 -snap {("G1" 11)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 53467060.428032 -snap {("G1" 8)}
wvSetCursor -win $_nWave2 44083045.740663 -snap {("G1" 11)}
wvSetCursor -win $_nWave2 60886979.018044 -snap {("G1" 9)}
wvSetCursor -win $_nWave2 66233685.060848 -snap {("G1" 8)}
wvSetCursor -win $_nWave2 48993285.984054 -snap {("G1" 11)}
wvSetCursor -win $_nWave2 56631437.473773 -snap {("G1" 11)}
wvSetCursor -win $_nWave2 56795112.148552 -snap {("G1" 12)}
debExit
