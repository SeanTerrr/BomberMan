`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 13:15:18
// Design Name: 
// Module Name: staticBomb
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


module staticBomb(
    input [6:0] centreX, 
    input [5:0] centreY, 
    input [12:0] pixel_index, 
    input clock, 
//    input [15:0] bg_data, 
    output reg [15:0] pixel_data,
    output reg isBomb
);

    integer numPoints = 55;
    reg [15:0] BLACK=16'h0000;
    reg [15:0] DARK_BLUE=16'h002A;
    reg [15:0] BLUE=16'h6356;
    reg [15:0] LIGHT_BLUE=16'hAD7A;
    reg [15:0] ORANGE=16'hEBE6;
    reg [15:0] RED=16'hEAC7;
    integer i;
    (* ram_style = "block" *)reg [6:0] xValueArray[0:54];
    (* ram_style = "block" *)reg [5:0] yValueArray[0:54];
    (* ram_style = "block" *)reg [15:0] colourValueArray[0:54];
    reg [6:0] x_value_check;
    reg [5:0] y_value_check;

    initial begin

        xValueArray[0] = 3;
        yValueArray[0] = 6'b111111 + 1 - 5;
        colourValueArray[0] = RED;

        xValueArray[1] = 7'b1111111 + 1 - 2;
        yValueArray[1] = 6'b111111 + 1 - 4;
        colourValueArray[1] = BLUE;

        xValueArray[2] = 7'b1111111 + 1 - 1;
        yValueArray[2] = 6'b111111 + 1 - 4;
        colourValueArray[2] = LIGHT_BLUE;

        xValueArray[3] = 0;
        yValueArray[3] = 6'b111111 + 1 - 4;
        colourValueArray[3] = LIGHT_BLUE;

        xValueArray[4] = 1;
        yValueArray[4] = 6'b111111 + 1 - 4;
        colourValueArray[4] = LIGHT_BLUE;

        xValueArray[5] = 2;
        yValueArray[5] = 6'b111111 + 1 - 4;
        colourValueArray[5] = BLACK;

        xValueArray[6] = 3;
        yValueArray[6] = 6'b111111 + 1 - 4;
        colourValueArray[6] = ORANGE;

        xValueArray[7] = 7'b1111111 + 1 - 3;
        yValueArray[7] = 6'b111111 + 1 - 3;
        colourValueArray[7] = DARK_BLUE;

        xValueArray[8] = 7'b1111111 + 1 - 2;
        yValueArray[8] = 6'b111111 + 1 - 3;
        colourValueArray[8] = BLUE;

        xValueArray[9] = 7'b1111111 + 1 - 1;
        yValueArray[9] = 6'b111111 + 1 - 3;
        colourValueArray[9] = BLUE;

        xValueArray[10] = 0;
        yValueArray[10] = 6'b111111 + 1 - 3;
        colourValueArray[10] = LIGHT_BLUE;

        xValueArray[11] = 1;
        yValueArray[11] = 6'b111111 + 1 - 3;
        colourValueArray[11] = LIGHT_BLUE;

        xValueArray[12] = 2;
        yValueArray[12] = 6'b111111 + 1 - 3;
        colourValueArray[12] = BLUE;

        xValueArray[13] = 7'b1111111 + 1 - 4;
        yValueArray[13] = 6'b111111 + 1 - 2;
        colourValueArray[13] = DARK_BLUE;

        xValueArray[14] = 7'b1111111 + 1 - 3;
        yValueArray[14] = 6'b111111 + 1 - 2;
        colourValueArray[14] = DARK_BLUE;

        xValueArray[15] = 7'b1111111 + 1 - 2;
        yValueArray[15] = 6'b111111 + 1 - 2;
        colourValueArray[15] = BLUE;

        xValueArray[16] = 7'b1111111 + 1 - 1;
        yValueArray[16] = 6'b111111 + 1 - 2;
        colourValueArray[16] = BLUE;

        xValueArray[17] = 0;
        yValueArray[17] = 6'b111111 + 1 - 2;
        colourValueArray[17] = BLUE;

        xValueArray[18] = 1;
        yValueArray[18] = 6'b111111 + 1 - 2;
        colourValueArray[18] = LIGHT_BLUE;

        xValueArray[19] = 2;
        yValueArray[19] = 6'b111111 + 1 - 2;
        colourValueArray[19] = LIGHT_BLUE;

        xValueArray[20] = 3;
        yValueArray[20] = 6'b111111 + 1 - 2;
        colourValueArray[20] = BLUE;

        xValueArray[21] = 7'b1111111 + 1 - 4;
        yValueArray[21] = 6'b111111 + 1 - 1;
        colourValueArray[21] = BLACK;

        xValueArray[22] = 7'b1111111 + 1 - 3;
        yValueArray[22] = 6'b111111 + 1 - 1;
        colourValueArray[22] = DARK_BLUE;

        xValueArray[23] = 7'b1111111 + 1 - 2;
        yValueArray[23] = 6'b111111 + 1 - 1;
        colourValueArray[23] = DARK_BLUE;

        xValueArray[24] = 7'b1111111 + 1 - 1;
        yValueArray[24] = 6'b111111 + 1 - 1;
        colourValueArray[24] = BLUE;

        xValueArray[25] = 0;
        yValueArray[25] = 6'b111111 + 1 - 1;
        colourValueArray[25] = BLUE;

        xValueArray[26] = 1;
        yValueArray[26] = 6'b111111 + 1 - 1;
        colourValueArray[26] = BLUE;

        xValueArray[27] = 2;
        yValueArray[27] = 6'b111111 + 1 - 1;
        colourValueArray[27] = LIGHT_BLUE;

        xValueArray[28] = 3;
        yValueArray[28] = 6'b111111 + 1 - 1;
        colourValueArray[28] = BLUE;
        
        xValueArray[29] = 7'b1111111 + 1 - 4;
        yValueArray[29] = 0;
        colourValueArray[29] = BLACK;

        xValueArray[30] = 7'b1111111 + 1 - 3;
        yValueArray[30] = 0;
        colourValueArray[30] = DARK_BLUE;

        xValueArray[31] = 7'b1111111 + 1 - 2;
        yValueArray[31] = 0;
        colourValueArray[31] = DARK_BLUE;

        xValueArray[32] = 7'b1111111 + 1 - 1;
        yValueArray[32] = 0;
        colourValueArray[32] = DARK_BLUE;

        xValueArray[33] = 0;
        yValueArray[33] = 0;
        colourValueArray[33] = BLUE;

        xValueArray[34] = 1;
        yValueArray[34] = 0;
        colourValueArray[34] = BLUE;

        xValueArray[35] = 2;
        yValueArray[35] = 0;
        colourValueArray[35] = BLUE;

        xValueArray[36] = 3;
        yValueArray[36] = 0;
        colourValueArray[36] = BLUE;

        xValueArray[37] = 7'b1111111 + 1 - 4;
        yValueArray[37] = 1;
        colourValueArray[37] = BLACK;

        xValueArray[38] = 7'b1111111 + 1 - 3;
        yValueArray[38] = 1;
        colourValueArray[38] = BLACK;

        xValueArray[39] = 7'b1111111 + 1 - 2;
        yValueArray[39] = 1;
        colourValueArray[39] = DARK_BLUE;

        xValueArray[40] = 7'b1111111 + 1 - 1;
        yValueArray[40] = 1;
        colourValueArray[40] = DARK_BLUE;

        xValueArray[41] = 0;
        yValueArray[41] = 1;
        colourValueArray[41] = DARK_BLUE;

        xValueArray[42] = 1;
        yValueArray[42] = 1;
        colourValueArray[42] = DARK_BLUE;

        xValueArray[43] = 2;
        yValueArray[43] = 1;
        colourValueArray[43] = DARK_BLUE;

        xValueArray[44] = 2;
        yValueArray[44] = 2;
        colourValueArray[44] = DARK_BLUE;

        xValueArray[45] = 3;
        yValueArray[45] = 1;
        colourValueArray[45] = DARK_BLUE;

        xValueArray[46] = 7'b1111111 + 1 - 3;
        yValueArray[46] = 2;
        colourValueArray[46] = BLACK;

        xValueArray[47] = 7'b1111111 + 1 - 2;
        yValueArray[47] = 2;
        colourValueArray[47] = BLACK;

        xValueArray[48] = 7'b1111111 + 1 - 1;
        yValueArray[48] = 2;
        colourValueArray[48] = BLACK;

        xValueArray[49] = 0;
        yValueArray[49] = 2;
        colourValueArray[49] = DARK_BLUE;

        xValueArray[50] = 1;
        yValueArray[50] = 2;
        colourValueArray[50] = DARK_BLUE;

        xValueArray[51] = 7'b1111111 + 1 - 2;
        yValueArray[51] = 3;
        colourValueArray[51] = BLACK;

        xValueArray[52] = 7'b1111111 + 1 - 1;
        yValueArray[52] = 3;
        colourValueArray[52] = BLACK;

        xValueArray[53] = 0;
        yValueArray[53] = 3;
        colourValueArray[53] = BLACK;

        xValueArray[54] = 1;
        yValueArray[54] = 3;
        colourValueArray[54] = BLACK;

    end

    always @ (posedge clock) begin
        isBomb <= 0;
        for (i = 0; i < numPoints; i = i + 1) begin
            x_value_check = centreX + xValueArray[i];
             y_value_check = centreY + yValueArray[i];
            if ( (pixel_index / 96 == y_value_check) && (pixel_index % 96 == x_value_check) ) begin 
                pixel_data <= colourValueArray[i];
                isBomb <= 1;
            end
        end
    end
endmodule
