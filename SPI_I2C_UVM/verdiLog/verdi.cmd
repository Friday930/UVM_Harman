simSetSimulator "-vcssv" -exec "./build/simv" -args "+UVM_TESTNAME=test"
debImport "-dbdir" "./build/simv.daidir"
debLoadSimResult /home/hedu22/dev/SPI_I2C_UVM/build/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
