-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMXNSEGTOPLD
DELIMITER ;
DROP TABLE IF EXISTS `FORMXNSEGTOPLD`;DELIMITER $$

CREATE TABLE `FORMXNSEGTOPLD` (
  `NivelSegtoID` int(11) NOT NULL COMMENT 'clave de nivel se segto\nsegún catalogo de niveles de segto',
  `FormularioID` int(11) DEFAULT NULL COMMENT 'clave de formulario en levantamiento de información de segto\nsegún catalogo de formularios',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NivelSegtoID`),
  KEY `fk_FORMXN SEGTOPLD_1` (`NivelSegtoID`),
  KEY `fk_FORMXN SEGTOPLD_2` (`FormularioID`),
  CONSTRAINT `fk_FORMXN SEGTOPLD_1` FOREIGN KEY (`NivelSegtoID`) REFERENCES `NIVELSEGTOPLD` (`NivelSegtoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_FORMXN SEGTOPLD_2` FOREIGN KEY (`FormularioID`) REFERENCES `FORMULASEGTOPLD` (`FormularioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='formularios  de levantamiento de información que deberan ser'$$