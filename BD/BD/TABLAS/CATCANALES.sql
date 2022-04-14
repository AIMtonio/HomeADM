-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCANALES
DELIMITER ;
DROP TABLE IF EXISTS `CATCANALES`;DELIMITER $$

CREATE TABLE `CATCANALES` (
  `CanalID` int(11) NOT NULL COMMENT 'Codigo de Canal de la Transaccion',
  `Descripcion` varchar(50) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CanalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Canales de Operacion D2441 y D2442'$$