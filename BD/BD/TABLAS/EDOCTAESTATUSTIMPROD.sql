-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAESTATUSTIMPROD
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAESTATUSTIMPROD`;
DELIMITER $$



CREATE TABLE `EDOCTAESTATUSTIMPROD` (
  `Anio` int(11) NOT NULL COMMENT 'Anido de timbrado',
  `MesIni` int(11) NOT NULL COMMENT 'Mes de inicio de timbrado',
  `MesFin` int(1) NOT NULL COMMENT 'Fecha de fin de timbrado',
  `Frecuencia` char(1) DEFAULT NULL COMMENT 'Frecuencia M=Mensual E=Semestral',
  `ProductoCredID` int(4) NOT NULL COMMENT 'Producto de Credito',
  `Mes1` char(1) DEFAULT NULL COMMENT 'Mes de Enero N= NO Timbrado S= Si Timbrado',
  `Mes2` char(1) DEFAULT NULL COMMENT 'Mes de Febrero N= NO Timbrado S= Si Timbrado',
  `Mes3` char(1) DEFAULT NULL COMMENT 'Mes de Marzo N= NO Timbrado S= Si Timbrado',
  `Mes4` char(1) DEFAULT NULL COMMENT 'Mes de Abril N= NO Timbrado S= Si Timbrado',
  `Mes5` char(1) DEFAULT NULL COMMENT 'Mes de Mayo N= NO Timbrado S= Si Timbrado',
  `Mes6` char(1) DEFAULT NULL COMMENT 'Mes de Junio N= NO Timbrado S= Si Timbrado',
  `Mes7` char(1) DEFAULT NULL COMMENT 'Mes de Julio N= NO Timbrado S= Si Timbrado',
  `Mes8` char(1) DEFAULT NULL COMMENT 'Mes de Agosto N= NO Timbrado S= Si Timbrado',
  `Mes9` char(1) DEFAULT NULL COMMENT 'Mes de Septiembre N= NO Timbrado S= Si Timbrado',
  `Mes10` char(1) DEFAULT NULL COMMENT 'Mes de Octubre N= NO Timbrado S= Si Timbrado',
  `Mes11` char(1) DEFAULT NULL COMMENT 'Mes de Noviembre N= NO Timbrado S= Si Timbrado',
  `Mes12` char(1) DEFAULT NULL COMMENT 'Mes de Diciembre N= NO Timbrado S= Si Timbrado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`Anio`,`MesIni`,`MesFin`,`ProductoCredID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene el control de los productos timbrados'$$
