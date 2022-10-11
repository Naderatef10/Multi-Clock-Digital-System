module Data_sync

#(

parameter BUS_WIDTH = 8,
parameter NUM_STAGES = 3
)

(

input           wire [BUS_WIDTH-1:0] unsync_bus,
input           wire bus_enable,
input           wire clk,
input           wire rst, 

output           reg [BUS_WIDTH-1:0]sync_bus,
output           reg  enable_pulse 


);


reg [NUM_STAGES-1:0] Multi_flop;
wire out_multi_flop;
reg register_pulse;
reg pulse_gen;
reg [BUS_WIDTH-1:0]out_mux;



always @(posedge clk , negedge rst) begin
    
if(!rst)

begin 

Multi_flop <= 0;

end 

else 

begin 

Multi_flop <= {Multi_flop[NUM_STAGES-2:0],bus_enable};

register_pulse <= out_multi_flop;
pulse_gen <= (~register_pulse & out_multi_flop);
enable_pulse <= pulse_gen;
sync_bus <= out_mux;
end 


end


assign out_multi_flop = Multi_flop[NUM_STAGES-1'b1];

always @ (*)

begin 

if(pulse_gen)

begin 

out_mux = unsync_bus;



end 


else

begin 

out_mux = sync_bus;

end 






end 

endmodule