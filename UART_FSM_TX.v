module UART_FSM_TX
(

input wire ser_done,
input wire Data_Valid,
input wire PAR_EN,
input wire clk,
input wire rst,

output reg  [1:0]mux_sel,
output reg  busy,
output reg  ser_en




);


localparam IDLE = 3'b000 ;
localparam sending_start = 3'b001;
localparam sending_data = 3'b010;
localparam sending_parity= 3'b011;
localparam sending_stop = 3'b100;


reg [2:0]present_state,next_state;

// output and next state logic.

always @(posedge clk , negedge rst) begin
    if(!rst)

    begin

    present_state <= IDLE;
   
    end

    else

    begin 

    present_state <= next_state;

    end 

end

always@(*)

begin
mux_sel = 2'b10;
busy = 1'b0;
ser_en = 1'b0;
next_state = IDLE;

case (present_state)
    IDLE:
    begin
    if(Data_Valid == 0)
    begin

        next_state = IDLE;


    end 
    else

    begin
    
        next_state = sending_start;


    end

    end 

    sending_start:
    begin

      mux_sel = 2'b11;
      ser_en = 1'b1;
      busy = 1'b1;
      next_state = sending_data;

    end

    sending_data:
    begin
     
     if(ser_done && PAR_EN)
     begin
     
     next_state= sending_parity;
     busy = 1'b1;
     mux_sel = 2'b00;


     end


    else if(ser_done && !PAR_EN)

    begin

        next_state = sending_stop;
        busy = 1'b1;
        mux_sel = 2'b10;

    end



     else

     begin
    
    mux_sel = 2'b01;
    ser_en = 1'b1;
    busy = 1'b1;
    next_state = sending_data;
        

     end

    end

    sending_parity:
    begin

    mux_sel = 2'b10;
    ser_en = 1'b0;
    busy = 1'b1;

    next_state = sending_stop;

    end

   sending_stop:
   begin
   
   mux_sel = 2'b10;
   busy = 1'b1;
   ser_en = 1'b0;
   
   next_state = IDLE;

   end


   
endcase









end 


endmodule
