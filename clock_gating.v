module clock_gating(

input wire CLK_EN,
input wire CLK,
output wire GATED_CLK

);


reg latch_out;

always @(CLK, CLK_EN) begin
    
if(!CLK)
begin 

latch_out <= CLK_EN;

end

end


assign GATED_CLK = latch_out && CLK;


endmodule