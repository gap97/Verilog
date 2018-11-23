module COUNT1000__C_SEG(CLK, RESET);

input CLK, RESET;

reg [3:0] COUNT_1, COUNT_10, COUNT_100, COUNT_TMP;  
reg [3:0] CLK_COUNT; 
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
	

endmodule

