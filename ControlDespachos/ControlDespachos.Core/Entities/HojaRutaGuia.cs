using System;

namespace ControlDespachos.Core.Entities
{
    public class HojaRutaGuia
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid? HojaRutaId { get; set; }
        public HojaRuta HojaRuta { get; set; }
        
        public Guid? GuiaId { get; set; }
        public GuiaRemision GuiaRemision { get; set; }
    }
}
