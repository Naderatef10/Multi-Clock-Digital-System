module serial_tx(

input wire ser_en,
input wire clk,
input wire rst,
input wire Data_Valid,
input wire [7:0]P_DATA,
output reg serial_data,
output wire ser_done
);


reg [3:0] counter;
wire counter_finish;
reg [7:0] latched_data;


assign counter_finish = (counter == 4'b1001);
assign ser_done = (counter == 4'b1001);


always @ (*)

begin



if(Data_Valid)

begin

latched_data = P_DATA;

end

else 

begin 

latched_data = latched_data;

end

end


always @(posedge clk , negedge rst) begin
    
if(!rst)
begin 


counter <= 0;
serial_data <= 0;

end

else if(ser_en && !counter_finish )

begin

serial_data <= latched_data[counter];
counter <= counter + 1'b1;

end


else


begin

counter <= 0;


end

end

endmodule
