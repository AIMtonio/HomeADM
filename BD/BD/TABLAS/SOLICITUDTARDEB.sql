-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDTARDEB
DELIMITER ;
DROP TABLE IF EXISTS `SOLICITUDTARDEB`;DELIMITER $$

CREATE TABLE `SOLICITUDTARDEB` (
  `FolioSolicitudID` int(11) NOT NULL COMMENT 'Folio generado de la solicitud',
  `TipoSolicitud` char(1) DEFAULT NULL COMMENT 'R=Reposicion,N=Nueva',
  `TarjetaDebAntID` char(16) DEFAULT NULL COMMENT 'Numero de Tarjeta de Debito a reponer. Este campo ira vacio cuando la solicitud sea nueva',
  `CorpRelacionadoID` int(11) DEFAULT NULL COMMENT 'Identificador del Cliente Corporativo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente que solicita la tarjeta ( CLIENTE FINAL NO COORPORATIVO)',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TipoTarjetaDebID` int(11) DEFAULT NULL COMMENT 'Tipo de Tarjeta solicitada FK tabla TIPOTARJETADEB',
  `NombreTarjeta` varchar(45) DEFAULT NULL COMMENT 'Nombre de tarjeta debito NOMINATIVA, si no es nominativa ira VACIO.',
  `Relacion` char(1) DEFAULT NULL COMMENT 'Relacion del TarjetaHabiente  T.-Titular, A.-Adicional',
  `Costo` decimal(13,2) DEFAULT NULL COMMENT 'Costo por reposicion emision de tarjeta.',
  `FechaSolicitud` datetime DEFAULT NULL COMMENT 'Fecha de Solicitud de Tarjeta',
  `LoteFolio` int(11) DEFAULT NULL COMMENT 'No de Lote que se genera momento de crear el archivo para solicitar las tarjetas nominativas',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Solicitud \nS.- Solicitada',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo Auditoria',
  PRIMARY KEY (`FolioSolicitudID`),
  KEY `ClienteID_idx` (`ClienteID`),
  KEY `CuentaAhoID_idx` (`CuentaAhoID`),
  KEY `fk_SOLICITUDTARDEB_1` (`TipoTarjetaDebID`),
  CONSTRAINT `ClienteID` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `CuentaAhoID` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITUDTARDEB_1` FOREIGN KEY (`TipoTarjetaDebID`) REFERENCES `TIPOTARJETADEB` (`TipoTarjetaDebID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Solicitud de Tarjeta Debito Reposicion o Nominativa.'$$