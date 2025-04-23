`include "opcodes.v"
`include "alu_def.v"

module ALUControlUnit (
    input      [10:0] part_of_inst,
    output reg [ 3:0] alu_op
);
  wire [6:0] funct7;
  wire [2:0] funct3;
  wire [6:0] opcode;

  assign {funct7[5], funct3, opcode} = part_of_inst;
  assign {funct7[6], funct7[4:0]} = 0;

  always @(*) begin
    case (opcode)
      `ARITHMETIC, `ARITHMETIC_IMM: begin
        case (funct3)
          `FUNCT3_ADD: alu_op = (opcode == `ARITHMETIC && funct7 == `FUNCT7_SUB)
                                ? `SUB : `ADD;
          `FUNCT3_SLL: alu_op = `SLL;
          `FUNCT3_XOR: alu_op = `XOR;
          `FUNCT3_OR:  alu_op = `OR;
          `FUNCT3_AND: alu_op = `AND;
          `FUNCT3_SRL: alu_op = `SRL;
          default:     alu_op = 0;  // never reaches
        endcase
      end

      `BRANCH: begin
        case (funct3)
          `FUNCT3_BEQ: alu_op = `BEQ;
          `FUNCT3_BNE: alu_op = `BNE;
          `FUNCT3_BLT: alu_op = `BLT;
          `FUNCT3_BGE: alu_op = `BGE;
          default:     alu_op = 0;  // never reaches
        endcase
      end

      `LOAD, `STORE, `JAL, `JALR
             :         alu_op = `ADD;

      `ECALL :         alu_op = `BEQ;

      default:         alu_op = 0;  // never reaches
    endcase
  end
endmodule
