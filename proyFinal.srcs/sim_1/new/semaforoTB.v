`timescale 1ns / 1ps

module cruceSemaforosTB( );
    reg clk;
    reg rst;
    reg acelerar;
    reg sentido;
    wire [2:0] sArriba;
    wire [2:0] sAbajo;
    wire [2:0] sIzquierda;
    wire [2:0] sDerecha;
    
    cruceSemaforos DUT(
        .clk (clk),
        .rst (rst),
        .sentido(sentido),
        .acelerar (acelerar),
        .sArriba (sArriba),
        .sAbajo (sAbajo),
        .sIzquierda (sIzquierda),
        .sDerecha (sDerecha)
    );
    
     always begin
    #1 clk = ~clk;
      end
    
      initial begin
        clk = 0;
        rst = 0;
        acelerar = 0;
        sentido = 0;
        
        
    
        #10
        rst = 1;
    
        #10
        rst = 0;
        
        #1
        acelerar = 1;
        
        #10
        sentido = 1;
        
        #200
        $stop;
        end

endmodule
