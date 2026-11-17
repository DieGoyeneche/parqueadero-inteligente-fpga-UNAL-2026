module top_parqueadero (
    input  wire       clk,               // Reloj 50 MHz (Pin físico de la FPGA)
    input  wire       rst_n,             // Botón de Reset (Pin físico)
    input  wire [3:0] switches_prueba,   // Switches físicos para probar sin sensores aún
    output wire [2:0] leds_cupos_libres, // LEDs físicos para ver los cupos disponibles
    output wire       pin_servo_pwm      // Pin físico hacia el servomotor
);

    // Cable interno que une ambos módulos
    wire senal_abrir_barrera;

    // 1. Instancia del módulo de control y conteo
	 // u_control es nombre de instancia. Etiquetas para identificar cada bloque en el diagrama esquemático de Quartus. 
	 // formato: .puerto_del_modulo (cable_del_top)
    control_parqueadero u_control (
        .clk               (clk),
        .reset_n           (rst_n),
        .espacios_ocupados (switches_prueba),
        .sensor_entrada    (1'b1),
        .cupos_libres      (leds_cupos_libres),
        .abrir_barrera     (senal_abrir_barrera)
    );

    // 2. Instancia del módulo PWM del servomotor
	 // u_control es nombre de instancia. Etiquetas para identificar cada bloque en el diagrama esquemático de Quartus. 
    servo_pwm u_servo (
        .clk     			 (clk),
        .reset_n   		 (rst_n),
        .abrir_barrera   (senal_abrir_barrera),
        .pwm_out 			 (pin_servo_pwm)
    );

endmodule
