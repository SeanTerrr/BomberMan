`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2024 15:39:17
// Design Name: 
// Module Name: uart_rx_new
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx_new(
    input clk,          // System clock
    input reset,        // Reset signal
    input rx,          // UART receive line
    output reg [31:0] data, // Received 32-bit data
    output reg valid    // Data validity flag
);
    parameter CLKS_PER_BIT = 1302; // For 9600 baud rate, assuming 100 MHz clock

    reg [13:0] clk_cnt;   // Clock counter for baud rate
    reg [4:0] bit_idx;    // Index for received bits
    reg [31:0] shift_reg; // Shift register for UART reception

    // State machine states
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;
    
    reg [1:0] state = IDLE; // State register
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid <= 1'b0;
            clk_cnt <= 0;
            bit_idx <= 0;
            state <= IDLE;
            shift_reg <= 31'b0;
            data <= 31'b0;
        end else begin
            case (state)
                IDLE: begin
                    valid <= 1'b0;
                    if (rx == 1'b0) begin // Start bit detected
                        state <= START;
                        clk_cnt <= 0;
                    end
                end
                START: begin
                    if (clk_cnt < (CLKS_PER_BIT / 2) - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        state <= DATA;
                        bit_idx <= 0; // Reset bit index for data reception
                    end
                end
                DATA: begin
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        shift_reg[bit_idx] <= rx; // Capture data bit
                        bit_idx <= bit_idx + 1;
                        if (bit_idx == 31) begin // After capturing 32 data bits
                            state <= STOP;
                        end
                    end
                end
                STOP: begin
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        if (rx == 1'b1) begin // Stop bit validation
                            data <= shift_reg; // Extract 32-bit data
                            valid <= 1'b1;     // Mark data as valid
                        end
                        state <= IDLE; // Return to idle state
                    end
                end
            endcase
        end
    end
endmodule
