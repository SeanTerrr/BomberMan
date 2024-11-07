`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 11:02:32
// Design Name: 
// Module Name: renderRob
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


module renderRob(
    input [6:0] centreX, 
    input [5:0] centreY, 
    input [12:0] pixel_index, 
    input isWalking,
    input clock, 
    output reg [15:0] pixel_data,
    output reg isRob
    
//    ,
//    output reg [1:0] state
);
    
    wire [15:0] Rob0, Rob1, Rob2;
    wire isRob0, isRob1, isRob2;
    reg [1:0] state = 0;
    reg [31:0] count = 348055;
    
    renderRob0(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Rob0),
                 .isPixel(isRob0)
                );
    renderRob1(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Rob1),
                 .isPixel(isRob1)
                );
    renderRob2(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Rob2),
                 .isPixel(isRob2)
                );

    always @ (posedge clock) begin
        if (isWalking) begin
            if (count == 0) begin
                state <= state == 2 ? 0 : state + 1;
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
                pixel_data <= Rob1;
                isRob <= isRob1;
            end
            2: begin
                pixel_data <= Rob2;
                isRob <= isRob2;
            end
            default: begin
                pixel_data <= Rob0;
                isRob <= isRob0;
            end
        endcase
    end
endmodule
