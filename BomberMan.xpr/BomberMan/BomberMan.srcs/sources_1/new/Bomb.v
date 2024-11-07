`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2024 17:24:55
// Design Name: 
// Module Name: Bomb
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


module Bomb #(parameter Maxbombcount = 5,parameter dimension = 9,parameter[2:0] maxplayerbomb = 2)(
    input clk6p25m, clk,
    input[12:0] pixel_index ,
    input[6:0] Player1Block , Player2Block,Player3Block,Player4Block,
    input Player1DebouncedBtnC , Player2DebouncedBtnC, Player3DebouncedBtnC, Player4DebouncedBtnC, 
    input[15:0] SW,
    input player1_isReviving, player2_isReviving,player3_isReviving,player4_isReviving,
    input start_game,
    output reg bomb = 1'b0 ,
    output ExplosionAnimations ,
    output player1_die , player2_die ,player3_die,player4_die,
    output reg[3:0] playerHitLimit,
    output reg [15:0] pixel_data,
    output [Maxbombcount-1 : 0] ActiveBombs
);  
    
    //seems like got bug with dropping more than n-2 bombs where
    //it will explode where the player is
    //increasing bomb count significantly increase bitstream gen time
    //decrease bomb count for testing purposes
    
    reg[6:0] BombsBlock [0:Maxbombcount-1];
    wire[6:0] ExplosionRadiusBlocks[0 : Maxbombcount-1][0:7];
    wire[Maxbombcount-1 :0] bombs;
    wire[Maxbombcount-1 :0] explode;
    wire[Maxbombcount-1 : 0] immediate_explode;
    wire[Maxbombcount-1 : 0] player1_died;
    wire[Maxbombcount-1 : 0] player2_died;
    wire[Maxbombcount-1 : 0] player3_died;
    wire[Maxbombcount-1 : 0] player4_died;
    wire[Maxbombcount-1 : 0] edge_registered;
    wire[Maxbombcount-1 : 0] ExplosionAnimation;
    reg[69:0] blocksAffectedByExplosion;
    wire[6:0] PlayerBlocks [0:3];
    wire [15:0] bombPixelData [0:Maxbombcount - 1];
    
    assign player1_die = |player1_died;
    assign player2_die = |player2_died;
    assign player3_die = |player3_died;
    assign player4_die = |player4_died;
    
    assign PlayerBlocks[0] = Player1Block;
    assign PlayerBlocks[1] = Player2Block;
    assign PlayerBlocks[2] = Player3Block;
    assign PlayerBlocks[3] = Player4Block;
    integer k;
    reg [1:0] configuration [0:Maxbombcount-1];
    initial begin
        
        for(k =0 ; k < Maxbombcount ; k = k+1)
        begin
            BombsBlock[k] = 7'b0;
        end
        configuration[0] = 0;
        configuration[1] = 0;
        configuration[2] = 1;
        configuration[3] = 1;
        configuration[4] = 2;
        configuration[5] = 3;
    end
    
    
    wire[3:0] player_revive = {player4_isReviving, player3_isReviving,player2_isReviving,player1_isReviving};
    wire[3:0] btns = {Player4DebouncedBtnC , Player3DebouncedBtnC, Player2DebouncedBtnC, Player1DebouncedBtnC};
    wire[1:0] player_count [0:3];
    genvar j;
    
    assign player_count[0] = (ActiveBombs[0] & ActiveBombs[1]) ? 2 : (~ActiveBombs[0] & ~ActiveBombs[1]) ? 0 : 1;
    assign player_count[1] = (ActiveBombs[2] & ActiveBombs[3]) ? 2 : (~ActiveBombs[2] & ~ActiveBombs[3]) ? 0 : 1;
    assign player_count[2] = ActiveBombs[4];
    assign player_count[3] = ActiveBombs[5];
        
    FreeBombIndi Freebomb1(
        .clk6p25m(clk6p25m) ,
        .ActiveBombs(ActiveBombs[0]),
        .PlayerDebouncedBtnC(btns[configuration[0]]),
        .start_game(start_game),
        .player_isReviving(player_revive[configuration[0]]),
        .edge_registered(edge_registered[0]),
        .player_count(player_count[configuration[0]]),
        .handle_case(0)
    );
    
    FreeBombIndi Freebomb2(
        .clk6p25m(clk6p25m) ,
        .ActiveBombs(ActiveBombs[1]),
        .PlayerDebouncedBtnC(btns[configuration[1]]),
        .start_game(start_game),
        .player_isReviving(player_revive[configuration[1]]),
        .edge_registered(edge_registered[1]),
        .player_count(player_count[configuration[1]]),
        .handle_case(1)
    );
    
    FreeBombIndi Freebomb3(
        .clk6p25m(clk6p25m) ,
        .ActiveBombs(ActiveBombs[2]),
        .PlayerDebouncedBtnC(btns[configuration[2]]),
        .start_game(start_game),
        .player_isReviving(player_revive[configuration[2]]),
        .edge_registered(edge_registered[2]),
        .player_count(player_count[configuration[2]]),
        .handle_case(0)
    );
    
    FreeBombIndi Freebomb4(
        .clk6p25m(clk6p25m) ,
        .ActiveBombs(ActiveBombs[3]),
        .PlayerDebouncedBtnC(btns[configuration[3]]),
        .start_game(start_game),
        .player_isReviving(player_revive[configuration[3]]),
        .edge_registered(edge_registered[3]),
        .player_count(player_count[configuration[3]]),
        .handle_case(1)
    );
    
    FreeBombIndi Freebomb5(
        .clk6p25m(clk6p25m) ,
        .ActiveBombs(ActiveBombs[4]),
        .PlayerDebouncedBtnC(btns[configuration[4]]),
        .start_game(start_game),
        .player_isReviving(player_revive[configuration[4]]),
        .edge_registered(edge_registered[4]),
        .player_count(player_count[configuration[4]]),
        .handle_case(0)
    );
    
    FreeBombIndi Freebomb6(
        .clk6p25m(clk6p25m) ,
        .ActiveBombs(ActiveBombs[5]),
        .PlayerDebouncedBtnC(btns[configuration[5]]),
        .start_game(start_game),
        .player_isReviving(player_revive[configuration[5]]),
        .edge_registered(edge_registered[5]),
        .player_count(player_count[configuration[5]]),
        .handle_case(0)
    );
    
    generate
        for(j = 0 ; j < Maxbombcount ; j = j+1)
        begin : mod_inst
              renderBomb renderbomby(.centreX(((BombsBlock[j] % 10) * 9)+3+4),                              
                   .centreY(((BombsBlock[j] / 10) * 9)+1+4), 
                   .pixel_index(pixel_index), .clock(clk6p25m),                                                          
                   .edge_registered(edge_registered[j]),
                   .isBomb(bombs[j]),                              
                   .pixel_data(bombPixelData[j])
            );
        end
    endgenerate
    
    generate
        for(j = 0 ; j < Maxbombcount ; j = j+1)
        begin : mod_inst1
            BombCounter Bombcounter(
                .immediate_explode(immediate_explode[j]),
                .clk6p25m(clk6p25m), 
                .active(ActiveBombs[j]) ,
                .edge_registered(edge_registered[j])
            );
        end
    endgenerate
    
    generate
        for(j = 0 ; j < Maxbombcount ; j = j+1)
        begin : mod_inst2
            ExplodeBomb ExplodeAnimation(
                .clk6p25m(clk6p25m), 
                .pixel_index(pixel_index),
                .BombBlock(BombsBlock[j]),    
                .active(ActiveBombs[j]),   
                .Player1Block(Player1Block), .Player2Block(Player2Block),.Player3Block(Player3Block),.Player4Block(Player4Block), 
                .ExplosionAnimation(ExplosionAnimation[j]),
                .player1_died(player1_died[j]),.player2_died(player2_died[j]),.player3_died(player3_died[j]),.player4_died(player4_died[j]),
                .Up1(ExplosionRadiusBlocks[j][0]) , .Up2(ExplosionRadiusBlocks[j][1]),
                .Left1(ExplosionRadiusBlocks[j][2]) , .Left2(ExplosionRadiusBlocks[j][3]),
                .Right1(ExplosionRadiusBlocks[j][4]) , .Right2(ExplosionRadiusBlocks[j][5]),
                .Down1(ExplosionRadiusBlocks[j][6]) , .Down2(ExplosionRadiusBlocks[j][7]),
                .explode(explode[j])
            );
        end
    endgenerate
    //can look to remove this below
    generate
        for(j = 0 ; j < Maxbombcount ; j = j+1)
        begin : mod_inst3
            TriggerExplosion #(Maxbombcount) TriggerForBlockJ(
                .BombBlock(BombsBlock[j]) ,
                .active(ActiveBombs[j]),
                .blocksAffectedByExplosion(blocksAffectedByExplosion),
                .immediate_explode(immediate_explode[j])
            );
        end
    endgenerate
    
    //assign to different players according to signals
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign ExplosionAnimations = |ExplosionAnimation;

    integer iterate;
    always @ (posedge clk6p25m)
    begin
        for(iterate = 0; iterate < Maxbombcount ; iterate = iterate + 1)
        begin
            if(ActiveBombs[iterate] & edge_registered[iterate])
            begin
                BombsBlock[iterate] <= PlayerBlocks[configuration[iterate]];
            end
        end
        
        bomb <= 1'b0; 
        for(k = 0 ; k < Maxbombcount ; k = k+1)
        begin
            if(bombs[k] == 1'b1 && ActiveBombs[k] == 1'b1)
            begin
                bomb <= 1'b1;
                pixel_data <= bombPixelData[k];
            end
        end
    end
  
    //should be ok since cneter is not recognised?
    integer x,y;
    always @ (posedge clk6p25m)
    begin
        blocksAffectedByExplosion <= 70'b0;
        for(x = 0 ; x < Maxbombcount ; x = x+1)
        begin
            if(explode[x] == 1'b1)
            begin
                for(y = 0 ; y < 8 ; y = y + 1)
                begin
                    if((ExplosionRadiusBlocks[x][y]) < 70)
                    begin
                       blocksAffectedByExplosion[ExplosionRadiusBlocks[x][y]] <= 1'b1;
                    end
                end
            end
        end
    end
    
endmodule
