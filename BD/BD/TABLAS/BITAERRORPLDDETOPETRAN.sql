DELIMITER ;
DROP TABLE IF EXISTS `BITAERRORPLDDETOPETRAN`;
DELIMITER $$

CREATE TABLE `BITAERRORPLDDETOPETRAN` (
  `BitacoraID` bigint(12) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la bitacora',
  `Procedimiento` varchar(50) NOT NULL COMMENT 'Nombre del procedimiento',
  `NumErr` int(11) NOT NULL COMMENT 'Numero de error',
  `ErrMen` varchar(600) NOT NULL COMMENT 'Mensaje de error',
  `TipoOperacion` int(11) NOT NULL COMMENT 'Tipo de operacion 1 = Abonos y cargos cuenta, 2= Pago de credito',
  `ClienteID` int(11) NOT NULL COMMENT 'id de cliente',
  `CreditoID` bigint(12) NOT NULL COMMENT 'id de credito',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del movimiento cargo o abono',
  `FechaSistema` date NOT NULL COMMENT 'Fecha de sistema',
  `Monto` decimal(18,2) NOT NULL COMMENT 'Monto transaccion',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`BitacoraID`),
  KEY `idx_BITAERRORPLDDETOPETRAN_1` (`ClienteID`),
  KEY `idx_BITAERRORPLDDETOPETRAN_2` (`CreditoID`),
  KEY `idx_BITAERRORPLDDETOPETRAN_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB:Bitacora de error al detectar operaciones inusuales o fraccionadas por transaccion'$$
