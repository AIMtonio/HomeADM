-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORATARDEB
DELIMITER ;
DROP TABLE IF EXISTS `BITACORATARDEB`;DELIMITER $$

CREATE TABLE `BITACORATARDEB` (
  `TarjetaDebID` char(16) NOT NULL COMMENT 'ID de la tarjeta de Debito',
  `TipoEvenTDID` char(16) NOT NULL COMMENT 'ID del Tipo Evento de la Bitacora fk TARDEBEVENTOSTD',
  `MotivoBloqID` int(11) DEFAULT NULL COMMENT 'Motivo de Bloqueo FK tabla CATALCANBLOQTAR',
  `DescripAdicio` varchar(500) DEFAULT NULL COMMENT 'Descripcion Adicional del Evento (Tipo Bloqueo, Cuenta asociada, etc ,etc)',
  `Fecha` datetime DEFAULT NULL COMMENT 'Hora y Fecha del Evento',
  `NombreCliente` varchar(150) DEFAULT NULL COMMENT 'Nombre del TItular de la Tarjeta de Debito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_BITACORATARDEB_1` (`TipoEvenTDID`),
  KEY `fk_BITACORATARDEB_2` (`MotivoBloqID`),
  CONSTRAINT `fk_BITACORATARDEB_1` FOREIGN KEY (`TipoEvenTDID`) REFERENCES `TARDEBEVENTOSTD` (`TipoEvenTDID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Eventos de la Bitacora de Tarjeta de Debito'$$