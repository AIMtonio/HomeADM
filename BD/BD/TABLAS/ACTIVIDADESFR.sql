-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESFR
DELIMITER ;
DROP TABLE IF EXISTS `ACTIVIDADESFR`;DELIMITER $$

CREATE TABLE `ACTIVIDADESFR` (
  `ActividadFRID` bigint(20) NOT NULL COMMENT 'ID o Numero de Actividad FR',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripción de la Actividad',
  `FamiliaBANXICO` varchar(10) DEFAULT NULL COMMENT 'Clave de la Familia Banxico\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ActividadFRID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Actividades Segun la Financiera Rural'$$