using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ControlDespachos.Data.Migrations
{
    /// <inheritdoc />
    public partial class DecoupleNotasFromOVs : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_notas_ordenes_venta_OvId",
                table: "notas");

            migrationBuilder.DropIndex(
                name: "IX_notas_OvId",
                table: "notas");

            migrationBuilder.AlterColumn<string>(
                name: "OvId",
                table: "notas",
                type: "nvarchar(150)",
                maxLength: 150,
                nullable: false,
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<Guid>(
                name: "OvId",
                table: "notas",
                type: "uniqueidentifier",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(150)",
                oldMaxLength: 150);

            migrationBuilder.CreateIndex(
                name: "IX_notas_OvId",
                table: "notas",
                column: "OvId");

            migrationBuilder.AddForeignKey(
                name: "FK_notas_ordenes_venta_OvId",
                table: "notas",
                column: "OvId",
                principalTable: "ordenes_venta",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
