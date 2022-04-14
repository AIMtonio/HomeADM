-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MENUSREGULATORIOS
DELIMITER ;
DROP TABLE IF EXISTS `MENUSREGULATORIOS`;DELIMITER $$

CREATE TABLE `MENUSREGULATORIOS` (
  `MenuID` int(11) NOT NULL COMMENT 'ID del Menú',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripción o Nombre del Menú',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MenuID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$