`timescale 1ns/1ps
module tb;
    // 파형 저장 (GTKWave로 확인) - 원본 TB에 추가한 부분
    initial begin $dumpfile("traffic.vcd"); $dumpvars(0, tb); end
    reg clk=0,rst=1,flicker=0;
    always #5 clk=~clk;
    wire [3:0] red,yellow,green,left,wr,wg;
    traffic #(.CLK_HZ(4)) dut(clk,rst,flicker,red,yellow,green,left,wr,wg);
    integer direction,phase,subcycle;
    reg [3:0] vm,pm,er,ey,eg,ewr,ewg;
    task step; begin @(posedge clk); #1; end endtask
    task check;
        begin
            case(direction)
                0: begin vm=8; pm=4; end
                1: begin vm=4; pm=2; end
                2: begin vm=2; pm=1; end
                3: begin vm=1; pm=8; end
            endcase
            er=~vm; ey=0; eg=0; ewr=15; ewg=0;
            if(phase<11) eg=vm; else ey=vm;
            if(phase<4) begin ewg=pm; ewr=~pm; end
            else if(phase<11) begin
                ewr=~pm; if(subcycle<2) ewg=pm;
            end
            if({red,yellow,green,wr,wg} !== {er,ey,eg,ewr,ewg})
                $fatal(1,"traffic dir=%0d phase=%0d sub=%0d",direction,phase,subcycle);
            if(left !== green) $fatal(1,"left indicator");
        end
    endtask
    initial begin
        step; @(negedge clk); rst=0;
        // 네 방향의 13단계와 각 초의 점멸을 확인합니다.
        for(direction=0;direction<4;direction=direction+1)
            for(phase=0;phase<13;phase=phase+1)
                for(subcycle=0;subcycle<4;subcycle=subcycle+1) begin
                    check; step;
                end
        direction=0; phase=0; subcycle=0; check;
        @(negedge clk); flicker=1; step;
        repeat(8) begin
            if(red !== 0 || green !== 0 || wg !== 0) $fatal(1,"flicker outputs");
            if(yellow !== wr || !(yellow===0 || yellow===15)) $fatal(1,"flicker blink");
            step;
        end
        @(negedge clk); flicker=0; rst=1; step;
        direction=0; phase=0; subcycle=0; check;
        $display("PASS traffic: full cycle, pedestrian blink, flicker, reset"); $finish;
    end
    initial begin #100000; $fatal(1,"timeout"); end
endmodule
