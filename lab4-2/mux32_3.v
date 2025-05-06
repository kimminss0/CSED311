module mux32_3 (
    input  [ 1:0] select,
    input  [31:0] w0,
    input  [31:0] w1,
    input  [31:0] w2,
    input  [31:0] w3,
    output [31:0] dout
);

  assign dout = select[1] ? (select[0] ? w3 : w2) : (select[0] ? w1 : w0);

endmodule
