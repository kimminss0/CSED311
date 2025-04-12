// Submit this file with other files you created.
// Do not touch port declarations of the module 'CPU'.

// Guidelines
// 1. It is highly recommened to `define opcodes and something useful.
// 2. You can modify the module.
// (e.g., port declarations, remove modules, define new modules, ...)
// 3. You might need to describe combinational logics to drive them into the module (e.g., mux, and, or, ...)
// 4. `include files if required
`include "alu_def.v"

module cpu (
    input         reset,           // positive reset signal
    input         clk,             // clock signal
    output        is_halted,
    output [31:0] print_reg[32]
);  // Whehther to finish simulation
  /***** Wire declarations *****/
  wire [31:0] current_pc, next_pc, mem_address;
  wire [31:0] mem_dout, rs1_dout, rs2_dout, imm, alu_in_1, alu_in_2, rd_din, alu_result;
  wire [3:0] alu_op;

  wire alu_bcond;
  reg bcond;

  /* signal wire */
  wire write_IR, write_MDR, write_AB, write_ALUOut;
  wire write_pc, i_or_d, mem_read, mem_write, mem_to_reg, write_reg, alu_scr_A, pc_source, write_bcond;
  wire [1:0] alu_scr_B;
  wire control_add;

  wire [4:0] rf_rs1;

  // ECALL related
  wire is_ecall;

  /***** Register declarations *****/
  reg [31:0] IR;  // instruction register
  reg [31:0] MDR;  // memory data register
  reg [31:0] A;  // Read 1 data register
  reg [31:0] B;  // Read 2 data register
  reg [31:0] ALUOut;  // ALU output register
  // Do not modify and use registers declared above.

  assign is_halted = is_ecall && bcond;
  assign rf_rs1 = is_ecall ? 17 : IR[19:15];


  initial begin
    IR = 0;
    MDR = 0;
    A = 0;
    B = 0;
    ALUOut = 0;
    bcond = 0;
  end

  // Update registers
  always @(posedge clk) begin
    if (reset) begin
      IR <= 0;
      MDR <= 0;
      A <= 0;
      B <= 0;
      ALUOut <= 0;
      bcond <= 0;
    end else begin
      if (write_IR) IR <= mem_dout;
      if (write_MDR) MDR <= mem_dout;
      if (write_AB) begin
        A <= rs1_dout;
        B <= rs2_dout;
      end
      if (write_ALUOut) ALUOut <= alu_result;
      if (write_bcond) bcond <= alu_bcond;
    end
  end

  mux32 mem_address_mux (
      .select(i_or_d),
      .w0(current_pc),
      .w1(ALUOut),
      .dout(mem_address)
  );

  mux32 register_write_data_mux (
      .select(mem_to_reg),
      .w0(ALUOut),
      .w1(MDR),
      .dout(rd_din)
  );

  mux32 AluScrA_mux (
      .select(alu_scr_A),
      .w0(current_pc),
      .w1(A),
      .dout(alu_in_1)
  );

  mux32_2 AluScrB_mux (
      .select(alu_scr_B),
      .w0(B),
      .w1(imm),
      .w2(4),
      .dout(alu_in_2)
  );

  mux32 next_pc_mux (
      .select(pc_source),
      .w0(alu_result),
      .w1(ALUOut),
      .dout(next_pc)
  );

  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  pc pc (
      .reset     (reset),      // input (Use reset to initialize PC. Initial value must be 0)
      .clk       (clk),        // input
      .write     (write_pc),   // input
      .next_pc   (next_pc),    // input
      .current_pc(current_pc)  // output
  );

  // ---------- Register File ----------
  RegisterFile reg_file (
      .reset       (reset),      // input
      .clk         (clk),        // input
      .rs1         (rf_rs1),     // input
      .rs2         (IR[24:20]),  // input
      .rd          (IR[11:7]),   // input
      .rd_din      (rd_din),     // input
      .write_enable(write_reg),  // input
      .rs1_dout    (rs1_dout),   // output
      .rs2_dout    (rs2_dout),   // output
      .print_reg   (print_reg)   // output (TO PRINT REGISTER VALUES IN TESTBENCH)
  );

  // ---------- Memory ----------
  Memory memory (
      .reset    (reset),        // input
      .clk      (clk),          // input
      .addr     (mem_address),  // input
      .din      (B),            // input
      .mem_read (mem_read),     // input
      .mem_write(mem_write),    // input
      .dout     (mem_dout)      // output
  );

  // ---------- Microcode Unit ----------
  microcode_unit microcode_unit (
      .reset       (reset),         // input
      .clk         (clk),           // input
      .opcode      (IR[6:0]),       // input
      .bcond       (bcond),         // input
      .write_pc    (write_pc),
      .i_or_d      (i_or_d),
      .mem_read    (mem_read),
      .mem_write   (mem_write),
      .write_IR    (write_IR),
      .write_MDR   (write_MDR),
      .mem_to_reg  (mem_to_reg),
      .write_reg   (write_reg),
      .write_AB    (write_AB),
      .alu_scr_A   (alu_scr_A),
      .alu_scr_imm (alu_scr_B[0]),
      .alu_scr_4   (alu_scr_B[1]),
      .write_ALUOut(write_ALUOut),
      .pc_source   (pc_source),
      .write_bcond (write_bcond),
      .control_add (control_add),
      .is_ecall    (is_ecall)       // output (ecall inst)
  );

  // ---------- Immediate Generator ----------
  imm_gen imm_gen (
      .part_of_inst(IR),  // input
      .imm_gen_out (imm)  // output
  );

  // ---------- ALU Control Unit ----------
  alu_control_unit alu_control_unit (
      .part_of_inst({IR[30], IR[14:12], IR[6:0]}),  // input
      .alu_op      (alu_op)                         // output
  );

  // ---------- ALU ----------
  alu alu (
      .alu_op    (control_add ? `ADD : alu_op),  // input
      .alu_in_1  (alu_in_1),                     // input
      .alu_in_2  (alu_in_2),                     // input
      .alu_result(alu_result),                   // output
      .alu_bcond (alu_bcond)                     // output
  );

endmodule
