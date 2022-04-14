-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCUEN
DELIMITER ;
DROP TABLE IF EXISTS `CLIAPROTECCUEN`;DELIMITER $$

CREATE TABLE `CLIAPROTECCUEN` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `SaldoCuenta` decimal(14,2) DEFAULT NULL COMMENT 'Saldo  de la cuenta',
  `MonAplicaCuenta` decimal(14,2) DEFAULT NULL COMMENT 'Monto que se aplicara por proteccion de credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`CuentaAhoID`),
  KEY `fk_CLIAPROTECCUEN_1_idx` (`ClienteID`),
  KEY `fk_CLIAPROTECCUEN_2_idx` (`CuentaAhoID`),
  CONSTRAINT `fk_CLIAPROTECCUEN_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIAPLICAPROTEC` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIAPROTECCUEN_2` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda las cuentas activas que tenga el cliente en el moment'$$