// Submit this file with other files you created.
// Do not touch port declarations of the module 'cpu'.

// Guidelines
// 1. It is highly recommened to `define opcodes and something useful.
// 2. You can modify the module.
// (e.g., port declarations, remove modules, define new modules, ...)
// 3. You might need to describe combinational logics to drive them into the module (e.g., mux, and, or, ...)
// 4. `include files if required

module cpu (
    input         reset,         // positive reset signal
    input         clk,           // clock signal
    output        is_halted,     // Whehther to finish simulation
    output [31:0] print_reg[32]  // TO PRINT REGISTER VALUES IN TESTBENCH
                                 // (YOU SHOULD NOT USE THIS)
);
  /***** Wire declarations *****/
  //data wire
  wire [31:0] pc, pc_add_4, pc_add_imm, pc_jal, next_pc;
  wire [31:0] instruction;
  wire [31:0] imm, rs1_output, rs2_output, rs2_or_imm;
  wire [31:0] alu_result, mem_output;
  wire [31:0] write_back_data, write_data;

  //signal wire
  wire is_jal, is_jalr, branch;
  wire mem_read, mem_to_reg, mem_write;
  wire alu_src, write_enable, pc_to_reg, is_ecall;

  wire alu_bcond, signal_pc_4_imm;

  //pc+4와 pc+imm의 slect signal, JAL과 BRANCH에서 발생
  assign signal_pc_4_imm = is_jal | (branch & alu_bcond);

  // two adders
  assign pc_add_4 = pc + 4;
  assign pc_add_imm = pc + imm;

  // five mux
  mux32 mux_pc_4_imm (
      .select(signal_pc_4_imm),
      .w0(pc_add_4),
      .w1(pc_add_imm),
      .dout(pc_jal)
  );
  mux32 mux_jal_alu (
      .select(is_jalr),
      .w0(pc_jal),
      .w1(alu_result),
      .dout(next_pc)
  );

  mux32 mux_rs2_imm (
      .select(alu_src),
      .w0(rs2_output),
      .w1(imm),
      .dout(rs2_or_imm)
  );

  mux32 mux_alu_mem (
      .select(mem_to_reg),
      .w0(alu_result),
      .w1(mem_output),
      .dout(write_back_data)
  );

  mux32 mux_write_back (
      .select(pc_to_reg),
      .w0(write_back_data),
      .w1(pc_add_4),
      .dout(write_data)
  );

  /***** Register declarations *****/

  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  pc pc (
      .reset     (),  // input (Use reset to initialize PC. Initial value must be 0)
      .clk       (),  // input
      .next_pc   (),  // input
      .current_pc()   // output
  );

  // ---------- Instruction Memory ----------
  instruction_memory imem (
      .reset(),  // input
      .clk  (),  // input
      .addr (),  // input
      .dout ()   // output
  );

  // ---------- Register File ----------
  register_file reg_file (
      .reset       (),          // input
      .clk         (),          // input
      .rs1         (),          // input
      .rs2         (),          // input
      .rd          (),          // input
      .rd_din      (),          // input
      .write_enable(),          // input
      .rs1_dout    (),          // output
      .rs2_dout    (),          // output
      .print_reg   (print_reg)  //DO NOT TOUCH THIS
  );


  // ---------- Control Unit ----------
  control_unit ctrl_unit (
      .part_of_inst(),  // input
      .is_jal      (),  // output
      .is_jalr     (),  // output
      .branch      (),  // output
      .mem_read    (),  // output
      .mem_to_reg  (),  // output
      .mem_write   (),  // output
      .alu_src     (),  // output
      .write_enable(),  // output
      .pc_to_reg   (),  // output
      .is_ecall    ()   // output (ecall inst)
  );

  // ---------- Immediate Generator ----------
  immediate_generator imm_gen (
      .part_of_inst(),  // input
      .imm_gen_out ()   // output
  );

  // ---------- ALU Control Unit ----------
  alu_control_unit alu_ctrl_unit (
      .part_of_inst(),  // input
      .alu_op      ()   // output
  );

  // ---------- ALU ----------
  alu alu (
      .alu_op    (),  // input
      .alu_in_1  (),  // input
      .alu_in_2  (),  // input
      .alu_result(),  // output
      .alu_bcond ()   // output
  );

  // ---------- Data Memory ----------
  data_memory dmem (
      .reset    (),  // input
      .clk      (),  // input
      .addr     (),  // input
      .din      (),  // input
      .mem_read (),  // input
      .mem_write(),  // input
      .dout     ()   // output
  );
endmodule
