`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 15:51:24
// Design Name: 
// Module Name: TriggerExplosion
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


module TriggerExplosion #(parameter[6:0] Maxbombcount = 5)(
    input[6:0] BombBlock ,
    input active,
    input[69:0] blocksAffectedByExplosion,
    output immediate_explode
);
    assign immediate_explode = blocksAffectedByExplosion[BombBlock] & active;
endmodule
