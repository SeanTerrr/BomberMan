`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 09:47:18
// Design Name: 
// Module Name: BombSimulation
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


module BombSimulation();

    reg clk6p25m;
    reg[12:0] pixel_index;
    reg[6:0] Player1Block;
    reg Player1DebouncedBtnC;
    reg player1_isReviving;
    reg start_game;
    reg bomb;
    wire ExplosionAnimations;
    wire player1_die , player2_die ,player3_die,player4_die;
    integer k ,x,y;
    reg[15:0] pixel_data;
    
    
        wire[3:0] xBlock;
        wire[2:0] yBlock;
        wire[6:0] BombMinX , BombMaxX;
        wire[5:0] BombMinY , BombMaxY;
        parameter dimension = 9;
        parameter[6:0] Maxbombcount = 4; 
        //seems like got bug with dropping more than n-2 bombs where
        //it will explode where the player is
        //increasing bomb count significantly increase bitstream gen time
        //decrease bomb count for testing purposes
        
        //look to remove this
        reg[25:0] Bombs [0:Maxbombcount-1];
        reg[6:0] BombsBlock [0:Maxbombcount-1];
        wire[6:0] ExplosionRadiusBlocks[0 : Maxbombcount-1][0:7];
        wire[Maxbombcount-1 :0] bombs;
        wire[Maxbombcount-1 :0] explode;
        wire[Maxbombcount-1 : 0] ActiveBombs;
        wire[Maxbombcount-1 : 0] player1_died;
        wire[Maxbombcount-1 : 0] player2_died;
        wire[Maxbombcount-1 : 0] player3_died;
        wire[Maxbombcount-1 : 0] player4_died;
        wire[Maxbombcount-1 : 0] immediate_explode;
        wire[(Maxbombcount * 2) - 1 : 0] WhichPlayerBomb;
        wire[7:0] FreeBomb;
        wire edge_registered;
        wire[Maxbombcount-1 : 0] ExplosionAnimation;
        reg[69:0] blocksAffectedByExplosion;
        
        initial begin
            clk6p25m = 0;
            pixel_index = 0;
            Player1Block = 1;
            player1_isReviving = 0;
            start_game = 1;
            Player1DebouncedBtnC = 0;
            pixel_data = 0;
            x =0 ;
            y = 0;
            Bombs[0] = 26'b0;
            BombsBlock[0] = 7'b0;
            Bombs[1] = 26'b0;
            BombsBlock[1] = 7'b0;
            Bombs[2] = 26'b0;
            BombsBlock[2] = 7'b0;
            Bombs[3] = 26'b0;
            BombsBlock[3] = 7'b0;
            #1000;
            Player1Block = 2; #1000; Player1DebouncedBtnC = 1; #50_000_000; Player1DebouncedBtnC = 0; #1000;
            Player1Block = 3; #1000; Player1DebouncedBtnC = 1; #50_000_000; Player1DebouncedBtnC = 0; #1000;
            Player1Block = 4; #1000; Player1DebouncedBtnC = 1; #50_000_000; Player1DebouncedBtnC = 0; #1000;
            //Player1Block = 5; #1000; Player1DebouncedBtnC = 1; #200_000_000; Player1DebouncedBtnC = 0; #1000;
            Player1Block = 9; #1000;
           
        end
        
        always begin
            #80;clk6p25m = ~clk6p25m; 
        end
        
          
           wire [15:0] bombPixelData [0:Maxbombcount - 1];
           
           assign player1_die = |player1_died;
           assign player2_die = |player2_died;
           assign player3_die = |player3_died;
           assign player4_die = |player4_died;
           
           FreeBomb #(Maxbombcount)FindFreeBomb(
               .clk6p25m(clk6p25m) , 
               .ActiveBombs(ActiveBombs) ,
               .FreeBomb(FreeBomb) , 
               .Player1DebouncedBtnC(Player1DebouncedBtnC) ,
               .Player2DebouncedBtnC(0) ,
               .Player3DebouncedBtnC(0) ,
               .Player4DebouncedBtnC(0) ,
               .edge_registered(edge_registered),
               .player1_isReviving(player1_isReviving),
               .player2_isReviving(0),
               .player3_isReviving(0),
               .player4_isReviving(0),
               .start_game(start_game)
           );
           
           genvar j;
           
           generate
               for(j = 0 ; j < Maxbombcount ; j = j+1)
               begin : mod_inst
                     renderBomb renderBomb1(.centreX((Bombs[j][25:19] + Bombs[j][18:12])/2),                              
                          .centreY((Bombs[j][11:6] + Bombs[j][5:0])/2), 
                          .pixel_index(pixel_index), .clock(clk6p25m),                              
                          .FreeBomb(FreeBomb),
                          .MyNumber(j),                              
                          .edge_registered(edge_registered),
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
                       .active(ActiveBombs[j]) , .FreeBomb(FreeBomb) , 
                       .MyNumber(j) ,
                       .edge_registered(edge_registered)
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
                       .Player1Block(Player1Block), .Player2Block(55),.Player3Block(55),.Player4Block(55), 
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
           
           wire[6:0] PlayerBlock = Player1Block;
           //////////////////////////////////////////////////////////////////////////////////////////////////////
           //assign PlayerBlock = SW[5] ? Player1Block : SW[6] ? Player2Block : SW[7] ? Player3Block : Player4Block;
           
           //assign to different players according to signals
           ////////////////////////////////////////////////////////////////////////////////////////////////////////
           assign ExplosionAnimations = |ExplosionAnimation;
           assign xBlock = (PlayerBlock % 10) + 1;
           assign yBlock = (PlayerBlock / 10) + 1;
           assign BombMinX = 3 + (xBlock - 1) * dimension;
           assign BombMaxX = 3 + (xBlock * dimension) - 1;
           assign BombMinY = 1 + (yBlock - 1) * dimension;
           assign BombMaxY = 1 + (yBlock * dimension) - 1;
           
           always @ (posedge clk6p25m)
           begin
               if(FreeBomb != 99)
               begin
                   BombsBlock[FreeBomb] <= PlayerBlock;
                   Bombs[FreeBomb][25:19] <= BombMinX;
                   Bombs[FreeBomb][18:12] <= BombMaxX;
                   Bombs[FreeBomb][11:6] <= BombMinY;
                   Bombs[FreeBomb][5:0] <= BombMaxY;
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
