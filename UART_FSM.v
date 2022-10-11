module UART_FSM (

input wire clk,
input wire rst,
input wire PAR_EN,
input wire [3:0]bit_cnt, 
input wire rx_in,
input wire par_err,
input wire [2:0]edge_cnt,
input wire strt_glitch,
input wire stp_err,

output reg  data_valid,
output reg  par_chk_en,
output reg  strt_chk_en,
output reg  stp_chk_en,
output reg  enable_counter,
output reg  data_sample_en,
output reg  deser_en  
    

);
    
reg [2:0] present_state,next_state;

localparam  IDLE = 3'b000;
localparam  START_BIT= 3'b001;
localparam  DATA_PROCESSING= 3'b010 ;
localparam  PARITY_BIT= 3'b011;
localparam  STOP_BIT= 3'b100;
localparam  DATA_VALID = 3'b101;


// sequential logic
always @(posedge clk, negedge rst ) begin
    
if(!rst)
begin 

present_state <= IDLE;
next_state <= IDLE;

end 

else 

begin 

present_state <= next_state;


end 


end
// next state logic and output logic

always @(*)

begin 

data_valid = 1'b0;
par_chk_en = 1'b0;
strt_chk_en = 1'b0;
stp_chk_en =  1'b0;
enable_counter = 1'b1;
data_sample_en = 1'b1;
deser_en  = 1'b0;


case (present_state)

/***************************************    IDLE CASE                ************************************/
    IDLE:

    begin
     
    if(rx_in == 1'b1)

    begin 

    next_state = IDLE;
    enable_counter = 1'b0;
    data_sample_en = 1'b0;

    end

    else

    begin 
    
    next_state = START_BIT;
    strt_chk_en = 1'b1;
    deser_en  = 1'b0;

    end  

    end

/**********************************************************************************************************************/


/***************************************** START_BIT **************************************************************/

    START_BIT:

    begin 

    strt_chk_en = 1'b1;

    if(bit_cnt == 1 && !strt_glitch)

    begin

    next_state = DATA_PROCESSING;
    deser_en = 1'b1;
    

    end 

    else if(bit_cnt == 1 && strt_glitch)

    begin 

    next_state = IDLE;
    

    end 

    else

    begin

    
    next_state = START_BIT;

    end 

    end

/********************************************** *************************************************************************/

/************************ DATA_PROCESSING *********************************************************/

    DATA_PROCESSING:
    
   

    begin 

    deser_en = 1'b1;
    enable_counter = 1'b1;
    data_sample_en = 1'b1; 


    if(PAR_EN && bit_cnt == 9)

    begin
    
    next_state = PARITY_BIT;
    
    

    end 

    else if(!PAR_EN && bit_cnt == 9)
    
    begin
    
    next_state = STOP_BIT;
    

    end 

    else 

    begin 

    next_state = DATA_PROCESSING;


    end

    end 

    /***********************************************************************************************************************/

    /****************************** PARITY_BIT *****************************************************************************/

    PARITY_BIT:
    

    begin 
    
    par_chk_en = 1'b1;

    if(bit_cnt == 10)

    begin

    next_state = STOP_BIT;
    stp_chk_en = 1'b1;

    end


    else

    begin

    next_state = PARITY_BIT;
    par_chk_en = 1'b1;

    end 

    end
    
/******************************************************************************************************************/

/*********************************** STOP_BIT ******************************************************************/

    STOP_BIT:

    begin

    stp_chk_en = 1'b1;

    if((bit_cnt == 11 && ! stp_err && !par_err) || (bit_cnt == 10 && !stp_err && !PAR_EN))

    begin 

    next_state = DATA_VALID;

    end

    else if( ((bit_cnt == 10) && stp_err && !PAR_EN ) || ( (bit_cnt == 11) && (stp_err || par_err))  )

    begin 

    next_state = IDLE;

    end

    else

    begin 

    next_state = STOP_BIT;

    end 

    end

    /***************************************************************************************************************/
    /******************************** DATA_VALID *****************************************************************/

    DATA_VALID:

    begin

    data_valid = 1'b1;
    data_sample_en = 1'b0;
    enable_counter = 1'b0;

    next_state = IDLE;

    end 


   /************************************************************************************************************************/


    default: next_state = IDLE;


endcase










end 




















endmodule