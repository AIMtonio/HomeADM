-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOTETARJETADEB
DELIMITER ;
DROP TABLE IF EXISTS `LOTETARJETADEB`;DELIMITER $$

CREATE TABLE `LOTETARJETADEB` (
  `LoteDebitoID` int(11) NOT NULL COMMENT 'ID Lote. Es un consecutivo que se mantiene en FOLIOSAPLIC',
  `TipoTarjetaDebID` int(11) DEFAULT NULL COMMENT 'ID del Tipo de Tarjeta de Debito tabla TIPOTARJETADEB',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de Registro del Lote',
  `SucursalSolicita` char(4) DEFAULT NULL,
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que Genero el Lote tabla USUARIOS',
  `NumTarjetas` int(11) DEFAULT NULL COMMENT 'Numero de Tarjetas Generadas con este Folio',
  `Estatus` int(11) DEFAULT NULL,
  `EsAdicional` varchar(5) DEFAULT NULL,
  `NomArchiGen` varchar(20) DEFAULT NULL,
  `FolioInicial` int(11) DEFAULT NULL COMMENT 'Folio Inicial',
  `FolioFinal` int(11) DEFAULT NULL COMMENT 'Folio Final',
  `BitCargaID` int(11) DEFAULT NULL COMMENT 'ID de la Bitacora de Carga. tabla BITACORALOTEDEB ',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LoteDebitoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Lotes Generados de las Tarjetas de Debito'$$