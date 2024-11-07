`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 13:42:37
// Design Name: 
// Module Name: renderJones3
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


module renderJones3(
    input [6:0] centreX, 
    input [5:0] centreY, 
    input [12:0] pixel_index, 
    input clock, 
    output reg [15:0] pixel_data,
    output reg isPixel
);

    integer numPoints = 53;
    integer i;
    (* ram_style = "block" *)reg [6:0] xValueArray[0:53];
    (* ram_style = "block" *)reg [5:0] yValueArray[0:53];
    (* ram_style = "block" *)reg [15:0] colourValueArray[0:53];
    reg [6:0] x_value_check;
    reg [5:0] y_value_check;

    initial begin

        xValueArray[0] = 7'b1111111 + 1 - 2;
        yValueArray[0] = 6'b111111 + 1 - 4;
        colourValueArray[0] = 37611;

        xValueArray[1] = 7'b1111111 + 1 - 1;
        yValueArray[1] = 6'b111111 + 1 - 4;
        colourValueArray[1] = 37611;

        xValueArray[2] = 7'b1111111 + 1 - 2;
        yValueArray[2] = 6'b111111 + 1 - 3;
        colourValueArray[2] = 37611;

        xValueArray[3] = 7'b1111111 + 1 - 1;
        yValueArray[3] = 6'b111111 + 1 - 3;
        colourValueArray[3] = 37611;

        xValueArray[4] = 2;
        yValueArray[4] = 6'b111111 + 1 - 4;
        colourValueArray[4] = 37611;

        xValueArray[5] = 0;
        yValueArray[5] = 6'b111111 + 1 - 2;
        colourValueArray[5] = 37611;

        xValueArray[6] = 1;
        yValueArray[6] = 6'b111111 + 1 - 2;
        colourValueArray[6] = 37611;

        xValueArray[7] = 2;
        yValueArray[7] = 6'b111111 + 1 - 2;
        colourValueArray[7] = 37611;

        xValueArray[8] = 3;
        yValueArray[8] = 6'b111111 + 1 - 3;
        colourValueArray[8] = 37611;

        xValueArray[9] = 3;
        yValueArray[9] = 6'b111111 + 1 - 2;
        colourValueArray[9] = 37611;

        xValueArray[10] = 4;
        yValueArray[10] = 6'b111111 + 1 - 2;
        colourValueArray[10] = 37611;

        xValueArray[11] = 3;
        yValueArray[11] = 3;
        colourValueArray[11] = 37611;

        xValueArray[12] = 0;
        yValueArray[12] = 6'b111111 + 1 - 4;
        colourValueArray[12] = 45940;

        xValueArray[13] = 1;
        yValueArray[13] = 6'b111111 + 1 - 4;
        colourValueArray[13] = 45940;

        xValueArray[14] = 0;
        yValueArray[14] = 6'b111111 + 1 - 3;
        colourValueArray[14] = 45940;

        xValueArray[15] = 1;
        yValueArray[15] = 6'b111111 + 1 - 3;
        colourValueArray[15] = 45940;

        xValueArray[16] = 2;
        yValueArray[16] = 6'b111111 + 1 - 3;
        colourValueArray[16] = 45940;

        xValueArray[17] = 0;
        yValueArray[17] = 3;
        colourValueArray[17] = 45940;

        xValueArray[18] = 1;
        yValueArray[18] = 3;
        colourValueArray[18] = 45940;

        xValueArray[19] = 2;
        yValueArray[19] = 3;
        colourValueArray[19] = 45940;

        xValueArray[20] = 7'b1111111 + 1 - 2;
        yValueArray[20] = 4;
        colourValueArray[20] = 45940;

        xValueArray[21] = 3;
        yValueArray[21] = 4;
        colourValueArray[21] = 45940;

        xValueArray[22] = 7'b1111111 + 1 - 3;
        yValueArray[22] = 6'b111111 + 1 - 2;
        colourValueArray[22] = 10761;

        xValueArray[23] = 7'b1111111 + 1 - 2;
        yValueArray[23] = 6'b111111 + 1 - 2;
        colourValueArray[23] = 10761;

        xValueArray[24] = 7'b1111111 + 1 - 1;
        yValueArray[24] = 6'b111111 + 1 - 2;
        colourValueArray[24] = 10761;

        xValueArray[25] = 7'b1111111 + 1 - 2;
        yValueArray[25] = 2;
        colourValueArray[25] = 10761;

        xValueArray[26] = 7'b1111111 + 1 - 2;
        yValueArray[26] = 3;
        colourValueArray[26] = 10761;

        xValueArray[27] = 7'b1111111 + 1 - 1;
        yValueArray[27] = 2;
        colourValueArray[27] = 10761;

        xValueArray[28] = 3;
        yValueArray[28] = 2;
        colourValueArray[28] = 10761;

        xValueArray[29] = 7'b1111111 + 1 - 2;
        yValueArray[29] = 6'b111111 + 1 - 1;
        colourValueArray[29] = 63310;

        xValueArray[30] = 7'b1111111 + 1 - 2;
        yValueArray[30] = 0;
        colourValueArray[30] = 63310;

        xValueArray[31] = 7'b1111111 + 1 - 2;
        yValueArray[31] = 1;
        colourValueArray[31] = 63310;

        xValueArray[32] = 7'b1111111 + 1 - 1;
        yValueArray[32] = 3;
        colourValueArray[32] = 63310;

        xValueArray[33] = 0;
        yValueArray[33] = 2;
        colourValueArray[33] = 63310;

        xValueArray[34] = 1;
        yValueArray[34] = 6'b111111 + 1 - 1;
        colourValueArray[34] = 63310;

        xValueArray[35] = 1;
        yValueArray[35] = 2;
        colourValueArray[35] = 63310;

        xValueArray[36] = 2;
        yValueArray[36] = 6'b111111 + 1 - 1;
        colourValueArray[36] = 63310;

        xValueArray[37] = 2;
        yValueArray[37] = 2;
        colourValueArray[37] = 63310;

        xValueArray[38] = 7'b1111111 + 1 - 1;
        yValueArray[38] = 6'b111111 + 1 - 1;
        colourValueArray[38] = 49948;

        xValueArray[39] = 7'b1111111 + 1 - 1;
        yValueArray[39] = 0;
        colourValueArray[39] = 49948;

        xValueArray[40] = 7'b1111111 + 1 - 1;
        yValueArray[40] = 1;
        colourValueArray[40] = 49948;

        xValueArray[41] = 0;
        yValueArray[41] = 6'b111111 + 1 - 1;
        colourValueArray[41] = 00000;

        xValueArray[42] = 3;
        yValueArray[42] = 6'b111111 + 1 - 1;
        colourValueArray[42] = 00000;

        xValueArray[43] = 7'b1111111 + 1 - 2;
        yValueArray[43] = 5;
        colourValueArray[43] = 4231;

        xValueArray[44] = 2;
        yValueArray[44] = 5;
        colourValueArray[44] = 4231;

        xValueArray[45] = 0;
        yValueArray[45] = 0;
        colourValueArray[45] = 54120;

        xValueArray[46] = 1;
        yValueArray[46] = 0;
        colourValueArray[46] = 54120;

        xValueArray[47] = 2;
        yValueArray[47] = 0;
        colourValueArray[47] = 54120;

        xValueArray[48] = 3;
        yValueArray[48] = 0;
        colourValueArray[48] = 54120;

        xValueArray[49] = 0;
        yValueArray[49] = 1;
        colourValueArray[49] = 54120;

        xValueArray[50] = 1;
        yValueArray[50] = 1;
        colourValueArray[50] = 54120;

        xValueArray[51] = 2;
        yValueArray[51] = 1;
        colourValueArray[51] = 54120;

        xValueArray[52] = 3;
        yValueArray[52] = 1;
        colourValueArray[52] = 54120;

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
