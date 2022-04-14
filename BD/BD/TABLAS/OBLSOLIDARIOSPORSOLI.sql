-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBLSOLIDARIOSPORSOLI
DELIMITER ;
DROP TABLE IF EXISTS `OBLSOLIDARIOSPORSOLI`;DELIMITER $$

CREATE TABLE `OBLSOLIDARIOSPORSOLI` (
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Identificador para la solicitud de credito ',
  `OblSolidID` bigint(11) NOT NULL COMMENT 'Identificador para obligados solidarios',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente ',
  `ProspectoID` int(11) NOT NULL COMMENT 'Identificador del Prospecto',
  `Estatus` varchar(1) NOT NULL COMMENT 'El estatus',
  `FechaRegistro` datetime NOT NULL COMMENT 'La fecha de registro ',
  `TipoRelacionID` int(11) NOT NULL COMMENT 'Identificador del tipo de relacion ',
  `TiempoDeConocido` decimal(12,2) NOT NULL COMMENT 'Tiempo de conocido ',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  KEY `INDICE_OBLSOLIDARIOSPORSOLI_1` (`SolicitudCreditoID`),
  KEY `INDICE_OBLSOLIDARIOSPORSOLI_2` (`OblSolidID`),
  KEY `INDICE_OBLSOLIDARIOSPORSOLI_3` (`ClienteID`),
  KEY `INDICE_OBLSOLIDARIOSPORSOLI_4` (`ProspectoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para los obligados solidarios por solicitud.'$$