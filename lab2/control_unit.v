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

  always @(*) begin
    //is_jal
    is_jal = opcode == `JAL;

    //is_jalr
    is_jalr = opcode == `JALR;

    //branch
    branch = opcode == `BRANCH;

    //mem_~
    mem_read = opcode == `LOAD;
    mem_to_reg = opcode == `LOAD;
    mem_write = opcode == `STORE;

    //alu_src : zero -> src is register; one -> imm gen;
    case (opcode)
      `BRANCH, `ARITHMETIC: alu_src = 0;
      default: alu_src = 1;
    endcase

    //write_enable
    case (opcode)
      `BRANCH, `STORE, `ECALL: write_enable = 0;
      default: write_enable = 1;
    endcase

    //pc_to_reg : zero -> normal , one -> PC+4 to register write input
    case (opcode)
      `JAL, `JALR: pc_to_reg = 1;
      default: pc_to_reg = 0;
    endcase

    //is_ecall
    is_ecall = opcode == `ECALL;
  end


endmodule
