module register_file 
#(

parameter  WIDTH = 8,
parameter DEPTH = 16

)


(

input wire WrEn,
input wire CLK,
input wire RST,
input wire RdEn,
input wire [WIDTH-1:0]WrData,
input wire [3:0]Address,

output reg RdData_Valid,

output wire [WIDTH-1:0]REG0,
output wire [WIDTH-1:0]REG1,
output wire [WIDTH-1:0]REG2,
output wire [WIDTH-1:0]REG3,


output reg  [WIDTH-1:0]RdData



);

reg [WIDTH-1:0] register_file [DEPTH-1:0];

integer  i;

always @(posedge CLK, negedge RST ) begin
    RdData_Valid <=0;
    RdData <= 0;
if(!RST)

begin

for(i=0;i<DEPTH;i=i+1)

begin 

if(i == 2)
begin 

register_file[2] <= 'b001000_01;


end 

else if (i == 3)

begin 

register_file[3] <= 'b0000_1000;

end 

else 

begin 

register_file[i] <= 0;

end 

end 

end 

else if(WrEn)

begin

register_file[Address] <= WrData;

end 

else if(RdEn && !WrEn)

begin

RdData <= register_file[Address];
RdData_Valid <= 1'b1;

end


end 

assign REG0 = register_file[0];
assign REG1 = register_file[1];
assign REG2 = register_file[2];
assign REG3 = register_file[3];








endmodule