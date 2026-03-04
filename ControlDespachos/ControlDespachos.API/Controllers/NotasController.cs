using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using ControlDespachos.Core.Entities;
using ControlDespachos.Core.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace ControlDespachos.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotasController : ControllerBase
    {
        private readonly INotaService _notaService;

        public NotasController(INotaService notaService)
        {
            _notaService = notaService;
        }

        [HttpGet("{ovId}")]
        public async Task<ActionResult<IEnumerable<Nota>>> GetByOv(string ovId)
        {
            try
            {
                var notas = await _notaService.GetByOvAsync(ovId);
                return Ok(notas);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno: {ex.Message}");
            }
        }

        [HttpPost]
        public async Task<ActionResult<Nota>> Create(Nota nota)
        {
            try
            {
                // Asegurar que la fecha se asigne en el servidor
                nota.FechaHora = DateTime.Now;
                var createdNota = await _notaService.CreateAsync(nota);
                return CreatedAtAction(nameof(GetByOv), new { ovId = nota.OvId }, createdNota);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al guardar nota: {ex.Message}");
            }
        }

        [HttpGet("contadores")]
        public async Task<ActionResult<IDictionary<string, int>>> GetContadores()
        {
            try
            {
                var contadores = await _notaService.GetContadoresAsync();
                return Ok(contadores);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al obtener contadores: {ex.Message}");
            }
        }
    }
}
