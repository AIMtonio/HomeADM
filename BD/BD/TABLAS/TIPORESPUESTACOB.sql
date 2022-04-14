-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPORESPUESTACOB
DELIMITER ;
DROP TABLE IF EXISTS `TIPORESPUESTACOB`;DELIMITER $$

CREATE TABLE `TIPORESPUESTACOB` (
  `AccionID` int(11) NOT NULL COMMENT 'Identificador consecutivo del tipo de accion tabl TIPOACCIONCOB',
  `RespuestaID` int(11) NOT NULL COMMENT 'Identificador consecutivo del tipo de respuesta',
  `Descripcion` varchar(200) NOT NULL COMMENT 'Descripcion del tipo de respuesta',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus tipo de respuesta A= activo, I= inactivo',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`AccionID`,`RespuestaID`),
  KEY `IDX_TIPORESPUESTACOB_1` (`AccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los Tipos de Respuestas de cobranza'$$