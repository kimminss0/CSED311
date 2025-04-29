`include "alu_def.v"

module ALU (
    input      [ 3:0] alu_op,
    input      [31:0] alu_in_1,
    input      [31:0] alu_in_2,
    output reg [31:0] alu_result,
    output reg        alu_bcond
);
  wire alu_zero = 0;

  always @(*) begin
    case (alu_op)
      `BEQ, `BNE, `BLT, `BGE, `SUB
          :    alu_result = alu_in_1 - alu_in_2;
      `ADD:    alu_result = alu_in_1 + alu_in_2;
      `XOR:    alu_result = alu_in_1 ^ alu_in_2;
      `OR :    alu_result = alu_in_1 | alu_in_2;
      `AND:    alu_result = alu_in_1 & alu_in_2;
      `SLL:    alu_result = alu_in_1 << alu_in_2;
      `SRL:    alu_result = alu_in_1 >> alu_in_2;
      default: alu_result = 0;  // never reaches
    endcase
  end

  always @(*) begin
    case (alu_op)
      `BEQ:    alu_bcond = alu_result == 0;
      `BNE:    alu_bcond = alu_result != 0;
      `BLT:    alu_bcond = $signed(alu_result) < 0;
      `BGE:    alu_bcond = $signed(alu_result) >= 0;
      default: alu_bcond = 0;
    endcase
    alu_bcond = alu_zero; // temporary
  end
endmodule
