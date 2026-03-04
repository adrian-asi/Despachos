using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ControlDespachos.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddNotasTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "hojas_ruta",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Fecha = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Turno = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Chofer = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Estado = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_hojas_ruta", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ordenes_venta",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    NumeroOv = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime2", nullable: false),
                    HoraCreacion = table.Column<TimeSpan>(type: "time", nullable: false),
                    OcCotizacion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NumeroOt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ClienteId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ClienteNombre = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DomicilioDestino = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Distrito = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Pais = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PiezaCodigo = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PiezaDescripcion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Cantidad = table.Column<int>(type: "int", nullable: false),
                    Udm = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SolicitadoPor = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AreaSolicitante = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LineaProductiva = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AlmacenOrigen = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CourierSugerido = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FechaNecesidad = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Estado = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ordenes_venta", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "roles",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Nombre = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "cierre_hoja_ruta",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    HojaRutaId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    KmTotal = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    HoraCierre = table.Column<TimeSpan>(type: "time", nullable: false),
                    ObservacionesFinales = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_cierre_hoja_ruta", x => x.Id);
                    table.ForeignKey(
                        name: "FK_cierre_hoja_ruta_hojas_ruta_HojaRutaId",
                        column: x => x.HojaRutaId,
                        principalTable: "hojas_ruta",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "notas",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OvId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    OvNum = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    UserName = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: false),
                    UserRole = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Texto = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FechaHora = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_notas", x => x.Id);
                    table.ForeignKey(
                        name: "FK_notas_ordenes_venta_OvId",
                        column: x => x.OvId,
                        principalTable: "ordenes_venta",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "users",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    Activo = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_users_roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "roles",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "nota_imagenes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NotaId = table.Column<int>(type: "int", nullable: false),
                    Base64Data = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_nota_imagenes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_nota_imagenes_notas_NotaId",
                        column: x => x.NotaId,
                        principalTable: "notas",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "guias_remision",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    NumeroGre = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    OvId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    FechaEmision = table.Column<DateTime>(type: "datetime2", nullable: false),
                    HoraEmision = table.Column<TimeSpan>(type: "time", nullable: false),
                    CantidadEmitida = table.Column<int>(type: "int", nullable: false),
                    EstadoGre = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    EmitidaPor = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    Programada = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_guias_remision", x => x.Id);
                    table.ForeignKey(
                        name: "FK_guias_remision_ordenes_venta_OvId",
                        column: x => x.OvId,
                        principalTable: "ordenes_venta",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_guias_remision_users_EmitidaPor",
                        column: x => x.EmitidaPor,
                        principalTable: "users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "adjuntos_guias",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    GuiaId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    NombreArchivo = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UrlStorage = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_adjuntos_guias", x => x.Id);
                    table.ForeignKey(
                        name: "FK_adjuntos_guias_guias_remision_GuiaId",
                        column: x => x.GuiaId,
                        principalTable: "guias_remision",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "cierre_guias",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    GuiaId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    HoraInicio = table.Column<TimeSpan>(type: "time", nullable: false),
                    KmInicio = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    HoraFin = table.Column<TimeSpan>(type: "time", nullable: false),
                    KmFin = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    Observaciones = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DocumentosEntregados = table.Column<bool>(type: "bit", nullable: false),
                    EstadoEntrega = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_cierre_guias", x => x.Id);
                    table.ForeignKey(
                        name: "FK_cierre_guias_guias_remision_GuiaId",
                        column: x => x.GuiaId,
                        principalTable: "guias_remision",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "hoja_ruta_guias",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    HojaRutaId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    GuiaId = table.Column<Guid>(type: "uniqueidentifier", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_hoja_ruta_guias", x => x.Id);
                    table.ForeignKey(
                        name: "FK_hoja_ruta_guias_guias_remision_GuiaId",
                        column: x => x.GuiaId,
                        principalTable: "guias_remision",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_hoja_ruta_guias_hojas_ruta_HojaRutaId",
                        column: x => x.HojaRutaId,
                        principalTable: "hojas_ruta",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_adjuntos_guias_GuiaId",
                table: "adjuntos_guias",
                column: "GuiaId");

            migrationBuilder.CreateIndex(
                name: "IX_cierre_guias_GuiaId",
                table: "cierre_guias",
                column: "GuiaId");

            migrationBuilder.CreateIndex(
                name: "IX_cierre_hoja_ruta_HojaRutaId",
                table: "cierre_hoja_ruta",
                column: "HojaRutaId");

            migrationBuilder.CreateIndex(
                name: "IX_guias_remision_EmitidaPor",
                table: "guias_remision",
                column: "EmitidaPor");

            migrationBuilder.CreateIndex(
                name: "IX_guias_remision_NumeroGre",
                table: "guias_remision",
                column: "NumeroGre",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_guias_remision_OvId",
                table: "guias_remision",
                column: "OvId");

            migrationBuilder.CreateIndex(
                name: "IX_hoja_ruta_guias_GuiaId",
                table: "hoja_ruta_guias",
                column: "GuiaId");

            migrationBuilder.CreateIndex(
                name: "IX_hoja_ruta_guias_HojaRutaId_GuiaId",
                table: "hoja_ruta_guias",
                columns: new[] { "HojaRutaId", "GuiaId" },
                unique: true,
                filter: "[HojaRutaId] IS NOT NULL AND [GuiaId] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_nota_imagenes_NotaId",
                table: "nota_imagenes",
                column: "NotaId");

            migrationBuilder.CreateIndex(
                name: "IX_notas_OvId",
                table: "notas",
                column: "OvId");

            migrationBuilder.CreateIndex(
                name: "IX_ordenes_venta_NumeroOv",
                table: "ordenes_venta",
                column: "NumeroOv",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_roles_Nombre",
                table: "roles",
                column: "Nombre",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_users_Email",
                table: "users",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_users_RoleId",
                table: "users",
                column: "RoleId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "adjuntos_guias");

            migrationBuilder.DropTable(
                name: "cierre_guias");

            migrationBuilder.DropTable(
                name: "cierre_hoja_ruta");

            migrationBuilder.DropTable(
                name: "hoja_ruta_guias");

            migrationBuilder.DropTable(
                name: "nota_imagenes");

            migrationBuilder.DropTable(
                name: "guias_remision");

            migrationBuilder.DropTable(
                name: "hojas_ruta");

            migrationBuilder.DropTable(
                name: "notas");

            migrationBuilder.DropTable(
                name: "users");

            migrationBuilder.DropTable(
                name: "ordenes_venta");

            migrationBuilder.DropTable(
                name: "roles");
        }
    }
}
