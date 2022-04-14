-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESSCIAN
DELIMITER ;
DROP TABLE IF EXISTS `ACTIVIDADESSCIAN`;DELIMITER $$

CREATE TABLE `ACTIVIDADESSCIAN` (
  `ActividadSCIANID` varchar(8) NOT NULL COMMENT 'ID o Numero de Actividad SCIAN\n',
  `Descripcion` varchar(250) NOT NULL COMMENT 'Descripcion de la Actividad\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'No. Empresa\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ActividadSCIANID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Actividades Segun el "Sistema de Clasificacion Industrial de America del Norte" (SCIAN)'$$