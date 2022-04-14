-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOFONDEOAGRO
DELIMITER ;
DROP TABLE IF EXISTS `CAMBIOFONDEOAGRO`;
DELIMITER $$


CREATE TABLE `CAMBIOFONDEOAGRO` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito al que se le aplica el cambio',
  `FechaRegistro` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de REgistro del cambio',
  `MontoCredito` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Credito al momento del cambio del credito',
  `InstitFondeoIDAnt` int(11) DEFAULT NULL COMMENT 'Insitucion de Fondeo Anterior',
  `LineaFondeoAnt` int(11) DEFAULT NULL COMMENT 'ID de la INstitucion de Fondeo Anterior',
  `CreditoPasivoIDAnt` int(11) DEFAULT NULL COMMENT 'ID del Credito Pasivo a Pagar',
  `InstitFondeoID` int(11) DEFAULT NULL COMMENT 'Insitucion de Fondeo Nuevo',
  `LineaFondeo` int(11) DEFAULT NULL COMMENT 'ID de la INstitucion de Fondeo Nuevo',
  `CreditoPasivoID` int(11) DEFAULT NULL COMMENT 'ID del Credito Pasivo Nuevo',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'Usuario que autoriza el cambio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`CreditoID`,`FechaRegistro`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Registro Cambio Fondeo Agro'$$