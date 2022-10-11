module stop_check (
  input wire stp_chk_en,
  input wire sampled_bit,
  output wire stp_err 
  

);
    

assign stp_err = stp_chk_en ? !(sampled_bit == 1'b1) :1'b0;






endmodule