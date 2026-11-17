module control_parqueadero (
    input  wire       clk,
    input  wire       reset_n,			  // Reset negado -> Se activa con 0. De modo que es reset_n = 1.
    input  wire [3:0] espacios_ocupados, // Espacios del parqueadero (4 cupos). 1 = Ocupado, 0 = Libre
    input  wire       sensor_entrada,    // Entrada que detecta un carro en el ingreso del parqueadero. 1 = Carro esperando en la barrera (opcional/switch)
    output reg  [2:0] cupos_libres,      // Cantidad de espacios disponibles (0 a 4)
    output reg        abrir_barrera      // Señal de control para el módulo servo_pwm
);

    // Cálculo combinacional de espacios libres (inverso de ocupados)
    wire [3:0] espacios_libres = ~espacios_ocupados;		//Invierte bit a bit los 4 sensores

    always @(posedge clk or negedge reset_n) begin			//Se activa cuando el reloj suba de 0 a 1, o cuando el botón reset baje de 1 a 0
        
		  //Cuando reset_n == 0, entra en un estado inicial seguro
		  if (!reset_n) begin				  								
            cupos_libres  <= 3'd4;		  //Todos los cupos están disponibles
            abrir_barrera <= 1'b0;		  //La barrera se baja
        end 
		  
		  //Funcionamiento normal (cuando reset_n no está presionado)
		  else begin
            // Suma de puestos libres
            cupos_libres <= espacios_libres[0] + espacios_libres[1] + espacios_libres[2] + espacios_libres[3];

            // Lógica de apertura: abre si hay al menos 1 cupo libre
            // (Si usan sensor de entrada, cambien a: (cupos_libres > 3'd0) && sensor_entrada)
            if (cupos_libres > 3'd0)
                abrir_barrera <= 1'b1;
            else
                abrir_barrera <= 1'b0;
        end
    end

endmodule
