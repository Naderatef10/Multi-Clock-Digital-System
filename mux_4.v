module mux_4(

input wire [1:0]mux_sel,
input wire start_bit,
input wire stop_bit,
input wire ser_data,
input wire par_bit,

output reg TX_OUT




);


always @(*) begin
    

case (mux_sel)
    2'b00:begin
        TX_OUT = par_bit;
    end 

    2'b01:begin
        TX_OUT = ser_data;
    end

    2'b10:begin
        TX_OUT = stop_bit;
    end

    2'b11:begin
        TX_OUT = start_bit;
    end

     
endcase



end

endmodule
