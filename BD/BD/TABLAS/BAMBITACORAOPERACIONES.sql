-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMBITACORAOPERACIONES
DELIMITER ;
DROP TABLE IF EXISTS `BAMBITACORAOPERACIONES`;DELIMITER $$

CREATE TABLE `BAMBITACORAOPERACIONES` (
  `NumeroOperacion` bigint(20) NOT NULL COMMENT 'Folio o Transaccion que identifica la Operacion como unica',
  `ClienteID` int(11) NOT NULL,
  `Folio` bigint(20) NOT NULL,
  `TipoOperacionID` bigint(20) NOT NULL COMMENT 'Folio o Transaccion que identifica la Operacion como unica',
  `FechaOperacion` datetime NOT NULL COMMENT 'Fecha Real en que se Realiza la Operacion',
  `Monto` decimal(12,2) NOT NULL COMMENT 'Monto de la Transaccion, cuando asi aplique',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion de la Operacion',
  `Referencia` varchar(45) NOT NULL COMMENT 'Referencia de la Operacion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NumeroOperacion`),
  KEY `fk_BAMBITACORAOPERACIONES_1_idx` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora o Detalle de las Operaciones que se Realizan en el Movil'$$