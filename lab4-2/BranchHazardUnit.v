`include "opcodes.v"

module BranchHazardUnit (
    input      [ 6:0] IF_opcode,      
    input      [ 6:0] IF_ID_opcode,
    input      [ 6:0] ID_EX_opcode,
    input      [31:0] IF_pc,          //pc on IF stage
    input      [31:0] IF_ID_pc,       //pc on ID stage
    input      [31:0] ID_EX_pc,       //pc on EX stage
    input      [31:0] pc_BTB,         //BLT output
    input      [31:0] pc_4,           //pc+4
    input      [31:0] pc_imm,         //pc+imm
    input      [31:0] pc_A,           //alu_result
    input             bcond,          //rs1_dout == rs2_dout
    output reg        flush_IF_ID,
    output reg        flush_ID_EX,
    output reg [31:0] next_pc
);

  wire [31:0] branch_real_pc;
  wire reg pc_4_signal;

  assign branch_real_pc = bcond ? pc_imm : ID_EX_pc+4;
  assign pc_4_signal = (IF_opcode == `ARITHMETIC) || (IF_opcode == `ARITHMETIC_IMM) || (IF_opcode == `LOAD) || (IF_opcode == `STORE) || (IF_opcode == `ECALL);

  always @(*) begin
    // JALR, detected in EX stage
    if (ID_EX_opcode == `JALR && pc_A != IF_ID_pc) begin 
      next_pc = pc_A;
      flush_IF_ID = 1;
      flush_ID_EX = 1;
    end
    // JAL, detected in EX stage
    else if (ID_EX_opcode == `JAL && pc_imm != IF_ID_pc) begin
      next_pc = pc_imm;
      flush_IF_ID = 1;
      flush_ID_EX = 1;
    end
    // Branch, detected in EX stage
    else if (ID_EX_opcode == `BRANCH && branch_real_pc != IF_ID_pc) begin
      next_pc = branch_real_pc;
      flush_IF_ID = 1;
      flush_ID_EX = 1;
    end
    // On non-control inst, next pc is static ( pc+4 )
    else if (pc_4_signal == 1) begin
      next_pc = pc_4;
      flush_IF_ID = 0;
      flush_ID_EX = 0;
    end
    else begin
    // On control flow, use BLT pc
      next_pc = pc_BTB;
      flush_IF_ID = 0;
      flush_ID_EX = 0;
    end
  end

endmodule
