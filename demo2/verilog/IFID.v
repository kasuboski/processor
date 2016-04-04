module IFID(clk, rst, PC, addr, PCout, addrOut);
    input clk, rst;
    input [15:0] PC, addr;

    output [15:0] PCout, addrOut;
    
    dff pc[15:0](.q(PCout), .d(PC), .clk(clk), .rst(rst));
    dff address[15:0](.q(addrOut), .d(addr), .clk(clk), .rst(rst));
endmodule