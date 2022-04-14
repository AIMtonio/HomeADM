-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CUENTASAHOSUCUR
DELIMITER ;
DROP TABLE IF EXISTS `HIS-CUENTASAHOSUCUR`;DELIMITER $$

CREATE TABLE `HIS-CUENTASAHOSUCUR` (
  `CuentaSucurID` int(11) DEFAULT NULL COMMENT 'Consecutivo',
  `SucursalID` int(11) NOT NULL COMMENT 'ID de la sucursal\n',
  `InstitucionID` int(11) NOT NULL COMMENT 'ID de la Institucion',
  `CueClave` char(18) NOT NULL COMMENT 'Clave bancaria estandarizada',
  `EsPrincipal` char(1) DEFAULT 'N' COMMENT 'Es principal\nS= Si\nN=No\nsolo una principal por\nInstitucion',
  `Estatus` char(1) DEFAULT 'A' COMMENT 'Estatus \nA=Abilitada\nI  =Inabilitada\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT '	',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(70) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historial de Cuentas de ahorro de una sucursal'$$