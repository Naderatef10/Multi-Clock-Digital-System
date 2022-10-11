module CTRL_RX
#(
parameter ADDR_WIDTH = 4,
parameter OPERAND_WIDTH = 16
)
(
input wire RX_D_VLD,
input wire [7:0]RX_P_DATA,
input wire [OPERAND_WIDTH-1:0] ALU_OUT,
input wire ALU_OUT_valid,
input wire clk,
input wire rst, 
input wire [7:0]Rd_D,
input wire Rd_D_Vld,
output reg CLK_Gate_EN,
output reg [3:0]FUN,
output reg EN,
output reg [ADDR_WIDTH-1:0]ADDR,
output reg RdEn,
output reg WrEn,
output reg [7:0]Wr_Data,
output reg CLK_DIV_EN,
output reg [7:0] RF_SEND_TX,
output reg RF_SEND_TX_FLAG,
output reg [15:0] ALU_OUT_LATCHED,
output reg ALU_SEND_FLAG
);

localparam [3:0]IDLE = 4'b0000;
localparam [3:0]WRITE_CMD_RF_S = 4'b0001 ;
localparam [3:0]WRITE_ADDR_RF_S = 4'b0010 ;
localparam [3:0]WRITE_DATA_RF_S = 4'b0011;

localparam [3:0]READ_ADDR_RF_S = 4'b0101;
localparam [3:0]ALU_WNOP_CMD_S = 4'b0110;
localparam [3:0]ALU_WNOP_FUN_S = 4'b0111;


localparam [3:0]ALU_WOP_OPA_S = 4'b1001;
localparam [3:0]ALU_WOP_OPB_S = 4'b1010;
localparam [3:0]ALU_WOP_FUN_S= 4'b1011;
localparam [3:0]RF_WAIT_S =  4'b1110;

localparam [3:0]ALU_EXTRA_STATE = 4'b1111;

localparam [7:0] RF_WRITE_CMD = 8'hAA;
localparam [7:0] RF_READ_CMD = 8'hBB;
localparam [7:0] ALU_W_OP_CMD = 8'hCC;
localparam [7:0] ALU_WN_OP_CMD = 8'hDD;

reg [3:0] present_state, next_state;

always @(posedge clk , negedge rst ) begin

if(!rst)

    begin 

        present_state <= IDLE;

    end 

    else 

    begin 

        present_state <= next_state;

    end 


end


reg store_address_RF;
reg store_data_RF;
reg store_alu_data;
reg [7:0] RF_ADD_STORE;
reg [7:0] RF_DATA_STORE;

always @(posedge clk , negedge rst) begin
    
if(!rst)

begin 

RF_ADD_STORE <= 0;

end 

else if (store_address_RF)

begin 

RF_ADD_STORE <= RX_P_DATA;

end 


end


always @(posedge clk , negedge rst) begin
    
if(!rst)

begin 

RF_DATA_STORE <= 0;

end 

else if (store_data_RF)

begin 

RF_SEND_TX <= Rd_D ;

end 


end


always @(posedge clk , negedge rst) begin
    
if(!rst)

begin 

ALU_OUT_LATCHED <=0; 

end 

else if (store_alu_data)

begin 

ALU_OUT_LATCHED <= ALU_OUT;

end 


end













always @(*) begin

case (present_state)

   IDLE : 
   
                    begin
                
                                if(!RX_D_VLD)
                                begin 

                                next_state = IDLE;
                                
                                end 
                                
                                else if(RX_P_DATA == RF_WRITE_CMD && RX_D_VLD )

                                begin 

                                next_state = WRITE_ADDR_RF_S;


                                end

                                else if(RX_P_DATA == RF_READ_CMD && RX_D_VLD )

                                begin 

                                next_state = READ_ADDR_RF_S;

                                end 

                                else if(RX_P_DATA == ALU_W_OP_CMD && RX_D_VLD)

                                begin 

                                next_state = ALU_WOP_OPA_S;


                                end

                                else if(RX_P_DATA == ALU_WN_OP_CMD && RX_D_VLD  )

                                begin 

                                next_state = ALU_WOP_FUN_S;

                                end

                                else 

                                begin 

                                next_state = IDLE;

                                end

                    end 

     
        WRITE_ADDR_RF_S:

                    begin 
                    
                            if(RX_D_VLD)

                            begin 

                            next_state = WRITE_DATA_RF_S;

                            end 

                            else 

                            begin 

                            next_state =  WRITE_ADDR_RF_S;

                            end 

                    end

        WRITE_DATA_RF_S:

                    begin 

                            if(RX_D_VLD)

                                begin 

                                next_state = IDLE;

                                end 

                            else 

                                begin 

                                next_state =  WRITE_DATA_RF_S;  

                                end 

                    end

    
                    

        READ_ADDR_RF_S:

                    begin
                    
                            if(RX_D_VLD)

                                begin 

                                next_state = RF_WAIT_S;


                                end

                            else

                                begin 
                                
                                next_state = READ_ADDR_RF_S;


                                end  


                    end 

      RF_WAIT_S:

                    begin 

                        if(Rd_D_Vld)

                                begin 

                                next_state = IDLE;

                                end

                        else

                                begin 

                                next_state = RF_WAIT_S;


                                end 


                    end


    ALU_WOP_OPA_S:

                    begin 


                        if(RX_D_VLD)

                                begin

                                next_state = ALU_WOP_OPB_S;


                                end 


                        else 

                                begin 

                                next_state = ALU_WOP_OPA_S;      
                                

                                end 

                    end 

    ALU_WOP_OPB_S:

                    begin 


                        if(RX_D_VLD)

                            begin 

                            next_state = ALU_WOP_FUN_S;


                            end

                        else 

                            begin 

                            next_state = ALU_WOP_OPB_S;

                            end 
                    end 
ALU_WOP_FUN_S:

begin 

                            if(RX_D_VLD)

                                begin 

                                next_state = ALU_EXTRA_STATE;

                                end 

                            else 

                                begin 

                                next_state = ALU_WOP_FUN_S;

                                end

end 

ALU_EXTRA_STATE:

                        begin 

                            if(ALU_OUT_valid)

                                begin

                                next_state = IDLE;

                                end 

                                else 

                                begin 

                                next_state =  ALU_EXTRA_STATE;      

                                end  

                        end 
                            








    default: 
    
    begin 

    next_state = IDLE; 

    end 

 endcase 






end


always @(*) begin

        CLK_Gate_EN = 0;
        FUN= 4'b0;
        EN= 0 ;
        ADDR=4'b0;
        RdEn= 0 ;
        WrEn= 0;
        Wr_Data= 0;
        CLK_DIV_EN= 1'b1;
        store_address_RF= 1'b0;
        store_data_RF = 1'b0;
        store_alu_data = 1'b0;
        ALU_SEND_FLAG = 1'b0;
        RF_SEND_TX_FLAG = 1'b0;

    case (present_state)
        
        
        IDLE:
        begin 

        CLK_Gate_EN = 0;
        FUN= 4'b0;
        EN= 0 ;
        ADDR=4'b0;
        RdEn= 0 ;
        WrEn= 0;
        Wr_Data= 0;
        CLK_DIV_EN= 1'b1;
      

        end 

        
        WRITE_ADDR_RF_S:

        begin

        if(RX_D_VLD) 
        begin 

        store_address_RF = 1'b1;

        end 

        else 

        begin 
        
        store_address_RF = 1'b0;

        end 

        end 
        
        READ_ADDR_RF_S:
        begin 
        
        if(RX_D_VLD) 
        
        begin 

        store_address_RF = 1'b1;

        end 

        else 

        begin 
        
        store_address_RF = 1'b0;

        end 
        
        end 
        
        WRITE_DATA_RF_S:
        begin 
        
        if(RX_D_VLD) 
        begin 

        Wr_Data = RX_P_DATA;
        ADDR = RF_ADD_STORE;
        WrEn = 1'b1;


        end 

        else 

        begin 

        Wr_Data = RX_P_DATA;
        ADDR = RF_ADD_STORE;
        WrEn = 1'b0;
      

        end 

        end 
        
        RF_WAIT_S:
        begin 
        RdEn = 1'b1;
        ADDR = RF_ADD_STORE;

        if(Rd_D_Vld) 
        
        begin 
        
        store_data_RF = 1'b1;
        RF_SEND_TX_FLAG = 1'b1;

        end 

        else 

        begin 
        
        store_data_RF = 1'b0;
        RF_SEND_TX_FLAG = 1'b0;

        end 

        end 
        
        ALU_WOP_OPA_S:
        begin 

        if(RX_D_VLD) 
        
        begin 

         WrEn = 1'b1;
         Wr_Data = RX_P_DATA;
         ADDR = 0000_0000;

        end 

        else 

        begin 
        
        WrEn = 1'b0;
        Wr_Data = RX_P_DATA;
        ADDR = 0000_0000;
        

        end 

        end 
        
        ALU_WOP_OPB_S:
        begin 
        
        if(RX_D_VLD) 
        
        begin 

         WrEn = 1'b1;
         Wr_Data = RX_P_DATA;
         ADDR = 0000_0001;

        end 

        else 

        begin 
        
        WrEn = 1'b0;
        Wr_Data = RX_P_DATA;
        ADDR = 0000_0001;
        

        end 

        end 
        
        ALU_WOP_FUN_S:
        begin 
        
        CLK_Gate_EN = 1'b1;

        if(RX_D_VLD) 
        
        begin 
        
        FUN = RX_P_DATA;
        EN = 1'b1;

        end 

        else 

        begin 
        
        FUN = RX_P_DATA;
        EN = 1'b0;
        
        end 

        end 
        
        ALU_EXTRA_STATE:
        begin 
        
        CLK_Gate_EN = 1'b1;
        if(ALU_OUT_valid) 
        
        begin 

        store_alu_data = 1'b1;
        ALU_SEND_FLAG = 1'b1;


        end 

        else 

        begin 
        
        store_alu_data = 1'b0;
        ALU_SEND_FLAG = 1'b1;

        end 


        end 

        default: begin
        CLK_Gate_EN = 0;
        FUN= 4'b0;
        EN= 0 ;
        ADDR=4'b0;
        RdEn= 0 ;
        WrEn= 0;
        Wr_Data= 0;
        CLK_DIV_EN= 1'b1;
        store_address_RF= 1'b0;
        store_data_RF = 1'b0;
        store_alu_data = 1'b0;
        ALU_SEND_FLAG = 1'b0;
        RF_SEND_TX_FLAG = 1'b0;

        end 

    endcase







end














endmodule