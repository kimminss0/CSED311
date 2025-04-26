// Submit this file with other files you created.
// Do not touch port declarations of the module 'CPU'.

// Guidelines
// 1. It is highly recommened to `define opcodes and something useful.
// 2. You can modify modules (except InstMemory, DataMemory, and RegisterFile)
// (e.g., port declarations, remove modules, define new modules, ...)
// 3. You might need to describe combinational logics to drive them into the module (e.g., mux, and, or, ...)
// 4. `include files if required

module cpu (
    input         reset,         // positive reset signal
    input         clk,           // clock signal
    output        is_halted,     // Whehther to finish simulation
    output [31:0] print_reg[32]  // Whehther to finish simulation
);
  /***** Wire declarations *****/
  wire is_stall;

  wire [31:0] current_pc, next_pc;
  wire [31:0] instruction;
  wire [31:0] imm, rs1_dout, rs2_dout, alu_rs2, rd_din;
  wire [31:0] alu_result, mem_dout;
  wire [31:0] write_back_data, write_data;
  wire [31:0] alu_rs1, alu_rs2_or_imm;
  wire [3:0] alu_op;
  wire [4:0] rf_rs1;

  wire [31:0] pc_imm, pc_4;

  wire mem_read, mem_to_reg, mem_write, alu_src, write_enable, pc_to_reg;
  wire is_ecall;
  wire bcond;

  wire [1:0] forward_A, forward_B;
  wire        forward_ecall;

  /***** Register declarations *****/
  // You need to modify the width of registers
  // In addition,
  // 1. You might need other pipeline registers that are not described below
  // 2. You might not need registers described below
  /***** IF/ID pipeline registers *****/
  reg  [31:0] IF_ID_inst;  // will be used in ID stage
  reg  [31:0] IF_ID_PC;
  /***** ID/EX pipeline registers *****/
  // From the control unit
  reg         ID_EX_alu_op;  // will be used in EX stage
  reg         ID_EX_alu_src;  // will be used in EX stage
  reg         ID_EX_mem_write;  // will be used in MEM stage
  reg         ID_EX_mem_read;  // will be used in MEM stage
  reg         ID_EX_mem_to_reg;  // will be used in WB stage
  reg         ID_EX_reg_write;  // will be used in WB stage
  // From others
  reg  [31:0] ID_EX_inst;  // will be used in EX stage
  reg  [31:0] ID_EX_rs1_data;
  reg  [31:0] ID_EX_rs2_data;
  reg  [31:0] ID_EX_imm;
  reg  [10:0] ID_EX_ALU_ctrl_unit_input;
  reg  [ 4:0] ID_EX_rd;
  reg  [31:0] ID_EX_PC;

  /***** EX/MEM pipeline registers *****/
  // From the control unit
  reg         EX_MEM_mem_write;  // will be used in MEM stage
  reg         EX_MEM_mem_read;  // will be used in MEM stage
  reg         EX_MEM_is_branch;  // will be used in MEM stage
  reg         EX_MEM_mem_to_reg;  // will be used in WB stage
  reg         EX_MEM_reg_write;  // will be used in WB stage
  // From others
  reg  [31:0] EX_MEM_alu_out;
  reg  [31:0] EX_MEM_dmem_data;
  reg  [ 4:0] EX_MEM_rd;
  reg  [31:0] EX_MEM_pc_imm;
  reg         EX_MEM_is_halted;
  reg         ID_EX_is_halted;

  /***** MEM/WB pipeline registers *****/
  // From the control unit
  reg         MEM_WB_mem_to_reg;  // will be used in WB stage
  reg         MEM_WB_reg_write;  // will be used in WB stage
  // From others
  reg         MEM_WB_mem_to_reg_src_1;
  reg         MEM_WB_mem_to_reg_src_2;
  reg  [31:0] MEM_WB_alu_out;
  reg  [ 4:0] MEM_WB_rd;  // write address(rd) on register
  reg  [31:0] MEM_WB_mem_dout;
  reg         MEM_WB_is_halted;


  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  PC pc (
      .reset     (reset),       // input (Use reset to initialize PC. Initial value must be 0)
      .clk       (clk),         // input
      .next_pc   (next_pc),     // input
      .current_pc(current_pc),  // output
      .is_stall  (is_stall)
  );

  // PC add 4
  assign pc_4 = current_pc + 4;

  // mux PC_4, PC_imm
  mux32 pc_mux (
      .select(0),  //controlflow가 없으므로 일단 pc+4로 고정해둠
      .w0(pc_4),
      .w1(EX_MEM_pc_imm),
      .dout(next_pc)
  );

  // ---------- Instruction Memory ----------
  InstMemory imem (
      .reset(reset),   // input
      .clk(clk),     // input
      .addr(current_pc),    // input
      .dout(instruction)     // output
  );

  // Update IF/ID pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      IF_ID_inst <= 0;
      IF_ID_PC   <= 0;
    end else if (!is_stall) begin
      IF_ID_inst <= instruction;
      IF_ID_PC   <= current_pc;
    end
    // On else, IF_ID_inst doesn't not change
  end

  // mux for is_ecall
  assign rf_rs1 = is_ecall ? 17 : IF_ID_inst[19:15];

  // ---------- Register File ----------
  RegisterFile reg_file (
      .reset       (reset),              // input
      .clk         (clk),                // input
      .rs1         (rf_rs1),             // input
      .rs2         (IF_ID_inst[24:20]),  // input
      .rd          (MEM_WB_rd),          // input
      .rd_din      (rd_din),             // input
      .write_enable(MEM_WB_reg_write),   // input
      .rs1_dout    (rs1_dout),           // output
      .rs2_dout    (rs2_dout),           // output
      .print_reg   (print_reg)
  );


  // ---------- Control Unit ----------
  ControlUnit ctrl_unit (
      .part_of_inst(IF_ID_inst[6:0]),  // input
      .is_stall    (is_stall),         // input
      .mem_read    (mem_read),         // output
      .mem_to_reg  (mem_to_reg),       // output
      .mem_write   (mem_write),        // output
      .alu_src     (alu_src),          // output
      .write_enable(write_enable),     // output
      .pc_to_reg   (pc_to_reg),        // output
      .is_ecall    (is_ecall)          // output (ecall inst)
  );

  // ---------- Immediate Generator ----------
  ImmediateGenerator imm_gen (
      .part_of_inst(IF_ID_inst),  // input
      .imm_gen_out(imm)  // output
  );

  // Update ID/EX pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      /* used in ex stage */
      ID_EX_inst <= 0;
      ID_EX_alu_src <= 0;
      ID_EX_rs1_data <= 0;
      ID_EX_rs2_data <= 0;
      ID_EX_imm <= 0;
      ID_EX_PC <= 0;
      ID_EX_ALU_ctrl_unit_input <= 0;
      ID_EX_mem_write <= 0;
      ID_EX_mem_read <= 0;
      ID_EX_rd <= 0;
      ID_EX_reg_write <= 0;
      ID_EX_mem_to_reg <= 0;
      ID_EX_is_halted <= 0;

    end else begin
      /* used in ex stage */
      ID_EX_inst <= IF_ID_inst;
      ID_EX_alu_src <= alu_src;
      ID_EX_rs1_data <= rs1_dout;
      ID_EX_rs2_data <= rs2_dout;
      ID_EX_imm <= imm;
      ID_EX_PC <= IF_ID_PC;
      ID_EX_ALU_ctrl_unit_input <= {IF_ID_inst[30], IF_ID_inst[14:12], IF_ID_inst[6:0]};

      /* used in mem stage */
      ID_EX_mem_write <= mem_write;
      ID_EX_mem_read <= mem_read;

      /* used in wb stage */
      ID_EX_rd <= IF_ID_inst[11:7];
      ID_EX_reg_write <= write_enable;
      ID_EX_mem_to_reg <= mem_to_reg;
      ID_EX_is_halted <= is_ecall && ((forward_ecall ? EX_MEM_alu_out : rs1_dout) == 10);
    end
  end

  // ---------- add PC + imm
  assign pc_imm = ID_EX_PC + ID_EX_imm;

  // ---------- ALU Control Unit ----------
  ALUControlUnit alu_ctrl_unit (
      .part_of_inst(ID_EX_ALU_ctrl_unit_input),  // input
      .alu_op      (alu_op)                      // output
  );

  // ---------- ALU rs2 mux
  mux32 alu_rs2_mux (
      .select(ID_EX_alu_src),
      .w0(alu_rs2),
      .w1(ID_EX_imm),
      .dout(alu_rs2_or_imm)
  );

  mux32_2 alu_rs1_forward_mux (
      .select(forward_A),
      .w0(ID_EX_rs1_data),
      .w1(rd_din),
      .w2(EX_MEM_alu_out),
      .dout(alu_rs1)
  );

  mux32_2 alu_rs2_forward_mux (
      .select(forward_B),
      .w0(ID_EX_rs2_data),
      .w1(rd_din),
      .w2(EX_MEM_alu_out),
      .dout(alu_rs2)
  );

  // ---------- ALU ----------
  ALU alu (
      .alu_op    (alu_op),          // input
      .alu_in_1  (alu_rs1),         // input
      .alu_in_2  (alu_rs2_or_imm),  // input
      .alu_result(alu_result),      // output
      .alu_bcond (bcond)            // output
  );

  // ---------- Hazard Detection ----------
  HazardDetection hazard_detection (
      .IF_ID_inst      (IF_ID_inst),        // input
      .ID_EX_rd        (ID_EX_rd),          // input
      .EX_MEM_rd       (EX_MEM_rd),         // input
      .ID_EX_mem_read  (ID_EX_mem_read),    // input
      .ID_EX_reg_write (ID_EX_reg_write),   // input
      .EX_MEM_reg_write(EX_MEM_reg_write),  // input
      .stall           (is_stall)           // output
  );

  // ---------- Forwarding Unit ----------
  ForwardingUnit forwarding_unit (
      .ID_EX_inst      (ID_EX_inst),        // input
      .EX_MEM_rd       (EX_MEM_rd),         // input
      .MEM_WB_rd       (MEM_WB_rd),         // input
      .EX_MEM_reg_write(EX_MEM_reg_write),  // input
      .MEM_WB_reg_write(MEM_WB_reg_write),  // input
      .forward_A       (forward_A),         // output
      .forward_B       (forward_B),         // output
      .forward_ecall   (forward_ecall)      // output
  );

  // Update EX/MEM pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      EX_MEM_alu_out <= 0;
      EX_MEM_dmem_data <= 0;
      EX_MEM_mem_read <= 0;
      EX_MEM_mem_write <= 0;
      EX_MEM_rd <= 0;
      EX_MEM_reg_write <= 0;
      EX_MEM_pc_imm <= 0;
      EX_MEM_is_halted <= 0;
    end else begin
      /* used in mem stage */
      EX_MEM_alu_out <= alu_result;
      EX_MEM_dmem_data <= alu_rs2;

      EX_MEM_mem_read <= ID_EX_mem_read;
      EX_MEM_mem_write <= ID_EX_mem_write;

      EX_MEM_pc_imm <= pc_imm;  // jal, branch

      /* used in wb stage */
      // EX_MEM_alu_out is also used
      EX_MEM_rd <= ID_EX_rd;
      EX_MEM_reg_write <= ID_EX_reg_write;
      EX_MEM_mem_to_reg <= ID_EX_mem_to_reg;
      EX_MEM_is_halted <= ID_EX_is_halted;
    end
  end

  // ---------- Data Memory ----------
  DataMemory dmem (
      .reset    (reset),             // input
      .clk      (clk),               // input
      .addr     (EX_MEM_alu_out),    // input
      .din      (EX_MEM_dmem_data),  // input
      .mem_read (EX_MEM_mem_read),   // input
      .mem_write(EX_MEM_mem_write),  // input
      .dout     (mem_dout)           // output
  );

  // Update MEM/WB pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      MEM_WB_rd <= 0;
      MEM_WB_alu_out <= 0;
      MEM_WB_reg_write <= 0;
      MEM_WB_mem_dout <= 0;
      MEM_WB_is_halted <= 0;
    end else begin
      MEM_WB_rd <= EX_MEM_rd;
      MEM_WB_alu_out <= EX_MEM_alu_out;
      MEM_WB_reg_write <= EX_MEM_reg_write;
      MEM_WB_mem_to_reg <= EX_MEM_mem_to_reg;
      MEM_WB_mem_dout <= mem_dout;

      MEM_WB_is_halted <= EX_MEM_is_halted;
    end
  end

  // -------- is_halted
  assign is_halted = MEM_WB_is_halted;

  // -------- rd_din in regitser
  mux32 rd_din_mux (
      .select(MEM_WB_mem_to_reg),
      .w0(MEM_WB_alu_out),
      .w1(MEM_WB_mem_dout),
      .dout(rd_din)
  );

endmodule
