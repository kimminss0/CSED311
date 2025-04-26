module ForwardingUnit (
    input      [31:0] ID_EX_inst,
    input      [ 4:0] EX_MEM_rd,
    input      [ 4:0] MEM_WB_rd,
    input             EX_MEM_reg_write,
    input             MEM_WB_reg_write,
    output reg [ 1:0] forward_A,
    output reg [ 1:0] forward_B,
    output reg        forward_ecall
);
  wire [4:0] ID_EX_rs1 = ID_EX_inst[19:15];
  wire [4:0] ID_EX_rs2 = ID_EX_inst[24:20];

  always @(*) begin
    if (EX_MEM_reg_write && ID_EX_rs1 != 0 && EX_MEM_rd == ID_EX_rs1) begin
      forward_A = 2'b10;
    end else if (MEM_WB_reg_write && ID_EX_rs1 != 0 && MEM_WB_rd == ID_EX_rs1) begin
      forward_A = 2'b01;
    end else begin
      forward_A = 2'b00;
    end

    if (EX_MEM_reg_write && ID_EX_rs2 != 0 && EX_MEM_rd == ID_EX_rs2) begin
      forward_B = 2'b10;
    end else if (MEM_WB_reg_write && ID_EX_rs2 != 0 && MEM_WB_rd == ID_EX_rs2) begin
      forward_B = 2'b01;
    end else begin
      forward_B = 2'b00;
    end

    if (EX_MEM_reg_write && EX_MEM_rd == 17) begin
      forward_ecall = 1;
    end else begin
      forward_ecall = 0;
    end
  end

endmodule
