`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2024 22:29:28
// Design Name: 
// Module Name: SevenSegDisplay
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


module SevenSegDisplay(
    input clk6p25m, clk200hz,
    input start_game , pause,resetting,
    output reg[3:0] an = 4'b1111,
    output reg[6:0] seg = 7'b111_1111,
    output reg dp = 1'b1 ,
    output reg timer_reached = 0
);      
    wire clk1hz;
    var_clock onehz(.clk(clk6p25m) , .M(3124999) , . SLOW_CLOCK(clk1hz));
    
    parameter[5:0] game_mins = 10;
    parameter[5:0] game_seconds = 0;
    reg[15:0] total_seconds = game_mins*60 + game_seconds;
    reg[3:0] durations [0 : 3];
    
    always @ (posedge clk1hz)
    begin
        if(start_game & ~pause & ~resetting)
        begin
            total_seconds <= total_seconds == 0 ? 0 : total_seconds - 1;
        end
        else if (~start_game)
        begin
            total_seconds <= game_mins*60 + game_seconds;
            timer_reached <= 0;
        end
        
        if(total_seconds == 0)
        begin
            timer_reached <= 1;
        end
        durations[3] <= (total_seconds / 600);
        durations[2] <= (total_seconds / 60) % 10;
        durations[1] <= (total_seconds % 60) / 10;
        durations[0] <= (total_seconds % 10);
    end 
    
    reg[1:0] duration_loopcount = 0;
    always @ (posedge clk200hz)
    begin
        an <= (4'b1111) & ~(1 << duration_loopcount);
        case(durations[duration_loopcount])
            0 : seg <= 7'b1000000;
            1 : seg <= 7'b1111001;
            2 : seg <= 7'b0100100;
            3 : seg <= 7'b0110000;
            4 : seg <= 7'b0011001;
            5 : seg <= 7'b0010010;
            6 : seg <= 7'b000_0010;
            7 : seg <= 7'b111_1000;
            8 : seg <= 7'b000_0000;
            9 : seg <= 7'b001_1000;
            default : seg <= 7'b011_1111;
        endcase
        duration_loopcount <= duration_loopcount + 1;
    end
    
    

    
endmodule
