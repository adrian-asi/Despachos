using System;
using System.Collections.Generic;
using ControlDespachos.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace ControlDespachos.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Role> Roles { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<OrdenVenta> OrdenesVenta { get; set; }
        public DbSet<GuiaRemision> GuiasRemision { get; set; }
        public DbSet<HojaRuta> HojasRuta { get; set; }
        public DbSet<HojaRutaGuia> HojaRutaGuias { get; set; }
        public DbSet<CierreGuia> CierresGuia { get; set; }
        public DbSet<CierreHojaRuta> CierresHojaRuta { get; set; }
        public DbSet<AdjuntoGuia> AdjuntosGuias { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Role>(entity =>
            {
                entity.ToTable("roles");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Nombre).IsRequired().HasMaxLength(50);
                entity.HasIndex(e => e.Nombre).IsUnique();
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(255);
                entity.HasIndex(e => e.Email).IsUnique();
                
                entity.HasOne(d => d.Role)
                    .WithMany(p => p.Users)
                    .HasForeignKey(d => d.RoleId);
            });

            modelBuilder.Entity<OrdenVenta>(entity =>
            {
                entity.ToTable("ordenes_venta");
                entity.HasKey(e => e.Id);
                entity.HasIndex(e => e.NumeroOv).IsUnique();
                entity.Property(e => e.Estado).HasConversion<string>();
            });

            modelBuilder.Entity<GuiaRemision>(entity =>
            {
                entity.ToTable("guias_remision");
                entity.HasKey(e => e.Id);
                entity.HasIndex(e => e.NumeroGre).IsUnique();
                
                entity.HasOne(d => d.OrdenVenta)
                    .WithMany()
                    .HasForeignKey(d => d.OvId);
                    
                entity.HasOne(d => d.EmitidaPorUser)
                    .WithMany()
                    .HasForeignKey(d => d.EmitidaPor);
            });

            modelBuilder.Entity<HojaRuta>(entity =>
            {
                entity.ToTable("hojas_ruta");
                entity.HasKey(e => e.Id);
            });

            modelBuilder.Entity<HojaRutaGuia>(entity =>
            {
                entity.ToTable("hoja_ruta_guias");
                entity.HasKey(e => e.Id);
                entity.HasIndex(e => new { e.HojaRutaId, e.GuiaId }).IsUnique();
                
                entity.HasOne(d => d.HojaRuta)
                    .WithMany(p => p.Guias)
                    .HasForeignKey(d => d.HojaRutaId);
                    
                entity.HasOne(d => d.GuiaRemision)
                    .WithMany()
                    .HasForeignKey(d => d.GuiaId);
            });

            modelBuilder.Entity<CierreGuia>(entity =>
            {
                entity.ToTable("cierre_guias");
                entity.HasKey(e => e.Id);
                
                entity.HasOne(d => d.GuiaRemision)
                    .WithMany()
                    .HasForeignKey(d => d.GuiaId);
            });

            modelBuilder.Entity<CierreHojaRuta>(entity =>
            {
                entity.ToTable("cierre_hoja_ruta");
                entity.HasKey(e => e.Id);
                
                entity.HasOne(d => d.HojaRuta)
                    .WithMany()
                    .HasForeignKey(d => d.HojaRutaId);
            });

            modelBuilder.Entity<AdjuntoGuia>(entity =>
            {
                entity.ToTable("adjuntos_guias");
                entity.HasKey(e => e.Id);
                
                entity.HasOne(d => d.GuiaRemision)
                    .WithMany()
                    .HasForeignKey(d => d.GuiaId);
            });
        }
    }
}
