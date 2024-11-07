`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2024 23:26:08
// Design Name: 
// Module Name: PixelDataControl
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

//to handle death of individual players
module PixelDataControl(
    input clk6p25m , input[12:0] pixel_index,
    input player1_die,player2_die,player3_die,player4_die,
    input CenterBlock , walls , 
    input player1 , player2 , player3 , player4 , 
    input bomb , 
    input[3:0] player_dead,
    input [15:0] bombPixelData, player1PixelData, player2PixelData, player3PixelData, player4PixelData,
    input ExplosionAnimations,
    input start_game, pause,EndGame,resetting,
    output reg[15:0] pixel_data = 16'b0 ,
    output player1_isReviving ,player2_isReviving,player3_isReviving,player4_isReviving
);
   parameter[2:0] deathcount = 4;
   wire[15:0] WHITE = 16'hFFFF;
   wire[15:0] BLUE = 16'h001F;
   wire[15:0] GREEN = 16'h07E0;
   wire[15:0] RED = 16'hF800;
   wire[15:0] BLACK = 16'h0000;
   wire[15:0] DARK_GREY = 16'h1042;
   wire[15:0] BROWN = 16'hA52A;
   wire[15:0] ORANGE = 16'hFCA0;
   
   wire PlayerBlinkClk;
   var_clock player_blink(clk6p25m , 32'd624999 , PlayerBlinkClk);
   wire player1_status , player2_status,player3_status,player4_status , player_status;
   
   AnimateDeath Player1(
       .clk6p25m(clk6p25m), .PlayerBlinkClk(PlayerBlinkClk),
       .player(player1),
       .player_die(player1_die),
       .player_status(player1_status),
       .isReviving(player1_isReviving)
   );
   
   AnimateDeath Player2(
      .clk6p25m(clk6p25m), .PlayerBlinkClk(PlayerBlinkClk),
      .player(player2),
      .player_die(player2_die),
      .player_status(player2_status),
      .isReviving(player2_isReviving)
    );
      
      
    AnimateDeath Player3(
        .clk6p25m(clk6p25m), .PlayerBlinkClk(PlayerBlinkClk),
        .player(player3),
        .player_die(player3_die),
        .player_status(player3_status),
        .isReviving(player3_isReviving)
    );
       
         
    AnimateDeath Player4(
        .clk6p25m(clk6p25m), .PlayerBlinkClk(PlayerBlinkClk),
        .player(player4),
        .player_die(player4_die),
        .player_status(player4_status),
        .isReviving(player4_isReviving)
    );
            
   wire[15:0] ss_pixeldata , pause_pixeldata , p1_data , p2_data , p3_data , p4_data , draw_data , reset_data;
   StartingScreen start(
    .clk6p25m(clk6p25m),
    .pixel_index(pixel_index),
    .pixel_data(ss_pixeldata)
   );
   
   EndScreen paused(
       .clk6p25m(clk6p25m),
       .pixel_index(pixel_index),
       .pixel_data(pause_pixeldata)
   );
  
    p1_win player_one(
        .clk6p25m(clk6p25m),
        .pixel_index(pixel_index),
        .pixel_data(p1_data)
    );
    
    p2_win player_two(
        .clk6p25m(clk6p25m),
        .pixel_index(pixel_index),
        .pixel_data(p2_data)
    );
    
    p3_win player_three(
        .clk6p25m(clk6p25m),
        .pixel_index(pixel_index),
        .pixel_data(p3_data)
    );
    
    p4_win player_four(
        .clk6p25m(clk6p25m),
        .pixel_index(pixel_index),
        .pixel_data(p4_data)
    );
    
    DrawScreen draw(
            .clk6p25m(clk6p25m),
            .pixel_index(pixel_index),
            .pixel_data(draw_data)
    );
    
    ResetScreen reset(
                .clk6p25m(clk6p25m),
                .pixel_index(pixel_index),
                .pixel_data(reset_data)
        );
    
    wire [6:0] centreX;
    wire [7:0] centreY;
    assign centreX = (((pixel_index % 96) - 3)/9)*9 + 6; // x coordinate for centre of block
    assign centreY = (((pixel_index / 96) - 1)/9)*9 + 5; // y coordinate for centre of block
    wire isExplosion;
    wire [15:0] explosionData;
    renderExplosion(
        .centreX(centreX), .centreY(centreY), 
        .clock(clk6p25m), .pixel_index(pixel_index), 
        .isPixel(isExplosion), .pixel_data(explosionData)
    );
   always @(posedge clk6p25m)
   begin
       
       if(~start_game)
       begin
           pixel_data <= ss_pixeldata;
       end
       else if(resetting)
       begin
           pixel_data <= reset_data; //resetting data pixel
       end
       else if(pause)
       begin
           pixel_data <= pause_pixeldata;
       end
       else if(EndGame)
       begin
           case(player_dead)
               4'b1101 : pixel_data <= p2_data;
               4'b1110 : pixel_data <= p1_data;
               4'b1011 : pixel_data <= p3_data;
               4'b0111 : pixel_data <= p4_data;
               default : pixel_data <= draw_data;
           endcase
       end
       else if(bomb)
           pixel_data <= bombPixelData;
       else if(player1_status & ~player_dead[0])
           pixel_data <= player1PixelData;
       else if(player2_status & ~player_dead[1])
           pixel_data <= player2PixelData;
       else if(player3_status & ~player_dead[2])
           pixel_data <= player3PixelData;
       else if(player4_status & ~player_dead[3])
           pixel_data <= player4PixelData;
       else if(CenterBlock)
       begin
           pixel_data <= DARK_GREY;
       end
       else if(walls)
          pixel_data <= BROWN;
       else if(ExplosionAnimations)
           pixel_data <= explosionData;
       else
           pixel_data <= BLACK;
       
   end
endmodule
