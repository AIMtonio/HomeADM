-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDESCERO
DELIMITER ;
DROP TABLE IF EXISTS `SOLICITUDESCERO`;DELIMITER $$

CREATE TABLE `SOLICITUDESCERO` (
  `SolicitudCeroID` bigint(20) NOT NULL COMMENT 'Numero de Registro',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de Registro de la Solicitud',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Indica el Usuario que da de Alta el Crédito',
  `Condicionada` char(1) DEFAULT 'N' COMMENT 'Valida si el Credito esta Condicionado',
  `CanalIngreso` char(1) DEFAULT 'S' COMMENT 'S .- Sucursal\nM .- Banca Movil\nL .- Banca en Linea',
  `ComentarioMesaControl` varchar(6000) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Comentario para la Mesa de Control',
  PRIMARY KEY (`SolicitudCeroID`),
  KEY `fk_SOLICITUDCREDITO_1_idx` (`CreditoID`),
  KEY `fk_SOLICITUDCREDITO_2_idx` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena Creditos que no tienen registrado una Solicitud de Credito'$$