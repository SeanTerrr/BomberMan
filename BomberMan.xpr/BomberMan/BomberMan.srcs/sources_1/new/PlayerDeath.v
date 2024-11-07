`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 02:05:28
// Design Name: 
// Module Name: PlayerDeath
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


module PlayerDeath(
    input clk200hz,
    input initiate_reset,
    input player1_isReviving ,
    output reg[2:0] player1_deathcount = 0
);

    reg incremented = 0;
    
    always @ (posedge clk200hz)
    begin
        if(player1_isReviving & ~incremented)
        begin
            player1_deathcount <= player1_deathcount + 1;
            incremented <= 1;
        end
        else if(~player1_isReviving)begin
            incremented <= 0;
        end
        
        if(initiate_reset)
        begin
            player1_deathcount <= 0;
        end
    end
endmodule
