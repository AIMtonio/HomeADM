-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACARGOSOBJ
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTACARGOSOBJ`;DELIMITER $$

CREATE TABLE `EDOCTACARGOSOBJ` (
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente',
  `Instrumento` varchar(20) NOT NULL COMMENT 'Instrumento que describe el medio que',
  `FechaSuceso` date NOT NULL COMMENT 'Fecha en la que ocurrio el cargo objetado',
  `Descripcion` varchar(300) NOT NULL COMMENT 'Descripcion del cargo objetado',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto del cargo objetado',
  `FechaReclama` date NOT NULL COMMENT 'Fecha en la que se esta reclamando el cargo objetado',
  `Folio` bigint(20) NOT NULL COMMENT 'Folio del cargo objetado',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para los cargos objetados de los estados de cuenta generados.'$$