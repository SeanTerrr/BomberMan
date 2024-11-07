`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2024 15:39:17
// Design Name: 
// Module Name: uart_tx_new
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


module uart_tx_new(
    input clk,           // System clock
    input reset,        // Reset signal
    input [31:0] data,   // Data to be transmitted
    input start,         // Start signal to begin transmission
    output reg tx,       // UART transmission line
    output reg tx_busy   // Busy status indicator
);
    parameter CLKS_PER_BIT = 1302; // For 19200 baud rate, assuming 100 MHz clock

    reg [4:0] bit_idx;      // Index for transmitted bits
    reg [13:0] clk_cnt;     // Clock counter for baud rate
    reg [32:0] shift_reg;   // Shift register for UART transmission (1 start + 32 data + 1 stop)

    // State machine states
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;
    
    reg [1:0] state = IDLE; // State register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1; // Idle state for UART is high
            tx_busy <= 1'b0;
            clk_cnt <= 0;
            bit_idx <= 0;
            shift_reg <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    if (start && !tx_busy) begin
                        shift_reg <= {1'b1, data}; // Load stop bit, data, and start bit
                        state <= START;
                        tx_busy <= 1'b1;
                        bit_idx <= 0;
                    end
                end
                START: begin
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        tx <= 1'b0; // Start bit
                        state <= DATA;
                    end
                end
                DATA: begin
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        tx <= shift_reg[bit_idx]; // Transmit data bits
                        bit_idx <= bit_idx + 1;
                        if (bit_idx == 31) begin
                            state <= STOP;
                        end
                    end
                end
                STOP: begin
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        tx <= 1'b1; // Stop bit
                        state <= IDLE;
                        tx_busy <= 1'b0; // Transmission complete
                    end
                end
            endcase
        end
    end
endmodule