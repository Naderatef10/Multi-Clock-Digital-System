module UART_TOP
#( 
parameter DATA_WIDTH = 8,
parameter PRESCALE_WIDTH = 5    
)


(

input wire RST,
input wire TX_CLK,
input wire RX_CLK,
input wire RX_IN_S,
output wire [DATA_WIDTH-1:0] RX_OUT_P,
input wire [DATA_WIDTH-1:0] TX_IN_P,
output wire RX_OUT_V,
input wire TX_IN_V,

output wire TX_OUT_S,

output wire busy,

input wire [PRESCALE_WIDTH-1:0] prescale,

input wire parity_enable,

input wire parity_type,

output wire parity_error,

output wire framing_error


);

// uart tx instansiation 

UART_TX UART_TX_U0(

.CLK(TX_CLK),
.RST(RST),
.DATA_VALID(TX_IN_V),
.PAR_EN(parity_enable),
.PAR_TYP(parity_type),
.P_DATA(TX_IN_P),
.TX_OUT(TX_OUT_S),
.BUSY(busy)


);

// uart rx instansaition 

UART_RX_TOP UART_RX_U1(

.rx_in(RX_IN_S),
.clk(RX_CLK),
.rst(RST),
.pre_scale(prescale),
.PAR_EN(parity_enable),
.PAR_TYP(parity_type),
.PAR_ERR(parity_error),
.STP_ERR(framing_error),
.P_DATA(RX_OUT_P),
.data_valid(RX_OUT_V)


);


endmodule