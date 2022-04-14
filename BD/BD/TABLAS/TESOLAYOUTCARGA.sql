-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOLAYOUTCARGA
DELIMITER ;
DROP TABLE IF EXISTS `TESOLAYOUTCARGA`;DELIMITER $$

CREATE TABLE `TESOLAYOUTCARGA` (
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TipoLayOut` char(1) DEFAULT NULL COMMENT 'Tipo de LayOut \nC = Carga\nS = Salida',
  `RutaLayOut` varchar(200) DEFAULT NULL COMMENT 'Ruta del xml que me indica la forma de ller el archivo para subirlo a la tabla de Conciliacion',
  `LineaInicial` int(10) DEFAULT NULL COMMENT 'Indica a partir de que linea comienza a leer el primer movimiento',
  KEY `fk_TESOLAYOUTCARGA_1` (`CuentaAhoID`),
  CONSTRAINT `fk_TESOLAYOUTCARGA_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Layout de Carga de Movimientos para la Conciliacion'$$