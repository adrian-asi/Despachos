using System;

namespace ControlDespachos.Core.Entities
{
    public class NotaImagen
    {
        public int Id { get; set; }
        public int NotaId { get; set; }
        public string Base64Data { get; set; } = string.Empty; // Formato "data:image/png;base64,..."
        
        // Relaciones
        public virtual Nota? Nota { get; set; }
    }
}
