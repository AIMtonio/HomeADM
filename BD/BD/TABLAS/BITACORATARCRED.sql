-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORATARCRED
DELIMITER ;
DROP TABLE IF EXISTS `BITACORATARCRED`;DELIMITER $$

CREATE TABLE `BITACORATARCRED` (
  `TarjetaCredID` char(16) NOT NULL COMMENT 'ID de la tarjeta de credito',
  `TipoEvenTDID` char(16) NOT NULL COMMENT 'ID del Tipo Evento de la Bitacora fk TARDEBEVENTOSTD',
  `MotivoBloqID` int(11) DEFAULT NULL COMMENT 'Motivo de Bloqueo FK tabla CATALCANBLOQTAR',
  `DescripAdicio` varchar(500) DEFAULT NULL COMMENT 'Descripcion Adicional del Evento (Tipo Bloqueo, Cuenta asociada, etc ,etc)',
  `Fecha` datetime DEFAULT NULL COMMENT 'Hora y Fecha del Evento',
  `NombreCliente` varchar(150) DEFAULT NULL COMMENT 'Nombre del TItular de la Tarjeta de Debito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  KEY `fk_BITACORATARDEB_1` (`TipoEvenTDID`),
  KEY `fk_BITACORATARDEB_2` (`MotivoBloqID`),
  CONSTRAINT `BITACORATARCRED_ibfk_1` FOREIGN KEY (`TipoEvenTDID`) REFERENCES `TARDEBEVENTOSTD` (`TipoEvenTDID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Lleva el registro de mivimientos del estatus de tarjetas'$$