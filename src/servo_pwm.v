module servo_pwm (
    input  wire clk,        // Reloj de 50 MHz de la Cyclone IV
    input  wire rst_n,      // Reset activo en bajo (botón de la tarjeta)
    input  wire abrir,      // 1 = Abrir barrera, 0 = Cerrar barrera
    output reg  pwm_out     // Señal hacia el cable naranja/amarillo del servo
);

    // Parámetros para reloj de 50 MHz (20 ns por ciclo)
    localparam PERIODO_20MS = 20'd1_000_000; // 20 ms
    localparam PULSO_CERRAR = 20'd50_000;    // 1.0 ms (0 grados)
    localparam PULSO_ABRIR  = 20'd100_000;   // 2.0 ms (90-180 grados)

    reg [19:0] contador;
    wire [19:0] ancho_pulso;

    assign ancho_pulso = (abrir) ? PULSO_ABRIR : PULSO_CERRAR;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            contador <= 20'd0;
            pwm_out  <= 1'b0;
        end else begin
            if (contador < PERIODO_20MS - 1)
                contador <= contador + 20'd1;
            else
                contador <= 20'd0;

            // Genera el pulso alto durante el tiempo seleccionado
            if (contador < ancho_pulso)
                pwm_out <= 1'b1;
            else
                pwm_out <= 1'b0;
        end
    end

endmodule
