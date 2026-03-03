using System;
using System.Collections.Generic;

namespace ControlDespachos.Core.Entities
{
    public class Role
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Nombre { get; set; } // VENDEDOR, OPERADOR_ALMACEN
        
        public ICollection<User> Users { get; set; }
    }
}
