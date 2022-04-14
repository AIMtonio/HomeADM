-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOSERVICIOS
DELIMITER ;
DROP TABLE IF EXISTS `PAGOSERVICIOS`;DELIMITER $$

CREATE TABLE `PAGOSERVICIOS` (
  `PagoServicioID` int(11) NOT NULL COMMENT 'consecutivo de tabla pago de servicios',
  `CatalogoServID` int(11) NOT NULL COMMENT 'ID de la tabla catalogo servicios',
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal donde se realizo el pago de servicio',
  `CajaID` int(11) NOT NULL COMMENT 'ID o Numero\n de Caja',
  `Fecha` date NOT NULL COMMENT 'Fecha del \nMovimiento',
  `Referencia` varchar(200) NOT NULL COMMENT 'Numero de Referencia del servicio pagado',
  `SegundaRefe` varchar(200) DEFAULT NULL COMMENT 'Numero de segunda Referencia del servicio pagado campo con valor opcional',
  `MonedaID` int(11) NOT NULL COMMENT 'Numero o ID \nde la Moneda',
  `MontoServicio` decimal(14,2) NOT NULL COMMENT 'Monto de la\n Operacion',
  `IvaServicio` decimal(14,2) NOT NULL COMMENT 'Monto de iva de la operacion',
  `Comision` decimal(14,2) NOT NULL COMMENT 'Monto de la\n Comision',
  `IVAComision` decimal(14,2) NOT NULL COMMENT 'Monto del\n IVA de la \nComision',
  `Total` decimal(12,2) DEFAULT NULL COMMENT 'Total del servicio cobrado',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente (requerido solo si el servicio lo indica)',
  `ProspectoID` bigint(20) DEFAULT NULL COMMENT 'ID del prospecto (requerido solo si el servicio lo indica)',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID del Credito(requerido solo si el servicio lo indica)',
  `Aplicado` char(1) DEFAULT NULL COMMENT 'Indica si el Pago ya fue aplicado con el proveedor del servicio Si= "S" No = "N"\nNace con "N"',
  `FolioDispersion` int(11) DEFAULT NULL COMMENT 'Indica el numero de Folio de dispersion, cuando el pago de servicio haya sido importado, Nace con "0"',
  `OrigenPago` char(1) DEFAULT NULL COMMENT 'Se refiere desde donde se realizo el pago del servicio\nB = Banca Electronica\nV = Ventanilla\nM = Banca Movil',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PagoServicioID`),
  KEY `fk_PAGOSERVICIOS_1_idx` (`CatalogoServID`),
  KEY `idx_NumTransaccion` (`NumTransaccion`),
  CONSTRAINT `fk_PAGOSERVICIOS_1` FOREIGN KEY (`CatalogoServID`) REFERENCES `CATALOGOSERV` (`CatalogoServID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Pago de servicios Realizados'$$