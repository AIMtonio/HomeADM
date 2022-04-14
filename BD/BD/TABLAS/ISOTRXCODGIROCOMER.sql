-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXCODGIROCOMER
DELIMITER ;
DROP TABLE IF EXISTS `ISOTRXCODGIROCOMER`;
DELIMITER $$


CREATE TABLE `ISOTRXCODGIROCOMER` (
  `CodGiroComerID` int(11) NOT NULL COMMENT 'Id de codigo del giro comercio',
  `Descripcion` varchar(250) DEFAULT NULL COMMENT 'Descripcion del giro del comercio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`CodGiroComerID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo para el codigo comercio'$$


