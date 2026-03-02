using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ControlDespachos.Core.Entities;
using ControlDespachos.Core.Enums;

namespace ControlDespachos.Services
{
    public interface IOrdenVentaService
    {
        Task<IEnumerable<OrdenVenta>> GetOrdenesPendientesAsync(Guid userId, string userRole);
        Task<bool> EmitirGreAsync(Guid ovId, int cantidad, Guid emisorId);
    }

    public class OrdenVentaService : IOrdenVentaService
    {
        // En un proyecto real inyectaríamos el IRepository correspondiente y DbContext.
        // private readonly IOrdenVentaRepository _repository;
        // private readonly IGuiaRemisionRepository _greRepository;

        public async Task<IEnumerable<OrdenVenta>> GetOrdenesPendientesAsync(Guid userId, string userRole)
        {
            // Lógica de validación de RLS implementada en el Backend de apoyo o confiando en Supabase RLS.
            // Si el rol es VENDEDOR, la consulta solo trae OVs solicitadas por él.
            // Si es OPERADOR, trae todas las Pendientes/Urgentes/Vencidas.
            throw new NotImplementedException("Requiere Entity Framework DbContext con token de Supabase.");
        }

        public async Task<bool> EmitirGreAsync(Guid ovId, int cantidad, Guid emisorId)
        {
            // Regla de Negocio: Validar que la OV no esté inactiva o cerrada.
            // Regla de Negocio: La cantidad emitida no puede superar el saldo pendiente de la OV.
            // Si la emisión de esta GRE cubre el 100% de la cantidad, = COMPLETO, sino = PARCIAL.
            
            // var ov = await _repository.GetByIdAsync(ovId);
            // if (ov.Estado == EstadoOV.CERRADA) throw new Exception("OV Cerrada");

            // var nuevaGre = new GuiaRemision {
            //      OvId = ovId,
            //      CantidadEmitida = cantidad,
            //      EmitidaPor = emisorId,
            //      EstadoGre = cantidad == ov.Cantidad ? "COMPLETO" : "PARCIAL" 
            // };
            // await _greRepository.AddAsync(nuevaGre);
            
            // ov.Estado = EstadoOV.EMITIDA;
            // await _repository.UpdateAsync(ov);

            return true;
        }
    }
}
