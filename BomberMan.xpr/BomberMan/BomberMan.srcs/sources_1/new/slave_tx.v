`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2024 15:39:17
// Design Name: 
// Module Name: slave_tx
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


module slave_tx(
    input clk,
    input reset,
    input btnU, btnD, btnL, btnR, DebouncedBtnC, SW,
    output wire tx,  // Changed to wire
    output reg start
);
    reg [31:0] tx_data = 0;
    wire uart_tx_out;  // Internal wire for UART module output
    wire tx_busy;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            start <= 0;
            tx_data <= 32'b0; // Clear tx_data during reset
        end else if (tx_busy == 1'b0) begin
            // Encode button presses into movement commands
            if (btnU) begin
                tx_data <= {SW,31'h01}; // Up command
                start <= 1;
            end else if (btnD) begin
                tx_data <= {SW,31'h02}; // Down command
                start <= 1;
            end else if (btnL) begin
                tx_data <= {SW,31'h03}; // Left command
                start <= 1;
            end else if (btnR) begin
                tx_data <= {SW,31'h04}; // Right command
                start <= 1;
            end else if (DebouncedBtnC) begin
                tx_data <= {SW,31'h05};
                start <= 1;
            end else begin
                tx_data <= {SW,31'h06};
                start <= 1;
            end
        end
    end

    // UART transmission module instance
    uart_tx_new uart_tx_inst_slave(
        .clk(clk),
        .reset(reset),
        .data(tx_data),
        .start(start),
        .tx(uart_tx_out), // Connect to internal wire
        .tx_busy(tx_busy)
    );

    // Assign the internal UART output wire to the module output
    assign tx = uart_tx_out;

endmodule