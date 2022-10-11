module data_sampling(
input wire [2:0]edge_cnt,
input wire data_sample_en,
input wire clk,
input wire rx_in,
input wire rst,
input wire [4:0]pre_scale,
output reg sampled_bit


);

reg [2:0] oversampled_bits;
reg [1:0] counter;

always @(posedge clk, negedge rst ) begin
    
if(!rst)

begin 

oversampled_bits <= 3'b000;


end 

else 

begin 

if(data_sample_en)

begin

if(edge_cnt == 3)

begin 
oversampled_bits[0]=rx_in;


end 

else if(edge_cnt == 4)

begin

oversampled_bits[1]=rx_in;

end


else if(edge_cnt == 5)

begin 


oversampled_bits[2]=rx_in;


end



end




end

end


always @(posedge clk, negedge rst) begin
    
if(!rst)

        begin 

        sampled_bit <= 0;

        end



       
else if (data_sample_en)

begin


case (oversampled_bits)
    
    3'b000:

    begin
    
    sampled_bit <= 0;

    end

    3'b001:

    begin

    sampled_bit <= 0;


    end 

    3'b010:

    begin

    sampled_bit <= 0;


    end

    3'b011:

    begin 

    sampled_bit <= 1;

    end

    3'b100:

    begin

    sampled_bit <= 0;

    end

    3'b101:

    begin 


    sampled_bit <= 1;

    end

    3'b110:

    begin

    sampled_bit <= 1;

    end

    3'b111:

    begin

    sampled_bit <= 1;

    end

    endcase


    end


end








endmodule