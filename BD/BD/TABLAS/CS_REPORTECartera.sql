--
-- Table structure for table `CS_REPORTECartera`
--
DELIMITER ;
DROP TABLE IF EXISTS `CS_REPORTECartera`;
DELIMITER $$

CREATE TABLE `CS_REPORTECartera` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha_de_la_operacion` date NOT NULL COMMENT 'fecha del movimiento',
  `Folio_de_la_operacion` bigint(20) NOT NULL,
  `Nombre_del_Usuario` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `No_De_contrato` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `Monto_de_la_operación` decimal(12,2) DEFAULT NULL,
  `Tipo_de_divisa` varchar(5) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Instrumento_monetario` varchar(19) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
