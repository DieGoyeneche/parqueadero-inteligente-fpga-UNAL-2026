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
    control_parqueadero u_control (
        .clk               (clk),
        .rst_n             (rst_n),
        .sensores_ocupados (switches_prueba),
        .sensor_entrada    (1'b1),
        .cupos_libres      (leds_cupos_libres),
        .abrir_barrera     (senal_abrir_barrera)
    );

    // 2. Instancia del módulo PWM del servomotor
    servo_pwm u_servo (
        .clk     (clk),
        .rst_n   (rst_n),
        .abrir   (senal_abrir_barrera),
        .pwm_out (pin_servo_pwm)
    );

endmodule
