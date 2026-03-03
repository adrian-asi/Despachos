using System;
using System.Collections.Generic;

namespace ControlDespachos.Core.Entities
{
    public class HojaRuta
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public DateTime Fecha { get; set; } = DateTime.Today;
        public string Turno { get; set; } // AM, PM
        public string Chofer { get; set; }
        public string Estado { get; set; } // ABIERTA, EN_RUTA, CERRADA
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public ICollection<HojaRutaGuia> Guias { get; set; }
    }
}
