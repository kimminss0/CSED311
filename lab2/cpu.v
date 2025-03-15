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
  wire [31:0] current_pc, pc_add_4, pc_add_imm, pc_jal, next_pc;
  wire [31:0] instruction;
  wire [31:0] imm, rs1_output, rs2_output, rs2_or_imm;
  wire [31:0] alu_result, mem_output;
  wire [31:0] write_back_data, write_data;
  wire [3:0] alu_op;

  //signal wire
  wire is_jal, is_jalr, branch;
  wire mem_read, mem_to_reg, mem_write;
  wire alu_src, write_enable, pc_to_reg, is_ecall;

  wire alu_bcond, signal_pc_4_imm;

  //pc+4와 pc+imm의 slect signal, JAL과 BRANCH에서 발생
  assign signal_pc_4_imm = is_jal | (branch & alu_bcond);

  // TODO: Implement
  assign is_halted = is_ecall ? 0 : 0;

  // two adders
  assign pc_add_4 = current_pc + 4;
  assign pc_add_imm = current_pc + imm;

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
  pc pc_ (
      .reset     (reset),      // input (Use reset to initialize PC. Initial value must be 0)
      .clk       (clk),        // input
      .next_pc   (next_pc),    // input
      .current_pc(current_pc)  // output
  );

  // ---------- Instruction Memory ----------
  instruction_memory imem (
      .reset(reset),       // input
      .clk  (clk),         // input
      .addr (current_pc),  // input
      .dout (instruction)  // output
  );

  // ---------- Register File ----------
  register_file reg_file (
      .reset       (reset),               // input
      .clk         (clk),                 // input
      .rs1         (instruction[19:15]),  // input
      .rs2         (instruction[24:20]),  // input
      .rd          (instruction[11:7]),   // input
      .rd_din      (write_data),          // input
      .write_enable(write_enable),        // input
      .rs1_dout    (rs1_output),          // output
      .rs2_dout    (rs2_output),          // output
      .print_reg   (print_reg)            //DO NOT TOUCH THIS
  );


  // ---------- Control Unit ----------
  control_unit ctrl_unit (
      .part_of_inst(instruction[6:0]),  // input
      .is_jal      (is_jal),            // output
      .is_jalr     (is_jalr),           // output
      .branch      (branch),            // output
      .mem_read    (mem_read),          // output
      .mem_to_reg  (mem_to_reg),        // output
      .mem_write   (mem_write),         // output
      .alu_src     (alu_src),           // output
      .write_enable(write_enable),      // output
      .pc_to_reg   (pc_to_reg),         // output
      .is_ecall    (is_ecall)           // output (ecall inst)
  );

  // ---------- Immediate Generator ----------
  immediate_generator imm_gen (
      .part_of_inst(instruction),  // input
      .imm_gen_out (imm)           // output
  );

  // ---------- ALU Control Unit ----------
  alu_control_unit alu_ctrl_unit (
      .part_of_inst({instruction[30], instruction[14:12], instruction[6:0]}),  // input
      .alu_op      (alu_op)                                                    // output
  );

  // ---------- ALU ----------
  alu alu_ (
      .alu_op    (alu_op),      // input
      .alu_in_1  (rs1_output),  // input
      .alu_in_2  (rs2_or_imm),  // input
      .alu_result(alu_result),  // output
      .alu_bcond (alu_bcond)    // output
  );

  // ---------- Data Memory ----------
  data_memory dmem (
      .reset    (reset),       // input
      .clk      (clk),         // input
      .addr     (alu_result),  // input
      .din      (rs2_output),  // input
      .mem_read (mem_read),    // input
      .mem_write(mem_write),   // input
      .dout     (mem_output)   // output
  );
endmodule
