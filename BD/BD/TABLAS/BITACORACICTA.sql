-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACICTA
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACICTA`;DELIMITER $$

CREATE TABLE `BITACORACICTA` (
  `TipoProceso` int(2) DEFAULT NULL COMMENT 'Numero de proceso del cierre',
  `DescripPro` varchar(50) DEFAULT NULL COMMENT 'Descripcion del proceso',
  `TiempoPro` int(11) DEFAULT NULL COMMENT 'Tiempo del proceso',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en la que se ejecuto',
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha en la que se ejecuto',
  `FechaSistema` date DEFAULT NULL COMMENT 'Fecha en la que se ejecuto',
  `Estatus` char(3) DEFAULT NULL COMMENT 'Para llevar el control se seguir o no con el proceso S = SI N = NO '
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal de Cuentas de Ahorro'$$