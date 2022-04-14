-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDTARCRE
DELIMITER ;
DROP TABLE IF EXISTS `SOLICITUDTARCRE`;DELIMITER $$

CREATE TABLE `SOLICITUDTARCRE` (
  `FolioSolicitudID` int(11) NOT NULL COMMENT 'Folio generado de la solicitud',
  `TipoSolicitud` char(1) DEFAULT NULL COMMENT 'R=Reposicion,N=Nueva',
  `TarjetaCreAntID` char(16) DEFAULT NULL COMMENT 'Numero de Tarjeta de Credito a reponer. Este campo ira vacio cuando la solicitud sea nueva',
  `CorpRelacionadoID` int(11) DEFAULT NULL COMMENT 'Identificador del Cliente Corporativo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente que solicita la tarjeta ( CLIENTE FINAL NO COORPORATIVO)',
  `LineaCreditoID` int(11) DEFAULT NULL COMMENT 'Numero de Linea de Credito Fk tabla LINEASCREDITO',
  `TipoTarjetaCredID` int(11) DEFAULT NULL COMMENT 'Tipo de Tarjeta solicitada FK tabla TIPOTARJETADEB ',
  `NombreTarjeta` varchar(45) DEFAULT NULL COMMENT 'Nombre de tarjeta credito NOMINATIVA, si no es nominativa ira VACIO.',
  `Relacion` char(1) DEFAULT NULL COMMENT 'Relacion del TarjetaHabiente  T.-Titular, A.-Adicional',
  `Costo` decimal(13,2) DEFAULT NULL COMMENT 'Costo por reposicion emision de tarjeta.',
  `FechaSolicitud` datetime DEFAULT NULL COMMENT 'Fecha de Solicitud de Tarjeta',
  `LoteFolio` int(11) DEFAULT NULL COMMENT 'No de Lote que se genera momento de crear el archivo para solicitar las tarjetas nominativas',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Solicitud \\nS.- Solicitada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo Auditoria',
  PRIMARY KEY (`FolioSolicitudID`),
  KEY `ClienteID_idx` (`ClienteID`),
  KEY `tipoTarjetaCredID_idx` (`TipoTarjetaCredID`),
  KEY `lineaCreditoID_idx` (`LineaCreditoID`),
  CONSTRAINT `fk_SOLICITUDTARCRE_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `fk_SOLICITUDTARCRE_2` FOREIGN KEY (`TipoTarjetaCredID`) REFERENCES `TIPOTARJETADEB` (`TipoTarjetaDebID`),
  CONSTRAINT `fk_SOLICITUDTARCRE_3` FOREIGN KEY (`LineaCreditoID`) REFERENCES `LINEATARJETACRED` (`LineaTarCredID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Lleva el registro de solicitud de tarjeta de credito'$$