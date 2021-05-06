`timescale 1ns / 1ps



module clkSemaforo 
#(
   /* si p=10ns y queremos 10 ms
  10ms / 10ns = 1M / 2 = 500k
  log(500^3)/log(2) = 18.93 => 19 bits para abarcar */
  parameter COUNTER_COMPARE = 50_000_000

)
(
    clk,
    rst,
    sentido,
    acelerar,
    sArriba,
    sAbajo,
    sIzquierda,
    sDerecha
   
    
    );
    
    input clk;
    input rst;
    input sentido; // Switch que determina si van en sentido del reloj o antihorario (Default es antihorario)
    input acelerar; // Botón que interrumpe el estado y apresura el paso al sig
    
    //Semáforos
    //Necesitan ser salidas & registros
    output wire [2:0] sArriba;
    output wire [2:0] sAbajo;
    output wire [2:0] sIzquierda;
    output wire [2:0] sDerecha;
    
    wire equal;
    wire subClock;
    
    countCompare
  #(
    .NBITS (26)
  ) count
  (
    .clk (clk),
    .rst (!rst),
    .compareValue (COUNTER_COMPARE),
    .equal (equal)
  );

  ffT FFTCLK
  (
    .clk (clk),
    .rst (!rst),
    .t (equal),
    .q (subClock)
  );
  
  
  cruceSemaforos CRUCE(
    .clk(subClock),
    .rst(rst),
    .sentido(sentido),
    .acelerar(acelerar),
    .sArriba(sArriba),
    .sAbajo(sAbajo),
    .sIzquierda(sIzquierda),
    .sDerecha(sDerecha)
   
    
    );
    
endmodule