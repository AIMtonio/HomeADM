-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCUENTAIVACART
DELIMITER ;
DROP TABLE IF EXISTS `SUBCUENTAIVACART`;DELIMITER $$

CREATE TABLE `SUBCUENTAIVACART` (
  `ConceptoCartID` int(11) NOT NULL COMMENT 'ID del concepto de cartera',
  `Porcentaje` decimal(12,2) NOT NULL COMMENT 'Porcentaje asignado a la cuenta',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numero de la subcuenta entre el concepto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID del usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'IP de donde se realiza el movimiento',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ID del programa',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion',
  PRIMARY KEY (`ConceptoCartID`,`Porcentaje`),
  CONSTRAINT `SUBCUENTAIVACART_ibfk_1` FOREIGN KEY (`ConceptoCartID`) REFERENCES `CONCEPTOSCARTERA` (`ConceptoCarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para la subcuenta por porcentaje asignado'$$