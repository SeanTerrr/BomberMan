`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 01:24:23
// Design Name: 
// Module Name: renderAl
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


module renderAl(
    input [6:0] centreX, 
    input [5:0] centreY, 
    input [12:0] pixel_index, 
    input isWalking,
    input clock, 
    output reg [15:0] pixel_data,
    output reg isAl
    
//    ,
//    output reg [1:0] state
);
    
    wire [15:0] Al0, Al1;
    wire isAl0, isAl1;
    reg state = 0;
    reg [31:0] count = 348055;
    
    renderAl0(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Al0),
                 .isPixel(isAl0)
                );
    renderAl1(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Al1),
                 .isPixel(isAl1)
                );

    always @ (posedge clock) begin
        if (isWalking) begin
            if (count == 0) begin
                state <= ~state;
                count <= 348055;
            end else begin
                count <= count - 1;
            end      
        end else begin
            state <= 0;
            count <= 348055;
        end
        case(state)
            1: begin
                pixel_data <= Al1;
                isAl <= isAl1;
            end
            default: begin
                pixel_data <= Al0;
                isAl <= isAl0;
            end
        endcase
    end
endmodule