`timescale 1ns/1ps
module tb;
    // 파형 저장 (GTKWave로 확인) - 원본 TB에 추가한 부분
    initial begin $dumpfile("piano.vcd"); $dumpvars(0, tb); end
    reg clk=0, rst=1;
    always #5 clk=~clk;
    reg [7:0] key=0;
    wire piezo;
    reg [7:0] select_key;
    wire [31:0] frequency_hz;
    note_select select_dut(select_key,frequency_hz);
    piano #(.CLK_HZ(10000)) dut(clk,rst,key,piezo);
    integer notes[0:7];
    integer n, j, half_cycles;
    reg expected;
    task step; begin @(posedge clk); #1; end endtask
    initial begin
        notes[0]=262; notes[1]=294; notes[2]=330; notes[3]=349;
        notes[4]=392; notes[5]=440; notes[6]=494; notes[7]=523;
        step; @(negedge clk); rst=0;
        for(n=0;n<8;n=n+1) begin
            select_key=8'h80 >> n; #1;
            if(frequency_hz !== notes[n]) $fatal(1,"note lookup");
            @(negedge clk); key=8'h80 >> n; step;
            if(piezo !== 0) $fatal(1,"note change reset");
            half_cycles=10000/(2*notes[n]);
            expected=0;
            for(j=1;j<=4*half_cycles;j=j+1) begin
                step;
                if(j%half_cycles==0) expected=~expected;
                if(piezo !== expected) $fatal(1,"tone timing note=%0d",n);
            end
        end
        @(negedge clk); key=8'hC0; select_key=8'hC0; step;
        if(piezo !== 0 || frequency_hz !== 0) $fatal(1,"multiple keys");
        @(negedge clk); key=0; select_key=0;
        repeat(40) begin step; if(piezo !== 0) $fatal(1,"silence"); end
        @(negedge clk); rst=1; step;
        if(piezo !== 0) $fatal(1,"reset");
        $display("PASS piano: all 8 tones, silence, multiple keys, reset"); $finish;
    end
    initial begin #100000; $fatal(1,"timeout"); end
endmodule
