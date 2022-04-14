-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUCRETIPCONTRA
DELIMITER ;
DROP TABLE IF EXISTS `BUCRETIPCONTRA`;DELIMITER $$

CREATE TABLE `BUCRETIPCONTRA` (
  `TipoContratoBCID` varchar(5) NOT NULL COMMENT 'ID del tipo de contrato',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion del tipo de contrato',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoContratoBCID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Contrato ante el Buro de Credito'$$