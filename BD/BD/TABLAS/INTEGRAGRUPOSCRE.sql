-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSCRE
DELIMITER ;
DROP TABLE IF EXISTS `INTEGRAGRUPOSCRE`;DELIMITER $$

CREATE TABLE `INTEGRAGRUPOSCRE` (
  `GrupoID` int(10) NOT NULL COMMENT 'ID de Grupo',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'ID de la Solicitud de Credito\n',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'ID del Prospecto',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\nA .- Integrante Activo\nI .- Integrante Inactivo o Dado de Baja\nR .- Rechazada',
  `ProrrateaPago` char(1) DEFAULT NULL COMMENT 'Especifica si se Prorratea el Pago\nS .- Si prorratea el Pago\nN .- NO prorratea el Pago',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha de Registro',
  `Ciclo` int(11) DEFAULT NULL COMMENT 'Numero del Ciclo Actual Del Cliente',
  `Cargo` int(11) DEFAULT NULL COMMENT 'Cargo del Integrante del Grupo\n1 presidente\n2 tesorero\n3 secretario\n4 integrante',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GrupoID`,`SolicitudCreditoID`),
  KEY `fk_INTEGRAGRUPOSCRE_1` (`GrupoID`),
  KEY `fk_INTEGRAGRUPOSCRE_2` (`SolicitudCreditoID`),
  CONSTRAINT `fk_INTEGRAGRUPOSCRE_1` FOREIGN KEY (`GrupoID`) REFERENCES `GRUPOSCREDITO` (`GrupoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_INTEGRAGRUPOSCRE_2` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Integrantes de los Grupos de Credito'$$