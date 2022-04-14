-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASMOVSTEMP
DELIMITER ;
DROP TABLE IF EXISTS `CAJASMOVSTEMP`;DELIMITER $$

CREATE TABLE `CAJASMOVSTEMP` (
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal donde\nse encuentra\nAsignada la Caja',
  `CajaID` int(11) NOT NULL COMMENT 'ID o Numero\n de Caja',
  `Fecha` date NOT NULL COMMENT 'Fecha del \nMovimiento',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de \nTransaccion',
  `Consecutivo` int(11) NOT NULL COMMENT 'Numero \nconsecutivo de\n movimiento por \nTransaccion',
  `MonedaID` int(11) NOT NULL COMMENT 'Numero o ID \nde la Moneda',
  `MontoEnFirme` decimal(14,2) NOT NULL COMMENT 'Monto de la \nOperacion para \nser Tomado \nen Firme',
  `MontoSBC` decimal(14,2) NOT NULL COMMENT 'Monto de la\n Operacion para\n ser Tomado \ncomo SBC',
  `TipoOperacion` int(11) NOT NULL COMMENT 'Tipo de Operacion\n corresponde \ncon tabla \nCAJATIPOSOPERA',
  `Instrumento` bigint(20) NOT NULL COMMENT 'Instrumento de \nla Operacion: \nNo Cuenta, \nNo Credito \nNo Prestador de \nServicios, \netc',
  `Referencia` varchar(200) NOT NULL COMMENT 'Descripcion de\n la Referencia',
  `Comision` decimal(14,2) NOT NULL COMMENT 'Monto de la\n Comision \nde la Transaccion',
  `IVAComision` decimal(14,2) NOT NULL COMMENT 'Monto del\n IVA de la \nComision de la \nTransaccion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$