`include "opcodes.v"

module immediate_generator (
    input [31:0] part_of_inst,  // input, part_of_inst = instruction
    output reg [31:0] imm_gen_out  // output
);

  // opcode in instraction
  wire [6:0] opcode;
  assign opcode = part_of_inst[6:0];

  always @(part_of_inst) begin
    case (opcode)
      `ARITHMETIC_IMM, `LOAD, `JALR: begin
        imm_gen_out[11:0] = part_of_inst[31:20];

        //sign-extend
        imm_gen_out[31:12] = (imm_gen_out[11] == 0) ? {20{1'b0}} : {20{1'b1}};
      end

      `STORE: begin
        imm_gen_out[4:0]  = part_of_inst[11:7];
        imm_gen_out[11:5] = part_of_inst[31:25];

        //sign-extend
        imm_gen_out[31:12] = (imm_gen_out[11] == 0) ? {20{1'b0}} : {20{1'b1}};
      end

      `BRANCH: begin
        imm_gen_out[0] = 1'b0;
        imm_gen_out[11]   = part_of_inst[8];
        imm_gen_out[4:1]  = part_of_inst[12:9];
        imm_gen_out[10:5] = part_of_inst[31:26];
        imm_gen_out[12]   = part_of_inst[31];

        //sign-extend
        imm_gen_out[31:13] = (imm_gen_out[12] == 0) ? {19{1'b0}} : {19{1'b1}};
      end

      `JAL: begin
        imm_gen_out[0] = 1'b0;
        imm_gen_out[19:12] = part_of_inst[20:13];
        imm_gen_out[11] = part_of_inst[21];
        imm_gen_out[10:1] = part_of_inst[30:22];
        imm_gen_out[20] = part_of_inst[31];

        //sign-extend
        imm_gen_out[31:21] = (imm_gen_out[20] == 0) ? {11{1'b0}} : {11{1'b1}};
      end

      default: imm_gen_out = 0;

    endcase
  end

endmodule
