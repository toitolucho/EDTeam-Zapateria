INSERT  INTO EDTEAM_ZAPATERIA.dbo.Productos (NombreProducto, Presentacion)
select UPPER(NombreArticulo1), UPPER(NombreArticulo1)
from QBAlmacenes10.dbo.Articulos


INSERT INTO EDTEAM_ZAPATERIA.DBO.Paises (NombrePais)
SELECT UPPER(NombrePais) FROM QBAlmacenes10.DBO.Paises


INSERT INTO EDTEAM_ZAPATERIA.dbo.Clientes(NombreCliente, IdPais)
select UPPER(Nombres), ABS(CHECKSUM(NEWID()) % 200)+1 as IdPais from QBAlmacenes10.dbo.Personas order by 2 desc


insert into EDTEAM_ZAPATERIA.[dbo].[InventarioProductos] (IdProducto, CostoVenta, PorcentajeImpuesto, CantidadExistencia, FechaUltimoMovimiento, TipoUltimoMovimiento)
select IdProducto, 0, 0, 0, GETDATE(), null from EDTEAM_ZAPATERIA.dbo.Productos


SET IDENTITY_INSERT EDTEAM_ZAPATERIA.dbo.IngresosProductos ON 
INSERT INTO EDTEAM_ZAPATERIA.dbo.IngresosProductos (IdIngreso, FechaRegistro, CodigoEstadoIngreso, Observaciones)
SELECT DISTINCT ia.NumeroIngresoArticulo, FechaHoraRegistro, 'F', CAST(Observaciones  AS VARCHAR(5000)) AS Observaciones
from IngresosArticulosDetalle IAD
join IngresosArticulos IA
ON IAD.NumeroAlmacen = IA.NumeroAlmacen
AND IAD.NumeroIngresoArticulo = IA.NumeroIngresoArticulo
JOIN InventariosArticulos IA2
on iad.CodigoArticulo = ia2.CodigoArticulo
where ia2.CantidadExistencia = 0
and CodigoTipoTransaccion = 'A'
AND YEAR(FechaHoraRegistro) = 2019
AND CodigoEstadoIngreso = 'F'
SET IDENTITY_INSERT EDTEAM_ZAPATERIA.dbo.IngresosProductos OFF
GO

INSERT INTO EDTEAM_ZAPATERIA.dbo.IngresosProductosDetalle (IdIngreso, IdProducto, PrecioIngreso, CantidadIngreso)
SELECT iad.NumeroIngresoArticulo, P.IdProducto, iad.PrecioUnitarioIngreso, iad.CantidadIngreso
from IngresosArticulosDetalle IAD
join IngresosArticulos IA
ON IAD.NumeroAlmacen = IA.NumeroAlmacen
AND IAD.NumeroIngresoArticulo = IA.NumeroIngresoArticulo
JOIN InventariosArticulos IA2
on iad.CodigoArticulo = ia2.CodigoArticulo
JOIN Articulos A
on iad.CodigoArticulo = a.CodigoArticulo
join EDTEAM_ZAPATERIA.dbo.Productos p
on P.NombreProducto = a.NombreArticulo1
where ia2.CantidadExistencia = 0
and CodigoTipoTransaccion = 'A'
AND YEAR(FechaHoraRegistro) = 2019
AND CodigoEstadoIngreso = 'F'



SET IDENTITY_INSERT EDTEAM_ZAPATERIA.[dbo].[SalidasProductos] ON 
INSERT INTO EDTEAM_ZAPATERIA.dbo.SalidasProductos (IdSalida, IdCliente, FechaRegistro, NroFactura, MontoTotal, MontoDescuento, CodigoEstadoSalida, Observaciones)
SELECT ia.NumeroSalidaArticulo,ABS(CHECKSUM(NEWID()) % 200)+1,  FechaHoraSalida, null, 0,0, 'F', NULL AS Observaciones
from SalidasArticulosDetalle IAD
join SalidasArticulos IA
ON IAD.NumeroAlmacen = IA.NumeroAlmacen
AND IAD.NumeroSalidaArticulo = IA.NumeroSalidaArticulo
JOIN InventariosArticulos IA2
on iad.CodigoArticulo = ia2.CodigoArticulo
where ia2.CantidadExistencia = 0
and CodigoTipoTransaccion = 'A'
AND YEAR(FechaHoraSalida) = 2019
AND CodigoEstadoSalida = 'F'
GROUP BY ia.NumeroSalidaArticulo, FechaHoraSalida
SET IDENTITY_INSERT EDTEAM_ZAPATERIA.dbo.SalidasProductos OFF
GO


INSERT INTO EDTEAM_ZAPATERIA.dbo.SalidasProductosDetalle (IdSalida, IdProducto, PrecioSalida, CantidadSalida)
SELECT iad.NumeroSalidaArticulo, P.IdProducto, iad.PrecioUnitarioSalida, iad.CantidadSalida
from SalidasArticulosDetalle IAD
join SalidasArticulos IA
ON IAD.NumeroAlmacen = IA.NumeroAlmacen
AND IAD.NumeroSalidaArticulo = IA.NumeroSalidaArticulo
JOIN InventariosArticulos IA2
on iad.CodigoArticulo = ia2.CodigoArticulo
JOIN Articulos A
on iad.CodigoArticulo = a.CodigoArticulo
join EDTEAM_ZAPATERIA.dbo.Productos p
on P.NombreProducto = a.NombreArticulo1
where ia2.CantidadExistencia = 0
and CodigoTipoTransaccion = 'A'
AND YEAR(FechaHoraSalida) = 2019
AND CodigoEstadoSalida = 'F'
AND IAD.PrecioUnitarioSalida > 0


