`timescale 1ns / 1ps

interface SPI_if;
    
endinterface //SPI_if

`include "uvm_macros.svh"
import uvm_pkg::*;

class SPI_seq_item extends uvm_sequence_item;
    function new();
        
    endfunction //new()
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
            `uvm_info("SEQ", $sformatf("SPI item to drive ..."));
            SPI_item.print(uvm_default_line_printer);

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

        if (!uvm_config_db#(virtual SPI_if)::get(this, "", "", ...)) begin
            `uvm_fatal("DRV", "SPI_if not found in uvm_config_db");
        end
        
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_export.get_next_item(SPI_item);
            @(posedge ***.clk);
        end
    endtask //

endclass //SPI_driver extends uvm_driver #(SPI_seq_item)