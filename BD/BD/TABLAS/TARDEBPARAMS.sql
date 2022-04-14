-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPARAMS
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBPARAMS`;DELIMITER $$

CREATE TABLE `TARDEBPARAMS` (
  `RutaAclaracion` varchar(300) NOT NULL COMMENT 'Ruta donde se depositaran los archivos adjuntos para las aclaraciones',
  `MaxDiasAclara` int(11) DEFAULT NULL COMMENT 'Máximo de días para realizar la aclaración partiendo de la fecha de la operación',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RutaAclaracion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parámetros de Tarjeta de Débito'$$