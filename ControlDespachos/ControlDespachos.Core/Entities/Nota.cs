using System;
using System.Collections.Generic;

namespace ControlDespachos.Core.Entities
{
    public class Nota
    {
        public int Id { get; set; }
        public string OvId { get; set; } = string.Empty;
        public string OvNum { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;
        public string UserRole { get; set; } = string.Empty;
        public string Texto { get; set; } = string.Empty;
        public DateTime FechaHora { get; set; } = DateTime.Now;
        
        // Relaciones
        public virtual ICollection<NotaImagen> Imagenes { get; set; } = new List<NotaImagen>();
    }
}
