`timescale 1ns/1ps
module traffic_lights(
    input wire [1:0] direction,
    input wire [3:0] phase,
    input wire flicker,blink,
    output reg [3:0] red,yellow,green,walk_red,walk_green
);
    reg [3:0] vehicle_mask,pedestrian_mask;
    always @* begin
        // 방향별 차량과 보행자 LED를 선택합니다.
        case(direction)
            0: begin vehicle_mask=4'b1000; pedestrian_mask=4'b0100; end
            1: begin vehicle_mask=4'b0100; pedestrian_mask=4'b0010; end
            2: begin vehicle_mask=4'b0010; pedestrian_mask=4'b0001; end
            3: begin vehicle_mask=4'b0001; pedestrian_mask=4'b1000; end
        endcase
        red=4'b1111; yellow=0; green=0; walk_red=4'b1111; walk_green=0;
        if(flicker) begin
            red=0; yellow={4{blink}}; walk_red={4{blink}};
        end else begin
            if(phase<=10) begin green=vehicle_mask; red=~vehicle_mask; end
            else begin yellow=vehicle_mask; red=~vehicle_mask; end
            if(phase<=3) begin walk_green=pedestrian_mask; walk_red=~pedestrian_mask; end
            else if(phase<=10) begin
                walk_green=blink ? pedestrian_mask : 4'b0000;
                walk_red=~pedestrian_mask;
            end
        end
    end
endmodule
