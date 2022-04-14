-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESMENUREG
DELIMITER ;
DROP TABLE IF EXISTS `OPCIONESMENUREG`;DELIMITER $$

CREATE TABLE `OPCIONESMENUREG` (
  `OpcionMenuID` int(11) NOT NULL COMMENT 'Consecutivo para las opciónes de los menús',
  `MenuID` int(11) NOT NULL COMMENT 'ID del Menú Regulatorio al que pertenece la opción',
  `CodigoOpcion` varchar(30) NOT NULL COMMENT 'ID de la opción para el MenuID',
  `Descripcion` varchar(250) NOT NULL COMMENT 'Descripción de la opción',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OpcionMenuID`),
  KEY `FK_OPCIONESMENUREG_1` (`MenuID`),
  CONSTRAINT `FK_OPCIONESMENUREG_1` FOREIGN KEY (`MenuID`) REFERENCES `MENUSREGULATORIOS` (`MenuID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$