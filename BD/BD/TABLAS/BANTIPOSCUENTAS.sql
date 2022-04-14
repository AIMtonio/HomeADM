-- BANTIPOSCUENTAS

DELIMITER ;
DROP TABLE IF EXISTS `BANTIPOSCUENTAS`;
DELIMITER $$


CREATE TABLE `BANTIPOSCUENTAS` (
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Llave primaria de tipos de cuentas',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`TipoCuentaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Tabla donde se almacenan los tipos de cuantas de ahorro.'$$
