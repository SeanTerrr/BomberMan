`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 09:29:09
// Design Name: 
// Module Name: EndGame
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


module EndGame(
    input clk6p25m, start_game,timer_reached,
    input[5:0] player1_deathcount ,player2_deathcount,player3_deathcount,player4_deathcount,
    output EndGame,
    output[3:0] player_dead
);
    
    parameter[2:0] deathcount = 4;
    wire draw;
    assign player_dead[0] = (player1_deathcount >= deathcount);
    assign player_dead[1] = (player2_deathcount >= deathcount);
    assign player_dead[2] = (player3_deathcount >= deathcount);
    assign player_dead[3] = (player4_deathcount >= deathcount);
    
    integer k;
    reg[2:0] num_player_dead= 0;
    always @ (posedge clk6p25m)
    begin
        num_player_dead <= player_dead[0] + player_dead[1] + player_dead[2] + player_dead[3];
    end
    
    assign EndGame = ((num_player_dead >= 3) & start_game) | timer_reached;
endmodule
