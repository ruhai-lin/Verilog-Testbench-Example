/* Altera Cyclone V LUT Primitive */
module cyclonev_lcell_comb
  (output combout, cout, sumout, shareout,
   input dataa, datab, datac, datad,
   input datae, dataf, datag, cin,
   input sharein);

   parameter lut_mask      = 64'hFFFFFFFFFFFFFFFF;
   parameter dont_touch    = "off";
   parameter lpm_type      = "cyclonev_lcell_comb";
   parameter shared_arith  = "off";
   parameter extended_lut  = "off";

   // Internal variables
   // Sub mask for fragmented LUTs
   wire [15:0] mask_a, mask_b, mask_c, mask_d;
   // Independent output for fragmented LUTs
   wire        output_0, output_1, output_2, output_3;
   // Extended mode uses mux to define the output
   wire        mux_0, mux_1;
   // Input for hold the shared LUT mode value
   wire        shared_lut_alm;

   // Simulation model of 4-input LUT
   function lut4;
      input [15:0] mask;
      input        dataa, datab, datac, datad;
      reg [7:0]    s3;
      reg [3:0]    s2;
      reg [1:0]    s1;
      begin
         s3   = datad ? mask[15:8] : mask[7:0];
         s2   = datac ?   s3[7:4]  :   s3[3:0];
         s1   = datab ?   s2[3:2]  :   s2[1:0];
         lut4 = dataa ? s1[1] : s1[0];
      end
   endfunction // lut4

   // Simulation model of 5-input LUT
   function lut5;
      input [31:0] mask; // wp-01003.pdf, page 3: "a 5-LUT can be built with two 4-LUTs and a multiplexer.
      input        dataa, datab, datac, datad, datae;
      reg          upper_lut_value;
      reg          lower_lut_value;
      begin
         upper_lut_value = lut4(mask[31:16], dataa, datab, datac, datad);
         lower_lut_value = lut4(mask[15:0], dataa, datab, datac, datad);
         lut5            = (datae) ? upper_lut_value : lower_lut_value;
      end
   endfunction // lut5

   // Simulation model of 6-input LUT
   function lut6;
      input [63:0] mask;
      input        dataa, datab, datac, datad, datae, dataf;
      reg          upper_lut_value;
      reg          lower_lut_value;
      reg          out_0, out_1, out_2, out_3;
      begin
         upper_lut_value = lut5(mask[63:32], dataa, datab, datac, datad, datae);
         lower_lut_value = lut5(mask[31:0], dataa, datab, datac, datad, datae);
         lut6            = (dataf) ?  upper_lut_value : lower_lut_value;
      end
   endfunction // lut6

   assign {mask_a, mask_b, mask_c, mask_d} = {lut_mask[15:0], lut_mask[31:16], lut_mask[47:32], lut_mask[63:48]};
`ifdef ADVANCED_ALM
   always @(*) begin
      if(extended_lut == "on")
        shared_lut_alm = datag;
      else
        shared_lut_alm = datac;
      // Build the ALM behaviour
      out_0 = lut4(mask_a, dataa, datab, datac, datad);
      out_1 = lut4(mask_b, dataa, datab, shared_lut_alm, datad);
      out_2 = lut4(mask_c, dataa, datab, datac, datad);
      out_3 = lut4(mask_d, dataa, datab, shared_lut_alm, datad);
   end
`else
   `ifdef DEBUG
       initial $display("Advanced ALM lut combine is not implemented yet");
   `endif
`endif
endmodule // cyclonev_lcell_comb