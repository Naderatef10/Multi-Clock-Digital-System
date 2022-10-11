module SYSTEM_TOP(

input wire REF_CLK,
input wire RST,
input wire UART_CLK,
input wire RX_IN,

output wire TX_OUT,
output wire framing_error,
output wire parity_error




);

wire TX_CLK;
wire [7:0]RX_OUT_P_SYNCH;
wire [7:0]TX_IN_P;
wire busy;
wire [7:0]Rd_D;
wire Rd_D_Vld;
wire UART_RX_VLD_SYNCH;
wire [15:0]ALU_OUT;
wire ALU_OUT_valid;
wire UART_TX_VALID_DATA_SYNCHRNOIZER;
wire WrEn;
wire RdEn;
wire [3:0]ADDR;
wire CLK_Gate_EN;
wire EN;
wire [7:0]wr_data;
wire CLK_DIV_EN;
wire [3:0]FUN;
wire [7:0]UART_TX_INPUT_DATA_SYNCHRONIZER; 
wire UART_RX_VLD_DATA_SYNCHRONIZER;
wire [7:0]UART_RX_DATA_SYNCHRONIZER;

wire SYNC_RST_CTRL_DOMAIN;
wire [7:0]UART_CONFIG;
wire [7:0]OPA,OPB;
wire parity_enable;
wire parity_type;
wire [4:0]pre_scale;
wire TX_OUT_V_SYNCHRNOZIER;
wire [7:0]div_ratio_clk; 
wire ALU_CLK;
wire UART_TX_VALID_SYNCHRONOUS;
wire SYNC_RST_DATA_SYNCH_UART_DOMAIN;
wire busy_sync;


assign parity_type = UART_CONFIG[1];
assign parity_enable = UART_CONFIG[0];
assign pre_scale = UART_CONFIG[6:2];


UART_TOP UART_TOP_U1(

.RST(SYNC_RST_DATA_SYNCH_UART_DOMAIN),
.TX_CLK(TX_CLK),
.RX_CLK(UART_CLK),
.RX_IN_S(RX_IN),
.RX_OUT_P(RX_OUT_P_SYNCH),
.TX_IN_P(TX_IN_P),
.RX_OUT_V(UART_RX_VLD_SYNCH),
.TX_IN_V(UART_TX_VALID_SYNCHRONOUS),
.TX_OUT_S(TX_OUT),
.busy(busy),
.prescale(pre_scale),
.parity_enable(parity_enable),
.parity_type(parity_type),
.parity_error(parity_error),
.framing_error(framing_error)


);



CTRL_TOP CTRL_TOP_U2(

.clk(REF_CLK),
.rst(SYNC_RST_CTRL_DOMAIN),
.Rd_D(Rd_D),
.Rd_D_Vld(Rd_D_Vld),
.ALU_OUT(ALU_OUT),
.ALU_OUT_valid(ALU_OUT_valid),
.UART_RX_VLD(UART_RX_VLD_DATA_SYNCHRONIZER),
.UART_RX_DATA(UART_RX_DATA_SYNCHRONIZER),
.UART_TX_Busy(busy_sync),
.WrEn(WrEn),
.RdEn(RdEn),
.ADDR(ADDR),
.CLK_Gate_EN(CLK_Gate_EN),
.EN(EN),
.WR_DATA(wr_data),
.CLK_DIV_EN(CLK_DIV_EN),
.FUN(FUN),
.UART_TX_INPUT(UART_TX_INPUT_DATA_SYNCHRONIZER),
.UART_TX_VALID(UART_TX_VALID_DATA_SYNCHRNOIZER)

);



register_file REGISTER_FILE_U1(
.WrEn(WrEn),
.CLK(REF_CLK),
.RST(SYNC_RST_CTRL_DOMAIN),
.RdEn(RdEn),
.WrData(wr_data),
.RdData(Rd_D),
.Address(ADDR),
.RdData_Valid(Rd_D_Vld),
.REG0(OPA),
.REG1(OPB),
.REG2(UART_CONFIG),
.REG3(div_ratio_clk)



);



ALU ALU_MODULE_U2(
.A(OPA), 
.B(OPB), 
.ALU_FUN(FUN),
.CLK(ALU_CLK),
.RST(SYNC_RST_CTRL_DOMAIN),
.Enable(EN),
.ALU_OUT(ALU_OUT),
.OUT_VALID(ALU_OUT_valid)


);


RST_SYNC RST_SYNC_REG_FILE(


 .RST(RST),
 .CLK(REF_CLK),
 .SYNC_RST(SYNC_RST_CTRL_DOMAIN)


);



RST_SYNC RST_SYNC_DATA_SYNCHRONIZER(
.RST(RST),
.CLK(UART_CLK),
.SYNC_RST(SYNC_RST_DATA_SYNCH_UART_DOMAIN) 

);

clock_gating CLOCK_GATING(

.CLK_EN(CLK_Gate_EN),
.CLK(REF_CLK),
.GATED_CLK(ALU_CLK)

);

clock_divider  CLK_DIVIDER(
.i_ref_clk(UART_CLK),
.i_rst_n(SYNC_RST_DATA_SYNCH_UART_DOMAIN),
.i_clk_en(CLK_DIV_EN),
.i_div_ratio(div_ratio_clk[3:0]),
.o_div_clk(TX_CLK)

);

Data_sync #(.NUM_STAGES(2) ) DATA_SYNC_UART_TX(

.unsync_bus(UART_TX_INPUT_DATA_SYNCHRONIZER),
.bus_enable(UART_TX_VALID_DATA_SYNCHRNOIZER),
.clk(TX_CLK),
.rst(SYNC_RST_DATA_SYNCH_UART_DOMAIN), 
.sync_bus(TX_IN_P),
.enable_pulse(UART_TX_VALID_SYNCHRONOUS) 

);

Data_sync DATA_SYNC_UART_RX(

.unsync_bus(RX_OUT_P_SYNCH),
.bus_enable(UART_RX_VLD_SYNCH),
.clk(REF_CLK),
.rst(SYNC_RST_CTRL_DOMAIN), 
.sync_bus(UART_RX_DATA_SYNCHRONIZER),
.enable_pulse(UART_RX_VLD_DATA_SYNCHRONIZER) 

);


bit_sync busy_synchronization(

.ASYNC(busy),
.RST(RST),
.CLK(REF_CLK),
.SYNC(busy_sync)



);

endmodule