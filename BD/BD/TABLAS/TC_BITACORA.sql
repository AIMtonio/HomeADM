-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORA
DELIMITER ;
DROP TABLE IF EXISTS `TC_BITACORA`;DELIMITER $$

CREATE TABLE `TC_BITACORA` (
  `TarjetaCredID` char(16) NOT NULL COMMENT 'ID de la tarjeta de Credito',
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
  KEY `fk_BITACORATARCRED_1` (`TipoEvenTDID`),
  KEY `fk_BITACORATARCRED_2` (`MotivoBloqID`),
  CONSTRAINT `fk_BITACORATARCRED_1` FOREIGN KEY (`TipoEvenTDID`) REFERENCES `TARDEBEVENTOSTD` (`TipoEvenTDID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tipos de Eventos de la Bitacora de Tarjeta de Credito'$$