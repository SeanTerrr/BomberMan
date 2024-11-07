`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 00:17:20
// Design Name: 
// Module Name: ButtonGate
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


module ButtonGate#(parameter Maxbombcount = 5)(
    input SWCheck , input[3:0] player_dead, playerHitLimit, input[Maxbombcount-1:0] ActiveBombs,
    input player1_isReviving, player2_isReviving, player3_isReviving, player4_isReviving,
    input btnUPlayer1In,btnDPlayer1In,btnLPlayer1In,btnRPlayer1In,btnCPlayer1In,
    btnUPlayer2In,btnDPlayer2In,btnLPlayer2In,btnRPlayer2In,btnCPlayer2In,
    btnUPlayer3In,btnDPlayer3In,btnLPlayer3In,btnRPlayer3In,btnCPlayer3In,
    btnUPlayer4In,btnDPlayer4In,btnLPlayer4In,btnRPlayer4In,btnCPlayer4In,
    output btnUPlayer1,btnDPlayer1,btnLPlayer1,btnRPlayer1,btnCPlayer1,
    btnUPlayer2,btnDPlayer2,btnLPlayer2,btnRPlayer2,btnCPlayer2,
    btnUPlayer3,btnDPlayer3,btnLPlayer3,btnRPlayer3,btnCPlayer3,
    btnUPlayer4,btnDPlayer4,btnLPlayer4,btnRPlayer4,btnCPlayer4
);
    wire stop;
    assign stop = (ActiveBombs == 3'b110) | (ActiveBombs == 3'b101) | (ActiveBombs == 3'b011);
    assign btnUPlayer1 = (SWCheck & ~player_dead[0] & ~player1_isReviving) ? btnUPlayer1In : 0; 
    assign btnDPlayer1 = (SWCheck & ~player_dead[0] & ~player1_isReviving) ? btnDPlayer1In : 0; 
    assign btnLPlayer1 = (SWCheck & ~player_dead[0] & ~player1_isReviving) ? btnLPlayer1In : 0; 
    assign btnRPlayer1 = (SWCheck & ~player_dead[0] & ~player1_isReviving) ? btnRPlayer1In : 0; 
    assign btnCPlayer1 = (SWCheck & ~player_dead[0] & ~player1_isReviving) ? btnCPlayer1In : 0; 
    assign btnUPlayer2 = (SWCheck & ~player_dead[1] & ~player2_isReviving) ? btnUPlayer2In : 0; 
    assign btnDPlayer2 = (SWCheck & ~player_dead[1] & ~player2_isReviving) ? btnDPlayer2In : 0; 
    assign btnLPlayer2 = (SWCheck & ~player_dead[1] & ~player2_isReviving) ? btnLPlayer2In : 0; 
    assign btnRPlayer2 = (SWCheck & ~player_dead[1] & ~player2_isReviving) ? btnRPlayer2In : 0; 
    assign btnCPlayer2 = (SWCheck & ~player_dead[1] & ~player2_isReviving) ? btnCPlayer2In : 0; 
    assign btnUPlayer3 = (SWCheck & ~player_dead[2] & ~player3_isReviving) ? btnUPlayer3In : 0; 
    assign btnDPlayer3 = (SWCheck & ~player_dead[2] & ~player3_isReviving) ? btnDPlayer3In : 0; 
    assign btnLPlayer3 = (SWCheck & ~player_dead[2] & ~player3_isReviving) ? btnLPlayer3In : 0; 
    assign btnRPlayer3 = (SWCheck & ~player_dead[2] & ~player3_isReviving) ? btnRPlayer3In : 0; 
    assign btnCPlayer3 = (SWCheck & ~player_dead[2] & ~player3_isReviving) ? btnCPlayer3In : 0; 
    assign btnUPlayer4 = (SWCheck & ~player_dead[3] & ~player4_isReviving) ? btnUPlayer4In : 0; 
    assign btnDPlayer4 = (SWCheck & ~player_dead[3] & ~player4_isReviving) ? btnDPlayer4In : 0; 
    assign btnLPlayer4 = (SWCheck & ~player_dead[3] & ~player4_isReviving) ? btnLPlayer4In : 0; 
    assign btnRPlayer4 = (SWCheck & ~player_dead[3] & ~player4_isReviving) ? btnRPlayer4In : 0; 
    assign btnCPlayer4 = (SWCheck & ~player_dead[3] & ~player4_isReviving) ? btnCPlayer4In : 0; 
    
          
endmodule