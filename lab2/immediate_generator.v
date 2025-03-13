module immediate_generator (
    input [31:0] part_of_inst,  // input, part_of_inst = instruction
    output reg [31:0] imm_gen_out  // output
);

  // opcode in instraction
  wire [6:0] opcode;

  assign opcode = part_of_inst[6:0];

  initial begin
    imm_gen_out = 0;
  end

  always @(part_of_inst) begin
    case (opcode)
      `ARITHMETIC_IMM, `LOAD, `JALR: begin
        imm_gen_out[11:0] = part_of_inst[31:20];
        //sign-extend
        if (imm_gen_out[11] == 0) imm_gen_out[31:12] = 20'b00000000000000000000;
        else imm_gen_out[31:12] = 20'b11111111111111111111;
      end

      `STORE: begin
        imm_gen_out[4:0]  = part_of_inst[11:7];
        imm_gen_out[11:5] = part_of_inst[31:25];
        //sign-extend
        if (imm_gen_out[11] == 0) imm_gen_out[31:12] = 20'b00000000000000000000;
        else imm_gen_out[31:12] = 20'b11111111111111111111;
      end

      `BRANCH: begin
        imm_gen_out[11]   = part_of_inst[8];
        imm_gen_out[4:1]  = part_of_inst[12:9];
        imm_gen_out[10:5] = part_of_inst[31:26];
        imm_gen_out[12]   = part_of_inst[31];

        if (imm_gen_out[12] == 0)  //sign-extend
          imm_gen_out[31:13] = 19'b0000000000000000000;
        else imm_gen_out[31:13] = 19'b1111111111111111111;
      end

      `JAL: begin
        imm_gen_out[19:12] = part_of_inst[20:13];
        imm_gen_out[11] = part_of_inst[21];
        imm_gen_out[10:1] = part_of_inst[30:22];
        imm_gen_out[20] = part_of_inst[31];

        if (imm_gen_out[20] == 0)  //sign-extend
          imm_gen_out[31:21] = 11'b00000000000;
        else imm_gen_out[31:21] = 11'b11111111111;
      end

      default: imm_gen_out = 0;

    endcase
  end

endmodule
