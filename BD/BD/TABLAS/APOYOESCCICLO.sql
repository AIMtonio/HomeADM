-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APOYOESCCICLO
DELIMITER ;
DROP TABLE IF EXISTS `APOYOESCCICLO`;DELIMITER $$

CREATE TABLE `APOYOESCCICLO` (
  `ApoyoEscCicloID` int(11) NOT NULL DEFAULT '0' COMMENT 'consecutivo de la tabla',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Indica el ciclo escolar(Primaria,Secundaria, etc.) ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`ApoyoEscCicloID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar los ciclos escolares que entran en el apo'$$