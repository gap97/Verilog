module RSP(CLK, RESET,key_row,key_col, key_data1, key_data2);

 

input CLK, RESET;

input	[3:0] 	key_row;

output	[2:0]	key_col;

output [2:0] key_data1;

output [2:0] key_data2;

 

reg [2:0] key_data1, key_data2;

reg RANDOM, rsp_number, user_number;

wire	key_stop;

reg clk1, clk2;

	reg	[2:0]	state;

	reg [13:0]  counts1, counts2;

	

	parameter no_scan = 3'b000;

	parameter column1 = 3'b001;

	parameter column2 = 3'b010;

	parameter column3 = 3'b100; 

	

	parameter rock = 1;

	parameter scissor = 2;

	parameter paper = 3;

	

assign key_stop = key_row[0] | key_row[1] | key_row[2] | key_row[3] ;

assign key_col = state;

 

always @(posedge CLK or posedge RESET)  begin

	  	if(RESET) begin 

		counts1 <= 0; 

		clk1 <= 1; end

		else if (counts1 >= 500) begin counts1 <= 0; clk1 <= !clk1; end

		else counts1 <= counts1 +1; end

 

always @(posedge CLK or posedge RESET)  begin

	  	if(RESET) begin 

		counts2 <= 0; 

		clk2 <= 1; end

		else if (counts2 >= 600) begin counts2 <= 0; clk2 <= !clk2; end

		else counts2 <= counts2 +1; end

 

always @(negedge CLK or posedge RESET)// Creating random number 

	if(RESET) RANDOM <= 1;

	else if (RANDOM==3) 

		begin 

			RANDOM<=1;   

		end

		

	else 

		begin 

			RANDOM <= RANDOM+1; 

		end

			

always @(posedge clk1 or posedge RESET)

	begin

		if (RESET) state <= no_scan;

		else begin

		  if (!key_stop) begin

		    case (state)

		    no_scan : state <= column1;

		    column1 : state <= column2;

		    column2 : state <= column3;

		    column3 : state <= column1;

		    default : state <= no_scan;

		    endcase

		  end

		end

	end

 

always @ (posedge clk1) begin

	case (state)

	  column1 : case (key_row)

	  	4'b0001 : user_number=1;

	  	default : user_number=0;

	  	endcase

	  column2 : case (key_row)

	  	4'b0001 : user_number=2;

	  	4'b1000 : user_number=0; 

	  	default : user_number=0;

	  	endcase

	  column3 : case (key_row)

	  	4'b0001 : user_number=3; 

	  	default : user_number=0;

	  	endcase	  	

	  default : user_number=0;

	endcase

	end

	

	always @(posedge clk2) begin

	if (key_stop) begin

	rsp_number = RANDOM;	

	end

	end

	

		always @(posedge clk2) begin

	if(key_stop) begin

	case (user_number)

	  1  : key_data1 <= 3'b001; // key_1

	  2 : key_data1 <= 3'b010;

 // key_2

	  3 : key_data1 <= 3'b100; // key_3

	

	  default : key_data1 <= 3'b000;

	endcase

	end

	end

	

		always @(posedge clk2) begin

	

	if(key_stop) begin

	case (rsp_number)

	  1  : key_data2 <= 3'b001; // key_1

	  2 : key_data2 <= 3'b010;

		 // key_2

	  3 : key_data2 <= 3'b100; // key_3

 	

	  default : key_data2 <= 3'b000;

	endcase

	end

	

	

	end

endmodule
