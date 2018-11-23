# Verilog


## 0. 설명
Verilog를 이용하여 Entry2를 제어하는 코드입니다. module이 정상적으로 동작하기 위해서 output은 모두 register형으로 선언해주시기 바랍니다.


## 1. Basic Logical Operation
기본적인 논리연산(AND, OR)을 Verilog로 구현한 코드입니다. 


## 2. Counter
Entry2의 주파수를 이용하여 원하는 빠르기로 숫자를 세는 코드입니다.

### ▸ asymmetric_clock
clock을 이용한 비대칭형 counter입니다. 

````
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
````
이 부분이 counter를 비대칭형으로 만듭니다. 

else if 문의 CLK_COUNT를 조절하면, 자신이 원하는 만큼 분주를 할 수 있습니다. 즉, 대칭형 counter도 만들 수 있습니다.


### ▸ asymmetric_clock_7segment
asymmetric_clock 코드를 이용하여 7segment를 제어합니다.

````
always@(SEL_SEG)
	case(SEL_SEG)
		0 : SEG_SEL <= 8'b11111110;  
		1 : SEG_SEL <= 8'b11111101;
		2 : SEG_SEL <= 8'b11111011;
	endcase
````
Array로 이루어진 7segment를 조절하는 부분입니다. 이 코드의 SEG_SEL의 숫자를 조절하시면 Array중 원하는 7 segment가 작동하게 할 수 있습니다.   
실제로 Array로 이루어진 7 segment에 하나의 신호가 가기 때문에 켜져있는 모든 7 segment의 숫자는 동일합니다.  
만약 다른 '34'처럼 다른 숫자를 각각 할당하고 싶다면, 눈의 잔상효과를 이용하여야 합니다. 그러기 위해서는 켜져있는 7 segment를 매우 빠르게 바꾸어주어야 합니다. 다음은 이 코드 중 그를 구현한 코드입니다.

````
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
````



````
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
````
10진수 숫자를 7segment가 사용하는 8진수로 바꾸어주는 코드입니다. 가지고 계시는 기계에 맞게 수정해주셔야 합니다.

### ▸ stopwatch
위의 코드들을 활용하여 만든 초시계 코드입니다. 60초를 셀 수 있습니다. 가지고 계시는 기계의 주파수에 맞게 CLK_COUNT를 조절하시면 됩니다. 

## 3. Application
난수생성을 이용하여 가위바위보 게임을 할 수 있는 코드입니다.
````
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
  ````
  entry2에 주어지는 주파수가 매우 크다는 것을 이용하여 만든 난수 생성 코드입니다. 숫자가 매우 빠르게 변하기 때문에 난수 생성 함수와 비슷한 동작을 합니다.
    
