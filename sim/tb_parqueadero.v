`timescale 1ns / 1ps

module tb_parqueadero;

    // Señales de prueba
    reg        clk;
    reg        rst_n;
    reg  [3:0] switches_prueba;
    wire [2:0] leds_cupos_libres;
    wire       pin_servo_pwm;

    // Instancia de tu proyecto completo
    top_parqueadero dut (
        .clk               (clk),
        .rst_n             (rst_n),
        .switches_prueba   (switches_prueba),
        .leds_cupos_libres (leds_cupos_libres),
        .pin_servo_pwm     (pin_servo_pwm)
    );

    // Generación del reloj de 50 MHz (periodo = 20 ns -> cambia cada 10 ns)
    always #10 clk = ~clk;

    initial begin
        // 1. Estado inicial: Reset presionado, todos los cupos libres (0000)
        clk = 0;
        rst_n = 0;
        switches_prueba = 4'b0000;
        #100;

        // 2. Soltamos el reset: deben haber 4 cupos libres y el servo abriendo (pulso de 2 ms)
        rst_n = 1;
        #25_000_000; // Esperamos 25 ms (más de un periodo completo de 20 ms del servo)

        // 3. Se ocupan 2 cupos (0011): deben quedar 2 cupos libres y el servo sigue abierto
        switches_prueba = 4'b0011;
        #25_000_000;

        // 4. Se ocupan los 4 cupos (1111): 0 cupos libres y el servo debe cerrar (pulso de 1 ms)
        switches_prueba = 4'b1111;
        #25_000_000;

        $stop; // Detiene la simulación
    end

endmodule