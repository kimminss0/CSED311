module mux32_2 (
    input [1:0] select,
    input [31:0] w0,
    input [31:0] w1,
    input [31:0] w2,
    output [31:0] dout
);
// select == 3 일때도 w2를 사용하도록 함
  assign dout = select[1] ? w2 : (select[0] ? w1 : w0);

endmodule
