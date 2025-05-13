`include "opcodes.v"

// Gshare Branch Predictor

module BranchPrediction #(
    parameter integer BTB_DEPTH = 32,
    parameter integer TAG_WIDTH = 30 - $clog2(BTB_DEPTH),
    parameter integer BTB_IDX_WIDTH = $clog2(BTB_DEPTH)
) (
    input  [              6:0] opcode,
    input  [              6:0] ID_EX_opcode,
    input  [             31:0] ID_EX_pc,
    input  [BTB_IDX_WIDTH-1:0] ID_EX_pht_idx,
    input  [             31:0] pc,
    input  [             31:0] pc_4,                     //pc+4
    input  [             31:0] predicted_branch_target,
    input  [             31:0] actual_branch_target,
    input                      actual_taken,
    input                      reset,                    // positive reset signal
    input                      clk,
    output [             31:0] pc_predicted,
    output [BTB_IDX_WIDTH-1:0] pht_idx
);
  integer i;

  wire use_btb = opcode == `JAL || opcode == `JALR || opcode == `BRANCH;
  wire ID_EX_use_btb = ID_EX_opcode == `JAL || ID_EX_opcode == `JALR || ID_EX_opcode == `BRANCH;

  reg [31:0] btb[BTB_DEPTH];
  reg [TAG_WIDTH-1:0] tag_table[BTB_DEPTH];
  reg [BTB_IDX_WIDTH-1:0] bhsr;
  reg [1:0] pht[BTB_DEPTH];

  wire [BTB_IDX_WIDTH+1:2] btb_idx;
  wire [BTB_IDX_WIDTH+1:2] ID_EX_btb_idx;
  wire [TAG_WIDTH-1:0] tag;
  wire [TAG_WIDTH-1:0] ID_EX_tag;
  wire [TAG_WIDTH-1:0] tag_table_entry;
  wire pht_taken;
  wire is_predict;
  wire is_predict_correct;

  assign {tag, btb_idx} = pc[31:2];
  assign {ID_EX_tag, ID_EX_btb_idx} = ID_EX_pc[31:2];
  assign pht_idx = bhsr ^ btb_idx;
  assign pht_taken = pht[pht_idx][1];
  assign is_predict = use_btb && pht_taken && tag == tag_table[btb_idx];
  assign pc_predicted = is_predict ? btb[btb_idx] : pc_4;
  assign is_predict_correct = actual_branch_target == predicted_branch_target;

  always @(posedge clk) begin
    if (reset) begin
      for (i = 0; i < BTB_DEPTH; i = i + 1) begin
        btb[i] <= 0;
        tag_table[i] <= 0;
        pht[i] <= 2'b11;
      end
      bhsr <= 0;
    end else begin
      if (ID_EX_use_btb) begin
        if (ID_EX_opcode == `BRANCH) begin
          bhsr <= {actual_taken, bhsr[BTB_IDX_WIDTH-1:1]};
        end
        if (actual_taken) begin
          if (!is_predict_correct) begin
            btb[ID_EX_btb_idx] <= actual_branch_target;
            tag_table[ID_EX_btb_idx] <= ID_EX_tag;
          end
          unique case (pht[ID_EX_pht_idx])
            2'b11: pht[ID_EX_pht_idx] <= 2'b11;
            2'b10: pht[ID_EX_pht_idx] <= 2'b11;
            2'b01: pht[ID_EX_pht_idx] <= 2'b10;
            2'b00: pht[ID_EX_pht_idx] <= 2'b01;
          endcase
        end else begin
          unique case (pht[ID_EX_pht_idx])
            2'b00: pht[ID_EX_pht_idx] <= 2'b00;
            2'b01: pht[ID_EX_pht_idx] <= 2'b00;
            2'b10: pht[ID_EX_pht_idx] <= 2'b01;
            2'b11: pht[ID_EX_pht_idx] <= 2'b10;
          endcase
        end
      end
    end
  end


endmodule
