-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMSCALIFICA
DELIMITER ;
DROP TABLE IF EXISTS `PARAMSCALIFICA`;
DELIMITER $$


CREATE TABLE `PARAMSCALIFICA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CapitalNeto` decimal(12,2) NOT NULL COMMENT 'Capital Neto o Contable al Cierre de Mes anterior',
  `TipoInstitucion` varchar(2) NOT NULL COMMENT 'Tipo de Institución: R1 IFNB Regulada y no UCS, R2 IFNB Regulado tipo UCS y N IFNB No regulada \n',
  `LimiteExpuesto` int(4) NOT NULL COMMENT 'Tipo de Limite para montos expuestos : 0 - Inferior 1 - Intermedio y 2 - Superior \n',
  `LimiteCubierto` int(4) NOT NULL COMMENT 'Tipo de Limite para montos cubiertos : 0 - Inferior 1 - Intermedio y 2 - Superior \n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros para calificación y calculo de reservas\n'$$
