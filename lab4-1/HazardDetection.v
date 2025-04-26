`include "opcodes.v"

module HazardDetection (
    input      [31:0] IF_ID_inst,
    input      [ 4:0] ID_EX_rd,
    input      [ 4:0] EX_MEM_rd,
    input             ID_EX_mem_read,
    input             ID_EX_reg_write,
    input             EX_MEM_reg_write,
    output reg        stall
);
  wire [4:0] IF_ID_rs1 = is_ecall ? 17 : IF_ID_inst[19:15];
  wire [4:0] IF_ID_rs2 = IF_ID_inst[24:20];
  wire [6:0] IF_ID_opcode = IF_ID_inst[6:0];

  reg        is_ecall;
  reg        use_rs1;
  reg        use_rs2;

  assign stall = ID_EX_mem_read && (
    (IF_ID_rs1 == ID_EX_rd && use_rs1) ||
    (IF_ID_rs2 == ID_EX_rd && use_rs2)) ||
    is_ecall && IF_ID_rs1 == ID_EX_rd && ID_EX_reg_write;

  always @(*) begin
    case (IF_ID_opcode)
      `ARITHMETIC:                   {use_rs1, use_rs2, is_ecall} = 3'b110;
      `ARITHMETIC_IMM, `LOAD, `JALR: {use_rs1, use_rs2, is_ecall} = 3'b100;
      `STORE:                        {use_rs1, use_rs2, is_ecall} = 3'b110;
      `BRANCH:                       {use_rs1, use_rs2, is_ecall} = 3'b110;
      `JAL:                          {use_rs1, use_rs2, is_ecall} = 3'b000;
      `ECALL:                        {use_rs1, use_rs2, is_ecall} = 3'b101;
      default:                       {use_rs1, use_rs2, is_ecall} = 3'b000;
    endcase
    use_rs1 &= IF_ID_rs1 != 0;
    use_rs2 &= IF_ID_rs2 != 0;
  end

endmodule
