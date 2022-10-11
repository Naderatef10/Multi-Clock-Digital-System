module parity_type(

input wire [7:0] P_DATA,
input wire Data_Valid,
input wire PAR_TYP,
output reg par_bit


);



always@(*)

begin

if(PAR_TYP && Data_Valid)

begin 

par_bit = ~(^P_DATA);


end 


else

begin

par_bit = (^P_DATA);

end




end



endmodule