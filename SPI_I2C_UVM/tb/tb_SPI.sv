// `timescale 1ns / 1ps

// interface SPI_if();
//     // global signals
//     logic       clk;
//     logic       reset;
//     // internal signals
//     logic       cpol;
//     logic       cpha;
//     logic       start;
//     logic [7:0] tx_data;
//     logic [7:0] rx_data;
//     logic       done;
//     logic       ready;
//     // external port
//     logic       SS;
// endinterface //SPI_if

// `include "uvm_macros.svh"
// import uvm_pkg::*;

// class SPI_seq_item extends uvm_sequence_item;
//     // internal signals
//     logic       cpol;
//     logic       cpha;
//     logic       start;
//     rand logic [7:0] tx_data;
//     logic [7:0] rx_data;
//     logic       done;
//     logic       ready;
//     // external port
//     logic       SS;
//     function new(string name = "ITEM");
//         super.new(name);
//     endfunction //new()

//     `uvm_object_utils_begin(SPI_seq_item)
//         `uvm_field_int(cpol, UVM_DEFAULT)
//         `uvm_field_int(cpha, UVM_DEFAULT)
//         `uvm_field_int(start, UVM_DEFAULT)
//         `uvm_field_int(tx_data, UVM_DEFAULT)
//         `uvm_field_int(rx_data, UVM_DEFAULT)
//         `uvm_field_int(done, UVM_DEFAULT)
//         `uvm_field_int(ready, UVM_DEFAULT)
//         `uvm_field_int(SS, UVM_DEFAULT)
//     `uvm_object_utils_end

// endclass //SPI_seq_item extends uvm_sequence_item

// class SPI_sequence extends uvm_sequence #(SPI_seq_item);
//     `uvm_object_utils(SPI_sequence)

//     function new(string name = "SEQ");
//         super.new(name);
//     endfunction

//     SPI_seq_item SPI_item;
//     logic [7:0] prev_tx_data = 0;


//     virtual task body();       
//         // Write 명령 (8'b10000000)
//         send_fixed_transaction(8'b1_0000000);
        
//         // 4번의 write 데이터 - 각각 랜덤
//         for (int i = 0; i < 4; i++) begin
//             send_transaction();
//         end
        
//         // Read 명령 (8'h00)
//         send_fixed_transaction(8'b0_0000000);
        
//         // 4번의 read 데이터 (8'hff)
//         for (int i = 0; i < 4; i++) begin
//             send_fixed_transaction(8'hff);
//         end
        
//     endtask

//     task send_transaction();
//         SPI_item = SPI_seq_item::type_id::create("ITEM");
//         start_item(SPI_item);
        
//         SPI_item.randomize();  // 랜덤 tx_data
//         SPI_item.cpol = 0;
//         SPI_item.cpha = 0;
        
//         `uvm_info("SEQ", $sformatf("Random tx_data: %02h", prev_tx_data), UVM_NONE);
//         finish_item(SPI_item);
//     endtask
    
//     task send_fixed_transaction(logic [7:0] data);
//         SPI_item = SPI_seq_item::type_id::create("ITEM");
//         start_item(SPI_item);

//         SPI_item.tx_data = data;
//         SPI_item.cpol = 0;
//         SPI_item.cpha = 0;
        
//         `uvm_info("SEQ", $sformatf("Fixed tx_data: %002h", prev_tx_data), UVM_NONE);

//         prev_tx_data = SPI_item.tx_data;
//         finish_item(SPI_item);
//     endtask
// endclass

// class SPI_driver extends uvm_driver #(SPI_seq_item);
//     `uvm_component_utils(SPI_driver)
//     function new(string name = "DRV", uvm_component parent);
//         super.new(name, parent);
//     endfunction //new()

//     SPI_seq_item SPI_item;
//     virtual SPI_if S_if;
//     int transaction_count = 0;

//     logic [7:0] prev_tx_data = 0;

//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         SPI_item = SPI_seq_item::type_id::create("ITEM");

//         if (!uvm_config_db#(virtual SPI_if)::get(this, "", "S_if", S_if)) begin
//             `uvm_fatal("DRV", "SPI_if not found in uvm_config_db");
//         end
//     endfunction

//     virtual task run_phase(uvm_phase phase);
//         int transaction_count = 0;
        
//         // 초기화 (동일)
//         S_if.reset = 1;
//         S_if.SS = 1;        // 초기에는 비활성화
//         S_if.start = 0;
//         S_if.cpol = 0;
//         S_if.cpha = 0;
//         S_if.tx_data = 8'h00;
        
//         repeat(10) @(posedge S_if.clk);
//         S_if.reset = 0;
//         repeat(10) @(posedge S_if.clk);
        
//         // 시나리오 시작
//         S_if.SS = 0;  // 활성화
//         // `uvm_info("DRV", "SS = 0 (Start of scenario)", UVM_NONE);
        
//         forever begin
//             seq_item_port.get_next_item(SPI_item);
            
//             // SS 제어 로직
//             if (transaction_count == 5) begin
//                 S_if.SS = 1;  // Write 완료 후 비활성화
//                 // `uvm_info("DRV", "SS = 1 (End of Write phase)", UVM_NONE);
//                 repeat(5) @(posedge S_if.clk);  // 5 클럭 대기
//                 S_if.SS = 0;  // Read 시작
//                 // `uvm_info("DRV", "SS = 0 (Start of Read phase)", UVM_NONE);
//             end
            
//             // SPI 트랜잭션 실행
//             execute_spi_transaction();
            
//             transaction_count++;
//             seq_item_port.item_done();
            
//             // 10개 트랜잭션 완료 후 종료
//             if (transaction_count >= 10) begin
//                 S_if.SS = 1;  // 최종 비활성화
//                 // `uvm_info("DRV", "SS = 1 (End of scenario)", UVM_NONE);
//                 break;
//             end
//         end
//     endtask

//     task execute_spi_transaction();
//         // ready 신호 대기
//         while (S_if.ready == 0) begin
//             @(posedge S_if.clk);
//         end
        
//         @(posedge S_if.clk);
//         S_if.tx_data = SPI_item.tx_data;
//         S_if.start = 1;

        

        
//         `uvm_info("DRV", $sformatf("Drive dut: tx=%02h", prev_tx_data), UVM_NONE);

//         prev_tx_data = SPI_item.tx_data;
        
//         @(posedge S_if.clk);
//         S_if.start = 0;
        
//         // done 신호 대기
//         fork
//             begin
//                 forever begin
//                     @(posedge S_if.clk);
//                     if (S_if.done == 1) break;
//                 end
//             end
//             begin
//                 repeat(1000) @(posedge S_if.clk);
//                 `uvm_error("DRV", "Timeout in transaction");
//             end
//         join_any
//         disable fork;
        
//         @(posedge S_if.clk);
//         // `uvm_info("DRV", $sformatf("Completed[%0d]: rx=0x%02d", transaction_count, S_if.rx_data), UVM_NONE);
//     endtask
// endclass //SPI_driver extends uvm_driver #(SPI_seq_item)

// class SPI_monitor extends uvm_monitor;
//     `uvm_component_utils(SPI_monitor)

//     uvm_analysis_port #(SPI_seq_item) send;

//     function new(string name = "MON", uvm_component parent);
//         super.new(name, parent);
//         send = new("WRITE", this);
//     endfunction //new()

//     SPI_seq_item SPI_item;
//     virtual SPI_if S_if;
//     logic [7:0] prev_tx_data = 0;


//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         SPI_item = SPI_seq_item::type_id::create("ITEM");
//         if (!uvm_config_db#(virtual SPI_if)::get(this, "", "S_if", S_if)) begin
//             `uvm_fatal("MON", "SPI_if not found in uvm_config_db");
//         end
//     endfunction

//     virtual task run_phase(uvm_phase phase);
//         forever begin
//             @(posedge S_if.clk);
//             #1;
//             // done 엣지나 start 신호 감지
//             if (S_if.start == 1) begin
//                 SPI_item.tx_data = S_if.tx_data;
//             end
//             if(S_if.done == 1) begin
//                 SPI_item.rx_data = S_if.rx_data;
//                 SPI_item.start = S_if.start;
//                 SPI_item.done = S_if.done;
//                 SPI_item.SS = S_if.SS;
//                 // `uvm_info("MON", $sformatf("sampled tx:%0d, rx:%0d", 
//                 //         SPI_item.tx_data, SPI_item.rx_data), UVM_NONE);
//                 `uvm_info("MON", $sformatf("sampled tx_data:%02h, rx_data:%02h", 
//                         prev_tx_data, SPI_item.rx_data), UVM_NONE);

//                 send.write(SPI_item);
//                 prev_tx_data = SPI_item.tx_data;
//             end
//         end
//     endtask
// endclass //SPI_monitor extends uvm_monitor

// // class SPI_scoreboard extends uvm_scoreboard;
// //     `uvm_component_utils(SPI_scoreboard)

// //     uvm_analysis_imp #(SPI_seq_item, SPI_scoreboard) recv;

// //     SPI_seq_item SPI_item;

// //     logic [7:0] prev_tx_data = 0;  // 추가

// //     function new(string name = "SCO", uvm_component parent);
// //         super.new(name, parent);
// //         recv = new("READ", this);
// //     endfunction //new()

// //     virtual function void build_phase(uvm_phase phase);
// //         super.build_phase(phase);
// //         SPI_item = SPI_seq_item::type_id::create("ITEM");
// //     endfunction

// //     virtual function void write(SPI_seq_item item);
// //         SPI_item = item;
// //         // `uvm_info("SCO", $sformatf("Recieved tx_data:%0d, rx_data:%0d", item.tx_data, item.rx_data), UVM_LOW);
// //         `uvm_info("SCO", $sformatf("Recieved tx_data:%0d, rx_data:%0d", prev_tx_data, item.rx_data), UVM_LOW);
// //         // SPI_item.print(uvm_default_line_printer);
// //         if (prev_tx_data != 0 && prev_tx_data != 8'b10000000) begin
// //             if (SPI_item.rx_data == prev_tx_data ) begin
// //             `uvm_info("SCO", "*** TEST PASSED ***", UVM_NONE); 
// //             end else begin
// //                 `uvm_error("SCO", "*** TEST FAILED ***");
// //             end
// //         end
        
// //         prev_tx_data = SPI_item.tx_data;  // 추가

// //     endfunction
// // endclass //SPI_scoreboard extends uvm_scoreboard -> 이전

// class SPI_scoreboard extends uvm_scoreboard;
//     `uvm_component_utils(SPI_scoreboard)

//     uvm_analysis_imp #(SPI_seq_item, SPI_scoreboard) recv;
//     SPI_seq_item SPI_item;

//     // 예상 데이터 저장을 위한 큐
//     logic [7:0] write_data_queue[$];
//     logic [7:0] expected_read_data[4];
//     int transaction_count = 0;
//     bit write_phase = 1;  // Write phase인지 Read phase인지 구분

//     function new(string name = "SCO", uvm_component parent);
//         super.new(name, parent);
//         recv = new("READ", this);
//     endfunction //new()

//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         SPI_item = SPI_seq_item::type_id::create("ITEM");
//     endfunction

//     virtual function void write(SPI_seq_item item);
//         SPI_item = item;
//         transaction_count++;
        
//         `uvm_info("SCO", $sformatf("[%0d] tx_data: %02h, rx_data: %02h", 
//                 transaction_count, item.tx_data, item.rx_data), UVM_LOW);

//         // Phase 전환 감지
//         if (transaction_count == 6) begin
//             write_phase = 0;  // Read phase 시작
//             // Write된 데이터를 expected read data로 설정
//             for (int i = 0; i < 4; i++) begin
//                 if (write_data_queue.size() > i) begin
//                     expected_read_data[i] = write_data_queue[i];
//                 end else begin
//                     expected_read_data[i] = 8'h00;  // 기본값
//                 end
//             end
//             `uvm_info("SCO", "=== SWITCHING TO READ PHASE ===", UVM_NONE);
//             return;
//         end

//         if (write_phase) begin
//             // Write Phase: TX 데이터 저장 (명령어 제외)
//             if (transaction_count > 1) begin  // 첫 번째는 Write 명령어
//                 write_data_queue.push_back(item.tx_data);
//                 `uvm_info("SCO", $sformatf("Stored write data[%0d]: %02h", 
//                         write_data_queue.size()-1, item.tx_data), UVM_NONE);
//             end
//         end else begin
//             // Read Phase: RX 데이터 검증
//             if (transaction_count > 6) begin  // Read 명령어 이후
//                 int read_index = transaction_count - 7;  // 0부터 시작
//                 if (read_index < 4) begin
//                     if (item.rx_data == expected_read_data[read_index]) begin
//                         `uvm_info("SCO", $sformatf("*** READ TEST PASSED [%0d]: Expected=%02h, Got=%02h ***", 
//                                 read_index, expected_read_data[read_index], item.rx_data), UVM_NONE);
//                     end else begin
//                         `uvm_error("SCO", $sformatf("*** READ TEST FAILED [%0d]: Expected=%02h, Got=%02h ***", 
//                                 read_index, expected_read_data[read_index], item.rx_data));
//                     end
//                 end
//             end
//         end
//     endfunction
// endclass //SPI_scoreboard extends uvm_scoreboard

// class SPI_agent extends uvm_agent;
//     `uvm_component_utils(SPI_agent)

//     function new(string name = "AGT", uvm_component parent);
//         super.new(name, parent);
//     endfunction //new()

//     SPI_monitor SPI_mon;
//     SPI_driver SPI_drv;
//     uvm_sequencer #(SPI_seq_item) SPI_sqr;

//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         SPI_mon = SPI_monitor::type_id::create("MON", this);
//         SPI_drv = SPI_driver::type_id::create("DRV", this);
//         SPI_sqr = uvm_sequencer #(SPI_seq_item)::type_id::create("SQR", this);
//     endfunction

//     virtual function void connect_phase(uvm_phase phase);
//         super.connect_phase(phase);
//         SPI_drv.seq_item_port.connect(SPI_sqr.seq_item_export);
//     endfunction

// endclass //SPI_agent extends uvm_agents

// class SPI_environment extends uvm_env;
//     `uvm_component_utils(SPI_environment)
    
//     function new(string name = "ENV", uvm_component parent);
//         super.new(name, parent);
//     endfunction //new()

//     SPI_scoreboard SPI_sco;
//     SPI_agent SPI_agt;

//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         SPI_sco = SPI_scoreboard::type_id::create("SCO", this);
//         SPI_agt = SPI_agent::type_id::create("AGT", this);
//     endfunction

//     virtual function void connect_phase(uvm_phase phase);
//         super.connect_phase(phase);
//         SPI_agt.SPI_mon.send.connect(SPI_sco.recv);
//     endfunction

// endclass //SPI_environment extends uvm_envs

// class test extends uvm_test;
//     `uvm_component_utils(test)

//     function new(string name = "TEST", uvm_component parent);
//         super.new(name, parent);
//     endfunction //new()

//     SPI_sequence SPI_seq;
//     SPI_environment SPI_env;

//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         SPI_seq = SPI_sequence::type_id::create("SEQ", this);
//         SPI_env = SPI_environment::type_id::create("ENV", this);
//     endfunction

//     virtual function void start_of_simulation_phase(uvm_phase phase);
//         super.start_of_simulation_phase(phase);
//         uvm_root::get().print_topology();
//     endfunction

//     virtual task run_phase(uvm_phase phase);
//         phase.raise_objection(this);
//         SPI_seq.start(SPI_env.SPI_agt.SPI_sqr);
//         phase.drop_objection(this);
//     endtask //
// endclass //test extends uvm_test

// module tb_SPI ();
//     // test SPI_test; // if you need, please erase
//     SPI_if S_if();

//     // put dut here
//     SPI_top dut(
//         // global signals
//         .clk(S_if.clk),
//         .reset(S_if.reset),
//         // internal signals
//         .cpol(S_if.cpol),
//         .cpha(S_if.cpha),
//         .start(S_if.start),
//         .tx_data(S_if.tx_data),
//         .rx_data(S_if.rx_data),
//         .done(S_if.done),
//         .ready(S_if.ready),
//         // external port
//         .SS(S_if.SS)
//     );
    
//     always #5 S_if.clk = ~S_if.clk;

//     initial begin
//         $fsdbDumpvars(0);
//         $fsdbDumpfile("wave.fsdb");
//         S_if.clk = 0;

//         // SPI_test = new("TEST", null);
//         uvm_config_db #(virtual SPI_if)::set(null, "*", "S_if", S_if);

//         run_test();
//     end
    
// endmodule


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
    endfunction

    SPI_seq_item SPI_item;

    virtual task body();       
        // Write 명령 (8'b10000000)
        send_fixed_transaction(8'b1_0000000);
        
        // 4번의 write 데이터 - 각각 랜덤
        for (int i = 0; i < 4; i++) begin
            send_transaction();
        end
        
        // Read 명령 (8'h00)
        send_fixed_transaction(8'b0_0000000);
        
        // 4번의 read 데이터 (8'hff)
        for (int i = 0; i < 4; i++) begin
            send_fixed_transaction(8'hff);
        end
        
    endtask

    task send_transaction();
        SPI_item = SPI_seq_item::type_id::create("ITEM");
        start_item(SPI_item);
        
        SPI_item.randomize();  // 랜덤 tx_data
        SPI_item.cpol = 0;
        SPI_item.cpha = 0;
        
        `uvm_info("SEQ", $sformatf("Random tx_data: %02h", SPI_item.tx_data), UVM_NONE);
        finish_item(SPI_item);
    endtask
    
    task send_fixed_transaction(logic [7:0] data);
        SPI_item = SPI_seq_item::type_id::create("ITEM");
        start_item(SPI_item);

        SPI_item.tx_data = data;
        SPI_item.cpol = 0;
        SPI_item.cpha = 0;
        
        `uvm_info("SEQ", $sformatf("Fixed tx_data: %02h", SPI_item.tx_data), UVM_NONE);

        finish_item(SPI_item);
    endtask
endclass

class SPI_driver extends uvm_driver #(SPI_seq_item);
    `uvm_component_utils(SPI_driver)
    function new(string name = "DRV", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    SPI_seq_item SPI_item;
    virtual SPI_if S_if;
    int transaction_count = 0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        SPI_item = SPI_seq_item::type_id::create("ITEM");

        if (!uvm_config_db#(virtual SPI_if)::get(this, "", "S_if", S_if)) begin
            `uvm_fatal("DRV", "SPI_if not found in uvm_config_db");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        int transaction_count = 0;
        
        // 초기화 (동일)
        S_if.reset = 1;
        S_if.SS = 1;        // 초기에는 비활성화
        S_if.start = 0;
        S_if.cpol = 0;
        S_if.cpha = 0;
        S_if.tx_data = 8'h00;
        
        repeat(10) @(posedge S_if.clk);
        S_if.reset = 0;
        repeat(10) @(posedge S_if.clk);
        
        // 시나리오 시작
        S_if.SS = 0;  // 활성화
        // `uvm_info("DRV", "SS = 0 (Start of scenario)", UVM_NONE);
        
        forever begin
            seq_item_port.get_next_item(SPI_item);
            
            // SS 제어 로직
            if (transaction_count == 5) begin
                S_if.SS = 1;  // Write 완료 후 비활성화
                // `uvm_info("DRV", "SS = 1 (End of Write phase)", UVM_NONE);
                repeat(5) @(posedge S_if.clk);  // 5 클럭 대기
                S_if.SS = 0;  // Read 시작
                // `uvm_info("DRV", "SS = 0 (Start of Read phase)", UVM_NONE);
            end
            
            // SPI 트랜잭션 실행
            execute_spi_transaction();
            
            transaction_count++;
            seq_item_port.item_done();
            
            // 10개 트랜잭션 완료 후 종료
            if (transaction_count >= 10) begin
                S_if.SS = 1;  // 최종 비활성화
                // `uvm_info("DRV", "SS = 1 (End of scenario)", UVM_NONE);
                break;
            end
        end
    endtask

    task execute_spi_transaction();
        // ready 신호 대기
        while (S_if.ready == 0) begin
            @(posedge S_if.clk);
        end
        
        @(posedge S_if.clk);
        S_if.tx_data = SPI_item.tx_data;
        S_if.start = 1;

        `uvm_info("DRV", $sformatf("Drive dut: tx=%02h", SPI_item.tx_data), UVM_NONE);
        
        @(posedge S_if.clk);
        S_if.start = 0;
        
        // done 신호 대기
        fork
            begin
                forever begin
                    @(posedge S_if.clk);
                    if (S_if.done == 1) break;
                end
            end
            begin
                repeat(1000) @(posedge S_if.clk);
                `uvm_error("DRV", "Timeout in transaction");
            end
        join_any
        disable fork;
        
        @(posedge S_if.clk);
        // `uvm_info("DRV", $sformatf("Completed[%0d]: rx=0x%02d", transaction_count, S_if.rx_data), UVM_NONE);
    endtask
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
            @(posedge S_if.clk);
            #1;
            // done 엣지나 start 신호 감지
            if (S_if.start == 1) begin
                SPI_item.tx_data = S_if.tx_data;
            end
            if(S_if.done == 1) begin
                SPI_item.rx_data = S_if.rx_data;
                SPI_item.start = S_if.start;
                SPI_item.done = S_if.done;
                SPI_item.SS = S_if.SS;
                // `uvm_info("MON", $sformatf("sampled tx:%0d, rx:%0d", 
                //         SPI_item.tx_data, SPI_item.rx_data), UVM_NONE);
                `uvm_info("MON", $sformatf("sampled tx_data:%02h, rx_data:%02h", 
                        SPI_item.tx_data, SPI_item.rx_data), UVM_NONE);

                send.write(SPI_item);
            end
        end
    endtask
endclass //SPI_monitor extends uvm_monitor

// class SPI_scoreboard extends uvm_scoreboard;
//     `uvm_component_utils(SPI_scoreboard)

//     uvm_analysis_imp #(SPI_seq_item, SPI_scoreboard) recv;

//     SPI_seq_item SPI_item;

//     logic [7:0] prev_tx_data = 0;  // 추가

//     function new(string name = "SCO", uvm_component parent);
//         super.new(name, parent);
//         recv = new("READ", this);
//     endfunction //new()

//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         SPI_item = SPI_seq_item::type_id::create("ITEM");
//     endfunction

//     virtual function void write(SPI_seq_item item);
//         SPI_item = item;
//         // `uvm_info("SCO", $sformatf("Recieved tx_data:%0d, rx_data:%0d", item.tx_data, item.rx_data), UVM_LOW);
//         `uvm_info("SCO", $sformatf("Recieved tx_data:%0d, rx_data:%0d", prev_tx_data, item.rx_data), UVM_LOW);
//         // SPI_item.print(uvm_default_line_printer);
//         if (prev_tx_data != 0 && prev_tx_data != 8'b10000000) begin
//             if (SPI_item.rx_data == prev_tx_data ) begin
//             `uvm_info("SCO", "*** TEST PASSED ***", UVM_NONE); 
//             end else begin
//                 `uvm_error("SCO", "*** TEST FAILED ***");
//             end
//         end
        
//         prev_tx_data = SPI_item.tx_data;  // 추가

//     endfunction
// endclass //SPI_scoreboard extends uvm_scoreboard -> 이전

class SPI_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(SPI_scoreboard)

    uvm_analysis_imp #(SPI_seq_item, SPI_scoreboard) recv;
    SPI_seq_item SPI_item;

    // 예상 데이터 저장을 위한 큐
    logic [7:0] write_data_queue[$];
    logic [7:0] expected_read_data[4];
    int transaction_count = 0;
    bit write_phase = 1;  // Write phase인지 Read phase인지 구분

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
        transaction_count++;
        
        `uvm_info("SCO", $sformatf("[%0d] tx_data: %02h, rx_data: %02h", 
                transaction_count, item.tx_data, item.rx_data), UVM_LOW);

        // Phase 전환 감지
        if (transaction_count == 6) begin
            write_phase = 0;  // Read phase 시작
            // Write된 데이터를 expected read data로 설정
            for (int i = 0; i < 4; i++) begin
                if (write_data_queue.size() > i) begin
                    expected_read_data[i] = write_data_queue[i];
                end else begin
                    expected_read_data[i] = 8'h00;  // 기본값
                end
            end
            `uvm_info("SCO", "=== SWITCHING TO READ PHASE ===", UVM_NONE);
            return;
        end

        if (write_phase) begin
            // Write Phase: TX 데이터 저장 (명령어 제외)
            if (transaction_count > 1) begin  // 첫 번째는 Write 명령어
                write_data_queue.push_back(item.tx_data);
                `uvm_info("SCO", $sformatf("Stored write data[%0d]: %02h", 
                        write_data_queue.size()-1, item.tx_data), UVM_NONE);
            end
        end else begin
            // Read Phase: RX 데이터 검증
            if (transaction_count > 6) begin  // Read 명령어 이후
                int read_index = transaction_count - 7;  // 0부터 시작
                if (read_index < 4) begin
                    if (item.rx_data == expected_read_data[read_index]) begin
                        `uvm_info("SCO", $sformatf("*** READ TEST PASSED [%0d]: Expected=%02h, Got=%02h ***", 
                                read_index, expected_read_data[read_index], item.rx_data), UVM_NONE);
                    end else begin
                        `uvm_error("SCO", $sformatf("*** READ TEST FAILED [%0d]: Expected=%02h, Got=%02h ***", 
                                read_index, expected_read_data[read_index], item.rx_data));
                    end
                end
            end
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
        $fsdbDumpvars(0);
        $fsdbDumpfile("wave.fsdb");
        S_if.clk = 0;

        // SPI_test = new("TEST", null);
        uvm_config_db #(virtual SPI_if)::set(null, "*", "S_if", S_if);

        run_test();
    end
    
endmodule