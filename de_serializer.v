module de_serializer(

input wire deser_en,
input wire clk,
input wire rst,
input wire [2:0]edge_cnt,
input wire sampled_bit,

output reg [7:0] P_DATA


);


reg [2:0] counter;
assign de_serializer_is_done = (counter == 3'b111); 

always @(posedge clk , negedge rst) begin
    
    if(!rst)
    
    begin 

    P_DATA <= 8'b0;
    counter <= 0;


    end

    else 

    begin 
    
    if(edge_cnt == 3'd6 &&  deser_en)

    begin 

    P_DATA[counter] <= sampled_bit;
    counter <= counter + 1'b1;

    end 

    else 

    begin 

    P_DATA <= P_DATA;

    end

    end


end


endmodule