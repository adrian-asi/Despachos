using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ControlDespachos.Core.Entities;
using ControlDespachos.Core.Interfaces;
using ControlDespachos.Data;
using Microsoft.EntityFrameworkCore;

namespace ControlDespachos.Services
{
    public class NotaService : INotaService
    {
        private readonly ApplicationDbContext _context;

        public NotaService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Nota>> GetByOvAsync(string ovId)
        {
            return await _context.Notas
                .Include(n => n.Imagenes)
                .Where(n => n.OvId == ovId)
                .OrderByDescending(n => n.FechaHora)
                .ToListAsync();
        }

        public async Task<Nota> CreateAsync(Nota nota)
        {
            _context.Notas.Add(nota);
            await _context.SaveChangesAsync();
            return nota;
        }

        public async Task<IDictionary<string, int>> GetContadoresAsync()
        {
            return await _context.Notas
                .GroupBy(n => n.OvId)
                .Select(g => new { OvId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.OvId, x => x.Count);
        }
    }
}
