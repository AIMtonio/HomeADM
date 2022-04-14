-- BITACORACRBCARGOABONOCTAWS
DELIMITER ;
DROP TABLE IF EXISTS BITACORACRBCARGOABONOCTAWS;

DELIMITER $$
CREATE TABLE `BITACORACRBCARGOABONOCTAWS` (
  `FechaCarga` datetime NOT NULL COMMENT 'Fecha en la que se realiza la carga',
  `FolioCarga` int(11) NOT NULL COMMENT 'Folio de la carga',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Identificador del numero de cuentas de ahorro',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto a abonar',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza: cargo/ abono',
  `Referencia` varchar(50) NOT NULL COMMENT 'Referencia de la Operacion',
  `MensajeError` varchar(400) NOT NULL COMMENT 'Mensaje del error',
  `CodigoError` int(11) NOT NULL COMMENT 'Codigo error',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  KEY `fk_CRBCARGOABONOCTA_1` (`FolioCarga`),
  KEY `fk_CRBCARGOABONOCTA_2` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Bitacora de registros de las cuentas que tuvieron algun error al realizar el abono.'$$
