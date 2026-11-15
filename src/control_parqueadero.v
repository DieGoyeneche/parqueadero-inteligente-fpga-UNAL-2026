module control_parqueadero (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] sensores_ocupados, // 1 = Ocupado, 0 = Libre (4 cupos)
    input  wire       sensor_entrada,    // 1 = Carro esperando en la barrera (opcional/switch)
    output reg  [2:0] cupos_libres,      // Cantidad de espacios disponibles (0 a 4)
    output reg        abrir_barrera      // Señal de control para el módulo servo_pwm
);

    // Cálculo combinacional de espacios libres (inverso de ocupados)
    wire [3:0] libres_vec = ~sensores_ocupados;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cupos_libres  <= 3'd4;
            abrir_barrera <= 1'b0;
        end else begin
            // Suma de bits libres
            cupos_libres <= libres_vec[0] + libres_vec[1] + libres_vec[2] + libres_vec[3];

            // Lógica de apertura: abre si hay al menos 1 cupo libre
            // (Si usan sensor de entrada, cambien a: (cupos_libres > 3'd0) && sensor_entrada)
            if (cupos_libres > 3'd0)
                abrir_barrera <= 1'b1;
            else
                abrir_barrera <= 1'b0;
        end
    end

endmodule
