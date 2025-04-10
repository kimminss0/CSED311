module mux32 (
    input select,
    input [31:0] w0,
    input [31:0] w1,
    output [31:0] dout
);

  assign dout = select ? w1 : w0;

endmodule
