module COUNT1000__C_SEG(CLK, RESET, SEG_C, SEG_SEL);

input CLK, RESET;
output [6:0] SEG_C; //7-segment에서 segment data a~g
output [7:0] SEG_SEL; //7-segment에서 com단자(segment select), 우리가 사용하지 않을 것 끌것

//출력은 모두 reg로 선언
reg CLK2;
reg [6:0] SEG_C;
reg [3:0] COUNT_1, COUNT_10, COUNT_100, COUNT_TMP;//각 자리수의 숫자 기억 temp는 지금 출력할 숫자 저장  
reg [50:0] CLK_COUNT; //분주를 나타냄 
reg [1:0] SEL_SEG; // 0이면 1의자리 1이면 10의 자리... 몇 번째 자리를 할건지 얘가 정함
reg [7:0] SEG_SEL; //분주된 클락 
reg CLK1;

always @(negedge CLK or posedge RESET) // CLK/10
	if(RESET) 
		CLK1<=0;
	//대칭형이면 반을 세어야할 수 있어야 하고 비대칭형은 셀 수 있어야함.
	else if (CLK_COUNT==100000000) // 비대칭형. 대칭형인지 비대칭형인지 분주방법이 달라짐.
		begin 
			CLK_COUNT<=0; 
			CLK1<=1;  
		end
		
	else 
		begin 
			CLK_COUNT <= CLK_COUNT+1; 
			CLK1<=0; //CLK_COUNT가 0~8까지는 CLK1이 0이다 
		end

always @(negedge CLK1 or posedge RESET) // CLK/10
	if(RESET) 
		CLK2<=0;
	//대칭형이면 반을 세어야할 수 있어야 하고 비대칭형은 셀 수 있어야함.
	else if (CLK1==100000000) // 비대칭형. 대칭형인지 비대칭형인지 분주방법이 달라짐.
		begin 
			CLK2<=1;  
		end
		
	else 
		begin 
			CLK2<=0; //CLK_COUNT가 0~8까지는 CLK1이 0이다 
		end
		
always @(negedge CLK1 or posedge RESET) // COUNT_1 1의 자리 숫자값 계산
	if(RESET) 
		COUNT_1<=0;
	else if (COUNT_1==9) 
		COUNT_1<=0;
	else COUNT_1 <= COUNT_1+1;

always @(negedge CLK1 or posedge RESET) // COUNT_10
	if(RESET) 
		COUNT_10<=0;
else if (COUNT_1 ==9) 
	begin
		if (COUNT_10==9) COUNT_10<=0;
		else COUNT_10 <= COUNT_10+1; 
	end
	
always @(negedge CLK1 or posedge RESET) // COUNT_100
	begin
		if(RESET) COUNT_100<=0;
		else if((COUNT_1 ==9) && (COUNT_10==9)) 
			begin
				if (COUNT_100==9) COUNT_100<=0;
				else COUNT_100 <= COUNT_100+1; 
			end
	end
	
always@(negedge CLK2) // SEC_SEG 0->1->2->0...
	if(SEL_SEG==2) 
		SEL_SEG <=0;
	else SEL_SEG <= SEL_SEG+1;

always@(COUNT_1 or COUNT_10 or COUNT_100 or SEL_SEG)//FSM을 이용하여 상태 변화
	case (SEL_SEG)
		0 : COUNT_TMP <= COUNT_1;
		1 : COUNT_TMP <= COUNT_10;
		2 : COUNT_TMP <= COUNT_100;
	endcase
	
always@(SEL_SEG)
	case(SEL_SEG)
		0 : SEG_SEL <= 8'b11111110; //1의 자리만 활성화시키겠음 
		1 : SEG_SEL <= 8'b11111101;
		2 : SEG_SEL <= 8'b11111011;
	endcase
	
SEG_DEC U0 (COUNT_TMP,SEG_C);

endmodule


module SEG_DEC(DIGIT, SEG_DEC); //conv

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
