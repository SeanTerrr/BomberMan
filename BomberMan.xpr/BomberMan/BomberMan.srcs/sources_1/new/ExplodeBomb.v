`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2024 21:20:12
// Design Name: 
// Module Name: ExplodeBomb
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


module ExplodeBomb(
    input clk6p25m,
    input[6:0] Player1Block,Player2Block,Player3Block,Player4Block,
    input [12:0] pixel_index,
    input[6:0] BombBlock,
    input active , 
    output ExplosionAnimation ,
    output player1_died,  player2_died ,player3_died,player4_died,
    output [6:0] Up1 , Up2 , Left1 , Left2 , Right1 , Right2 , Down1 , Down2 ,
    output reg explode = 0
);

    wire[8:0] blocks;
    reg initialise = 0;            
    reg[31:0] counter = 32'd1250000;    
    wire ImmutableUp , ImmutableDown, ImmutableLeft, ImmutableRight;
    wire[6:0] Up , Down , Left , Right;
    
    assign Up = BombBlock - 10;
    assign Down = BombBlock + 10;
    assign Left = BombBlock - 1;
    assign Right = BombBlock + 1;
    
    BlockIsImmutable ModuleUp(.BombBlock(Up), .Immutable(ImmutableUp));
    BlockIsImmutable ModuleDown(.BombBlock(Down), .Immutable(ImmutableDown));
    BlockIsImmutable ModuleLeft(.BombBlock(Left), .Immutable(ImmutableLeft));
    BlockIsImmutable ModuleRight(.BombBlock(Right), .Immutable(ImmutableRight));
    
    assign Up1 = (BombBlock < 10 | ImmutableUp) ? BombBlock : BombBlock - 10;
    assign Up2 = (BombBlock < 20 | (Up1 == BombBlock)) ? BombBlock : BombBlock - 20;
    assign Left1 = (BombBlock % 10 <= 0 | ImmutableLeft) ? BombBlock : BombBlock - 1;
    assign Left2 = (BombBlock % 10 <= 1 | (Left1 == BombBlock)) ? BombBlock : BombBlock - 2;
    assign Right1 = (BombBlock % 10 >= 9 | ImmutableRight) ? BombBlock : BombBlock + 1;
    assign Right2 = (BombBlock % 10 >= 8 | (Right1 == BombBlock)) ? BombBlock : BombBlock + 2;
    assign Down1 = (BombBlock > 60 | ImmutableDown) ? BombBlock : BombBlock + 10;
    assign Down2 = (BombBlock > 50 | (Down1 == BombBlock)) ? BombBlock : BombBlock + 20;
    assign player1_died = explode ? ((Player1Block == Up1) | (Player1Block == Up2) | (Player1Block == Down1) | (Player1Block == Down2) 
                        | (Player1Block == Left1) | (Player1Block == Left2) | (Player1Block == Right1) | (Player1Block == Right2) | (Player1Block == BombBlock)) : 0;
    assign player2_died = explode ? ((Player2Block == Up1) | (Player2Block == Up2) | (Player2Block == Down1) | (Player2Block == Down2) 
                        | (Player2Block == Left1) | (Player2Block == Left2) | (Player2Block == Right1) | (Player2Block == Right2) | (Player2Block == BombBlock)) : 0;
    assign player3_died = explode ? ((Player3Block == Up1) | (Player3Block == Up2) | (Player3Block == Down1) | (Player3Block == Down2) 
                        | (Player3Block == Left1) | (Player3Block == Left2) | (Player3Block == Right1) | (Player3Block == Right2) | (Player3Block == BombBlock)) : 0;
    assign player4_died = explode ? ((Player4Block == Up1) | (Player4Block == Up2) | (Player4Block == Down1) | (Player4Block == Down2) 
                        | (Player4Block == Left1) | (Player4Block == Left2) | (Player4Block == Right1) | (Player4Block == Right2) | (Player4Block == BombBlock)) : 0;

    BlockColourPixel BombExplosion1(.BombBlock(BombBlock) , .pixel_index(pixel_index) , .isColouredPixel(blocks[0]));
    BlockColourPixel BombExplosion2(.BombBlock(Up1) , .pixel_index(pixel_index) , .isColouredPixel(blocks[1]));
    BlockColourPixel BombExplosion3(.BombBlock(Up2) , .pixel_index(pixel_index) , .isColouredPixel(blocks[2]));
    BlockColourPixel BombExplosion4(.BombBlock(Down1) , .pixel_index(pixel_index) , .isColouredPixel(blocks[3]));
    BlockColourPixel BombExplosion5(.BombBlock(Down2) , .pixel_index(pixel_index) , .isColouredPixel(blocks[4]));
    BlockColourPixel BombExplosion6(.BombBlock(Left1) , .pixel_index(pixel_index) , .isColouredPixel(blocks[5]));
    BlockColourPixel BombExplosion7(.BombBlock(Left2) , .pixel_index(pixel_index) , .isColouredPixel(blocks[6]));
    BlockColourPixel BombExplosion8(.BombBlock(Right1) , .pixel_index(pixel_index) , .isColouredPixel(blocks[7]));
    BlockColourPixel BombExplosion9(.BombBlock(Right2) , .pixel_index(pixel_index) , .isColouredPixel(blocks[8]));
    
    assign ExplosionAnimation = explode 
            ? (blocks[0] | blocks[1] | blocks[2] | blocks[3] | blocks[4] | blocks[5] | blocks[6] | blocks[7] | blocks[8])
            : 0;

    always @ (posedge clk6p25m)
    begin
        if(active & ~initialise)
        begin
            initialise <= 1;
        end
        if(~active & initialise)
        begin 
            initialise <= 0;
            explode <= 1;
        end  
        if(explode == 1)
        begin
            counter <= counter - 1;
            if(counter == 0)
            begin
                counter <= 625000;
                explode <= 0;
            end      
        end   
    end
endmodule
