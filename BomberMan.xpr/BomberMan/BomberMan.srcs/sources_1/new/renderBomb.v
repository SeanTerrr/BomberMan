`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 13:15:18
// Design Name: 
// Module Name: renderBomb
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


module renderBomb(
    input [6:0] centreX, 
    input [5:0] centreY, 
    input [12:0] pixel_index, 
    input clock,
    input edge_registered,
    output reg [15:0] pixel_data,
    output reg isBomb
);

   wire [15:0] bombState;
   reg startFlicker = 0;
   wire stopFlicker;
   wire isRed;
   wire isDefBomb;
   staticBomb staticbomb(.centreX(centreX), 
              .centreY(centreY), 
              .pixel_index(pixel_index), .clock(clock), 
              .isBomb(isDefBomb), 
              .pixel_data(bombState)
             );
   flickerBomb flickerBomb(.clock(clock), .start(startFlicker),
               .bombCounter(32'd31250000),
               .isRed(isRed), .stop(stopFlicker)
               );    
   always @ (posedge clock) begin
        isBomb <= isDefBomb;
        if (edge_registered) begin
            startFlicker <= 1;
        end
        if (isRed) begin
            pixel_data <= 16'hF800;
        end else begin
            pixel_data <= bombState;
        end
        if (stopFlicker) begin
            startFlicker <= 0;
        end
   end

   
endmodule
