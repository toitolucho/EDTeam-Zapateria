USE master;

CREATE DATABASE EDTEAM_ZAPATERIA;
GO

DROP TABLE SalidasProductosDetalle
DROP TABLE SalidasProductos
DROP TABLE IngresosProductosDetalle
DROP TABLE IngresosProductos
DROP TABLE Clientes
DROP TABLE Paises
DROP TABLE InventarioProductos
DROP TABLE Productos
GO


USE EDTEAM_ZAPATERIA;
GO


CREATE TABLE Productos
(
	IdProducto		INT IDENTITY(1,1),
	NombreProducto	VARCHAR(200),
	Presentacion	VARCHAR(MAX),	
	CONSTRAINT PK_Productos PRIMARY KEY(IdProducto),
	CONSTRAINT U_Nombre_Producto UNIQUE(NombreProducto)	
)
GO


CREATE TABLE InventarioProductos
(
	IdProducto				INT,
	CostoVenta				DECIMAL(10,2), --Promedio de las compras
	PorcentajeImpuesto		DECIMAL(10,2), --Impuesto que se le debe aplicar al producto de forma individual en función a la configuración del usuario
	CantidadExistencia		INT, --Existencia Real en funcion a los movimientos del articulo
	FechaUltimoMovimiento	DATETIME, --Registro de la fecha de ultimo movimiento
	TipoUltimoMovimiento	CHAR(1),   -- 'I'->Ingreso, 'S'->SALIDA
	PRIMARY KEY(IdProducto)	,
	FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
)

CREATE TABLE Paises
(
	IdPais		INT IDENTITY(1,1),
	NOmbrePais	VARCHAR(200) UNIQUE,
	CONSTRAINT PK_Paises PRIMARY KEY(IdPais)
)

CREATE TABLE Clientes
(
	IdCliente		INT IDENTITY(1,1),
	NombreCliente	VARCHAR(200),
	IdPais			INT,
	CONSTRAINT PK_Clientes PRIMARY KEY(IdCliente),
	CONSTRAINT FK_Clientes_Paises FOREIGN KEY(IdPais) REFERENCES Paises(IdPais),
	
)

CREATE TABLE IngresosProductos
(
	IdIngreso 			INT IDENTITY(1,1),
	FechaRegistro		DATETIME,
	CodigoEstadoIngreso CHAR(1) CHECK(CodigoEstadoIngreso IN ('I','F','A')), -- 'I'->INICIADO , 'F'->FINALIZADO, 'A'->ANULADO
	Observaciones		VARCHAR(MAX),
	CONSTRAINT FK_IngresosProductos PRIMARY KEY(IdIngreso)
)

CREATE TABLE IngresosProductosDetalle
(
	IdIngreso		INT,
	IdProducto		INT,
	PrecioIngreso	DECIMAL(10,2) CHECK(PrecioIngreso>0),
	CantidadIngreso	INT CHECK(CantidadIngreso>0),
	CONSTRAINT PK_IngresosProductosDetalle PRIMARY KEY(IdIngreso,IdProducto),
	CONSTRAINT FK_IngresosProductosDetalle_Articulos FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto),
	CONSTRAINT FK_IngresosProductosDetalle FOREIGN KEY (IdIngreso) REFERENCES IngresosProductos(IdIngreso)
)


CREATE TABLE SalidasProductos
(
	IdSalida 			INT IDENTITY(1,1),		
	IdCliente			INT,
	FechaRegistro		DATETIME,
	NroFactura			VARCHAR(100),
	MontoTotal			DECIMAL(10,2),
	MontoDescuento		DECIMAL(10,2),
	CodigoEstadoSalida CHAR(1) CHECK(CodigoEstadoSalida IN ('I','F','A')), -- 'I'->INICIADO , 'F'->FINALIZADO, 'A'->ANULADO
	Observaciones		VARCHAR(MAX),
	CONSTRAINT FK_SalidasProductos PRIMARY KEY(IdSalida),
	CONSTRAINT FK_SalidasProductosClientes FOREIGN KEY (IdCliente) REFERENCES Clientes (IdCliente)
)

CREATE TABLE SalidasProductosDetalle
(
	IdSalida		INT,
	IdProducto		INT,
	PrecioSalida	DECIMAL(10,2) CHECK(PrecioSalida>0),
	CantidadSalida	INT CHECK(CantidadSalida>0),
	CONSTRAINT PK_SalidasProductosDetalle PRIMARY KEY(IdSalida,IdProducto),
	CONSTRAINT FK_SalidasProductosDetalle_Articulos FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto),
	CONSTRAINT FK_SalidasProductosDetalle FOREIGN KEY (IdSalida) REFERENCES SalidasProductos(IdSalida)
)