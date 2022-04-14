-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERIODOSREEL
DELIMITER ;
DROP TABLE IF EXISTS `PLDPERIODOSREEL`;DELIMITER $$

CREATE TABLE `PLDPERIODOSREEL` (
  `PeriodoReeID` int(11) NOT NULL COMMENT 'Id del periodo Reelevante',
  `Descripcion` varchar(45) DEFAULT NULL COMMENT 'Meses Comprendidos en el Periodo\n',
  `MesDiaInicio` varchar(10) DEFAULT NULL COMMENT 'Mes y dia del inicio del Periodo\n',
  `MesDiaFin` varchar(10) DEFAULT NULL COMMENT 'Mes y dia del Fin del Periodo\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PeriodoReeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Periodos para reportar Operaciones Reelevantes'$$