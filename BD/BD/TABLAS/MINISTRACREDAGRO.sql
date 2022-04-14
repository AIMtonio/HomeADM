-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREDAGRO
DELIMITER ;
DROP TABLE IF EXISTS `MINISTRACREDAGRO`;
DELIMITER $$

CREATE TABLE `MINISTRACREDAGRO` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion con la que se registra',
  `Numero` int(11) NOT NULL COMMENT 'Número Consecutivo de la Ministración.',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de Solicitud de Crédito',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Numero de Prospecto',
  `FechaPagoMinis` date NOT NULL COMMENT 'Fecha de Pago de la Ministracion',
  `Capital` decimal(18,2) NOT NULL COMMENT 'Monto de Capital de la ministracion',
  `FechaMinistracion` date DEFAULT NULL COMMENT 'Fecha Real en la que se realiza la ministración.',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Ministración:\nI.- Inactivo\nP.- Pendiente\nC.- Cancelada\nD.- Desembolsada',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'ID del Usuario que realiza la autorización dependiendo del Estatus de la Operación.',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha en la que se realiza la autorización dependiendo del Estatus de la Operación.',
  `ComentariosAutoriza` varchar(500) DEFAULT NULL COMMENT 'Comentarios que hace el usuario que autoriza, depende del Estatus de la Operación.',
  `ForPagComGarantia` CHAR(1) NOT NULL COMMENT 'Forma de pago Comision por Garantia \n"".- No aplica \nA.- Anticipada \nD.- Deducida \nV.- Al Vencimiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TransaccionID`,`Numero`),
  KEY `FK_MINISTRACIONESCRED_1_idx` (`ClienteID`),
  KEY `INDEX_MINISTRACREDAGRO_2_idx` (`SolicitudCreditoID`,`CreditoID`,`ClienteID`,`ProspectoID`),
  KEY `FK_MINISTRACREDAGRO_1_idx` (`UsuarioAutoriza`),
  KEY `INDEX_MINISTRACREDAGRO_3_idx` (`TransaccionID`),
  KEY `INDEX_MINISTRACREDAGRO_4_idx` (`SolicitudCreditoID`),
  CONSTRAINT `FK_MINISTRACREDAGRO_1` FOREIGN KEY (`UsuarioAutoriza`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Ministraciones para Creditos Agropecuarios'$$