-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREGHISCUENTASAHO
DELIMITER ;
DROP TABLE IF EXISTS `TMPREGHISCUENTASAHO`;DELIMITER $$

CREATE TABLE `TMPREGHISCUENTASAHO` (
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente al que pertenece la cuenta',
  `Saldo` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de la cuenta',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'ID del estado de la direccion del cliente',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'ID del municipio de la direccion del cliente',
  `ColoniaID` int(11) DEFAULT NULL,
  `CodigoPostal` varchar(5) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de transaccion que genera el reporte',
  PRIMARY KEY (`CuentaAhoID`,`NumTransaccion`),
  KEY `idxCliTmp` (`ClienteID`),
  KEY `idxEstTmp` (`EstadoID`),
  KEY `idxMuniTmp` (`MunicipioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para reportes regulatorios, Almacena datos de'$$