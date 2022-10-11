module ALU(

// declaring input ports of the design
input wire   [7:0] A, // First input to ALU
input wire   [7:0] B, // second input to ALU
input wire   [3:0] ALU_FUN, //control signals to ALU
input wire CLK,
input wire RST,
input wire Enable,


// declaring output ports of the design 
output reg [15:0]ALU_OUT, // output of ALU
output reg OUT_VALID


);

// temp register for the output of combinational logic of ALU
reg [15:0]ALU_OUT_COMB;

// behavioral always for describing the logic of the ALU
always @ (*)

begin 

// initalization of the flags and the outputs of the ALU
ALU_OUT_COMB =0;





case (ALU_FUN)

 

// addition operation 
4'b0000:    begin 
             
			 
             ALU_OUT_COMB = A+B;
             
			

             end 

//subtraction operation
4'b0001: 	begin 

			ALU_OUT_COMB = A-B;
			

			end 
//Multiplication operation
4'b0010: 	begin 

			ALU_OUT_COMB = A*B;
			

			end 

// division operation
4'b0011: 	begin 

			ALU_OUT_COMB = A/B;
		

			end 
// AND operation
4'b0100: 	begin 
			ALU_OUT_COMB = A&B;
			
			end 

// OR operation
4'b0101: 	begin 

			ALU_OUT_COMB = A|B;
			
			
			end 
// NAND operation
4'b0110: 	begin 
 

			ALU_OUT_COMB = ~(A&B);
			

			end 
// NOR operation
4'b0111: 	begin 

			ALU_OUT_COMB = ~(A|B);
		
			end 
// XOR operation
4'b1000: 	begin 

			ALU_OUT_COMB = A^B;
			
			end 
			
// XNOR operation
4'b1001:	begin 

			ALU_OUT_COMB = A~^B;
		
			
			end 
// Compare if (A==B)		
4'b1010: 	begin 

			
		if(A == B)
		
		begin
		
			ALU_OUT_COMB = 1;

		end

		else

		begin 
       
			ALU_OUT_COMB = 0;
          

		end 
        
			end 


// compare if (A>B)
4'b1011: 	begin 
			
		if(A > B)
        begin
            ALU_OUT_COMB = 2;
        end
		
        else

        begin 
       
			ALU_OUT_COMB = 0;
          
        end 
        
			end 

// Compare if B>A
4'b1100: 	begin 
        
        if(A < B)
        begin
            ALU_OUT_COMB = 3;

        end

        else

        begin 
       
			ALU_OUT_COMB = 0;
          

        end 
        
			end 
// shift right by 1
4'b1101: 	begin 

			
			ALU_OUT_COMB = A >> 1;

			end 
 
// shift left by 1 
4'b1110: 	begin 

			
			ALU_OUT_COMB = A << 1;

			end 
// default case to prevent un intentional latch
default : 
        
			begin
			
			ALU_OUT_COMB =0;
		

			end 


endcase 






end 


// transfering the combinational logic to the output of the flipflop

always @(posedge CLK )

begin

	if(!RST)

	begin
	
	ALU_OUT <= 0;
	OUT_VALID <= 0;

	end 

	else if (Enable)

	begin 

    ALU_OUT <= ALU_OUT_COMB;
    OUT_VALID <= 1'b1;

	end 

	else

	begin 

	OUT_VALID <= 0;

	end 
	
end





endmodule 