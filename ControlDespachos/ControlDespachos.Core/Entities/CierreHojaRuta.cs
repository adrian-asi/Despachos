using System;

namespace ControlDespachos.Core.Entities
{
    public class CierreHojaRuta
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid? HojaRutaId { get; set; }
        public HojaRuta HojaRuta { get; set; }
        public decimal? KmTotal { get; set; }
        public TimeSpan HoraCierre { get; set; }
        public string ObservacionesFinales { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
