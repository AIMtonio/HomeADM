-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANIGRAMA
DELIMITER ;
DROP TABLE IF EXISTS `ORGANIGRAMA`;
DELIMITER $$

CREATE TABLE `ORGANIGRAMA` (
  `PuestoPadreID` bigint(20) NOT NULL COMMENT 'ID o clave del Puesto Padre',
  `PuestoHijoID` bigint(20) NOT NULL COMMENT 'ID o clave del Puesto Hijo',
  `RequiereCtaCon` char(1) NOT NULL DEFAULT 'N' COMMENT 'Si el puesto padre requiere las cuentas contables de los puestos hijos: S= si, N=no',
  `CtaContable` varchar(50) NOT NULL DEFAULT '' COMMENT 'Numero de cuenta contable',
  `CentroCostoID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del centro de costos',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PuestoPadreID`,`PuestoHijoID`),
  KEY `idx_ORGANIGRAMA_1` (`CtaContable`),
  KEY `idx_ORGANIGRAMA_2` (`CentroCostoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Informacion del Organigrama, Puestos y Dependencias'$$