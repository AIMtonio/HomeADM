-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACOBAUT
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACOBAUT`;
DELIMITER $$


CREATE TABLE `BITACORACOBAUT` (
  `BitacoraCobAutID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID de la tabla',
  `FechaProceso` datetime NOT NULL COMMENT 'Fecha de la Bitacora',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Aplicacion\nA .- Aplicado\nF .- Fallido',
  `CreditoID` bigint(20) NOT NULL COMMENT 'Numero o ID de Credito',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero o ID de Cliente',
  `CuentaID` bigint(12) DEFAULT NULL,
  `SaldoDisponCta` decimal(12,2) NOT NULL COMMENT 'Saldo Disponible en la Cuenta de Ahorro al momento de Realizar el Proceso de la Cobranza',
  `MontoExigible` decimal(12,2) DEFAULT NULL COMMENT 'Monto Exigible del Credito',
  `MontoAplicado` decimal(12,2) NOT NULL COMMENT 'Monto del Pago Aplikado',
  `TiempoProceso` decimal(8,2) NOT NULL COMMENT 'Tiempo que toma aplicar el Pago por\nCada Credito',
  `GrupoID` int(11) DEFAULT NULL COMMENT 'Numero del Grupo al que se hizo el pago',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (BitacoraCobAutID),
  KEY `IDX_BITACORACOBAUT_1` (`BitacoraCobAutID`),
  KEY `IDX_BITACORACOBAUT_2` (`FechaProceso`),
  KEY `IDX_BITACORACOBAUT_3` (`ClienteID`),
  KEY `IDX_BITACORACOBAUT_4` (`CuentaID`),
  KEY `IDX_BITACORACOBAUT_5` (`CreditoID`),
  KEY `IDX_BITACORACOBAUT_6` (`GrupoID`),
  CONSTRAINT `FK_BITACORACOBAUT_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_BITACORACOBAUT_2` FOREIGN KEY (`CuentaID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla con la Bitacora de la Aplicacion de la Cobranza Automa'$$