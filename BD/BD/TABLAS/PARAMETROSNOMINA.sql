-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSNOMINA
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSNOMINA`;
DELIMITER $$


CREATE TABLE `PARAMETROSNOMINA` (
  `EmpresaID` int(11) NOT NULL,
  `CorreoElectronico` varchar(50) DEFAULT NULL COMMENT 'Correo Electronico del encargado de nomina',
  `CtaPagoTransito` varchar(25) DEFAULT NULL COMMENT ' Cuenta Contable en Tránsito para los depósitos en banco de Nómina',
  `NomenclaturaCR` varchar(30) DEFAULT NULL,
  `TipoMovTesCon` char(4) DEFAULT NULL COMMENT 'Id del Tipo de Movimiento de Conciliacion',
  `PerfilAutCalend` int(11) DEFAULT NULL COMMENT 'Campo para la definicion del Perfil Autorizado para Autorizar y Desautorizar el Calendario de Ingresos',
  `CtaTransDomicilia` VARCHAR(25) DEFAULT ''    COMMENT 'Cuenta Contable en Transito para Domiciliacion de Pagos',
  `TipoMovDomiciliaID` CHAR(4)  DEFAULT ''    COMMENT 'ID del Tipo de Movimiento de Domiciliacion de Pagos',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros de la Empresa de Nomina'$$