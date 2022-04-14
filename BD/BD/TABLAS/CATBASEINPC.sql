-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATBASEINPC
DELIMITER ;
DROP TABLE IF EXISTS `CATBASEINPC`;

DELIMITER $$
CREATE TABLE `CATBASEINPC` (
    `CatBaseID` int(11) NOT NULL COMMENT 'Idetinficador del catalogo base',
    `MesBase` int(11) NOT NULL COMMENT 'Mes Base del Registro del Activo',
    `MesINPC` int(11) NOT NULL COMMENT 'Mes a tomar para el valor de INPC',
    `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
    `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
    `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
    `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
    `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
    `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
    `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`CatBaseID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catálogo Base para obtener el INPC para el cálculo de Depreciación Fiscal'$$