module UART_RX_TOP(

input wire rx_in,
input wire clk,
input wire rst,
input wire [4:0]pre_scale,
input wire PAR_EN,
input wire PAR_TYP,

output wire PAR_ERR,
output wire STP_ERR,
output wire [7:0]P_DATA,
output wire data_valid

);

wire [3:0]bit_cnt;
wire enable_counter;
wire [2:0]edge_cnt;
wire data_sample_en;
wire deser_en;
wire stp_err;
wire stp_chk_en;
wire strt_glitch;
wire strt_chk_en;
wire par_err;
wire par_chk_en;
wire sampled_bit;
wire [7:0]P_DATA_internal;

assign P_DATA = P_DATA_internal;
assign PAR_ERR = par_err;
assign STP_ERR = stp_err;

data_sampling DATA_SAMPLING(

.edge_cnt(edge_cnt),
.data_sample_en(data_sample_en),
.clk(clk),
.rx_in(rx_in),
.rst(rst),
.pre_scale(pre_scale),
.sampled_bit(sampled_bit)
);


parity_check PARITY_CHECK(

.PAR_TYP(PAR_TYP),
.par_chk_en(par_chk_en),
.bit_cnt(bit_cnt),
.sampled_bit(sampled_bit),
.P_DATA(P_DATA_internal),
.par_err(par_err)

);


start_check START_CHECK(

.strt_chk_en(strt_chk_en),
.sampled_bit(sampled_bit),
.strt_glitch(strt_glitch) 

);

stop_check STOP_CHECK(

.stp_chk_en(stp_chk_en),
.sampled_bit(sampled_bit),
.stp_err(stp_err) 

);


edge_bit_counter EDGE_BIT_COUNTER(

.enable(enable_counter),
.clk(clk),
.rst(rst),
.bit_cnt(bit_cnt),
.edge_cnt(edge_cnt)


);


de_serializer DE_SERIALIZER(

.deser_en(deser_en),
.clk(clk),
.rst(rst),
.edge_cnt(edge_cnt),
.sampled_bit(sampled_bit),
.P_DATA(P_DATA_internal)

);


UART_FSM UART_FSM_TOP(

.clk(clk),
.rst(rst),
.PAR_EN(PAR_EN),
.bit_cnt(bit_cnt), 
.rx_in(rx_in),
.par_err(par_err),
.edge_cnt(edge_cnt),
.strt_glitch(strt_glitch),
.stp_err(stp_err),
.data_valid(data_valid),
.par_chk_en(par_chk_en),
.strt_chk_en(strt_chk_en),
.stp_chk_en(stp_chk_en),
.enable_counter(enable_counter),
.data_sample_en(data_sample_en),
.deser_en(deser_en)  


);


endmodule