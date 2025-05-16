program automatic test;
	import uvm_pkg::*;

	class hello_world extends uvm_test;
		`uvm_component_utils(hello_world)

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction
		
		virtual task run_phase(uvm_phase phase);
			phase.raise_objection(this);
			`uvm_info("TEST", "hello world!", UVM_MEDIUM);
			phase.drop_objection(this);
		endtask
	endclass

	initial begin
		run_test();
	end

endprogram
