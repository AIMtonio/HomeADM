-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMONTOAUTOMOD
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSMONTOAUTOMOD`;DELIMITER $$

CREATE TABLE `CREDITOSMONTOAUTOMOD` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `MontoOriginal` decimal(14,2) NOT NULL COMMENT 'Monto Original del Credito',
  `MontoModificado` decimal(14,2) NOT NULL COMMENT 'Monto Modificado del Credito',
  `Fecha` date NOT NULL COMMENT 'Fecha Registro o Modificacion',
  `Simulado` char(1) NOT NULL COMMENT 'Indica si ya se realizo la Simulacion\nS = SI\nN = NO',
  `FechaSimula` date NOT NULL COMMENT 'Fecha en que se realizo la Simulacion del Credito del monto modificado',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CreditoID`),
  KEY `INDEX_CREDITOSMONTOAUTOMOD_1` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Creditos con Montos Autorizados Modificados.'$$