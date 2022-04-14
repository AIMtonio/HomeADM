-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXCODRESPUESTA
DELIMITER ;
DROP TABLE IF EXISTS `ISOTRXCODRESPUESTA`;
DELIMITER $$


CREATE TABLE `ISOTRXCODRESPUESTA` (
  `CodRespuestaID` int(11) NOT NULL COMMENT 'Indica el codigo de respuesta',
  `Descripcion` varchar(250) DEFAULT NULL COMMENT 'Descripcion del codigo de respuesta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`CodRespuestaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo para el codigo de respuesta'$$