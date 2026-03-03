using System;

namespace ControlDespachos.Core.Entities
{
    public class GuiaRemision
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string NumeroGre { get; set; }
        public Guid? OvId { get; set; }
        public OrdenVenta OrdenVenta { get; set; }
        
        public DateTime FechaEmision { get; set; } = DateTime.Today;
        public TimeSpan HoraEmision { get; set; } = DateTime.Now.TimeOfDay;
        public int CantidadEmitida { get; set; }
        public string EstadoGre { get; set; } // PARCIAL, COMPLETO
        
        public Guid? EmitidaPor { get; set; }
        public User EmitidaPorUser { get; set; }
        public bool Programada { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
