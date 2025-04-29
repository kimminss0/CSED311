`include "opcodes.v"

module ImmediateGenerator (
    input [31:0] part_of_inst,  // input, part_of_inst = instruction
    output reg [31:0] imm_gen_out  // output
);
  // opcode in instraction
  wire [6:0] opcode;
  assign opcode = part_of_inst[6:0];

  always @(*) begin
    case (opcode)
      `ARITHMETIC_IMM, `LOAD, `JALR: begin
        imm_gen_out[11:0]  = part_of_inst[31:20];
        imm_gen_out[31:12] = {20{imm_gen_out[11]}};  //sign-extend
      end

      `STORE: begin
        imm_gen_out[4:0]   = part_of_inst[11:7];
        imm_gen_out[11:5]  = part_of_inst[31:25];
        imm_gen_out[31:12] = {20{imm_gen_out[11]}};  //sign-extend
      end

      `BRANCH: begin
        imm_gen_out[0]    = 1'b0;
        imm_gen_out[11]   = part_of_inst[7];
        imm_gen_out[4:1]  = part_of_inst[11:8];
        imm_gen_out[10:5] = part_of_inst[30:25];
        imm_gen_out[12]   = part_of_inst[31];
        imm_gen_out[31:13] = {19{imm_gen_out[12]}};  //sign-extend
      end

      `JAL: begin
        imm_gen_out[0]     = 1'b0;
        imm_gen_out[19:12] = part_of_inst[19:12];
        imm_gen_out[11]    = part_of_inst[20];
        imm_gen_out[10:1]  = part_of_inst[30:21];
        imm_gen_out[20]    = part_of_inst[31];
        imm_gen_out[31:21] = {11{imm_gen_out[20]}};  //sign-extend
      end

      `ECALL: imm_gen_out = 10;

      default: imm_gen_out = 0;

    endcase
  end
endmodule
