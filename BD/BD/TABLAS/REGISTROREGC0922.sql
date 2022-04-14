-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROREGC0922
DELIMITER ;
DROP TABLE IF EXISTS `REGISTROREGC0922`;DELIMITER $$

CREATE TABLE `REGISTROREGC0922` (
  `Anio` int(11) NOT NULL DEFAULT '0' COMMENT 'Ano que se reporta',
  `Mes` int(11) NOT NULL DEFAULT '0' COMMENT 'Mes que se reporta',
  `RegistroID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo del registro en el periodo',
  `ClasfContable` varchar(20) DEFAULT NULL COMMENT 'Cuenta contable de acuerdo al catalogo minomo',
  `Nombre` varchar(250) DEFAULT NULL COMMENT 'Nombre del beneficiario',
  `Puesto` varchar(60) DEFAULT NULL COMMENT 'Puesto del beneficiario',
  `TipoPercepcion` int(11) DEFAULT NULL COMMENT ' Tipo de Percepcion - CATTIPOPERCEPCION',
  `Descripcion` varchar(60) DEFAULT NULL COMMENT 'Descipcion del movimiento',
  `Dato` decimal(23,2) DEFAULT NULL COMMENT 'Monto de la operacion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Anio`,`Mes`,`RegistroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los registros reportados de Gastos de Administracion y Promocion C0922'$$