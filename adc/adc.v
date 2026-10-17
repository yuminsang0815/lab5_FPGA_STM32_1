`timescale 1ns/1ps
module adc #(parameter HALF_CYCLES=25)(
    input wire clk_50mhz,rst_p,
    input wire [2:0] add_sel,
    output wire adc_sclk,adc_ncs,adc_din,
    input wire adc_dout,
    output reg [11:0] sample,
    output reg data_valid,
    output wire [7:0] led_out
);
    wire [15:0] command,rx_word;
    wire busy,done;
    reg start;
    adc_command u_command(add_sel,command);
    serial_frame16 #(.HALF_CYCLES(HALF_CYCLES)) u_serial(
        clk_50mhz,rst_p,start,command,adc_dout,
        adc_sclk,adc_ncs,adc_din,busy,done,rx_word);
    always @(posedge clk_50mhz) begin
        if(rst_p) begin start<=0; sample<=0; data_valid<=0; end
        else begin
            start<=!busy && !start;
            data_valid<=done;
            if(done) sample<=rx_word[11:0];
        end
    end
    assign led_out=sample[11:4];
endmodule
