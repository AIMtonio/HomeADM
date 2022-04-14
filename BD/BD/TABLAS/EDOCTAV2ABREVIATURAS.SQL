DELIMITER ;

DROP TABLE IF EXISTS `EDOCTAV2ABREVIATURAS`;

DELIMITER $$

CREATE TABLE `EDOCTAV2ABREVIATURAS` (
  `EdoCtaV1AbreviaturasID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Abreviatura o simbolo de Abreviatura para la columna 1',
  `Abreviatuta01` varchar(30)      NOT NULL COMMENT 'Abreviatura o simbolo de Abreviatura para la columna 1',
  `Descripcion01` varchar(150)     NOT NULL COMMENT 'Descripcion de la Abreviatura Columna 1',
  `Abreviatuta02` varchar(30)      NOT NULL COMMENT 'Abreviatura o simbolo de Abreviatura para la columna 2',
  `Descripcion02` varchar(150)     NOT NULL COMMENT 'Descripcion de la Abreviatura Columna 2',
  PRIMARY KEY (`EdoCtaV1AbreviaturasID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar las abreviaturas que se muestran en el Estado de Cuenta.'$$
