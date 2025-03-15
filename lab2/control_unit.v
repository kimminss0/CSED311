`include "opcodes.v"

module control_unit (
    input [6:0] part_of_inst,  // input, = opcode
    output reg is_jal,  // output
    output reg is_jalr,  // output
    output reg branch,  // output
    output reg mem_read,  // output
    output reg mem_to_reg,  // output
    output reg mem_write,  // output
    output reg alu_src,  // output
    output reg write_enable,  // output
    output reg pc_to_reg,  // output
    output reg is_ecall  // output (ecall inst)
);
  //rename
  wire [6:0] opcode;
  assign opcode = part_of_inst;

  initial begin
    is_jal = 0;
    is_jalr = 0;
    branch = 0;
    mem_read = 0;
    mem_to_reg = 0;
    mem_write = 0;
    alu_src = 0;
    write_enable = 0;
    pc_to_reg = 0;
    is_ecall = 0;
  end

  always @(part_of_inst) begin
    //is_jal
    is_jal = (opcode == `JAL) ? 0 : 1;

    //is_jalr
    is_jalr = (opcode == `JALR) ? 0 : 1;

    //branch
    branch = (opcode == `BRANCH) ? 0 : 1;

    //mem_~
    mem_read = (opcode == `LOAD) ? 0 : 1;
    mem_to_reg = (opcode == `LOAD) ? 0 : 1;
    mem_write = (opcode == `STORE) ? 0 : 1;

    //alu_src : zero -> src is register; one -> imm gen;
    case (opcode)
      `JAL, `JALR, `BRANCH, `LOAD, `STORE, `ARITHMETIC_IMM: alu_src = 1;
      default: alu_src = 0;
    endcase

    //write_enable
    case (opcode)
      `JAL, `JALR, `LOAD, `ARITHMETIC, `ARITHMETIC_IMM: write_enable = 1;
      default: write_enable = 0;
    endcase

    //pc_to_reg : zero -> normal , one -> PC+4 to register write input
    case (opcode)
      `JAL, `JALR: pc_to_reg = 1;
      default: pc_to_reg = 0;
    endcase

    //is_ecall
    is_ecall = (opcode == `ECALL) ? 0 : 1;
  end


endmodule
