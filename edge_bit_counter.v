module edge_bit_counter(


input wire enable,
input wire clk,
input wire rst,
output reg  [3:0]bit_cnt,
output reg [2:0]edge_cnt

);


assign flag_complete_cycle = (edge_cnt == 3'b111);  

always @(posedge clk , negedge rst ) begin

if(!rst)

begin 

edge_cnt <= 0;
bit_cnt <= 0;


end

else if (!flag_complete_cycle && enable)

begin 

edge_cnt <= edge_cnt + 1;


end 

else if (flag_complete_cycle && enable)

begin 

bit_cnt <= bit_cnt + 1;
edge_cnt <= 0;


end

else 

begin 

bit_cnt <= 0;
edge_cnt <= 0;


end 



end



endmodule