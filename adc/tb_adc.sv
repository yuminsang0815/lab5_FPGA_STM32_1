`timescale 1ns/1ps
module tb;
    // 파형 저장 (GTKWave로 확인) - 원본 TB에 추가한 부분
    initial begin $dumpfile("adc.vcd"); $dumpvars(0, tb); end
    reg clk=0,rst=1;
    always #5 clk=~clk;
    reg [2:0] channel=2;
    reg miso=0;
    wire sclk,cs_n,mosi,valid;
    wire [11:0] sample;
    wire [7:0] led;
    adc #(.HALF_CYCLES(2)) dut(clk,rst,channel,sclk,cs_n,mosi,miso,sample,valid,led);
    reg [15:0] received_command;
    reg [15:0] reply=16'hA5C3;
    reg [2:0] frame_channel;
    integer bit_no,received_bits,frames=0;
    realtime last_mosi_change=0;
    // [보드 수정] AD7908 데이터시트 타이밍으로 바꾼 ADC 모델:
    // CS 하강에서 첫 비트, 이후 SCLK 하강 에지마다 다음 DOUT 비트(접근 시간 3 ns),
    // DIN은 SCLK 하강 에지에서 읽고 셋업 10 ns·홀드 5 ns를 검사한다.
    always @(mosi) last_mosi_change=$realtime;
    always @(negedge cs_n) begin
        bit_no=15; received_bits=0; received_command=0; frame_channel=channel;
        miso=reply[15];
    end
    always @(negedge sclk)
        if(!cs_n && !rst && received_bits<16) begin
            if($realtime - last_mosi_change < 10) $fatal(1,"ADC DIN setup violation at bit %0d",received_bits);
            received_command={received_command[14:0],mosi};
            received_bits=received_bits+1;
            bit_no=bit_no-1;
            #3 if(bit_no>=0) miso=reply[bit_no];
        end
    always @(negedge sclk)
        if(!cs_n && !rst) begin
            #5 if($realtime - last_mosi_change <= 5) $fatal(1,"ADC DIN hold violation at %0t",$realtime);
        end
    always @(posedge valid) begin
        #1;
        if(received_bits != 16) $fatal(1,"ADC frame length");
        if(received_command !== (16'hA370 | (frame_channel << 10)))
            $fatal(1,"ADC command channel=%0d cmd=%h",frame_channel,received_command);
        if(sample !== reply[11:0] || led !== reply[11:4]) $fatal(1,"ADC sample");
        frames=frames+1;
    end
    initial begin
        repeat(2) @(negedge clk);
        if(cs_n!==1 || sclk!==1 || sample!==0) $fatal(1,"ADC reset");
        rst=0;
        wait(frames==1); @(negedge clk); channel=5;
        wait(frames==2); @(negedge clk); channel=7;
        wait(frames==3); @(negedge clk); rst=1;
        @(posedge clk); #1;
        if(cs_n!==1 || sclk!==1 || sample!==0 || valid!==0) $fatal(1,"ADC reset after data");
        $display("PASS ADC: 3 serial frames, command bits, sample, reset"); $finish;
    end
    initial begin #100000; $fatal(1,"timeout"); end
endmodule
