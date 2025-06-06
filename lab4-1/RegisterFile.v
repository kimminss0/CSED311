module RegisterFile (
    input         reset,
    input         clk,
    input  [ 4:0] rs1,              // source register 1
    input  [ 4:0] rs2,              // source register 2
    input  [ 4:0] rd,               // destination register
    input  [31:0] rd_din,           // input data for rd
    input         write_enable,     // RegWrite signal
    output [31:0] rs1_dout,         // output of rs 1
    output [31:0] rs2_dout,
    output [31:0] print_reg   [32]  // output of rs 2
);
  integer i;
  // Register file
  reg [31:0] rf[32];
  assign print_reg = rf;
  // Asynchronously read register file
  assign rs1_dout  = rf[rs1];
  assign rs2_dout  = rf[rs2];

  always @(clk) begin
    if (clk == 0) begin  // negative edge
      if (write_enable & (rd != 0)) rf[rd] <= rd_din;
    end else begin  // positive edge
      if (reset) begin
        rf[0] <= 32'b0;
        rf[1] <= 32'b0;
        rf[2] <= 32'h2ffc;  // stack pointer
        for (i = 3; i < 32; i = i + 1) rf[i] <= 32'b0;
      end
    end
  end
endmodule
