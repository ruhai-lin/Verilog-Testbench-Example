`timescale 1ns/1ps
module testbench
  // You don't usually have ports in a testbench, but we need these to
  // signal to cocotb/gradescope that the testbench has passed, or failed.
  (output logic error_o = 0
  ,output logic pass_o = 0);

   localparam width_lp = 1;
   logic [width_lp-1:0] a_i;
   logic [width_lp-1:0] b_i;
   logic [width_lp-1:0] carry_i;
   logic [width_lp-1:0] sum_o;
   logic [width_lp-1:0] carry_o;

   // You can use this 
   logic [0:0] error;
   
   // Write your assertions inside of the DUT modules themselves.
   full_add
     #()
   dut
     (.a_i(a_i)
     ,.b_i(b_i)
     ,.carry_i(carry_i)
     ,.sum_o(sum_o)
     ,.carry_o(carry_o)
     );

   initial begin
      // Leave this code alone, it generates the waveforms
`ifndef COCOTB
`ifdef VERILATOR
      $dumpfile("verilator.vcd");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;
`endif

      // Leave this here. This is to signal success/failure to cocotb

      // Put your testbench code here. Print all of the test cases and
      // their correctness.

      // Test Case 1
      a_i = 0; b_i = 0; carry_i = 0;
      #10;
      if ((sum_o !== 0) || (carry_o !== 0)) begin
         error_o = 1;
         $display("Test Case 1 failed. Expected sum_o = 0 and carry_o = 0, Got sum_o = %b, carry_o = %b", sum_o, carry_o);
      end

      // Test Case 2
      a_i = 1; b_i = 0; carry_i = 0;
      #10;
      if ((sum_o !== 1) || (carry_o !== 0)) begin
         error_o = 1;
         $display("Test Case 2 failed. Expected sum_o = 1 and carry_o = 0, Got sum_o = %b, carry_o = %b", sum_o, carry_o);
      end

      // Test Case 3
      a_i = 0; b_i = 1; carry_i = 0;
      #10;
      if ((sum_o !== 1) || (carry_o !== 0)) begin
         error_o = 1;
         $display("Test Case 3 failed. Expected sum_o = 1 and carry_o = 0, Got sum_o = %b, carry_o = %b", sum_o, carry_o);
      end

      // Test Case 4
      a_i = 1; b_i = 1; carry_i = 0;
      #10;
      if ((sum_o !== 0) || (carry_o !== 1)) begin
         error_o = 1;
         $display("Test Case 4 failed. Expected sum_o = 0 and carry_o = 1, Got sum_o = %b, carry_o = %b", sum_o, carry_o);
      end

      // Test Case 5
      a_i = 0; b_i = 0; carry_i = 1;
      #10;
      if ((sum_o !== 1) || (carry_o !== 0)) begin
         error_o = 1;
         $display("Test Case 5 failed. Expected sum_o = 1 and carry_o = 0, Got sum_o = %b, carry_o = %b", sum_o, carry_o);
      end

      // Test Case 6
      a_i = 1; b_i = 0; carry_i = 1;
      #10;
      if ((sum_o !== 0) || (carry_o !== 1)) begin
         error_o = 1;
         $display("Test Case 6 failed. Expected sum_o = 0 and carry_o = 1, Got sum_o = %b, carry_o = %b", sum_o, carry_o);
      end

      // Test Case 7
      a_i = 0; b_i = 1; carry_i = 1;
      #10;
      if ((sum_o !== 0) || (carry_o !== 1)) begin
         error_o = 1;
         $display("Test Case 7 failed. Expected sum_o = 0 and carry_o = 1, Got sum_o = %b, carry_o = %b", sum_o, carry_o);
      end

      // Test Case 8
      a_i = 1; b_i = 1; carry_i = 1;
      #10;
      if ((sum_o !== 1) || (carry_o !== 1)) begin
         error_o = 1;
         $display("Test Case 8 failed. Expected sum_o = 1 and carry_o = 1, Got sum_o = %b, carry_o = %b", sum_o, carry_o);
      end


      #20;

      // Set pass_o if no errors
      if (!error_o) begin
         pass_o = 1;
      end

      // Set pass_o or error_o to trigger the final message. Delay for
      // 1 time unit, to ensure cocotb sees it.
      // error_o = 1; #1;
      $finish();
   end

   // This block executes after $finish() has been called.
   final begin
      $display("Simulation time is %t", $time);
      if(error_o) begin
	 $display("\033[0;31m    ______                    \033[0m");
	 $display("\033[0;31m   / ____/_____________  _____\033[0m");
	 $display("\033[0;31m  / __/ / ___/ ___/ __ \\/ ___/\033[0m");
	 $display("\033[0;31m / /___/ /  / /  / /_/ / /    \033[0m");
	 $display("\033[0;31m/_____/_/  /_/   \\____/_/     \033[0m");
	 $display("Simulation Failed");
     end else begin
	 $display("\033[0;32m    ____  ___   __________\033[0m");
	 $display("\033[0;32m   / __ \\/   | / ___/ ___/\033[0m");
	 $display("\033[0;32m  / /_/ / /| | \\__ \\\__ \ \033[0m");
	 $display("\033[0;32m / ____/ ___ |___/ /__/ / \033[0m");
	 $display("\033[0;32m/_/   /_/  |_/____/____/  \033[0m");
	 $display();
	 $display("Simulation Succeeded!");
      end
   end

endmodule
