`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 11:02:32
// Design Name: 
// Module Name: renderRob2
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


module renderRob2(
    input [6:0] centreX, 
    input [5:0] centreY, 
    input [12:0] pixel_index, 
    input clock, 
    output reg [15:0] pixel_data,
    output reg isPixel
);

    integer numPoints = 44;
    integer i;
    reg [6:0] xValueArray[0:44];
    reg [5:0] yValueArray[0:44];
    reg [15:0] colourValueArray[0:44];
    reg [6:0] x_value_check;
    reg [5:0] y_value_check;

    initial begin

        xValueArray[0] = 7'b1111111 + 1 - 2;
        yValueArray[0] = 6'b111111 + 1 - 3;
        colourValueArray[0] = 6372;

        xValueArray[1] = 7'b1111111 + 1 - 2;
        yValueArray[1] = 6'b111111 + 1 - 1;
        colourValueArray[1] = 6372;

        xValueArray[2] = 7'b1111111 + 1 - 1;
        yValueArray[2] = 6'b111111 + 1 - 4;
        colourValueArray[2] = 6372;

        xValueArray[3] = 7'b1111111 + 1 - 1;
        yValueArray[3] = 6'b111111 + 1 - 3;
        colourValueArray[3] = 6372;

        xValueArray[4] = 7'b1111111 + 1 - 1;
        yValueArray[4] = 6'b111111 + 1 - 1;
        colourValueArray[4] = 6372;

        xValueArray[5] = 0;
        yValueArray[5] = 6'b111111 + 1 - 4;
        colourValueArray[5] = 6372;

        xValueArray[6] = 0;
        yValueArray[6] = 6'b111111 + 1 - 3;
        colourValueArray[6] = 6372;

        xValueArray[7] = 0;
        yValueArray[7] = 2;
        colourValueArray[7] = 6372;

        xValueArray[8] = 1;
        yValueArray[8] = 3;
        colourValueArray[8] = 6372;

        xValueArray[9] = 2;
        yValueArray[9] = 2;
        colourValueArray[9] = 6372;

        xValueArray[10] = 2;
        yValueArray[10] = 4;
        colourValueArray[10] = 6372;

        xValueArray[11] = 0;
        yValueArray[11] = 0;
        colourValueArray[11] = 27501;

        xValueArray[12] = 0;
        yValueArray[12] = 1;
        colourValueArray[12] = 27501;

        xValueArray[13] = 1;
        yValueArray[13] = 6'b111111 + 1 - 4;
        colourValueArray[13] = 27501;

        xValueArray[14] = 1;
        yValueArray[14] = 6'b111111 + 1 - 3;
        colourValueArray[14] = 27501;

        xValueArray[15] = 1;
        yValueArray[15] = 0;
        colourValueArray[15] = 27501;

        xValueArray[16] = 1;
        yValueArray[16] = 1;
        colourValueArray[16] = 27501;

        xValueArray[17] = 7'b1111111 + 1 - 2;
        yValueArray[17] = 6'b111111 + 1 - 2;
        colourValueArray[17] = 61504;

        xValueArray[18] = 0;
        yValueArray[18] = 6'b111111 + 1 - 2;
        colourValueArray[18] = 61504;

        xValueArray[19] = 2;
        yValueArray[19] = 6'b111111 + 1 - 2;
        colourValueArray[19] = 61504;

        xValueArray[20] = 7'b1111111 + 1 - 4;
        yValueArray[20] = 3;
        colourValueArray[20] = 14823;

        xValueArray[21] = 7'b1111111 + 1 - 3;
        yValueArray[21] = 6'b111111 + 1 - 1;
        colourValueArray[21] = 14823;

        xValueArray[22] = 7'b1111111 + 1 - 3;
        yValueArray[22] = 2;
        colourValueArray[22] = 14823;

        xValueArray[23] = 7'b1111111 + 1 - 2;
        yValueArray[23] = 0;
        colourValueArray[23] = 14823;

        xValueArray[24] = 7'b1111111 + 1 - 2;
        yValueArray[24] = 2;
        colourValueArray[24] = 14823;

        xValueArray[25] = 7'b1111111 + 1 - 2;
        yValueArray[25] = 3;
        colourValueArray[25] = 14823;

        xValueArray[26] = 7'b1111111 + 1 - 2;
        yValueArray[26] = 4;
        colourValueArray[26] = 14823;

        xValueArray[27] = 7'b1111111 + 1 - 2;
        yValueArray[27] = 5;
        colourValueArray[27] = 14823;

        xValueArray[28] = 7'b1111111 + 1 - 1;
        yValueArray[28] = 6'b111111 + 1 - 2;
        colourValueArray[28] = 14823;

        xValueArray[29] = 7'b1111111 + 1 - 1;
        yValueArray[29] = 0;
        colourValueArray[29] = 14823;

        xValueArray[30] = 7'b1111111 + 1 - 1;
        yValueArray[30] = 1;
        colourValueArray[30] = 14823;

        xValueArray[31] = 7'b1111111 + 1 - 1;
        yValueArray[31] = 2;
        colourValueArray[31] = 14823;

        xValueArray[32] = 7'b1111111 + 1 - 1;
        yValueArray[32] = 3;
        colourValueArray[32] = 14823;

        xValueArray[33] = 0;
        yValueArray[33] = 6'b111111 + 1 - 1;
        colourValueArray[33] = 14823;

        xValueArray[34] = 1;
        yValueArray[34] = 6'b111111 + 1 - 1;
        colourValueArray[34] = 14823;

        xValueArray[35] = 2;
        yValueArray[35] = 6'b111111 + 1 - 1;
        colourValueArray[35] = 14823;

        xValueArray[36] = 1;
        yValueArray[36] = 6'b111111 + 1 - 2;
        colourValueArray[36] = 40211;

        xValueArray[37] = 1;
        yValueArray[37] = 5;
        colourValueArray[37] = 40211;

        xValueArray[38] = 2;
        yValueArray[38] = 0;
        colourValueArray[38] = 40211;

        xValueArray[39] = 2;
        yValueArray[39] = 3;
        colourValueArray[39] = 40211;

        xValueArray[40] = 3;
        yValueArray[40] = 2;
        colourValueArray[40] = 40211;

        xValueArray[41] = 4;
        yValueArray[41] = 3;
        colourValueArray[41] = 40211;

        xValueArray[42] = 0;
        yValueArray[42] = 3;
        colourValueArray[42] = 16877;

        xValueArray[43] = 1;
        yValueArray[43] = 2;
        colourValueArray[43] = 16877;

    end

    always @ (posedge clock) begin
        isPixel <= 0;
        for (i = 0; i < numPoints; i = i + 1) begin
            x_value_check = centreX + xValueArray[i];
             y_value_check = centreY + yValueArray[i];
            if ( (pixel_index / 96 == y_value_check) && (pixel_index % 96 == x_value_check) ) begin 
                pixel_data <= colourValueArray[i];
                isPixel <= 1;
            end
        end
    end
endmodule
