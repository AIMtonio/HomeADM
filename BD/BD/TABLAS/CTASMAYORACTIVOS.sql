-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTASMAYORACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `CTASMAYORACTIVOS`;DELIMITER $$

CREATE TABLE `CTASMAYORACTIVOS` (
  `ConceptoActivoID` int(11) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSACTIVOS',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Numero de Cuenta Mayor',
  `Nomenclatura` varchar(60) DEFAULT NULL COMMENT 'Nomenclatura de la cuenta',
  `NomenclaturaCC` varchar(60) DEFAULT NULL COMMENT 'Nomenclatura centro de costo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ConceptoActivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas Mayor de Activos'$$