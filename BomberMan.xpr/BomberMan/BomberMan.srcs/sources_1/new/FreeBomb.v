`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2024 16:30:15
// Design Name: 
// Module Name: FreeBomb
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

module FreeBomb #(parameter[6:0] Maxbombcount = 5)(
    input clk6p25m ,
    input [Maxbombcount-1 : 0]ActiveBombs,
    input Player1DebouncedBtnC , Player2DebouncedBtnC , Player3DebouncedBtnC , Player4DebouncedBtnC , 
    input start_game,
    input player1_isReviving,player2_isReviving,player3_isReviving,player4_isReviving,
    output reg[7:0] FreeBomb = 99,
    output reg edge_registered = 0
);

    integer k , j;
    reg next_clock = 0;
    reg init = 1;
    reg reassign = 1;
    reg[1:0] triggered_player = 0;
    reg p1_handled = 0,p2_handled = 0 ,p3_handled = 0,p4_handled = 0;
    reg disabled = 0;
    reg[7:0] block_clock = 100;
    
    always @(posedge clk6p25m)
    begin
        if(Player1DebouncedBtnC == 1 & ~player1_isReviving & start_game & ~edge_registered & ~disabled & ~p1_handled)
        begin
            edge_registered <= 1;
            triggered_player <= 1;
            p1_handled <= 1;
            disabled <= 1;
        end
        else if(Player2DebouncedBtnC == 1 & ~player2_isReviving & start_game & ~edge_registered & ~disabled & ~p2_handled)
        begin
            edge_registered <= 1;
            triggered_player <= 2;
            p2_handled <= 1;
            disabled <= 1;
        end
        else if(Player3DebouncedBtnC == 1 & ~player3_isReviving & start_game & ~edge_registered & ~disabled & ~p3_handled)
        begin
            edge_registered <= 1;
            triggered_player <= 3;
            p3_handled <= 1;
            disabled <= 1;
        end
        else if(Player4DebouncedBtnC == 1 & ~player4_isReviving & start_game & ~edge_registered & ~disabled & ~p4_handled)
        begin
            edge_registered <= 1;
            triggered_player <= 4;
            p4_handled <= 1;
            disabled <= 1;
        end
        else begin
            edge_registered <= 0;
            ///////////////////////////////////
            if(disabled)
            begin
                block_clock <= (block_clock == 0) ? 100 : block_clock - 1;
                disabled <= (block_clock == 0) ? 0 : 1;
            end
            //////////////////////////////////////
            if(~edge_registered & reassign)
            begin
                FreeBomb <= 99;                         
                for(k = 0 ; k < Maxbombcount ; k = k+1)
                begin
                    if(ActiveBombs[k] == 0 & (k != FreeBomb))
                    begin
                        FreeBomb <= k;
                        reassign <= 0;
                    end
                end
            end
            next_clock <= 1;
        end
        
        //maybe last 2 bombs cannot use cause of smt in this logics
        if((~reassign & ~init & next_clock & FreeBomb == 99) | (~reassign & ActiveBombs[FreeBomb] == 1))
        begin
            reassign <= 1;
            next_clock <= 0;
        end
        else if(init)
        begin
            init <= 0;
        end
        
        p1_handled <= (Player1DebouncedBtnC == 0) ? 0 : 1;
        p2_handled <= (Player2DebouncedBtnC == 0) ? 0 : 1;
        p3_handled <= (Player3DebouncedBtnC == 0) ? 0 : 1;
        p4_handled <= (Player4DebouncedBtnC == 0) ? 0 : 1;
    end
endmodule
