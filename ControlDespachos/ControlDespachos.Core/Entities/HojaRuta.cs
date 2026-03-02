using System;
using System.Collections.Generic;

namespace ControlDespachos.Core.Entities
{
    public class HojaRuta
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public DateTime Fecha { get; set; }
        public string Turno { get; set; } // AM, PM
        public string Chofer { get; set; }
        public string Estado { get; set; } // ABIERTA, EN_RUTA, CERRADA
        
        public DateTime CreatedAt { get; set; }
        
        public ICollection<HojaRutaGuia> GuiasAsignadas { get; set; } = new List<HojaRutaGuia>();
    }
    
    public class HojaRutaGuia
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid HojaRutaId { get; set; }
        public HojaRuta HojaRuta { get; set; }
        
        public Guid GuiaId { get; set; }
        public GuiaRemision Guia { get; set; }
    }
}
