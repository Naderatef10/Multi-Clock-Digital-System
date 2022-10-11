module CTRL_TX(

input wire clk, 
input wire rst,
input wire UART_TX_busy,
input wire RF_SEND_TX_FLAG,
input wire ALU_SEND_FLAG,
input wire [15:0]ALU_OUT_LATCHED,
input wire [7:0] RF_SEND_TX,

output reg [7:0] P_DATA,
output reg       UART_TX_VALID



);

localparam [2:0] IDLE = 3'b00; 
localparam [2:0] SEND_RD_RF = 3'b01; 
localparam [2:0] SEND_FST_BYTE = 3'b10;
localparam [2:0] SEND_2ND_BYTE = 3'b11;
localparam [2:0] half_alu_delay = 3'b111;

reg [2:0] present_state, next_state;


always @(posedge clk , negedge rst) begin

    if(!rst)

    begin 
    
    present_state <= 2'b00;


    end 
    else

    begin 

    present_state <= next_state;


    end 

end

// next_state_logic

always @(*) begin
    

    case (present_state)
        IDLE: begin 

         if(RF_SEND_TX_FLAG)

         begin 
        
       
        next_state = SEND_RD_RF;
        

         end

         else if(ALU_SEND_FLAG)

         begin 

        next_state = SEND_FST_BYTE;


         end 

         else

         begin 
        
        next_state = IDLE;

         end 




        end 

        
        SEND_RD_RF: begin 
        
        if(!UART_TX_busy)
        begin 
        
        next_state = SEND_RD_RF;

        end

        else
        
        begin 

        next_state = IDLE;

        end 


        end 

        
        SEND_FST_BYTE:begin 
        
        if(UART_TX_busy)
        
        begin 
        
        next_state = half_alu_delay;

        end

        else
        
        begin 

        next_state = SEND_FST_BYTE ;

        end 
        


        end 


        half_alu_delay:

        begin

         if(UART_TX_busy)
        
        begin 
        
        next_state = half_alu_delay;

        end

        else
        
        begin 

        next_state = SEND_2ND_BYTE ;

        end 
        
        

        end 


        SEND_2ND_BYTE:begin 
        
        if(UART_TX_busy)
        begin 

            next_state = IDLE;
        

        end

        else
        
        begin 

           next_state = SEND_2ND_BYTE ;

        end 



        end 
 
    endcase

    
end


always @(*) begin
    P_DATA = 8'b0000_0000;
    UART_TX_VALID = 1'b0;

    case (present_state)
        IDLE:begin 
        
    P_DATA = 8'b0;
    UART_TX_VALID = 1'b0;


        end 

        SEND_RD_RF:begin
        
    P_DATA = RF_SEND_TX;
    UART_TX_VALID = 1'b1;


        end 


        SEND_FST_BYTE:begin 

    P_DATA = ALU_OUT_LATCHED[7:0];
    UART_TX_VALID = 1'b1;


        end 

        half_alu_delay: begin

    P_DATA = 8'b0;
    UART_TX_VALID = 1'b0;

        end 

        SEND_2ND_BYTE:begin 
        
    P_DATA = ALU_OUT_LATCHED[15:8];
    UART_TX_VALID = 1'b1;


        end 



    endcase
    
end

endmodule