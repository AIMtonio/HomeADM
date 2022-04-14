-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCUENTACONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `TMPCUENTACONTABLE`;DELIMITER $$

CREATE TABLE `TMPCUENTACONTABLE` (
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0',
  `CuentaCompleta` varchar(30) NOT NULL COMMENT 'Cuenta Contable Completa',
  `CentroCosto` int(11) NOT NULL COMMENT 'Centro de Costos',
  `CuentaMayor` varchar(30) NOT NULL COMMENT 'Cuenta de Mayor',
  `Descripcion` varchar(250) NOT NULL COMMENT 'Descripción de la\nCuenta\n',
  `Naturaleza` char(1) NOT NULL COMMENT 'Naturaleza de la\nCuenta\nA .-  Acreedora\nD .-  Deudora',
  `Grupo` char(1) NOT NULL COMMENT 'Nivel de Desglose\nE= ''Encabezado'' \nD= ''Detalle''     ',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda ID',
  PRIMARY KEY (`NumTransaccion`,`CuentaCompleta`,`CentroCosto`),
  KEY `idx_TMPCUENTACONTABLE_1` (`CuentaMayor`,`NumTransaccion`,`CentroCosto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal Maestro o Catalogo de Cuentas Contables'$$