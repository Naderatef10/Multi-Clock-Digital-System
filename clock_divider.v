module clock_divider 
#(
parameter  WIDTH  = 4 


)


(

input wire i_ref_clk,
input wire i_rst_n,
input wire i_clk_en,
input wire [WIDTH-1:0]i_div_ratio,
output wire o_div_clk


);
reg o_div_clk_comb; 
reg [4:0] counter;
reg flag;
wire [WIDTH-1:0] div_result;
wire [4:0]check_even;
wire [4:0]check_odd;
assign div_result = i_div_ratio >> 1;
assign o_div_clk = i_clk_en ? o_div_clk_comb : i_ref_clk;  
assign check_even =  div_result -1 ;
assign check_odd = (i_div_ratio-div_result-1);


always @(posedge i_ref_clk , negedge i_rst_n) begin
/*reset state */
if(!i_rst_n)

    begin 

                flag <= 1;
                o_div_clk_comb <= 0;
                counter <= 0;


     end 

// odd if least significant is 1
else if(i_div_ratio[0] == 1 && i_clk_en && i_div_ratio > 1)

    begin

            if( ((counter == check_even) && flag )|| (counter == check_odd && !flag ) )

                begin 

                        flag <= ~flag ;
                        o_div_clk_comb = ~ o_div_clk_comb;
                        counter <= 0;

                 end 


                else

                begin 


                        o_div_clk_comb <= o_div_clk_comb;
                        counter <= counter + 1'b1;


                end 

    end 
/*even integer division */
else if (i_div_ratio[0] == 0 && i_clk_en && i_div_ratio > 1)

    begin 

            if( counter == check_even )

                begin 

                        o_div_clk_comb <= ~ o_div_clk_comb;
                        counter <= 0;

                end 

                else 

                begin 

                        o_div_clk_comb <= o_div_clk_comb;
                        counter <= counter + 1'b1;

                end 


    end 


end









    
endmodule