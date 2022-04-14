-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOCANAL
DELIMITER ;
DROP TABLE IF EXISTS `TIPOCANAL`;DELIMITER $$

CREATE TABLE `TIPOCANAL` (
  `TipoCanalID` int(11) NOT NULL,
  `Descripcion` varchar(50) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL,
  `TipoOpEqCNBVUIF` char(2) DEFAULT NULL COMMENT 'Equivalente a la clave del tipo de canal segun los catalogos correspondientes de la CNBV y la UIF',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoCanalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$