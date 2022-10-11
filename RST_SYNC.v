module RST_SYNC

#(
parameter NUM_STAGES = 2

)




(

input wire      RST,
input wire      CLK,
output wire     SYNC_RST

);

reg [NUM_STAGES-1:0] reset_synchronizer;


always @(posedge CLK, negedge RST ) begin
    
if(!RST)

begin

reset_synchronizer <= 0;

end 

else

begin 

reset_synchronizer <= {reset_synchronizer[NUM_STAGES-2:0],1'b1};

end 


end

assign SYNC_RST = reset_synchronizer[NUM_STAGES-1];

endmodule