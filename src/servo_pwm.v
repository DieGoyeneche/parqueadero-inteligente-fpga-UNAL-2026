module servo_pwm (
    input  wire clk,        		// Reloj de 50 MHz de la Cyclone IV
    input  wire reset_n,    		// Reset activo en bajo (botón de la tarjeta)
    input  wire abrir_barrera,   // 1 = Abrir barrera, 0 = Cerrar barrera
    output reg  pwm_out     		// Señal hacia el cable naranja/amarillo del servo
);

    // Parámetros para reloj de 50 MHz (20 ns por ciclo)
	 //localparam crea constantes del módulo para no dejar números sueltos dentro de la lógica
    localparam PERIODO_20MS = 20'd1_000_000; // El servomotor funciona a 50 Hz, lo que equivale a 20 ms -> Indica la cantidad de ciclos que entrega la FPGA en ese tiempo.
    localparam PULSO_CERRAR = 20'd50_000;    // 1.0 ms (0 grados)
    localparam PULSO_ABRIR  = 20'd100_000;   // 2.0 ms (90-180 grados)

    //Señales internas del módulo. Por eso no es necesario darles una entrada o salida
	 reg [19:0] contador;		//tipo reg hace uso de memoria. Cronometro. Contará desde 0 a 999_999.
    wire [19:0] ancho_pulso;	//Sin memoria. Meta. 

    //Uso de multiplexor. Si abrir_barrera == 1, se abre. Si abrir_barrera == 0, se cierra la talanquera 
	 assign ancho_pulso = (abrir_barrera) ? PULSO_ABRIR : PULSO_CERRAR;
	
    always @(posedge clk or negedge reset_n) begin		//Se activa cuando el reloj suba de 0 a 1, o cuando el botón reset baje de 1 a 0
        
		  //Cuando reset_n == 0, entra en un estado inicial seguro
		  if (!reset_n) begin							
            contador <= 20'd0;						//El contador inicia en 0
            pwm_out  <= 1'b0;							//La salida PWM se apaga (0)
        end 
		  
		  //Funcionamiento normal (cuando reset_n no está presionado)
		  else begin
            if (contador < PERIODO_20MS - 1)		//Si el contador es menor que 1_000_000
                contador <= contador + 20'd1;	//Aumenta contador de 1 en 1
            else
                contador <= 20'd0;					//De lo contrario, sea contador == 0

            // Genera el pulso alto durante el tiempo seleccionado
            if (contador < ancho_pulso)
                pwm_out <= 1'b1;						//Se activa la señal de la barrera (3.3 V)
            else
                pwm_out <= 1'b0;						//Se desactiva la señal de la barrera (0 V)
        end
    end

endmodule
