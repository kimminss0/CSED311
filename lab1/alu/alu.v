module ALU #(parameter data_width = 16) (
	input [data_width - 1 : 0] A, 
	input [data_width - 1 : 0] B, 
	input [3 : 0] FuncCode,
       	output reg [data_width - 1: 0] C,
       	output reg OverflowFlag);
// Do not use delay in your implementation.

initial begin
	C = 0;
	OverflowFlag = 0;
end   	

always @(*) begin
	if (FuncCode == 4'b0000)
		OverflowFlag = A[data_width - 1] == B[data_width - 1] && A[data_width - 1] != C[data_width - 1];
	else if (FuncCode == 4'b0001)
		OverflowFlag = A[data_width - 1] != B[data_width - 1] && A[data_width - 1] != C[data_width - 1];
	else
		OverflowFlag = 0;
end

always @(*) begin
	case (FuncCode)
		4'b0000 : C = A + B;
		4'b0001 : C = A - B;
		4'b0010 : C = A;
		4'b0011 : C = ~A;
		4'b0100 : C = A & B;
		4'b0101 : C = A | B;
		4'b0110 : C = ~(A & B);
		4'b0111 : C = ~(A | B);
		4'b1000 : C = A ^ B;
		4'b1001 : C = ~(A ^ B);
		4'b1010 : C = A << 1;
		4'b1011 : C = A >> 1;
		4'b1100 : C = A <<< 1;
		4'b1101 : C = A >>> 1;
		4'b1110 : C = ~A + 1;
		default : C = 0;
	endcase
end

endmodule
