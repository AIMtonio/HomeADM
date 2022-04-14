-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOPERIODO
DELIMITER ;
DROP TABLE IF EXISTS `CALCULOPERIODO`;
DELIMITER $$


CREATE TABLE `CALCULOPERIODO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo',
  `ClienteID` int(11) NOT NULL COMMENT 'ClienteID',
  `TotalCaptacion` decimal(14,2) NOT NULL COMMENT 'Total de Captacion en el Periodo',
  `FechaInicio` date NOT NULL COMMENT 'Fecha de Inicio del Periodo',
  `FechaFin` date NOT NULL COMMENT 'Fecha de Fin del Periodo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Auxiliar Para Calulo'$$
