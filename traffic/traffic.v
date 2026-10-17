`timescale 1ns/1ps
module traffic #(parameter CLK_HZ=50_000_000)(
    input wire clk_50mhz,rst_p,flicker,
    output wire [3:0] led_red,led_yellow,led_green,led_left,
    output wire [3:0] led_walk_red,led_walk_green
);
    wire tick,blink;
    wire [1:0] direction;
    wire [3:0] phase;
    second_tick #(.CLK_HZ(CLK_HZ)) u_tick(clk_50mhz,rst_p,tick,blink);
    traffic_sequence u_sequence(clk_50mhz,rst_p,tick,flicker,direction,phase);
    traffic_lights u_lights(direction,phase,flicker,blink,
        led_red,led_yellow,led_green,led_walk_red,led_walk_green);
    assign led_left=led_green;
endmodule
