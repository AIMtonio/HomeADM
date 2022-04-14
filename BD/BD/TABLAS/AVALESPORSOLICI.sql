-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESPORSOLICI
DELIMITER ;
DROP TABLE IF EXISTS `AVALESPORSOLICI`;
DELIMITER $$


CREATE TABLE `AVALESPORSOLICI` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `SolicitudCreditoID` bigint(20) DEFAULT NULL,
  `AvalID` bigint(11) DEFAULT NULL COMMENT 'ID del Aval',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente Asociado al Aval',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Número de Prospecto que fungirá como Aval',
  `Estatus` varchar(1) DEFAULT NULL COMMENT 'Estatus del Aval asociado a una Solicitud\nA: Asignado\nU: Autorizado',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha de Registro',
  `EstatusSolicitud` char(1) DEFAULT '' COMMENT 'Estatus de la Solicitud \nO: Origen\nN: Nuevo',
  `TipoRelacionID` int(11) NOT NULL COMMENT 'Identificador del tipo de relacion',
  `TiempoDeConocido` decimal(12,2) NOT NULL COMMENT 'Tiempo de conocido del Aval en anios utilizando decimal',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_AVALESPORSOLICI_1` (`SolicitudCreditoID`),
  KEY `fk_AVALESPORSOLICI_2` (`AvalID`),
  KEY `fk_AVALESPORSOLICI_3` (`ClienteID`),
  KEY `fk_AVALESPORSOLICI_4` (`ProspectoID`),
  PRIMARY KEY (`RegistroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Avales por Solicitud'$$
