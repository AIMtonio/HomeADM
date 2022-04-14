-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCAUSABAJA
DELIMITER ;
DROP TABLE IF EXISTS `CATCAUSABAJA`;DELIMITER $$

CREATE TABLE `CATCAUSABAJA` (
  `CausaBajaID` int(11) NOT NULL COMMENT 'Clave SITI de Causa de Baja',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion de la causa de baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CausaBajaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Causa de Baja de Funcionario SITI - Reg. A1713'$$