`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 13:15:18
// Design Name: 
// Module Name: flickerBomb
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


module flickerBomb(
    input clock, start,
    input [31:0] bombCounter,
    output reg isRed, stop
//    ,output reg [31:0] count, state, buffer, bufferLimit
    );
    
    reg [31:0] count, state, buffer, bufferLimit;
    initial begin
        count = 0;
        state = 0;
        buffer = 0;
        bufferLimit = 32'd696111;
        stop = 0;
    end

    always @ (posedge clock) begin
        if (start) begin
            stop <= 0;
            count <= count + 1;
            buffer <= buffer + 1;
            if (buffer >= bufferLimit) begin
                state <= state + 1;
                buffer <= 0;
            end
            if (state > 3) begin
                state <= 0;
            end
            isRed <= state == 3? 1 : 0;
            if (count == (bombCounter / 3) || count == (bombCounter / 3 * 2)) begin
                bufferLimit <= bufferLimit / 2;
            end
            if (count == bombCounter) begin
                stop <= 1;
                count <= 0;
                buffer <= 0;
                state <= 0;
                bufferLimit <= 32'd696111;
            end
        end 
    end
    
endmodule
