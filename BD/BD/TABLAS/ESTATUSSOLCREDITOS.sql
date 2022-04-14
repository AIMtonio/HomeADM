
DELIMITER ;
DROP TABLE IF EXISTS ESTATUSSOLCREDITOS;
DELIMITER $$
CREATE TABLE `ESTATUSSOLCREDITOS` (
  `EstatusSolCreID` bigint(20) NOT NULL COMMENT 'Id del estatus de la solicitud de credito',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Id de la solicitud de credito',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del credito',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del la solicitu de credito \nI .- Inactivo\nL .- Liberada\nE .- EnAnalisis\nB .- Devuelta\nC .- Cancelada\nR .- Rechazada\nA .- Autorizada\nS .- Condicionado\nF .- Descondicionado\nD .- Desembolsado\nP .- Dispersado\nG .- Asignado',
  `Fecha` date NOT NULL COMMENT 'Fecha de cambio del estatus',
  `HoraActualizacion` time NOT NULL COMMENT 'Hora en que se actualiza el estatus de solicitud de credito',
  `MotivoRechazoID` varchar(50) DEFAULT NULL COMMENT 'Id motivo de rechazo de solicitud de credito',
  `UsuarioAct` int(11) NOT NULL COMMENT 'Id del usuario que actualiza el estatus',
  `Comentario` varchar(200) DEFAULT NULL COMMENT 'Comentario del usuario acerca del cambio de estatus',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`EstatusSolCreID`,`SolicitudCreditoID`),
  KEY `fk_ESTATUSSOLCREDITOS_1_idx` (`SolicitudCreditoID`),
  KEY `INDEX_ESTATUSSOLCREDITOS_2_idx` (`CreditoID`),
  KEY `INDEX_ESTATUSSOLCREDITOS_3` (`MotivoRechazoID`),
  KEY `INDEX_ESTATUSSOLCREDITOS_4` (`UsuarioAct`),
  KEY `INDEX_ESTATUSSOLCREDITOS_5` (`NumTransaccion`),
  CONSTRAINT `fk_ESTATUSSOLCREDITOS_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: tabla para almacenar los estatus que pasa la solicitud de credito'$$