-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMENTARIOSSOL
DELIMITER ;
DROP TABLE IF EXISTS `COMENTARIOSSOL`;
DELIMITER $$


CREATE TABLE `COMENTARIOSSOL` (
  `ComentarioID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ComentarioID',
  `SolicitudCreditoID` bigint(20) NOT NULL DEFAULT '0' COMMENT 'SolicitudCreditoID',
  `Estatus` char(2) DEFAULT NULL COMMENT 'Estatus de la Solicitud de Credito\nSI: SOLICITUD INACTIVA\nSL: SOLICITUD LIBERADA\nSM: SOLICITUD EN ACTUALIZACIÓN\nSC: SOLICITUD CANCELADA\nSA: SOLICITUD AUTORIZADA\nSR: SOLICITUD RECHAZADA\nCI: CRÉDITO INACTIVO\nCA: CRÉDITO AUTORIZADO\nCC: CRÉDITO CONDICIONADO\nCD: CRÉDITO DESEMBOLSADO',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha de Registro de la Solicitud de Credito',
  `Comentario` varchar(2000) DEFAULT NULL COMMENT 'Comentario de Registro de la Solicitud de Credito',
  `UsuarioOperacion` int(11) DEFAULT NULL COMMENT 'Usuario que registro la Operacion',
  `TiempoEstatus` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ComentarioID`,`SolicitudCreditoID`),
  KEY `COMENTARIOSSOL_idx1` (`Estatus`) USING BTREE,
  KEY `COMENTARIOSSOL_idx2` (`Estatus`) USING BTREE,
  KEY `INDEX_COMENTARIOSSOL_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de Comentarios por Solicitud de Credito'$$