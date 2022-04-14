-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `IDENTIFICLIENTE`;DELIMITER $$

CREATE TABLE `IDENTIFICLIENTE` (
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente',
  `IdentificID` int(11) NOT NULL COMMENT 'ID del la identificacion del cliente',
  `EmpresaID` int(11) DEFAULT NULL,
  `TipoIdentiID` int(11) NOT NULL COMMENT 'ID de el tipo de identificacion del cliente',
  `Descripcion` varchar(45) DEFAULT NULL,
  `Oficial` varchar(1) DEFAULT NULL COMMENT 'Se refiere a si el tipo de identificacion es oficial',
  `NumIdentific` varchar(30) DEFAULT NULL COMMENT 'Es el num de identificacion del documento del cliente',
  `FecExIden` date DEFAULT NULL,
  `FecVenIden` date DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`IdentificID`),
  KEY `fk_IDENTIFICLIENTE_1` (`TipoIdentiID`),
  CONSTRAINT `fk_IDENTIFICLIENTE_1` FOREIGN KEY (`TipoIdentiID`) REFERENCES `TIPOSIDENTI` (`TipoIdentiID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$