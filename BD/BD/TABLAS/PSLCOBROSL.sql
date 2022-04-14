-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCOBROSL
DELIMITER ;
DROP TABLE IF EXISTS `PSLCOBROSL`;DELIMITER $$

CREATE TABLE `PSLCOBROSL` (
  `CobroID` bigint(20) NOT NULL COMMENT 'Id del cobro de servicio',
  `ProductoID` int(11) NOT NULL COMMENT 'Id del producto',
  `ServicioID` int(11) NOT NULL COMMENT 'Id de servicio del Broker',
  `ClasificacionServ` char(2) NOT NULL COMMENT 'Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)',
  `TipoUsuario` char(1) NOT NULL COMMENT 'Campo para el tipo de Usuario (S = Socio/Cliente, U = Usuario )',
  `NumeroTarjeta` varchar(30) NOT NULL COMMENT 'Numero de tarjeta del socio o cliente',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del socio o cliente',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Identificador del la cuenta de ahorro',
  `Producto` varchar(200) NOT NULL COMMENT 'Nombre del producto',
  `FormaPago` char(1) NOT NULL COMMENT 'Forma de pago por el producto (E = Efectivo, C = Cargo a cuenta de ahorro)',
  `Precio` decimal(14,2) NOT NULL COMMENT 'Precio del producto',
  `Telefono` varchar(13) NOT NULL COMMENT 'Telefono del servicio',
  `Referencia` varchar(30) NOT NULL COMMENT 'Referencia del servicio',
  `ComisiProveedor` decimal(14,2) NOT NULL COMMENT 'Monto por la comision del proveedor del servicio',
  `ComisiInstitucion` decimal(14,2) NOT NULL COMMENT 'Monto por la comision interna',
  `IVAComision` decimal(14,2) NOT NULL COMMENT 'IVA correspondiente a la comision interna',
  `TotalComisiones` decimal(14,2) NOT NULL COMMENT 'Monto total de las comisiones a pagar',
  `TotalPagar` decimal(14,2) NOT NULL COMMENT 'Total a pagar',
  `FechaHora` datetime NOT NULL COMMENT 'Fecha y hora del cobro de servicio',
  `SucursalID` int(11) NOT NULL COMMENT 'Identificador de la sucursal donde ser realizo el cobro de servicio',
  `CajaID` int(11) NOT NULL COMMENT 'Identificador de la caja donde ser realizo el cobro de servicio',
  `CajeroID` int(11) NOT NULL COMMENT 'Identificador de la cajero que realizo el cobro de servicio',
  `Canal` char(1) NOT NULL COMMENT 'Identificador del canal por donde ser realizo el servicio (V = Ventanilla, L = Banca en linea, M = Banca mobil)',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Identificador de la poliza contable',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del cobro (T = En Transito, E = Efectuado, C = Cancelado)',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CobroID`),
  KEY `INDEX_PSLCOBROSL_1` (`CobroID`),
  KEY `INDEX_PSLCOBROSL_2` (`ProductoID`),
  KEY `INDEX_PSLCOBROSL_3` (`ServicioID`),
  KEY `INDEX_PSLCOBROSL_4` (`ClasificacionServ`),
  KEY `INDEX_PSLCOBROSL_5` (`ClienteID`),
  KEY `INDEX_PSLCOBROSL_6` (`CuentaAhoID`),
  KEY `INDEX_PSLCOBROSL_7` (`SucursalID`),
  KEY `INDEX_PSLCOBROSL_8` (`PolizaID`),
  KEY `INDEX_PSLCOBROSL_9` (`NumTransaccion`),
  CONSTRAINT `FK_PSLCOBROSL_1` FOREIGN KEY (`ProductoID`) REFERENCES `PSLCONFIGPRODUCTO` (`ProductoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los cobros de servicios en linea.'$$