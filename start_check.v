module start_check (
  input wire strt_chk_en,
  input wire sampled_bit,
  output wire strt_glitch 
  

);
    

assign strt_glitch = strt_chk_en ? !(sampled_bit == 1'b0) :1'b0;






endmodule