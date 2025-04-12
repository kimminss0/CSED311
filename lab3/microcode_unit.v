`include "microcode_def.v"
`include "opcodes.v"

module microcode_unit (
    input reset,
    input clk,
    input [6:0] opcode,
    input bcond,
    output write_pc,
    output i_or_d,
    output mem_read,
    output mem_write,
    output write_IR,
    output write_MDR,
    output mem_to_reg,
    output write_reg,
    output write_AB,
    output alu_scr_A,
    output alu_scr_imm,
    output alu_scr_4,
    output write_ALUOut,
    output pc_source,
    output write_bcond,
    output control_add,
    output is_ecall
);

  wire mem_if_read, mem_excute;
  reg [2:0] current_upc;
  reg [2:0] next_upc;

  reg [9:0] microcode[8];

  assign mem_to_reg = opcode == `LOAD;
  assign pc_source = bcond && (opcode == `BRANCH);

  /* verilog_format: off */
  assign i_or_d       = microcode[current_upc][9];
  assign write_pc     = microcode[current_upc][8];
  assign write_IR     = microcode[current_upc][7];
  assign write_AB     = microcode[current_upc][6];
  assign write_ALUOut = microcode[current_upc][5];
  assign write_reg    = microcode[current_upc][4];
  assign write_bcond  = microcode[current_upc][3];
  assign write_MDR    = microcode[current_upc][2];
  assign mem_if_read  = microcode[current_upc][1];
  assign mem_excute   = microcode[current_upc][0];
  assign is_ecall     = opcode == `ECALL;
  /* verilog_format: on */

  assign mem_read = mem_if_read ? 1 : ( mem_excute && opcode == `LOAD);
  assign mem_write = ( mem_excute && opcode == `STORE);
  assign alu_scr_A = ( write_ALUOut && !(opcode == `BRANCH || opcode == `JAL  || opcode == `JALR) ) || (write_pc && opcode == `JALR) || write_bcond;
  assign alu_scr_imm = !( (write_ALUOut && opcode == `ARITHMETIC) || write_bcond );
  assign alu_scr_4 = write_pc ^ (opcode == `JAL || opcode == `JALR);

  assign control_add = (write_ALUOut && (opcode == `BRANCH)) || write_pc;

  initial begin
    current_upc  = 1;

    /* 9    | 8         | 7         | 6         | 5             | 4           | 3             | 2           | 1             | 0           |*/
    /* i|d  | write_pc  | write_IR  | write_AB  | writeALUOut   | write_reg   | write_bcond   | write_MDR   | mem_if_read   | mem_excute  */
    microcode[0] = 10'b0100000000;  // IF1
    microcode[1] = 10'b0010000010;  // IF2
    microcode[2] = 10'b0001000000;  // ID
    microcode[3] = 10'b0000100000;  // EX1
    microcode[4] = 10'b0000001000;  // EX2
    microcode[5] = 10'b1000000101;  // MEM1
    microcode[6] = 10'b0000000000;  // MEM2
    microcode[7] = 10'b0000010000;  // WB
  end

  always @(*) begin
    case (current_upc)
      `IF2: begin
        if (opcode == `JAL)
          //next_upc = `EX1; 처리 필요
          next_upc = current_upc + 1;
        else next_upc = current_upc + 1;
      end
      `EX2: begin
        if (opcode == `BRANCH || opcode == `ECALL) next_upc = `IF1;
        else if(opcode == `ARITHMETIC_IMM ||opcode == `ARITHMETIC || opcode == `JALR ||opcode == `JAL)
          next_upc = `WB;
        else next_upc = current_upc + 1;
      end
      `MEM2: begin
        if (opcode == `STORE) next_upc = `IF1;
        else next_upc = current_upc + 1;
      end
      default: next_upc = current_upc + 1;
    endcase
  end

  always @(posedge clk) begin
    if (reset) current_upc <= 1;
    else current_upc <= next_upc;
  end

endmodule
