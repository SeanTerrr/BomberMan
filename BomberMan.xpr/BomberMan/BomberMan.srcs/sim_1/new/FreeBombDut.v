`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 16:09:25
// Design Name: 
// Module Name: FreeBombDut
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


module FreeBombDut();
    parameter[6:0] Maxbombcount = 3;
    reg clk6p25m , clk;
    reg [Maxbombcount-1 : 0]ActiveBombs;
    reg Player1DebouncedBtnC,Player2DebouncedBtnC,Player3DebouncedBtnC,Player4DebouncedBtnC;
    reg start_game;
    reg player1_isReviving,player2_isReviving,player3_isReviving,player4_isReviving;
    reg [7:0] FreeBomb = 99;
    reg edge_registered = 0;
    reg [(Maxbombcount * 3) - 1 : 0] WhichPlayerBomb = 0;
    
    initial begin
        clk6p25m = 0; clk = 0;
        player1_isReviving = 0;player2_isReviving = 0; player3_isReviving = 0;player4_isReviving = 0;
        start_game = 1;
        Player1DebouncedBtnC = 0;Player2DebouncedBtnC = 0; Player3DebouncedBtnC = 0;Player4DebouncedBtnC = 0;
        ActiveBombs = 0;
        #1000;
        #1000; Player2DebouncedBtnC = 1; ActiveBombs = 3'b100; #50_000_000; Player2DebouncedBtnC = 0; #1000;
        #1000; Player2DebouncedBtnC = 1; ActiveBombs = 3'b110;#50_000_000; Player2DebouncedBtnC = 0; #1000;
        #1000; Player4DebouncedBtnC = 1; ActiveBombs = 3'b111;#50_000_000; Player4DebouncedBtnC = 0; 
        #500_000_000; ActiveBombs = 3'b011; 
        #1000; Player4DebouncedBtnC = 1; ActiveBombs = 3'b111;#50_000_000; Player4DebouncedBtnC = 0; #1000; 
        #500_000_000; ActiveBombs = 3'b101; 
        #1000; Player3DebouncedBtnC = 1; ActiveBombs = 3'b111;#50_000_000; Player3DebouncedBtnC = 0; #1000;
        #500_000_000; ActiveBombs = 3'b110; 
        #1000; Player3DebouncedBtnC = 1; ActiveBombs = 3'b111;#50_000_000; Player3DebouncedBtnC = 0; 
        
        #500_000_000; ActiveBombs = 3'b011; 
    end
    
    always begin
        #80; clk6p25m = ~clk6p25m; 
    end
    
    always begin
        #5; clk = ~clk;
    end
    genvar j;
    
    integer k , v , j;
    reg next_clock = 0;
    reg init = 1;
    reg reassign = 1;
    reg[2:0] triggered_player = 0;
    //i think can only assign once every 200ms sia
    reg p1_handled = 0,p2_handled = 0 ,p3_handled = 0,p4_handled = 0;
    reg disabled = 0;
    reg[7:0] block_clock = 100;
        
    always @(posedge clk6p25m)
    begin
        if(Player1DebouncedBtnC == 1 & ~player1_isReviving & start_game & ~edge_registered & ~disabled & ~p1_handled)
        begin
            edge_registered <= 1;
            triggered_player <= 1;
            WhichPlayerBomb <= WhichPlayerBomb & ~(3'b111 << (FreeBomb * 3));
            WhichPlayerBomb <= WhichPlayerBomb | 1 << (FreeBomb * 3);
            p1_handled <= 1;
            disabled <= 1;
        end
        else if(Player2DebouncedBtnC == 1 & ~player2_isReviving & start_game & ~edge_registered & ~disabled & ~p2_handled)
        begin
            edge_registered <= 1;
            triggered_player <= 2;
            WhichPlayerBomb <= WhichPlayerBomb & ~(3'b111 << (FreeBomb * 3));
            WhichPlayerBomb <= WhichPlayerBomb | 2 << (FreeBomb * 3);
            p2_handled <= 1;
            disabled <= 1;
        end
        else if(Player3DebouncedBtnC == 1 & ~player3_isReviving & start_game & ~edge_registered & ~disabled & ~p3_handled)
        begin
            edge_registered <= 1;
            triggered_player <= 3;
            WhichPlayerBomb <= WhichPlayerBomb & ~(3'b111 << (FreeBomb * 3));
            WhichPlayerBomb <= WhichPlayerBomb | 3 << (FreeBomb * 3);
            p3_handled <= 1;
            disabled <= 1;
        end
        else if(Player4DebouncedBtnC == 1 & ~player4_isReviving & start_game & ~edge_registered & ~disabled & ~p4_handled)
        begin
            edge_registered <= 1;
            triggered_player <= 4;
            WhichPlayerBomb <= WhichPlayerBomb & ~(3'b111 << (FreeBomb * 3));
            WhichPlayerBomb <= WhichPlayerBomb | 4 << (FreeBomb * 3);
            p4_handled <= 1;
            disabled <= 1;
        end
        else begin
            edge_registered <= 0;
            
            if(disabled)
            begin
                block_clock <= (block_clock == 0) ? 100 : block_clock - 1;
                disabled <= (block_clock == 0) ? 0 : 1;
            end
            
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
        else begin
            for(j = 0 ; j < Maxbombcount ; j = j+1)
            begin
                if(ActiveBombs[j] == 0)
                begin
                    WhichPlayerBomb <= WhichPlayerBomb & ~(3'b111 << (j * 3));
                end
            end
        end
        
        p1_handled <= (Player1DebouncedBtnC == 0) ? 1 : 0;
        p2_handled <= (Player2DebouncedBtnC == 0) ? 1 : 0;
        p3_handled <= (Player3DebouncedBtnC == 0) ? 1 : 0;
        p4_handled <= (Player4DebouncedBtnC == 0) ? 1 : 0;
    end
endmodule