`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 13:42:37
// Design Name: 
// Module Name: renderJones
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


module renderJones(
    input [6:0] centreX, 
    input [5:0] centreY, 
    input [12:0] pixel_index, 
    input isWalking,
    input clock, 
    output reg [15:0] pixel_data,
    output reg isJones
    
//    ,
//    output reg [1:0] state
);
    
    wire [15:0] Jones0, Jones1, Jones2, Jones3;
    wire isJones0, isJones1, isJones2, isJones3;
    reg [1:0] state = 0;
    reg [31:0] count = 348055;
    
    renderJones0(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Jones0),
                 .isPixel(isJones0)
                );
    renderJones1(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Jones1),
                 .isPixel(isJones1)
                );
    renderJones2(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Jones2),
                 .isPixel(isJones2)
                );
    renderJones3(.centreX(centreX), 
                 .centreY(centreY), 
                 .pixel_index(pixel_index), 
                 .clock(clock), 
                 .pixel_data(Jones3),
                 .isPixel(isJones3)
                );
    always @ (posedge clock) begin
        if (isWalking) begin
            state <= state == 0 ? 1 : state;
            if (count == 0) begin
                state <= state == 3 ? 1 : state + 1;
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
                pixel_data <= Jones1;
                isJones <= isJones1;
            end
            2: begin
                pixel_data <= Jones2;
                isJones <= isJones2;
            end
            3: begin 
                pixel_data <= Jones3;
                isJones <= isJones3;
            end
            default: begin
                pixel_data <= Jones0;
                isJones <= isJones0;
            end
        endcase
    end
endmodule
