`timescale 1ns / 1ps

module cruceSemaforos(
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
    
    //Notas: Acelerar se condiciona en los estados verdes y el sentido en los estados amarillos
    
    //Semáforos
    //Necesitan ser salidas & registros
    output reg [2:0] sArriba;
    output reg [2:0] sAbajo;
    output reg [2:0] sIzquierda;
    output reg [2:0] sDerecha;
    
    //Estados de los semáforos
    parameter S1 = 0, S2 = 1, S3 = 2, S4 = 3, S5 = 4, S6 = 5, S7 = 6, S8 = 7;  
    
    //Registros
    reg [3:0] count;
    reg [2:0] actualState;
    
    //Tiempo de luces
    parameter tiempoA = 2, tiempoV = 7; //Tiempo en amarillo 2 seg - Verde 7 seg
    
    //----------ESTADOS
    always @ (posedge clk or posedge rst)
    begin
        if(rst == 1) begin //reset activo, inicializando
            actualState <= S1; //Set al primer estado
            count <= 0;        //Comienzo de la cuenta en 0
        end
        //Si no está en reset, revisamos los estados
        else begin
        
            case (actualState)
            
            //Semaforo de ARRIBA / SEMÁFORO 1
                S1: //Semaforo arriba verde 
                    if(acelerar == 0) begin
                        if(count < tiempoV) begin //Si aun no pasa el tiempo en Verde
                            actualState <= S1; //Continua
                            count <= count + 1; //Sigue contando
                        end
                        else begin //Se cumple el tiempo V
                            actualState <= S2; //Siguiente estado
                            count <= 0; //Reset del count              
                        end
                    end
                    else begin
                        actualState <= S2; //Siguiente estado
                        count <= 0; //Reset del count  
                    end
                S2: //Semaforo arriba amarillo                   
                    if(count < tiempoA) begin //Si aun no pasa el tiempo en Amarillo
                        actualState <= S2; //Continua
                        count <= count + 1; //Sigue contando
                    end
                    else begin //Se cumple el tiempo A
                        if (sentido == 0) begin //Sentido antihorario 
                            actualState <= S3; //Siguiente estado
                            count <= 0; //Reset del count 
                        end
                        else begin //Sentido horario
                            actualState <= S7; //Siguiente estado
                            count <= 0; //Reset del count 
                        end
                                     
                    end
              
              //Semaforo Izquierda / SEMAFORO 2
                S3: //Semaforo izquierda verde
                    if (acelerar == 0) begin
                        if(count < tiempoV) begin //Si aun no pasa el tiempo en Verde
                            actualState <= S3; //Continua
                            count <= count + 1; //Sigue contando
                        end
                        else begin //Se cumple el tiempo V
                            actualState <= S4; //Siguiente estado
                            count <= 0; //Reset del count              
                        end
                    end
                    else begin
                            actualState <= S4; //Siguiente estado
                            count <= 0; //Reset del count  
                    end
                S4: //Semaforo izquierda amarillo
                    if(count < tiempoA) begin //Si aun no pasa el tiempo en Amarillo
                        actualState <= S4; //Continua
                        count <= count + 1; //Sigue contando
                    end
                    else begin //Se cumple el tiempo A
                        if (sentido == 0) begin //Sentido antihorario
                            actualState <= S5; //Siguiente estado
                            count <= 0; //Reset del count 
                        end
                        else begin //Sentido horario
                            actualState <= S1; //Siguiente estado
                            count <= 0; //Reset del count 
                        end
                                     
                    end
                    
                    
               //Semaforo Abajo / SEMAFORO 3
                S5: //Semaforo abajo verde
                    if(acelerar == 0) begin                                        
                        if(count < tiempoV) begin //Si aun no pasa el tiempo en Verde
                            actualState <= S5; //Continua 
                            count <= count + 1; //Sigue contando
                        end
                        else begin //Se cumple el tiempo V
                            actualState <= S6; //Siguiente estado
                            count <= 0; //Reset del count              
                        end
                    end
                    else begin
                        actualState <= S6; //Siguiente estado
                        count <= 0; //Reset del count 
                    end 
                     
                S6: //Semaforo abajo amarillo
                    if(count < tiempoA) begin //Si aun no pasa el tiempo en Amarillo
                        actualState <= S6; //Continua 
                        count <= count + 1; //Sigue contando
                    end
                    else begin //Se cumple el tiempo A
                        if ( sentido == 0 )begin //Sentido antihorario
                            actualState <= S7; //Siguiente estado
                            count <= 0; //Reset del count    
                        end
                        else begin //Sentido horario
                            actualState <= S3; //Siguiente estado
                            count <= 0; //Reset del count   
                        end                          
                    end
                    
                
                
                //Semaforo Derecha / SEMAFORO 4
                S7: //Semaforo derecha verde
                    if(acelerar == 0) begin
                        if(count < tiempoV) begin //Si aun no pasa el tiempo en Verde
                            actualState <= S7; //Continua 
                            count <= count + 1; //Sigue contando
                        end
                        else begin //Se cumple el tiempo V
                            actualState <= S8; //Siguiente estado
                            count <= 0; //Reset del count              
                        end
                    end
                    else begin
                         actualState <= S8; //Siguiente estado
                         count <= 0; //Reset del count    
                    end
                   
                S8: //Semaforo abajo amarillo
                    if(count < tiempoA) begin //Si aun no pasa el tiempo en Amarillo
                        actualState <= S8; //Continua 
                        count <= count + 1; //Sigue contando
                    end
                    else begin //Se cumple el tiempo A
                        if (sentido == 0) begin //Sentido antihorario
                            actualState <= S1; //REGRESA AL PRIMERO
                            count <= 0; //Reset del count        
                        end
                        else begin //Sentido horario
                            actualState <= S5; 
                            count <= 0; //Reset del count   
                        end
                              
                    end
                    
                default actualState <= S1;
            endcase            
           
        end
    end
    
    
     always @ (actualState) //Asignando las luces!
        begin
    
            case(actualState)
                
                S1:
                begin
                    sArriba <= 3'b001; //Verde
                    sIzquierda <= 3'b100; //Rojo
                    sAbajo <= 3'b100; //Rojo
                    sDerecha <= 3'b100; //Rojo                   
                end
                
                S2:
                begin
                    sArriba <= 3'b010; //Anarillo
                    sIzquierda <= 3'b100; //Rojo
                    sAbajo <= 3'b100; //Rojo
                    sDerecha <= 3'b100; //Rojo                   
                end
                
                S3:
                begin
                    sArriba <= 3'b100; //Rojo
                    sIzquierda <= 3'b001; //Verde
                    sAbajo <= 3'b100; //Rojo
                    sDerecha <= 3'b100; //Rojo                   
                end
                
                S4:
                begin
                    sArriba <= 3'b100; //Rojo
                    sIzquierda <= 3'b010; //Amarillo
                    sAbajo <= 3'b100; //Rojo
                    sDerecha <= 3'b100; //Rojo                   
                end
                
                S5:
                begin
                    sArriba <= 3'b100; //Rojo
                    sIzquierda <= 3'b100; //Rojo
                    sAbajo <= 3'b001; //Verde
                    sDerecha <= 3'b100; //Rojo                   
                end
                
                S6:
                begin
                    sArriba <= 3'b100; //Rojo
                    sIzquierda <= 3'b100; //Rojo
                    sAbajo <= 3'b010; //Amarillo
                    sDerecha <= 3'b100; //Rojo                   
                end
                
                S7:
                begin
                    sArriba <= 3'b100; //Rojo
                    sIzquierda <= 3'b100; //Rojo
                    sAbajo <= 3'b100; //Rojo
                    sDerecha <= 3'b001; //Verde                   
                end
                
                S8:
                begin
                    sArriba <= 3'b100; //Rojo
                    sIzquierda <= 3'b100; //Rojo
                    sAbajo <= 3'b100; //Rojo
                    sDerecha <= 3'b010; //Amarillo                   
                end
                
                default:
                begin
                    sArriba <= 3'b000; //Rojo
                    sIzquierda <= 3'b000; //Rojo
                    sAbajo <= 3'b000; //Rojo
                    sDerecha <= 3'b000; //Rojo    
                end 
                
                
                
            endcase
            
                    
        end
    
endmodule
