verdiSetActWin -dock widgetDock_<Watch>
simSetSimulator "-vcssv" -exec "./build/simv" -args "+UVM_TESTNAME=test"
debImport "-dbdir" "./build/simv.daidir"
debLoadSimResult /home/hedu22/dev/SPI_I2C_UVM/build/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiDockWidgetHide -dock widgetDock_<Watch>
srcTBSetHiddenView -view WatchView
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
verdiSetActWin -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_SPI/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_SPI/S_if"
wvGetSignalSetScope -win $_nWave2 "/tb_SPI/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_SPI/S_if"
wvGetSignalSetScope -win $_nWave2 "/tb_SPI/dut"
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_SPI/dut/U_SPI_Slave/MISO} \
{/tb_SPI/dut/U_SPI_Slave/MOSI} \
{/tb_SPI/dut/U_SPI_Slave/SCLK} \
{/tb_SPI/dut/U_SPI_Slave/SS} \
{/tb_SPI/dut/U_SPI_Slave/clk} \
{/tb_SPI/dut/U_SPI_Slave/reset} \
{/tb_SPI/dut/U_SPI_Slave/si_data\[7:0\]} \
{/tb_SPI/dut/U_SPI_Slave/si_done} \
{/tb_SPI/dut/U_SPI_Slave/so_data\[7:0\]} \
{/tb_SPI/dut/U_SPI_Slave/so_done} \
{/tb_SPI/dut/U_SPI_Slave/so_start} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_SPI/dut/U_SPI_Slave/MISO} \
{/tb_SPI/dut/U_SPI_Slave/MOSI} \
{/tb_SPI/dut/U_SPI_Slave/SCLK} \
{/tb_SPI/dut/U_SPI_Slave/SS} \
{/tb_SPI/dut/U_SPI_Slave/clk} \
{/tb_SPI/dut/U_SPI_Slave/reset} \
{/tb_SPI/dut/U_SPI_Slave/si_data\[7:0\]} \
{/tb_SPI/dut/U_SPI_Slave/si_done} \
{/tb_SPI/dut/U_SPI_Slave/so_data\[7:0\]} \
{/tb_SPI/dut/U_SPI_Slave/so_done} \
{/tb_SPI/dut/U_SPI_Slave/so_start} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvGetSignalClose -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectGroup -win $_nWave2 {G2}
