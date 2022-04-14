-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUCREPARAMETROS
DELIMITER ;
DROP TABLE IF EXISTS `BUCREPARAMETROS`;
DELIMITER $$

CREATE TABLE `BUCREPARAMETROS` (
  `ClaveInstitID` varchar(20) NOT NULL COMMENT 'ID de la Institucion ante BC',
  `UsuarioID` varchar(20) DEFAULT NULL COMMENT 'Numero de Usuario Ante BC',
  `Password` varchar(50) DEFAULT NULL COMMENT 'Password del Usuario ante BC',
  `TipoNegocioID` varchar(5) DEFAULT NULL COMMENT 'Tipo de Negocio',
  `Nombre` varchar(50) DEFAULT NULL COMMENT 'Nombre de la Institucion',
  `ClaveUsuarioBCPM` int(4) DEFAULT NULL,
  `TipoUsuarioBCPM` varchar(3) DEFAULT NULL,
  `TipoNegVta` VARCHAR(45) NULL COMMENT 'Tipo de negocio para venta de cartera' ,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClaveInstitID`),
  KEY `fk_BUCREPARAMETROS_1` (`TipoNegocioID`),
  CONSTRAINT `fk_BUCREPARAMETROS_1` FOREIGN KEY (`TipoNegocioID`) REFERENCES `BUCRETIPONEG` (`TipoNegocioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros Generales para Actividades Buro de Credito'$$