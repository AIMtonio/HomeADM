-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESFOMUR
DELIMITER ;
DROP TABLE IF EXISTS `ACTIVIDADESFOMUR`;DELIMITER $$

CREATE TABLE `ACTIVIDADESFOMUR` (
  `ActividadFOMURID` int(11) NOT NULL COMMENT 'Id de la tabla Actividad FOMMUR',
  `Descripcion` varchar(200) NOT NULL COMMENT 'Descripcion de la actividad FOMMUR',
  `FamiliaBANXICO` varchar(10) DEFAULT NULL COMMENT 'Clave de la Familia Banxico\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ActividadFOMURID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$