-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCAMBIOSUCUR
DELIMITER ;
DROP TABLE IF EXISTS `PARAMCAMBIOSUCUR`;DELIMITER $$

CREATE TABLE `PARAMCAMBIOSUCUR` (
  `ParamCambioSucurID` int(11) NOT NULL,
  `ValCtasActivas` char(1) DEFAULT NULL COMMENT 'indica si se validara que el cliente tenga almenos una cuenta activa',
  `ValCtasBloqueadas` char(1) DEFAULT NULL COMMENT 'Valida si el cliente tiene cuentas bloquedas\n',
  `ValDiasAtraso` char(1) DEFAULT NULL COMMENT 'si se validara que el cliente no tenga creditos con Dias de atraso \n',
  `ValCreCastVencido` char(1) DEFAULT NULL COMMENT 'Valida si el cliente tiene creditos Castigados',
  `ValInvProceso` char(1) DEFAULT NULL COMMENT 'validar si el cliente tiene Inversiones en proceso',
  `ValProfun` char(1) DEFAULT NULL COMMENT 'Validar si el cliente tiene Adudos de Profun',
  `ValCredAvalados` char(1) DEFAULT NULL COMMENT 'Si se validan los creditos avalados en pantalla',
  `Reclasificaconta` char(1) DEFAULT NULL COMMENT 'indica si se Realizara la Reclasificacion contable al cambiar un cliente de sucursal',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ParamCambioSucurID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros para el cambio de Sucursal de un cliente'$$