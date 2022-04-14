-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASFESTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `DIASFESTIVOS`;DELIMITER $$

CREATE TABLE `DIASFESTIVOS` (
  `Fecha` date NOT NULL COMMENT 'Fecha Dia\nFestivo o \nFeriado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Referencia o \nDescripcion del \nDia Festivo',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Dias Festivos o Feriados'$$