-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOCUENTATRANS
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOCUENTATRANS`;DELIMITER $$

CREATE TABLE `CATTIPOCUENTATRANS` (
  `CuentaTransID` int(11) NOT NULL COMMENT 'Codigo de Tipo de Cuenta',
  `TipoInstitID` int(11) NOT NULL,
  `Descripcion` varchar(150) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CuentaTransID`,`TipoInstitID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Cuentas D2441 y D2442'$$