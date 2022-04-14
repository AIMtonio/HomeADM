-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMSNOMINA
DELIMITER ;
DROP TABLE IF EXISTS `PARAMSNOMINA`;DELIMITER $$

CREATE TABLE `PARAMSNOMINA` (
  `CtaContablePagoTransito` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable de Aplicación de Pago de Credito de Nomina\nEn Transito',
  `CorreoElectronico` varchar(50) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros Generales del modulo de Nomina'$$