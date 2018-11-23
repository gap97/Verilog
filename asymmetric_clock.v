module COUNT1000__C_SEG(CLK, RESET, SEG_C, SEG_SEL);

input CLK, RESET;

output [6:0] SEG_C;
output [7:0] SEG_SEL;

reg [6:0] SEG_C;
reg [3:0] COUNT_1, COUNT_10, COUNT_100, COUNT_TMP;  
reg [3:0] CLK_COUNT; 
reg [1:0] SEL_SEG;
reg [7:0] SEG_SEL; 
reg CLK1;

always @(negedge CLK or posedge RESET) 
	if(RESET) 
		CLK1<=0;
	else if (CLK_COUNT==9) 
		begin 
			CLK_COUNT<=0; 
			CLK1<=1;  
		end
		
	else 
		begin 
			CLK_COUNT <= CLK_COUNT+1; 
			CLK1<=0;  
		end
		
always @(negedge CLK1 or posedge RESET) 
	if(RESET) 
		COUNT_1<=0;
	else if (COUNT_1==9) 
		COUNT_1<=0;
	else COUNT_1 <= COUNT_1+1;

always @(negedge CLK1 or posedge RESET) 
	if(RESET) 
		COUNT_10<=0;
else if (COUNT_1 ==9) 
	begin
		if (COUNT_10==9) COUNT_10<=0;
		else COUNT_10 <= COUNT_10+1; 
	end
	
always @(negedge CLK1 or posedge RESET)
	begin
		if(RESET) COUNT_100<=0;
		else if((COUNT_1 ==9) && (COUNT_10==9)) 
			begin
				if (COUNT_100==9) COUNT_100<=0;
				else COUNT_100 <= COUNT_100+1; 
			end
	end
	
always@(negedge CLK1) 
	if(SEL_SEG==2) 
		SEL_SEG <=0;
	else SEL_SEG <= SEL_SEG+1;

always@(COUNT_1 or COUNT_10 or COUNT_100 or SEL_SEG)
	case (SEL_SEG)
		0 : COUNT_TMP <= COUNT_1;
		1 : COUNT_TMP <= COUNT_10;
		2 : COUNT_TMP <= COUNT_100;
	endcase
	
always@(SEL_SEG)
	case(SEL_SEG)
		0 : SEG_SEL <= 8'b11111110;  
		1 : SEG_SEL <= 8'b11111101;
		2 : SEG_SEL <= 8'b11111011;
	endcase
	
SEG_DEC U0 (COUNT_TMP,SEG_C);

endmodule


module SEG_DEC(DIGIT, SEG_DEC); 

input [3:0] DIGIT;
output [6:0] SEG_DEC;

reg [6:0] SEG_DEC;

always @(DIGIT)
	case (DIGIT) // gfe_dcba
	0 : SEG_DEC <= 7'h3f; // 011_1111
	1 : SEG_DEC <= 7'h06; // 000_0110
	2 : SEG_DEC <= 7'h5b; // 101_1011
	3 : SEG_DEC <= 7'h4f; // 100_1111
	4 : SEG_DEC <= 7'h66; // 010_0110
	5 : SEG_DEC <= 7'h6d; // 110_1101
	6 : SEG_DEC <= 7'h7c; // 111_1100
	7 : SEG_DEC <= 7'h07; // 000_0111
	8 : SEG_DEC <= 7'h7f; // 111_1111
	9 : SEG_DEC <= 7'h67; // 110_0111
	endcase

endmodule
