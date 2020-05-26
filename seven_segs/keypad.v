`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:47:54 05/20/2020
// Design Name:
// Module Name:    keypad
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module keypad(input            clk,
              input            rst,
              input      [3:0] row,                 // 矩阵键盘 行
              output reg [3:0] col,                 // 矩阵键盘 列
              output reg [3:0] key_val         // 键盘值
             );

clock_div clk_d(.Reset(rst),
                .Clock(clk),
                .DividedClock(div_clk));

//++++++++++++++++++++++++++++++++++++++
// 状态机部分 开始
//++++++++++++++++++++++++++++++++++++++
// 状态数较少，独热码编码
// parameter NO_KEY_PRESSED = 6'b000_001;  // 没有按键按下
// parameter SCAN_COL0      = 6'b000_010;  // 扫描第0列
// parameter SCAN_COL1      = 6'b000_100;  // 扫描第1列
// parameter SCAN_COL2      = 6'b001_000;  // 扫描第2列
// parameter SCAN_COL3      = 6'b010_000;  // 扫描第3列
// parameter KEY_PRESSED    = 6'b100_000;  // 有按键按下

// reg [5:0] current_state, next_state;    // 现态、次态

parameter NO_KEY_PRESSED = 3'b000;  // 没有按键按下
parameter SCAN_COL0      = 3'b001;  // 扫描第0列
parameter SCAN_COL1      = 3'b010;  // 扫描第1列
parameter SCAN_COL2      = 3'b011;  // 扫描第2列
parameter SCAN_COL3      = 3'b100;  // 扫描第3列
parameter KEY_PRESSED    = 3'b101;  // 有按键按下

reg [2:0] current_state, next_state;    // 现态、次态

always @ (posedge div_clk, posedge rst)
    if (rst)
        current_state <= NO_KEY_PRESSED;
    else
        current_state <= next_state;

// 根据条件转移状态
always @ (*) begin
    case (current_state)
        NO_KEY_PRESSED :                    // 没有按键按下
            if (row != 4'hF)
                next_state = SCAN_COL0;
            else
                next_state = NO_KEY_PRESSED;
        SCAN_COL0 :                         // 扫描第0列
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = SCAN_COL1;
        SCAN_COL1 :                         // 扫描第1列
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = SCAN_COL2;
        SCAN_COL2 :                         // 扫描第2列
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = SCAN_COL3;
        SCAN_COL3 :                         // 扫描第3列
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = NO_KEY_PRESSED;
        KEY_PRESSED :                       // 有按键按下
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = NO_KEY_PRESSED;
        default:
            next_state = NO_KEY_PRESSED;
    endcase
end


reg       key_pressed_flag;             // 键盘按下标志
reg [3:0] col_val, row_val;             // 列值、行值

// 根据次态，给相应寄存器赋值
always @ (posedge div_clk, posedge rst)
    if (rst) begin
        col              <= 4'h0;
        key_pressed_flag <=    0;
    end
    else
    case (next_state)
        NO_KEY_PRESSED :                  // 没有按键按下
        begin
            col              <= 4'h0;
            key_pressed_flag <=    0;       // 清键盘按下标志
        end
        SCAN_COL0 :                       // 扫描第0列
            col <= 4'b1110;
        SCAN_COL1 :                       // 扫描第1列
            col <= 4'b1101;
        SCAN_COL2 :                       // 扫描第2列
            col <= 4'b1011;
        SCAN_COL3 :                       // 扫描第3列
            col <= 4'b0111;
        KEY_PRESSED :                     // 有按键按下
        begin
            col_val          <= col;        // 锁存列值
            row_val          <= row;        // 锁存行值
            key_pressed_flag <= 1;          // 置键盘按下标志
        end
    endcase
//--------------------------------------
// 状态机部分 结束
//--------------------------------------


//++++++++++++++++++++++++++++++++++++++
// 扫描行列值部分 开始
//++++++++++++++++++++++++++++++++++++++
always @ (posedge div_clk, posedge rst)
    if (rst)
        key_val <= 4'h0;
    else
        if (key_pressed_flag)
        case ({col_val, row_val})
            8'b1110_1110 :
                key_val <= 4'h1;
            8'b1110_1101 :
                key_val <= 4'h4;
            8'b1110_1011 :
                key_val <= 4'h7;
            8'b1110_0111 :
                key_val <= 4'h0;

            8'b1101_1110 :
                key_val <= 4'h2;
            8'b1101_1101 :
                key_val <= 4'h5;
            8'b1101_1011 :
                key_val <= 4'h8;
            8'b1101_0111 :
                key_val <= 4'hf;

            8'b1011_1110 :
                key_val <= 4'h3;
            8'b1011_1101 :
                key_val <= 4'h6;
            8'b1011_1011 :
                key_val <= 4'h9;
            8'b1011_0111 :
                key_val <= 4'he;

            8'b0111_1110 :
                key_val <= 4'ha;
            8'b0111_1101 :
                key_val <= 4'hb;
            8'b0111_1011 :
                key_val <= 4'hc;
            8'b0111_0111 :
                key_val <= 4'hd;
        endcase
//--------------------------------------
//  扫描行列值部分 结束
//--------------------------------------

endmodule
