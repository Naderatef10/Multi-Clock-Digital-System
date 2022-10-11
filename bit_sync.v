module bit_sync
#(

parameter  NUM_STAGES = 2,
parameter BUS_WIDTH = 1 // tlataaaaaaaaaaaaaaaaaaaa

)


(

input     wire [BUS_WIDTH-1:0]ASYNC,
input     wire RST,
input     wire CLK,
output    reg [BUS_WIDTH-1:0]SYNC

);


reg [NUM_STAGES-1:0]synchronizer[BUS_WIDTH-1:0];
integer  i;

always @(posedge CLK, negedge RST ) begin
    
if(!RST)

begin 

for(i=0;i<BUS_WIDTH;i=i+1)

begin 

synchronizer[i] <= 0;


end 


end 

else 

begin 

for(i=0;i<BUS_WIDTH;i=i+1)

begin 

 synchronizer[i] <= {synchronizer[i][NUM_STAGES-2:0],ASYNC[i]};
 

end 

end 


end

always @ (*)

begin 

for(i=0;i<BUS_WIDTH;i=i+1)

begin 

SYNC[i] = synchronizer[i][NUM_STAGES-1'b1];

end 

end 

endmodule 