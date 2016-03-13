`include "control_config.v"
module decode(clk, rst, instr, PC, writeBackData, readdata1, readdata2, immediate, jump, jumpReg, branch, memRead, memWrite, memToReg, ALUOp, ALUSrc, err);

    input clk, rst;
    
    input [15:0] instr;
    input [15:0] PC, writeBackData;
    
    output [15:0] readdata1, readdata2;
    output reg [15:0] immediate;

    output jump, jumpReg, branch;
    output memRead, memWrite, memToReg;
    output [3:0] ALUOp;
    output ALUSrc;
    output err;

    wire [1:0] regDst;
    wire whichImm, toExt, regWrite;

    reg [2:0] writereg; // where to get the writeregsel
    wire writedata;

    reg writeRegMuxErr, immediateMuxErr;
    wire ctrlErr, regErr;

    assign writedata = (regDst == `REG_R7) ? PC : writeBackData;

    //determine writeReg
    always @(*) begin
        writeRegMuxErr = 1'b0;

        case(regDst)
        `REG_I_FORMAT: writereg = instr[7:5];
        `REG_R_FORMAT: writereg = instr[4:2];
        `REG_R7: writereg = 3'd7;
        default: begin
            writereg = 3'bx;
            writeRegMuxErr = 1'b1;
        end
        endcase
    end

    //determine immediate
    always @(*) begin
        immediateMuxErr = 1'b0;
    
        case(whichImm)
        `IMM_J: immediate = {{5{instr[10]}}, instr[10:0]};
        `IMM_I1: immediate = instr[4:0];
        `IMM_I2: immediate = {{8{instr[7]}},instr[7:0]};
        default: begin
            immediateMuxErr = 1'b1;
            immediate = 16'bx;
        end
        endcase
    end

    control ctrl(.instr(instr[15:11]), .regDst(regDst), .regWrite(regWrite), .whichImm(whichImm), .toExt(toExt), .jump(jump), .jumpReg(jumpReg), .branch(branch), .memRead(memRead), .memWrite(memWrite), .memToReg(memToReg), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .err(ctrlErr));

    rf_bypass (
           .read1data(readdata1), .read2data(readdata2), .err(regErr),
           .clk(clk), .rst(rst), .read1regsel(instr[10:8]), .read2regsel(instr[7:5]), .writeregsel(writereg), .writedata(writedata), .write(regWrite)
           );

endmodule
