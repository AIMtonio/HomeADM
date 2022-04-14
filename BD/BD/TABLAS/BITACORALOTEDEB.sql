-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORALOTEDEB
DELIMITER ;
DROP TABLE IF EXISTS `BITACORALOTEDEB`;DELIMITER $$

CREATE TABLE `BITACORALOTEDEB` (
  `BitCargaID` int(11) NOT NULL COMMENT 'ID Lote. Es un consecutivo que se mantiene en FOLIOSAPLIC',
  `ConsecutivoBit` int(11) NOT NULL COMMENT 'Consecutivo general de la tabla',
  `TipoTarjetaDebID` int(11) DEFAULT NULL COMMENT 'ID del Tipo de Tarjeta de Debito tabla TIPOTARJETADEB',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha de Registro del Lote',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que Genero el Lote tabla USUARIOS',
  `RutaArchivo` varchar(200) DEFAULT NULL COMMENT 'Numero de Tarjetas Generadas con este Folio',
  `NumRegistro` int(11) DEFAULT NULL COMMENT 'Folio Inicial',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Folio Final',
  `FechaVencimiento` char(5) DEFAULT NULL COMMENT 'corresponde con la fecha de vencimiento de la tarjeta',
  `NIP` varchar(256) DEFAULT NULL COMMENT 'NIP de la Tarjeta.Encriptado con SHA',
  `NombreTarjeta` varchar(250) DEFAULT NULL COMMENT 'Nombre del TarjetaHabiente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Registro Procesado\n"E .- Exito\nF .- Fallo"\n',
  `MotivoFallo` varchar(200) DEFAULT NULL COMMENT 'Folio Final',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`BitCargaID`,`ConsecutivoBit`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora en la Generacion de Lotes de Tarjeta de Debito'$$