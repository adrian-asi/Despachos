using System;

namespace ControlDespachos.Core.Entities
{
    public class AdjuntoGuia
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid? GuiaId { get; set; }
        public GuiaRemision GuiaRemision { get; set; }
        public string NombreArchivo { get; set; }
        public string UrlStorage { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
