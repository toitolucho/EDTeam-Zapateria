
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Consulta la facturación de un cliente en específico.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE FacturacionCliente 
GO

CREATE PROCEDURE FacturacionCliente 
	@IdCliente	INT
AS
BEGIN
	SELECT C.NombreCliente [Nombre del Cliente] ,SA.FechaRegistro [Fecha Transacción], p.NombreProducto [Producto],  SAD.CantidadSalida [Cantidad], SAD.PrecioSalida [Costo], SAD.CantidadSalida * SAD.PrecioSalida as Total
	FROM SalidasProductos SA
	JOIN SalidasProductosDetalle SAD
	ON SA.IdSalida = SAD.IdSalida
	JOIN Clientes C
	ON SA.IdCliente = C.IdCliente
	JOIN Productos P
	on sad.IdProducto = p.IdProducto
	WHERE SA.CodigoEstadoSalida = 'F'
	AND c.IdCliente = @IdCliente
	order by c.NombreCliente, sa.FechaRegistro
	--GROUP BY C.NombreCliente
END
GO
--########################
--#    ejecucion		 #
--########################
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
exec FacturacionCliente 15
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Consulta la facturación de un producto en específico.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE FacturacionProducto
GO

CREATE PROCEDURE FacturacionProducto 
	@IdProducto	INT
AS
BEGIN
	SELECT p.IdProducto, p.NombreProducto [Producto],  C.NombreCliente [Nombre del Cliente] ,SA.FechaRegistro [Fecha de Venta], SAD.CantidadSalida [Cantidad], SAD.PrecioSalida [Costo], SAD.CantidadSalida * SAD.PrecioSalida as Total
	FROM SalidasProductos SA
	JOIN SalidasProductosDetalle SAD
	ON SA.IdSalida = SAD.IdSalida
	JOIN Clientes C
	ON SA.IdCliente = C.IdCliente
	JOIN Productos P
	on sad.IdProducto = p.IdProducto
	WHERE SA.CodigoEstadoSalida = 'F'
	--AND P.IdProducto = @IdProducto
	order by p.NombreProducto, sa.FechaRegistro
END
GO
--########################
--#    ejecucion		 #
--########################
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
exec FacturacionProducto 189
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---Consulta la facturación de un rango de fechas.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE FacturacionRangoFechas
GO

CREATE PROCEDURE FacturacionRangoFechas
	@FechaInicio DATETIME,
	@FechaFin DATETIME
AS
BEGIN
	SET @FechaInicio = CONVERT(DATETIME, CONVERT(VARCHAR(10),@FechaInicio,120),120)
	SET @FechaFin = DATEADD(SECOND,-1, DATEADD(DAY,1, CONVERT(DATETIME, CONVERT(VARCHAR(10),@FechaFin,120),120)))

	SELECT p.IdProducto [Id], p.NombreProducto [Nombre Producto],  SUM(CantidadSalida) AS [Total Unidades],  SUM(SAD.CantidadSalida* SAD.PrecioSalida) AS [Total Facturado]
	FROM SalidasProductos SA
	JOIN SalidasProductosDetalle SAD
	ON SA.IdSalida = SAD.IdSalida
	JOIN Productos P
	ON SAD.IdProducto = P.IdProducto
	WHERE SA.CodigoEstadoSalida = 'F'
	AND sa.FechaRegistro between @FechaInicio and @FechaFin
	GROUP BY p.IdProducto, P.NombreProducto
END
GO
--########################
--#    ejecucion		 #
--########################
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC FacturacionRangoFechas '01/01/2019', '31/01/2019'
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--De la facturación, consulta los clientes únicos (es decir, se requiere el listado de los clientes que han comprado por lo menos una vez, pero en el listado no se deben repetir los clientes)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE ClientesUnicos
GO

CREATE PROCEDURE ClientesUnicos
AS
BEGIN
	SELECT C.NombreCliente [Nombre Cliente], sum(SAD.CantidadSalida) as [Total Unidades], SUM(SAD.CantidadSalida* SAD.PrecioSalida) AS [Total Facturado]
	FROM SalidasProductos SA
	JOIN SalidasProductosDetalle SAD
	ON SA.IdSalida = SAD.IdSalida
	JOIN Clientes C
	ON SA.IdCliente = C.IdCliente
	WHERE SA.CodigoEstadoSalida = 'F'
	--AND c.IdCliente = @IdCliente
	GROUP BY C.NombreCliente
	ORDER BY C.NombreCliente
END
--########################
--#    ejecucion		 #
--########################
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
exec ClientesUnicos
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




--Cubo de información (opcional): Si tienes experiencia en cubos de información, diseña un cubo con la base de datos anterior donde se tenga toda la información de facturación.