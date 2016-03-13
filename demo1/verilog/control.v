module control(instr, regDst, regWrite, whichImm, toExt, jump, jumpReg, branch, memRead, memWrite, memToReg, ALUOp, ALUSrc, err);
    input [15:11] instr;

    output [1:0] regDst;
    output regWrite;
    output whichImm, toExt;
    output jump, jumpReg, branch;
    output memRead, memWrite, memToReg;
    output [3:0] ALUOp;
    output ALUSrc;

    output err;

endmodule
