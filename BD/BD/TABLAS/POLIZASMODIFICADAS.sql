-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASMODIFICADAS
DELIMITER ;
DROP TABLE IF EXISTS `POLIZASMODIFICADAS`;DELIMITER $$

CREATE TABLE `POLIZASMODIFICADAS` (
  `PolizaActual` bigint(12) DEFAULT NULL COMMENT 'Id de poliza actual registrada',
  `PolizaID` bigint(12) DEFAULT NULL COMMENT 'Id de la poliza anterior al cambio.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Prametro de auditoria EmpresaID.',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la operacion de la piliza anterior.',
  `Tipo` char(1) DEFAULT NULL COMMENT 'Tipo de poliza inforacion de la poliza anterior.',
  `ConceptoID` int(11) DEFAULT NULL COMMENT 'Identificador del concepto por el que se genero la poliza.',
  `Concepto` varchar(150) DEFAULT NULL COMMENT 'Descripcion del concepto.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria Usuario que realizo la poliza anterior.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria Fecha en que se realizo la poliza anterior.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria Direccion Ip del equipo que genero la poliza anterior.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria ProgramaID de elorigen de la operacion de la poliza anterior.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria Sucursal de donde se genero la poliza anterior.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoriaNumero de transaccion con el que se genero la poliza anterior.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$