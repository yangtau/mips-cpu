`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:51:38 04/28/2020
// Design Name:   control
// Module Name:   C:/Users/qyang/Code/mips/cpu/tb_control.v
// Project Name:  cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_control;

    // Inputs
    reg [5:0] opcode;

    // Outputs
    wire branch_eq;
    wire branch_ne;
    wire [1:0] aluop;
    wire memread;
    wire memwrite;
    wire memtoreg;
    wire regdst;
    wire regwrite;
    wire alusrc;
    wire jump;

    // Instantiate the Unit Under Test (UUT)
    control uut (
        .opcode(opcode), 
        .branch_eq(branch_eq), 
        .branch_ne(branch_ne), 
        .aluop(aluop), 
        .memread(memread), 
        .memwrite(memwrite), 
        .memtoreg(memtoreg), 
        .regdst(regdst), 
        .regwrite(regwrite), 
        .alusrc(alusrc), 
        .jump(jump)
    );

    initial begin
        // Initialize Inputs
        opcode = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here

    end
      
endmodule

