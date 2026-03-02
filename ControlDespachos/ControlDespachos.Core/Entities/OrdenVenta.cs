using System;

namespace ControlDespachos.Core.Entities
{
    public class OrdenVenta
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string NumeroOv { get; set; }
        public DateTime FechaCreacion { get; set; }
        public TimeSpan HoraCreacion { get; set; }
        public string OcCotizacion { get; set; }
        public string NumeroOt { get; set; }
        public string ClienteId { get; set; }
        public string ClienteNombre { get; set; }
        public string DomicilioDestino { get; set; }
        public string Distrito { get; set; }
        public string Pais { get; set; }
        public string PiezaCodigo { get; set; }
        public string PiezaDescripcion { get; set; }
        public int Cantidad { get; set; }
        public string Udm { get; set; }
        public string SolicitadoPor { get; set; }
        public string AreaSolicitante { get; set; }
        public string LineaProductiva { get; set; }
        public string AlmacenOrigen { get; set; }
        public string CourierSugerido { get; set; }
        public DateTime FechaNecesidad { get; set; }
        public Enums.EstadoOV Estado { get; set; }
        
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
