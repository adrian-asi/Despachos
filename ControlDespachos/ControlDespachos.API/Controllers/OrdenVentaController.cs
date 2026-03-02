using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using ControlDespachos.Services;

namespace ControlDespachos.API.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    // [Authorize] // En un caso real se configura AddJwtBearer para verificar el token de Supabase.
    public class OrdenVentaController : ControllerBase
    {
        private readonly IOrdenVentaService _servicio;

        public OrdenVentaController(IOrdenVentaService servicio)
        {
            _servicio = servicio;
        }

        [HttpGet("pendientes")]
        public async Task<IActionResult> GetPendientes()
        {
            try
            {
                // Obtenemos el ID de usuario desde los claims de Supabase inyectados en HttpContext
                // var userId = Guid.Parse(User.FindFirst("sub")?.Value);
                // var userRole = User.FindFirst("role")?.Value;

                var ordenes = await _servicio.GetOrdenesPendientesAsync(Guid.NewGuid(), "OPERADOR_ALMACEN");
                return Ok(ordenes);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpPost("{id}/emitir")]
        public async Task<IActionResult> EmitirGRE(Guid id, [FromBody] int cantidad)
        {
            try
            {
                // var userId = Guid.Parse(User.FindFirst("sub")?.Value);
                var resultado = await _servicio.EmitirGreAsync(id, cantidad, Guid.NewGuid());
                return Ok(new { success = resultado, message = "Guía emitida correctamente" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
