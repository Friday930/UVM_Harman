`timescale 1ns / 1ps

interface SPI_if();
    // global signals
    logic       clk;
    logic       reset;
    // internal signals
    logic       cpol;
    logic       cpha;
    logic       start;
    logic [7:0] tx_data;
    logic [7:0] rx_data;
    logic       done;
    logic       ready;
    // external port
    logic       SS;
endinterface //SPI_if

`include "uvm_macros.svh"
import uvm_pkg::*;

class SPI_seq_item extends uvm_sequence_item;
    // internal signals
    logic       cpol;
    logic       cpha;
    logic       start;
    rand logic [7:0] tx_data;
    logic [7:0] rx_data;
    logic       done;
    logic       ready;
    // external port
    logic       SS;
    function new(string name = "ITEM");
        super.new(name);
    endfunction //new()

    `uvm_object_utils_begin(SPI_seq_item)
        `uvm_field_int(cpol, UVM_DEFAULT)
        `uvm_field_int(cpha, UVM_DEFAULT)
        `uvm_field_int(start, UVM_DEFAULT)
        `uvm_field_int(tx_data, UVM_DEFAULT)
        `uvm_field_int(rx_data, UVM_DEFAULT)
        `uvm_field_int(done, UVM_DEFAULT)
        `uvm_field_int(ready, UVM_DEFAULT)
        `uvm_field_int(SS, UVM_DEFAULT)
    `uvm_object_utils_end

endclass //SPI_seq_item extends uvm_sequence_item

class SPI_sequence extends uvm_sequence #(SPI_seq_item);
    `uvm_object_utils(SPI_sequence)

    function new(string name = "SEQ");
        super.new(name);
    endfunction //new()

    SPI_seq_item SPI_item;

    virtual task body();
        SPI_item = SPI_seq_item::type_id::create("ITEM");

        for (int i = 0; i < 10 ; i++ ) begin
            start_item(SPI_item);

            SPI_item.randomize();
            $display("");
            `uvm_info("SEQ", $sformatf("SPI item to drive tx_data:%0d", SPI_item.tx_data), UVM_NONE);
            // SPI_item.print(uvm_default_line_printer); // if you need, please erase

            finish_item(SPI_item);
        end
    endtask //

endclass //SPI_sequence extends uvm_sequence #(SPI_seq_item)

class SPI_driver extends uvm_driver #(SPI_seq_item);
    `uvm_component_utils(SPI_driver)
    function new(string name = "DRV", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    SPI_seq_item SPI_item;
    virtual SPI_if S_if;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        SPI_item = SPI_seq_item::type_id::create("ITEM");

        if (!uvm_config_db#(virtual SPI_if)::get(this, "", "S_if", S_if)) begin
            `uvm_fatal("DRV", "SPI_if not found in uvm_config_db");
        end
        
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(SPI_item);
            @(posedge S_if.clk);

            S_if.tx_data = SPI_item.tx_data;
            `uvm_info("DRV", $sformatf("DRIVE DUT tx_data:%0d", SPI_item.tx_data), UVM_LOW);
            // SPI_item.print(uvm_default_line_printer); // if you need, please erase

            #1;
            seq_item_port.item_done();
        end
    endtask //

endclass //SPI_driver extends uvm_driver #(SPI_seq_item)

class SPI_monitor extends uvm_monitor;
    `uvm_component_utils(SPI_monitor)

    uvm_analysis_port #(SPI_seq_item) send;

    function new(string name = "MON", uvm_component parent);
        super.new(name, parent);
        send = new("WRITE", this);
    endfunction //new()

    SPI_seq_item SPI_item;
    virtual SPI_if S_if;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        SPI_item = SPI_seq_item::type_id::create("ITEM");
        if (!uvm_config_db#(virtual SPI_if)::get(this, "", "S_if", S_if)) begin
            `uvm_fatal("MON", "SPI_if not found in uvm_config_db");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            // @(posedge S_if.clk);
            // #1;
            
            // SPI_item.tx_data = S_if.tx_data;
            // SPI_item.rx_data = S_if.rx_data;

            // `uvm_info("MON", $sformatf("sampled tx_data:%0d, rx_data:%0d", SPI_item.tx_data, SPI_item.rx_data), UVM_LOW);
            // // SPI_item.print(uvm_default_line_printer); // if you need, please erase

            // send.write(SPI_item);
            // start 신호가 활성화될 때까지 대기
            @(posedge S_if.clk);
            #1;
            
            // start나 done이 활성화된 경우만 샘플링
            if (S_if.start == 1 || S_if.done == 1) begin
                SPI_item.tx_data = S_if.tx_data;
                SPI_item.rx_data = S_if.rx_data;
                SPI_item.start = S_if.start;
                SPI_item.done = S_if.done;
                SPI_item.SS = S_if.SS;
                SPI_item.cpol = S_if.cpol;
                SPI_item.cpha = S_if.cpha;

                `uvm_info("MON", $sformatf("sampled tx:0x%02x, rx:0x%02x, start:%0d, done:%0d", 
                        SPI_item.tx_data, SPI_item.rx_data, SPI_item.start, SPI_item.done), UVM_LOW);

                send.write(SPI_item);
            end
        end
    endtask //
endclass //SPI_monitor extends uvm_monitor

class SPI_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(SPI_scoreboard)

    uvm_analysis_imp #(SPI_seq_item, SPI_scoreboard) recv;

    SPI_seq_item SPI_item;

    function new(string name = "SCO", uvm_component parent);
        super.new(name, parent);
        recv = new("READ", this);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        SPI_item = SPI_seq_item::type_id::create("ITEM");
    endfunction

    virtual function void write(SPI_seq_item item);
        SPI_item = item;
        `uvm_info("SCO", $sformatf("Recieved tx_data:%0d", item.tx_data), UVM_LOW);
        // SPI_item.print(uvm_default_line_printer);

        if (SPI_item.rx_data == SPI_item.tx_data) begin
           `uvm_info("SCO", "*** TEST PASSED ***", UVM_NONE); 
        end else begin
            `uvm_error("SCO", "*** TEST FAILED ***");
        end
        
    endfunction
endclass //SPI_scoreboard extends uvm_scoreboard

class SPI_agent extends uvm_agent;
    `uvm_component_utils(SPI_agent)

    function new(string name = "AGT", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    SPI_monitor SPI_mon;
    SPI_driver SPI_drv;
    uvm_sequencer #(SPI_seq_item) SPI_sqr;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        SPI_mon = SPI_monitor::type_id::create("MON", this);
        SPI_drv = SPI_driver::type_id::create("DRV", this);
        SPI_sqr = uvm_sequencer #(SPI_seq_item)::type_id::create("SQR", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        SPI_drv.seq_item_port.connect(SPI_sqr.seq_item_export);
    endfunction

endclass //SPI_agent extends uvm_agents

class SPI_environment extends uvm_env;
    `uvm_component_utils(SPI_environment)
    
    function new(string name = "ENV", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    SPI_scoreboard SPI_sco;
    SPI_agent SPI_agt;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        SPI_sco = SPI_scoreboard::type_id::create("SCO", this);
        SPI_agt = SPI_agent::type_id::create("AGT", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        SPI_agt.SPI_mon.send.connect(SPI_sco.recv);
    endfunction

endclass //SPI_environment extends uvm_envs

class test extends uvm_test;
    `uvm_component_utils(test)

    function new(string name = "TEST", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    SPI_sequence SPI_seq;
    SPI_environment SPI_env;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        SPI_seq = SPI_sequence::type_id::create("SEQ", this);
        SPI_env = SPI_environment::type_id::create("ENV", this);
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        uvm_root::get().print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        SPI_seq.start(SPI_env.SPI_agt.SPI_sqr);
        phase.drop_objection(this);
    endtask //
endclass //test extends uvm_test

module tb_SPI ();
    // test SPI_test; // if you need, please erase
    SPI_if S_if();

    // put dut here
    SPI_top dut(
        // global signals
        .clk(S_if.clk),
        .reset(S_if.reset),
        // internal signals
        .cpol(S_if.cpol),
        .cpha(S_if.cpha),
        .start(S_if.start),
        .tx_data(S_if.tx_data),
        .rx_data(S_if.rx_data),
        .done(S_if.done),
        .ready(S_if.ready),
        // external port
        .SS(S_if.SS)
    );
    
    always #5 S_if.clk = ~S_if.clk;

    initial begin
        // $fsdbDumpvars(0);
        // $fsdbDumpfile("wave.fsdb");
        S_if.clk = 0;

        // SPI_test = new("TEST", null);
        uvm_config_db #(virtual SPI_if)::set(null, "*", "S_if", S_if);

        run_test();
    end
    
endmodule
