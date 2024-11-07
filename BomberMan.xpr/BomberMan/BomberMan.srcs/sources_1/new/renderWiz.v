`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 09:05:56
// Design Name: 
// Module Name: renderWiz
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


module renderWiz(
    input [6:0] centreX, 
input [5:0] centreY, 
input [12:0] pixel_index, 
input isWalking,
input clock, 
output reg [15:0] pixel_data,
output reg isWiz

//    ,
//    output reg [1:0] state
);

wire [15:0] Wiz0, Wiz1, Wiz2,Wiz3;
wire isWiz0, isWiz1, isWiz2, isWiz3;
reg [1:0] state = 0;
reg [31:0] count = 348055;

renderWiz0(.centreX(centreX), 
             .centreY(centreY), 
             .pixel_index(pixel_index), 
             .clock(clock), 
             .pixel_data(Wiz0),
             .isPixel(isWiz0)
            );
renderWiz1(.centreX(centreX), 
             .centreY(centreY), 
             .pixel_index(pixel_index), 
             .clock(clock), 
             .pixel_data(Wiz1),
             .isPixel(isWiz1)
            );
renderWiz2(.centreX(centreX), 
             .centreY(centreY), 
             .pixel_index(pixel_index), 
             .clock(clock), 
             .pixel_data(Wiz2),
             .isPixel(isWiz2)
            );
renderWiz3(.centreX(centreX), 
             .centreY(centreY), 
             .pixel_index(pixel_index), 
             .clock(clock), 
             .pixel_data(Wiz3),
             .isPixel(isWiz3)
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
            pixel_data <= Wiz1;
            isWiz <= isWiz1;
        end
        2: begin
            pixel_data <= Wiz2;
            isWiz <= isWiz2;
        end
        3: begin 
            pixel_data <= Wiz3;
            isWiz <= isWiz3;
        end
        default: begin
            pixel_data <= Wiz0;
            isWiz <= isWiz0;
        end
    endcase
end
endmodule
