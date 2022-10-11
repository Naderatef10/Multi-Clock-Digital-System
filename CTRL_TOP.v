module CTRL_TOP 
    
 (
    input wire clk,
    input wire rst,
    input wire [7:0]Rd_D,
    input wire Rd_D_Vld,
    
    input wire [15:0]ALU_OUT,
    input wire ALU_OUT_valid,
    input wire UART_RX_VLD,
    input wire [7:0]UART_RX_DATA,
    input wire UART_TX_Busy,
    
    output wire WrEn,
    output wire RdEn,
    output wire [3:0]ADDR,

    output wire CLK_Gate_EN,
    output wire EN,
    output wire [7:0]WR_DATA,
    output wire CLK_DIV_EN,

    output wire [3:0]FUN,
    output wire [7:0]UART_TX_INPUT,
    output wire UART_TX_VALID

);


wire [7:0]RF_SEND_TX;
wire RF_SEND_TX_FLAG;
wire [15:0]ALU_OUT_LATCHED; 
wire ALU_SEND_FLAG;

CTRL_RX CTRL_RX_U0(

.RX_D_VLD(UART_RX_VLD),
.RX_P_DATA(UART_RX_DATA),
.ALU_OUT(ALU_OUT),
.ALU_OUT_valid(ALU_OUT_valid),
.clk(clk),
.rst(rst), 
.Rd_D(Rd_D),
.Rd_D_Vld(Rd_D_Vld),
.CLK_Gate_EN(CLK_Gate_EN),
.FUN(FUN),
.EN(EN),
.ADDR(ADDR),
.RdEn(RdEn),
.WrEn(WrEn),
.Wr_Data(WR_DATA),
.CLK_DIV_EN(CLK_DIV_EN),
.RF_SEND_TX(RF_SEND_TX),
.RF_SEND_TX_FLAG(RF_SEND_TX_FLAG),
.ALU_OUT_LATCHED(ALU_OUT_LATCHED),
.ALU_SEND_FLAG(ALU_SEND_FLAG)


);

CTRL_TX CTRL_TX_U1 (
.clk(clk), 
.rst(rst),
.UART_TX_busy(UART_TX_Busy),
.RF_SEND_TX_FLAG(RF_SEND_TX_FLAG),
.ALU_SEND_FLAG(ALU_SEND_FLAG),
.ALU_OUT_LATCHED(ALU_OUT_LATCHED),
.RF_SEND_TX(RF_SEND_TX),
.P_DATA(UART_TX_INPUT),
.UART_TX_VALID(UART_TX_VALID)


);













    
endmodule