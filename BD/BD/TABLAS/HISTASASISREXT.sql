-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISTASASISREXT
DELIMITER ;
DROP TABLE IF EXISTS `HISTASASISREXT`;DELIMITER $$

CREATE TABLE `HISTASASISREXT` (
  `TasasExtID` int(11) NOT NULL COMMENT 'Numero Consecutivo.',
  `PaisID` int(11) NOT NULL COMMENT 'Numero de Pais, corresponde al ID de PAISES.',
  `TasaISR` decimal(12,2) NOT NULL COMMENT 'Valor de la Tasa ISR.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria.',
  PRIMARY KEY (`TasasExtID`),
  KEY `IDX_HISTASASISREXT_1` (`PaisID`),
  KEY `IDX_HISTASASISREXT_2` (`TasaISR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Tasas ISR de Residentes en el Extranjero.'$$