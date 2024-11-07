`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2024 11:36:52
// Design Name: 
// Module Name: PixelControl
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


module PixelControl(
    input clk100mhz ,clk6p25m ,
    input initiate_reset, EndGame,resetting,
    input btnU , btnD , btnL , btnR , btnC ,
    input [15:0]SW , 
    input [12:0] pixel_index ,
    input reset, masterToggle, 
    input [2:0] master_rx,
    input [3:0] slave_rx,
    input[3:0] player_dead,
    output[15:0] pixel_data ,
    output [2:0] slave_tx, output reg [15:0] led = 0,
    output reg SWCheck = 0,
    output [3:0] master_tx,
    output player1_isReviving,player2_isReviving,player3_isReviving,player4_isReviving,
    output reg initiate_reset_out = 0,
    output reg start_game = 0 , pause = 0
);
   parameter dimensions = 9;
   parameter minX = 3 ,maxX = 93;
   parameter minY = 1 , maxY = 64;
   parameter player_dimensions = 7;
   //Squaretracker tracks player
   //Concrete blocks builds concrete blocks
   //Collision tracker in PlayerMovement tracks if player hit concrete
   
   wire CenterBlock , walls;
    
   ConcreteBlocks #(dimensions,minX,maxX,minY,maxY) ConcreteBlock(
      .pixel_index(pixel_index) ,
      .walls(walls) , .CenterBlock(CenterBlock)
   );
   /////////////////////////////////////////////////////////////////////////
   //self implemented uart sections
   wire player1;
   wire[6:0] Player1MinX , Player1MaxX;
   wire[5:0] Player1MinY , Player1MaxY;
   wire btnUPlayer1,btnDPlayer1,btnLPlayer1,btnRPlayer1,btnCPlayer1;
   reg btnUPlayer1In,btnDPlayer1In,btnLPlayer1In,btnRPlayer1In,btnCPlayer1In;
   wire[6:0] Player1Block;
   wire player1_die;
  
   wire btnUPlayer2,btnDPlayer2,btnLPlayer2,btnRPlayer2,btnCPlayer2;
   reg btnUPlayer2In,btnDPlayer2In,btnLPlayer2In,btnRPlayer2In,btnCPlayer2In;
   wire player2;
   wire[6:0] Player2MinX , Player2MaxX;
   wire[5:0] Player2MinY , Player2MaxY;
   wire[6:0] Player2Block;
   wire player2_die;
   
      
   wire btnUPlayer3,btnDPlayer3,btnLPlayer3,btnRPlayer3,btnCPlayer3;
   reg btnUPlayer3In,btnDPlayer3In,btnLPlayer3In,btnRPlayer3In,btnCPlayer3In;  
   wire player3;
   wire[6:0] Player3MinX , Player3MaxX;
   wire[5:0] Player3MinY , Player3MaxY;
   wire[6:0] Player3Block;
   wire player3_die;

      
   wire btnUPlayer4,btnDPlayer4,btnLPlayer4,btnRPlayer4,btnCPlayer4;
   reg btnUPlayer4In,btnDPlayer4In,btnLPlayer4In,btnRPlayer4In,btnCPlayer4In;
   wire player4;
   wire[6:0] Player4MinX , Player4MaxX;
   wire[5:0] Player4MinY , Player4MaxY;
   wire[6:0] Player4Block;
   wire player4_die;
  
   
   /////////////////////////////////////////////////////////////////////////////////////////////
   always @ (posedge clk6p25m)
   begin
        if(btnUPlayer1 & btnUPlayer2 & btnUPlayer3 & btnUPlayer4 & SWCheck)
        begin
            start_game <= 1;
        end
        if(initiate_reset_out)
        begin
            start_game <= 0;
        end
        
        pause <= (start_game & ~SWCheck);
   end
   ////////////////////////////////////////////////
   ///////////////////////////////////////////////
   ///////////////////////////////////////////////
   parameter Maxbombcount = 6;//////////////////////
   ///////////////////////////////////////////////
   wire [Maxbombcount-1 : 0] ActiveBombs;
   

   wire[3:0] playerHitLimit;
   ButtonGate#(Maxbombcount) buttonControl(
     .SWCheck(~pause & ~resetting), 
     .playerHitLimit(playerHitLimit),
     .ActiveBombs(ActiveBombs),
     .player_dead(player_dead), .player1_isReviving(player1_isReviving), .player2_isReviving(player2_isReviving), .player3_isReviving(player3_isReviving), .player4_isReviving(player4_isReviving),
     .btnUPlayer1In(btnUPlayer1In),.btnDPlayer1In(btnDPlayer1In),.btnLPlayer1In(btnLPlayer1In),.btnRPlayer1In(btnRPlayer1In),.btnCPlayer1In(btnCPlayer1In),
     .btnUPlayer2In(btnUPlayer2In),.btnDPlayer2In(btnDPlayer2In),.btnLPlayer2In(btnLPlayer2In),.btnRPlayer2In(btnRPlayer2In),.btnCPlayer2In(btnCPlayer2In),
     .btnUPlayer3In(btnUPlayer3In),.btnDPlayer3In(btnDPlayer3In),.btnLPlayer3In(btnLPlayer3In),.btnRPlayer3In(btnRPlayer3In),.btnCPlayer3In(btnCPlayer3In),
     .btnUPlayer4In(btnUPlayer4In),.btnDPlayer4In(btnDPlayer4In),.btnLPlayer4In(btnLPlayer4In),.btnRPlayer4In(btnRPlayer4In),.btnCPlayer4In(btnCPlayer4In),
     .btnUPlayer1(btnUPlayer1),.btnDPlayer1(btnDPlayer1),.btnLPlayer1(btnLPlayer1),.btnRPlayer1(btnRPlayer1),.btnCPlayer1(btnCPlayer1),
     .btnUPlayer2(btnUPlayer2),.btnDPlayer2(btnDPlayer2),.btnLPlayer2(btnLPlayer2),.btnRPlayer2(btnRPlayer2),.btnCPlayer2(btnCPlayer2),
     .btnUPlayer3(btnUPlayer3),.btnDPlayer3(btnDPlayer3),.btnLPlayer3(btnLPlayer3),.btnRPlayer3(btnRPlayer3),.btnCPlayer3(btnCPlayer3),
     .btnUPlayer4(btnUPlayer4),.btnDPlayer4(btnDPlayer4),.btnLPlayer4(btnLPlayer4),.btnRPlayer4(btnRPlayer4),.btnCPlayer4(btnCPlayer4)
   );   
   /////////////////////////////////////////////////////////////////////////////////////////////
   PlayerMovement 
   #(4,10,2,8,dimensions,minX,maxX,minY,maxY) 
   Player1MovementControl(
       .clk100mhz(clk100mhz) , .clk6p25m(clk6p25m),
       //.btnU(btnU) , .btnD(btnD) , .btnL(btnL) , .btnR(btnR) , .btnC(btnC) ,
       .btnU(btnUPlayer1) , .btnD(btnDPlayer1) , .btnL(btnLPlayer1) , .btnR(btnRPlayer1) , .btnC(btnCPlayer1) ,
       .pixel_index(pixel_index) ,
       .player_isReviving(player1_isReviving),
       .start_game(start_game), .initiate_reset(initiate_reset),
       .PlayerMinX(Player1MinX) , .PlayerMaxX(Player1MaxX) ,
       .PlayerMinY(Player1MinY) , .PlayerMaxY(Player1MaxY) ,
       .PlayerBlock(Player1Block)
   );
  
  PlayerMovement 
  #(87,93,2,8,dimensions,minX,maxX,minY,maxY) 
  Player2MovementControl(
      .clk100mhz(clk100mhz) , .clk6p25m(clk6p25m),
      .btnU(btnUPlayer2) , .btnD(btnDPlayer2) , .btnL(btnLPlayer2) , .btnR(btnRPlayer2) , .btnC(btnCPlayer2) ,
      .pixel_index(pixel_index) ,
      .player_isReviving(player2_isReviving),
      .start_game(start_game), .initiate_reset(initiate_reset),
      ////output
      .PlayerMinX(Player2MinX) , .PlayerMaxX(Player2MaxX) ,
      .PlayerMinY(Player2MinY) , .PlayerMaxY(Player2MaxY) ,
      .PlayerBlock(Player2Block)
  );
    
    PlayerMovement 
    #(4,10,57,63,dimensions,minX,maxX,minY,maxY) 
    Player3MovementControl(
        .clk100mhz(clk100mhz) , .clk6p25m(clk6p25m),
        .btnU(btnUPlayer3) , .btnD(btnDPlayer3) , .btnL(btnLPlayer3) , .btnR(btnRPlayer3) , .btnC(btnCPlayer3) ,
        .pixel_index(pixel_index) ,
        .player_isReviving(player3_isReviving),
        .start_game(start_game), .initiate_reset(initiate_reset),
        ////output
        .PlayerMinX(Player3MinX) , .PlayerMaxX(Player3MaxX) ,
        .PlayerMinY(Player3MinY) , .PlayerMaxY(Player3MaxY) ,
        .PlayerBlock(Player3Block)
    );
    
    PlayerMovement 
    #(87,93,57,63,dimensions,minX,maxX,minY,maxY) 
    Player4MovementControl(
        .clk100mhz(clk100mhz) , .clk6p25m(clk6p25m),
        .btnU(btnUPlayer4) , .btnD(btnDPlayer4) , .btnL(btnLPlayer4) , .btnR(btnRPlayer4) , .btnC(btnCPlayer4) ,
        .pixel_index(pixel_index) ,
        .player_isReviving(player4_isReviving),
        .start_game(start_game), .initiate_reset(initiate_reset),
        ////output
        .PlayerMinX(Player4MinX) , .PlayerMaxX(Player4MaxX) ,
        .PlayerMinY(Player4MinY) , .PlayerMaxY(Player4MaxY) ,
        .PlayerBlock(Player4Block)
    );
   
   wire bomb;
   wire ExplosionAnimations;
   wire [15:0] bombPixelData;
   
   Bomb #(Maxbombcount,9,2) BombControl (
       .clk6p25m(clk6p25m), .clk(clk100mhz),
       .pixel_index(pixel_index) ,
       .bomb(bomb),.SW(SW),
       
       .Player1Block(Player1Block) ,
       .Player1DebouncedBtnC(btnCPlayer1), 
       .player1_die(player1_die),
       .player1_isReviving(player1_isReviving),
       
       .Player2Block(Player2Block) ,
       .Player2DebouncedBtnC(btnCPlayer2), 
       .player2_die(player2_die),
       .player2_isReviving(player3_isReviving),
       
       .Player3Block(Player3Block) ,
       .Player3DebouncedBtnC(btnCPlayer3), 
       .player3_die(player3_die),
       .player3_isReviving(player3_isReviving),
       
       .Player4Block(Player4Block),
       .Player4DebouncedBtnC(btnCPlayer4), 
       .player4_die(player4_die),
       .player4_isReviving(player4_isReviving),
       
       .ExplosionAnimations(ExplosionAnimations),
       .start_game(start_game),
       .pixel_data(bombPixelData),
       
       .playerHitLimit(playerHitLimit),
       .ActiveBombs(ActiveBombs)
   );
   
   wire [15:0] player1PixelData, player2PixelData, player3PixelData, player4PixelData;    
   PixelDataControl ColourControl(
       .clk6p25m(clk6p25m) , 
       .player1_die(player1_die), .player2_die(player2_die), .player3_die(player3_die), .player4_die(player4_die),
       .walls(walls) , .CenterBlock(CenterBlock), 
       .player1(player1) , .player2(player2) ,.player3(player3) ,.player4(player4) ,
       .bomb(bomb) , .bombPixelData(bombPixelData),
       .ExplosionAnimations(ExplosionAnimations),
       .player1PixelData(player1PixelData), .player2PixelData(player2PixelData), .player3PixelData(player3PixelData), .player4PixelData(player4PixelData),
       .pixel_data(pixel_data) ,
       .player_dead(player_dead),
       .player1_isReviving(player1_isReviving) , .player2_isReviving(player2_isReviving) ,
       .player3_isReviving(player3_isReviving) , .player4_isReviving(player4_isReviving) ,
       .start_game(start_game), .pixel_index(pixel_index) , .pause(pause) , .EndGame(EndGame) ,.resetting(resetting)
   );
   
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   //uart start   
      wire start1,start2,start3;
   
      slave_tx slave_tx_module(
          .clk(clk100mhz), .reset(reset),
          .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .DebouncedBtnC(btnC),
          .tx(slave_tx[0]), .start(start1), .SW(SW[1])
      );
      
      slave_tx slave_tx_module2(
          .clk(clk100mhz), .reset(reset),
          .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .DebouncedBtnC(btnC),
          .tx(slave_tx[1]), .start(start2), .SW(SW[2])
      );
         
      slave_tx slave_tx_module3(
          .clk(clk100mhz), .reset(reset),
          .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .DebouncedBtnC(btnC),
          .tx(slave_tx[2]), .start(start3), .SW(SW[3])
      );
      
      wire [31:0] rx_data_master;
      wire [31:0] rx_data_master2;
      wire [31:0] rx_data_master3;
      reg valid_master_flag1, valid_master_flag2, valid_master_flag3;
      wire valid_master1, valid_master2, valid_master3;
      
      uart_rx_new master_rx_module(
          .clk(clk100mhz), .reset(reset), .rx(master_rx[0]), 
          .data(rx_data_master), .valid(valid_master1)
      );

      uart_rx_new master_rx_module2(
          .clk(clk100mhz), .reset(reset), .rx(master_rx[1]), 
          .data(rx_data_master2), .valid(valid_master2)
      );
      
      uart_rx_new master_rx_module3(
          .clk(clk100mhz), .reset(reset), .rx(master_rx[2]), 
          .data(rx_data_master3), .valid(valid_master3)
      );         
      
      master_tx master_tx_module1(
          .clk(clk100mhz), .reset(reset),
          .btnU(btnUPlayer1), .btnD(btnDPlayer1), .btnL(btnLPlayer1),
          .btnR(btnRPlayer1), .btnC(btnCPlayer1), .led(led),                           
          .tx(master_tx[0]), .initiate_reset(initiate_reset)
      );
       
      master_tx master_tx_module2(
          .clk(clk100mhz), .reset(reset),
          .btnU(btnUPlayer2), .btnD(btnDPlayer2), .btnL(btnLPlayer2),
          .btnR(btnRPlayer2), .btnC(btnCPlayer2), .led(led[3:0]),
          .tx(master_tx[1]), .initiate_reset(initiate_reset)
      );
      
      master_tx master_tx_module3(
          .clk(clk100mhz), .reset(reset),
          .btnU(btnUPlayer3), .btnD(btnDPlayer3), .btnL(btnLPlayer3),
          .btnR(btnRPlayer3), .btnC(btnCPlayer3), .led(led[3:0]),
          .tx(master_tx[2]), .initiate_reset(initiate_reset)
      );        
      master_tx master_tx_module4(
          .clk(clk100mhz), .reset(reset),
          .btnU(btnUPlayer4), .btnD(btnDPlayer4), .btnL(btnLPlayer4),
          .btnR(btnRPlayer4), .btnC(btnCPlayer4), .led(led[3:0]),
          .tx(master_tx[3]), .initiate_reset(initiate_reset)
      );     
      wire [31:0] rx_data_slave;
      reg valid_slave_flag;
      wire valid_slave;
      
      uart_rx_new slave_rx_module(
          .clk(clk100mhz), .reset(reset),
          .rx(slave_rx[0]), .data(rx_data_slave), .valid(valid_slave)
      );
      
      wire [31:0] rx_data_slave2;
      reg valid_slave_flag2;
      wire valid_slave2;
      
      uart_rx_new slave_rx_module2(
          .clk(clk100mhz), .reset(reset),
          .rx(slave_rx[1]), .data(rx_data_slave2), .valid(valid_slave2)
      );
      
      wire [31:0] rx_data_slave3;
      reg valid_slave_flag3;
      wire valid_slave3;
      uart_rx_new slave_rx_module3(
          .clk(clk100mhz), .reset(reset),
          .rx(slave_rx[2]), .data(rx_data_slave3), .valid(valid_slave3)
      );
      
      wire [31:0] rx_data_slave4;
      reg valid_slave_flag4;
      wire valid_slave4;
      uart_rx_new slave_rx_module4(
          .clk(clk100mhz), .reset(reset),
          .rx(slave_rx[3]), .data(rx_data_slave4), .valid(valid_slave4)
      );
      
                     
      wire clk_40hz;
      var_clock clk40hz2(.clk(clk100mhz), .M(32'd1249999), .SLOW_CLOCK(clk_40hz));
      always @(posedge clk_40hz) begin
           if (masterToggle) begin
               initiate_reset_out <= initiate_reset;
               led[3:0] <= {rx_data_master3[31],rx_data_master2[31],rx_data_master[31],SW[0]};
               SWCheck <= rx_data_master3[31] & rx_data_master2[31] & rx_data_master[31] & SW[0];
               if (SWCheck) begin
                   case (rx_data_master[7:0])
                       8'h01: begin // Move Up   
                           btnUPlayer2In <= 1;
                           btnDPlayer2In <= 0;
                           btnLPlayer2In <= 0;
                           btnRPlayer2In <= 0;
                           btnCPlayer2In <= 0;                     
                       end
                       8'h02: begin // Move Down    
                           btnUPlayer2In <= 0;
                           btnDPlayer2In <= 1;
                           btnLPlayer2In <= 0;
                           btnRPlayer2In <= 0;
                           btnCPlayer2In <= 0;                         
                       end
                       8'h03: begin // Move Left
                           btnUPlayer2In <= 0;
                           btnDPlayer2In <= 0;
                           btnLPlayer2In <= 1;
                           btnRPlayer2In <= 0;
                           btnCPlayer2In <= 0;                   
                       end
                       8'h04: begin // Move Right
                           btnUPlayer2In <= 0;
                           btnDPlayer2In <= 0;
                           btnLPlayer2In <= 0;
                           btnRPlayer2In <= 1;
                           btnCPlayer2In <= 0;                      
                       end
                       8'h05: begin
                           btnUPlayer2In <= 0;
                           btnDPlayer2In <= 0;
                           btnLPlayer2In <= 0;
                           btnRPlayer2In <= 0;
                           btnCPlayer2In <= 1; 
                       end
                       default: begin
                           btnUPlayer2In <= 0;
                           btnDPlayer2In <= 0;
                           btnLPlayer2In <= 0;
                           btnRPlayer2In <= 0;
                           btnCPlayer2In <= 0;                          
                       end
                   endcase  
                   
                   case (rx_data_master2[7:0])
                       8'h01: begin // Move Up   
                           btnUPlayer3In <= 1;
                           btnDPlayer3In <= 0;
                           btnLPlayer3In <= 0;
                           btnRPlayer3In <= 0;
                           btnCPlayer3In <= 0;                     
                       end
                       8'h02: begin // Move Down    
                           btnUPlayer3In <= 0;
                           btnDPlayer3In <= 1;
                           btnLPlayer3In <= 0;
                           btnRPlayer3In <= 0;
                           btnCPlayer3In <= 0;                          
                       end
                       8'h03: begin // Move Left
                           btnUPlayer3In <= 0;
                           btnDPlayer3In <= 0;
                           btnLPlayer3In <= 1;
                           btnRPlayer3In <= 0;
                           btnCPlayer3In <= 0;                    
                       end
                       8'h04: begin // Move Right
                           btnUPlayer3In <= 0;
                           btnDPlayer3In <= 0;
                           btnLPlayer3In <= 0;
                           btnRPlayer3In <= 1;
                           btnCPlayer3In <= 0;                       
                       end
                       8'h05: begin
                           btnUPlayer3In <= 0;
                           btnDPlayer3In <= 0;
                           btnLPlayer3In <= 0;
                           btnRPlayer3In <= 0;
                           btnCPlayer3In <= 1;   
                       end
                       default: begin
                           btnUPlayer3In <= 0;
                           btnDPlayer3In <= 0;
                           btnLPlayer3In <= 0;
                           btnRPlayer3In <= 0;
                           btnCPlayer3In <= 0;                          
                       end
                   endcase     
                   
                   case (rx_data_master3[7:0])
                       8'h01: begin // Move Up   
                           btnUPlayer4In <= 1;
                           btnDPlayer4In <= 0;
                           btnLPlayer4In <= 0;
                           btnRPlayer4In <= 0;
                           btnCPlayer4In <= 0;                     
                       end
                       8'h02: begin // Move Down    
                           btnUPlayer4In <= 0;
                           btnDPlayer4In <= 1;
                           btnLPlayer4In <= 0;
                           btnRPlayer4In <= 0;
                           btnCPlayer4In <= 0;                                
                       end
                       8'h03: begin // Move Left
                           btnUPlayer4In <= 0;
                           btnDPlayer4In <= 0;
                           btnLPlayer4In <= 1;
                           btnRPlayer4In <= 0;
                           btnCPlayer4In <= 0;                                      
                       end
                       8'h04: begin // Move Right
                           btnUPlayer4In <= 0;
                           btnDPlayer4In <= 0;
                           btnLPlayer4In <= 0;
                           btnRPlayer4In <= 1;
                           btnCPlayer4In <= 0;                                          
                       end
                       8'h05: begin
                           btnUPlayer4In <= 0;
                           btnDPlayer4In <= 0;
                           btnLPlayer4In <= 0;
                           btnRPlayer4In <= 0;
                           btnCPlayer4In <= 1;                      
                       end
                       default: begin
                           btnUPlayer4In <= 0;
                           btnDPlayer4In <= 0;
                           btnLPlayer4In <= 0;
                           btnRPlayer4In <= 0;
                           btnCPlayer4In <= 0;                                              
                       end
                   endcase   
                                                
                   if (btnU) begin
                       btnUPlayer1In <= 1;
                       btnDPlayer1In <= 0;
                       btnLPlayer1In <= 0;
                       btnRPlayer1In <= 0;
                       btnCPlayer1In <= 0;               
                   end else if (btnD) begin 
                       btnUPlayer1In <= 0;
                       btnDPlayer1In <= 1;
                       btnLPlayer1In <= 0;
                       btnRPlayer1In <= 0;
                       btnCPlayer1In <= 0;               
                   end else if (btnL) begin 
                       btnUPlayer1In <= 0;
                       btnDPlayer1In <= 0;
                       btnLPlayer1In <= 1;
                       btnRPlayer1In <= 0;
                       btnCPlayer1In <= 0;              
                   end else if (btnR) begin  
                       btnUPlayer1In <= 0;
                       btnDPlayer1In <= 0;
                       btnLPlayer1In <= 0;
                       btnRPlayer1In <= 1;
                       btnCPlayer1In <= 0;                
                   end else if (/*DebouncedBtnC*/btnC) begin
                       btnUPlayer1In <= 0;
                       btnDPlayer1In <= 0;
                       btnLPlayer1In <= 0;
                       btnRPlayer1In <= 0;
                       btnCPlayer1In <= 1;                
                   end else begin
                       btnUPlayer1In <= 0;
                       btnDPlayer1In <= 0;
                       btnLPlayer1In <= 0;
                       btnRPlayer1In <= 0;
                       btnCPlayer1In <= 0;                 
                   end
               end 
           end else begin
               btnUPlayer1In <= rx_data_slave[31];
               btnDPlayer1In <= rx_data_slave[30];
               btnLPlayer1In <= rx_data_slave[29];
               btnRPlayer1In <= rx_data_slave[28];
               btnCPlayer1In <= rx_data_slave[27]; 
               btnUPlayer2In <= rx_data_slave2[31];
               btnDPlayer2In <= rx_data_slave2[30];
               btnLPlayer2In <= rx_data_slave2[29];
               btnRPlayer2In <= rx_data_slave2[28];
               btnCPlayer2In <= rx_data_slave2[27];
               btnUPlayer3In <= rx_data_slave3[31];
               btnDPlayer3In <= rx_data_slave3[30];
               btnLPlayer3In <= rx_data_slave3[29];
               btnRPlayer3In <= rx_data_slave3[28];
               btnCPlayer3In <= rx_data_slave3[27];
               btnUPlayer4In <= rx_data_slave4[31];
               btnDPlayer4In <= rx_data_slave4[30];
               btnLPlayer4In <= rx_data_slave4[29];
               btnRPlayer4In <= rx_data_slave4[28];
               btnCPlayer4In <= rx_data_slave4[27];
               led[3:0] <= rx_data_slave[26:23];
               initiate_reset_out <= rx_data_slave[22];
               SWCheck <= rx_data_slave[26] & rx_data_slave[25] & rx_data_slave[24] & rx_data_slave[23];
               //SWCheck <= 1;                        
           end
           led[15:9] <= ActiveBombs;
      end
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire player1IsMoving, player2IsMoving, player3IsMoving, player4IsMoving;
    assign player1IsMoving = btnUPlayer1 | btnDPlayer1 | btnLPlayer1 | btnRPlayer1;
    assign player2IsMoving = btnUPlayer2 | btnDPlayer2 | btnLPlayer2 | btnRPlayer2;
    assign player3IsMoving = btnUPlayer3 | btnDPlayer3 | btnLPlayer3 | btnRPlayer3;
    assign player4IsMoving = btnUPlayer4 | btnDPlayer4 | btnLPlayer4 | btnRPlayer4;
    renderJones jones(.centreX((Player1MaxX+Player1MinX)/2), .centreY((Player1MaxY+Player1MinY)/2),
                  .clock(clk6p25m), .pixel_index(pixel_index),
                  .isJones(player1), .pixel_data(player1PixelData),
                  .isWalking(player1IsMoving));
    renderWiz wiz(.centreX((Player2MaxX+Player2MinX)/2), .centreY((Player2MaxY+Player2MinY)/2),
               .clock(clk6p25m), .pixel_index(pixel_index),
               .isWiz(player2), .pixel_data(player2PixelData),
               .isWalking(player2IsMoving));
               
    renderRob rob(
       .centreX((Player3MaxX+Player3MinX)/2), .centreY((Player3MaxY+Player3MinY)/2),
       .clock(clk6p25m), .pixel_index(pixel_index),
       .isRob(player3), .pixel_data(player3PixelData),
       .isWalking(player3IsMoving)
    );
    
    renderAl al(
       .centreX((Player4MaxX+Player4MinX)/2), .centreY((Player4MaxY+Player4MinY)/2),
       .clock(clk6p25m), .pixel_index(pixel_index),
       .isAl(player4), .pixel_data(player4PixelData),
       .isWalking(player4IsMoving)
    );
                   
endmodule