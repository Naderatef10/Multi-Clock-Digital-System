module parity_check(

input wire PAR_TYP,
input wire par_chk_en,
input wire sampled_bit,
input wire [7:0]P_DATA,
input wire [3:0]bit_cnt,

output reg par_err


);

reg par_rx;


always@(*)

begin

if(PAR_TYP && par_chk_en && bit_cnt == 9)

begin 

par_rx = ~(^P_DATA);

end 

else if (!PAR_TYP && par_chk_en && bit_cnt == 9)

begin

par_rx = (^P_DATA);

end

else 

begin 

par_rx = par_rx;

end 

end



always @(*) begin
    
if(bit_cnt == 9)

begin 

par_err = !(par_rx == sampled_bit);

end 

else 

begin 

par_err = par_err;

end 


end


endmodule