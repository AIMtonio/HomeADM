-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-INTEGRAGRUPOSCRE
DELIMITER ;
DROP TABLE IF EXISTS `HIS-INTEGRAGRUPOSCRE`;
DELIMITER $$


CREATE TABLE `HIS-INTEGRAGRUPOSCRE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `GrupoID` int(10) DEFAULT NULL COMMENT 'ID de Grupo',
  `SolicitudCreditoID` int(11) DEFAULT NULL COMMENT 'ID de la Solicitud de Credito\n',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'ID del Prospecto',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\nA .- Integrante Activo\nI .- Integrante Inactivo o Dado de Baja',
  `ProrrateaPago` char(1) DEFAULT NULL COMMENT 'Especifica si se Prorratea el Pago\nS .- Si prorratea el Pago\nN .- NO prorratea el Pago',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha de Registro',
  `Ciclo` int(11) DEFAULT NULL COMMENT 'Numero del Ciclo Actual Del Grupo',
  `Cargo` int(11) DEFAULT NULL COMMENT 'Cargo del Integrante del Grupo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_INTEGRAGRUPOSCRE_1` (`SolicitudCreditoID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Integrantes de los Grupos de Credito'$$
