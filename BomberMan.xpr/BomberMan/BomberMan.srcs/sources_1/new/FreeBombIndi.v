`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2024 03:00:54
// Design Name: 
// Module Name: FreeBombIndi
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


module FreeBombIndi(
    input clk6p25m ,
    input ActiveBombs,
    input PlayerDebouncedBtnC,
    input start_game,
    input player_isReviving,
    input [1:0] player_count ,handle_case,
    output reg edge_registered = 0
);
    always @(posedge clk6p25m)
    begin
        if(PlayerDebouncedBtnC == 1 & ~player_isReviving & start_game & ~edge_registered & (player_count == handle_case) & ~ActiveBombs)
        begin
            edge_registered <= 1;
        end
        else if(ActiveBombs) begin
            edge_registered <= 0;
        end
    end
    
    
endmodule
