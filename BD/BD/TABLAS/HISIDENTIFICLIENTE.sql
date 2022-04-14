-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISIDENTIFICLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `HISIDENTIFICLIENTE`;DELIMITER $$

CREATE TABLE `HISIDENTIFICLIENTE` (
  `NumTransaccionAct` bigint(20) NOT NULL COMMENT 'Numero de Transaccion que realizo la actualización de los datos',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente',
  `IdentificID` int(11) NOT NULL COMMENT 'ID del la identificacion del cliente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `TipoIdentiID` int(11) NOT NULL COMMENT 'ID de el tipo de identificacion del cliente',
  `Descripcion` varchar(45) DEFAULT NULL COMMENT 'Descripcion',
  `Oficial` varchar(1) DEFAULT NULL COMMENT 'Se refiere a si el tipo de identificacion es oficial',
  `NumIdentific` varchar(30) DEFAULT NULL COMMENT 'Es el num de identificacion del documento del cliente',
  `FecExIden` date DEFAULT NULL COMMENT 'Fecha de Expedición',
  `FecVenIden` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`ClienteID`,`IdentificID`,`NumTransaccionAct`),
  KEY `fk_HISIDENTIFICLIENTE_1` (`TipoIdentiID`),
  CONSTRAINT `fk_HISIDENTIFICLIENTE_1` FOREIGN KEY (`TipoIdentiID`) REFERENCES `TIPOSIDENTI` (`TipoIdentiID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Historica de los Modificaciones de los Registros de la tabla de IDENTIFICLIENTE'$$