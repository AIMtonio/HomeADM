-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDCTE
DELIMITER ;
DROP TABLE IF EXISTS `LINFONCONDCTE`;DELIMITER $$

CREATE TABLE `LINFONCONDCTE` (
  `LineaFondeoID` int(11) NOT NULL COMMENT 'ID de la linea de Fondeo, Consecutivo de linea por Institucion de Fondeo (InstitutFondID)\n',
  `Sexo` char(1) NOT NULL COMMENT 'Valor: \nFemenino = "F" \nMasculino = "M" \nIndistinto = "I"',
  `EstadoCivil` varchar(200) NOT NULL COMMENT 'Clave Estado Civil:\\n\\''S\\'' = Soltero\\n\\''CS\\''  = Casado Bienes Separados\\n\\''CM\\''  = Casado Bienes Mancomunados\\n\\''CC\\''  = Casado Bienes Mancomunados Con Capitulacion\\n\\''V\\'' = Viudo\\n\\''D\\'' = Divorciado\\n\\''SE\\''  = Separado\\n\\''U\\'' = Union Libre',
  `MontoMinimo` decimal(12,2) DEFAULT NULL COMMENT 'Indica el monto minimo de un credito',
  `MontoMaximo` decimal(12,2) DEFAULT NULL COMMENT 'Indica el monto minimo de un credito',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `DiasGraIngCre` int(11) DEFAULT NULL,
  `ProductosCre` varchar(600) DEFAULT NULL COMMENT 'Ids separados por comas, corresponde con la tabla PRODUCTOSCREDITO',
  `MaxDiasMora` int(11) DEFAULT NULL COMMENT 'Maximo dias de mora q puede tener un credito',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'clasificacion del credito; C .- Comercial,  O .- Consumo,  H .- Hipotecario N.- No aplica',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LineaFondeoID`,`Sexo`,`EstadoCivil`),
  KEY `fk_LINFONCONDCTE_1_idx` (`LineaFondeoID`),
  KEY `fk_LINFONCONDCTE_2` (`MonedaID`),
  CONSTRAINT `fk_LINFONCONDCTE_1` FOREIGN KEY (`LineaFondeoID`) REFERENCES `LINEAFONDEADOR` (`LineaFondeoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_LINFONCONDCTE_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Condiciones descto Lineas Fondeo para clientes'$$