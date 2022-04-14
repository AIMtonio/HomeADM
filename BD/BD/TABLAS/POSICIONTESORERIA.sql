-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POSICIONTESORERIA
DELIMITER ;
DROP TABLE IF EXISTS `POSICIONTESORERIA`;
DELIMITER $$


CREATE TABLE `POSICIONTESORERIA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `SucursalID` int(11) NOT NULL COMMENT 'Id de la Sucursal',
  `TipoInstrumento` char(1) NOT NULL COMMENT 'Tipo de Instrumento:\nC .- Cartera\nI .- InvKubo\nP  .- InvPlazo',
  `PlazoInf` int(11) NOT NULL COMMENT 'Plazo Inf\nerior en Dias',
  `PlazoSup` int(11) NOT NULL COMMENT 'Plazo Superior en Dias\n',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital',
  `Interes` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Interes\n',
  `Moratorios` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios\n',
  `Comisiones` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Comisiones\n',
  `IVA` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de IVAs',
  `Retencion` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Retencion\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Registro',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa Origen',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal Origen',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  KEY `fk_POSICIONTESORERIA_1` (`SucursalID`),
  CONSTRAINT `fk_POSICIONTESORERIA_1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Posicion al Dia de la Tesoreria'$$
