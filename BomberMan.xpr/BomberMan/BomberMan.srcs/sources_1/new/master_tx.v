`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2024 15:37:33
// Design Name: 
// Module Name: master_tx
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


module master_tx(
    input clk,
    input reset,
    input btnU, btnD, btnL, btnR, btnC, initiate_reset,     
    input [3:0] led,
    output tx
);
    reg start;
    reg [51:0] tx_data;
    reg [1:0] state;
    wire tx_busy; // Signal to track UART transmission status

    // State machine states
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter WAIT = 2'b10;

    // Instantiate the uart_tx module
    uart_tx_new uart_tx_inst(
        .clk(clk),
        .reset(reset),
        .data(tx_data),
        .start(start),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // State machine for sending coordinates
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            start <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Encode the coordinates into a 32-bit data word
                    tx_data <= {btnU,btnD,btnL,btnR,btnC,
                                led,initiate_reset,22'b0};                                                                        
                    start <= 1;
                    state <= START;
                end
                START: begin
                    // Wait for UART to acknowledge the start signal
                    if (tx_busy) begin
                        start <= 0; // Deassert start when transmission starts
                        state <= WAIT;
                    end
                end
                WAIT: begin
                    // Wait for transmission to complete
                    if (!tx_busy) // Transmission done
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule
