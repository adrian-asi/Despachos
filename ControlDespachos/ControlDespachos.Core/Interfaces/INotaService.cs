using System.Collections.Generic;
using System.Threading.Tasks;
using ControlDespachos.Core.Entities;

namespace ControlDespachos.Core.Interfaces
{
    public interface INotaService
    {
        Task<IEnumerable<Nota>> GetByOvAsync(string ovId);
        Task<Nota> CreateAsync(Nota nota);
        Task<IDictionary<string, int>> GetContadoresAsync();
    }
}
