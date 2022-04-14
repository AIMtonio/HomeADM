-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISDIRECCLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `HISDIRECCLIENTE`;
DELIMITER $$

CREATE TABLE `HISDIRECCLIENTE` (
  `NumTransaccionAct` bigint(20) NOT NULL COMMENT 'Numero de Transaccion que realizo la actualización de los datos',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `DireccionID` int(11) NOT NULL COMMENT 'ID de la direccion de cliente',
  `PaisID`    INT(11) DEFAULT 0 COMMENT 'ID del País del cliente',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del estado del cliente',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del muncipio del cliente',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Numero de Localidad Correspondiente al Municipio',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `AniosRes`  INT(11) DEFAULT 0 COMMENT 'Años de residencia',
  `Oficial` char(1) DEFAULT NULL COMMENT 'Valor de direccion oficial\nS=SI, N=No',
  `Fiscal` char(1) DEFAULT NULL COMMENT 'Es domicilio Fiscal S:Si N:No',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`ClienteID`,`DireccionID`,`NumTransaccionAct`),
  KEY `fk_HISDIRECCLIENTE_2` (`EstadoID`),
  CONSTRAINT `fk_HISDIRECCLIENTE_2` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Historica de los Modificaciones de los Registros de la tabla de DIRECCLIENTE'$$