module UART_TX(
	input  wire            CLK,
	input  wire            RST,
	input  wire            DATA_VALID,
	input  wire            PAR_EN,
	input  wire            PAR_TYP,
	input  wire    [7:0]   P_DATA,
	output wire            TX_OUT,
	output wire            BUSY
);

wire        Ser_en_int;
wire        Ser_done_int;
wire        Ser_data_int;
wire [1:0]  Mux_sel_int;
wire        par_bit_int;

assign start_bit = 1'b0;
assign stop_bit =  1'b1;

serial_tx Serializer_instance (
    .clk(CLK),
    .rst(RST),
    .Data_Valid(DATA_VALID),
    .P_DATA(P_DATA),
    .ser_en(Ser_en_int),
    .serial_data(Ser_data_int),
    .ser_done(Ser_done_int)
);	

UART_FSM_TX FSM_instance (
    .clk(CLK),
    .rst(RST),
    .PAR_EN(PAR_EN),
    .Data_Valid(DATA_VALID),
    .ser_done(Ser_done_int),
    .ser_en(Ser_en_int),
    .mux_sel(Mux_sel_int),
    .busy(BUSY)
);

parity_type Parity_Calc_instance (

    .P_DATA(P_DATA),
    .Data_Valid(DATA_VALID),
    .PAR_TYP(PAR_TYP),
    .par_bit(par_bit_int)
);

mux_4 MUX_instance (
    .mux_sel(Mux_sel_int),
    .start_bit(start_bit),
    .stop_bit(stop_bit),
    .par_bit(par_bit_int),
    .ser_data(Ser_data_int),
    .TX_OUT(TX_OUT)
);
endmodule
