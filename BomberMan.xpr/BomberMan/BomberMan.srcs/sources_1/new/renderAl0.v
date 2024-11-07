`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 01:24:23
// Design Name: 
// Module Name: renderAl0
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


module renderAl0(
    input [6:0] centreX, 
    input [5:0] centreY, 
    input [12:0] pixel_index, 
    input clock, 
    output reg [15:0] pixel_data,
    output reg isPixel
);

    integer numPoints = 36;
    integer i;
    reg [6:0] xValueArray[0:36];
    reg [5:0] yValueArray[0:36];
    reg [15:0] colourValueArray[0:36];
    reg [6:0] x_value_check;
    reg [5:0] y_value_check;

    initial begin

        xValueArray[0] = 7'b1111111 + 1 - 3;
        yValueArray[0] = 5;
        colourValueArray[0] = 24043;

        xValueArray[1] = 7'b1111111 + 1 - 2;
        yValueArray[1] = 6'b111111 + 1 - 4;
        colourValueArray[1] = 24043;

        xValueArray[2] = 7'b1111111 + 1 - 2;
        yValueArray[2] = 6'b111111 + 1 - 2;
        colourValueArray[2] = 24043;

        xValueArray[3] = 7'b1111111 + 1 - 2;
        yValueArray[3] = 6'b111111 + 1 - 1;
        colourValueArray[3] = 24043;

        xValueArray[4] = 7'b1111111 + 1 - 2;
        yValueArray[4] = 0;
        colourValueArray[4] = 24043;

        xValueArray[5] = 7'b1111111 + 1 - 2;
        yValueArray[5] = 1;
        colourValueArray[5] = 24043;

        xValueArray[6] = 7'b1111111 + 1 - 2;
        yValueArray[6] = 3;
        colourValueArray[6] = 24043;

        xValueArray[7] = 7'b1111111 + 1 - 2;
        yValueArray[7] = 4;
        colourValueArray[7] = 24043;

        xValueArray[8] = 7'b1111111 + 1 - 1;
        yValueArray[8] = 6'b111111 + 1 - 3;
        colourValueArray[8] = 24043;

        xValueArray[9] = 7'b1111111 + 1 - 1;
        yValueArray[9] = 6'b111111 + 1 - 2;
        colourValueArray[9] = 24043;

        xValueArray[10] = 7'b1111111 + 1 - 1;
        yValueArray[10] = 6'b111111 + 1 - 1;
        colourValueArray[10] = 24043;

        xValueArray[11] = 7'b1111111 + 1 - 1;
        yValueArray[11] = 0;
        colourValueArray[11] = 24043;

        xValueArray[12] = 7'b1111111 + 1 - 1;
        yValueArray[12] = 1;
        colourValueArray[12] = 24043;

        xValueArray[13] = 7'b1111111 + 1 - 1;
        yValueArray[13] = 2;
        colourValueArray[13] = 24043;

        xValueArray[14] = 0;
        yValueArray[14] = 6'b111111 + 1 - 2;
        colourValueArray[14] = 16006;

        xValueArray[15] = 0;
        yValueArray[15] = 0;
        colourValueArray[15] = 16006;

        xValueArray[16] = 0;
        yValueArray[16] = 1;
        colourValueArray[16] = 16006;

        xValueArray[17] = 0;
        yValueArray[17] = 2;
        colourValueArray[17] = 16006;

        xValueArray[18] = 0;
        yValueArray[18] = 3;
        colourValueArray[18] = 16006;

        xValueArray[19] = 0;
        yValueArray[19] = 4;
        colourValueArray[19] = 16006;

        xValueArray[20] = 0;
        yValueArray[20] = 5;
        colourValueArray[20] = 16006;

        xValueArray[21] = 1;
        yValueArray[21] = 6'b111111 + 1 - 3;
        colourValueArray[21] = 16006;

        xValueArray[22] = 1;
        yValueArray[22] = 6'b111111 + 1 - 2;
        colourValueArray[22] = 16006;

        xValueArray[23] = 1;
        yValueArray[23] = 6'b111111 + 1 - 1;
        colourValueArray[23] = 16006;

        xValueArray[24] = 1;
        yValueArray[24] = 0;
        colourValueArray[24] = 16006;

        xValueArray[25] = 1;
        yValueArray[25] = 1;
        colourValueArray[25] = 16006;

        xValueArray[26] = 1;
        yValueArray[26] = 2;
        colourValueArray[26] = 16006;

        xValueArray[27] = 2;
        yValueArray[27] = 6'b111111 + 1 - 4;
        colourValueArray[27] = 16006;

        xValueArray[28] = 2;
        yValueArray[28] = 6'b111111 + 1 - 2;
        colourValueArray[28] = 16006;

        xValueArray[29] = 2;
        yValueArray[29] = 0;
        colourValueArray[29] = 16006;

        xValueArray[30] = 2;
        yValueArray[30] = 1;
        colourValueArray[30] = 16006;

        xValueArray[31] = 2;
        yValueArray[31] = 3;
        colourValueArray[31] = 16006;

        xValueArray[32] = 2;
        yValueArray[32] = 4;
        colourValueArray[32] = 16006;

        xValueArray[33] = 3;
        yValueArray[33] = 5;
        colourValueArray[33] = 16006;

        xValueArray[34] = 0;
        yValueArray[34] = 6'b111111 + 1 - 1;
        colourValueArray[34] = 00000;

        xValueArray[35] = 2;
        yValueArray[35] = 6'b111111 + 1 - 1;
        colourValueArray[35] = 00000;

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