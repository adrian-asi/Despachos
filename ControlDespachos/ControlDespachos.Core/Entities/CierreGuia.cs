using System;

namespace ControlDespachos.Core.Entities
{
    public class CierreGuia
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid? GuiaId { get; set; }
        public GuiaRemision GuiaRemision { get; set; }
        public TimeSpan HoraInicio { get; set; }
        public decimal? KmInicio { get; set; }
        public TimeSpan HoraFin { get; set; }
        public decimal? KmFin { get; set; }
        public string Observaciones { get; set; }
        public bool DocumentosEntregados { get; set; }
        public string EstadoEntrega { get; set; } // COMPLETO, PARCIAL, NO_RECIBIDO
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
