-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETOPEALRIESPLD
DELIMITER ;
DROP TABLE IF EXISTS `DETOPEALRIESPLD`;DELIMITER $$

CREATE TABLE `DETOPEALRIESPLD` (
  `OpeAltoRiesgoID` int(11) NOT NULL,
  `ContratoID` varchar(20) DEFAULT NULL,
  `ConsecContrato` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `UsuarioID` int(11) DEFAULT NULL,
  `FechaDeteccion` date DEFAULT NULL,
  `SucursalManeja` int(11) DEFAULT NULL,
  `MotivoNRiesgoID` varchar(3) DEFAULT NULL,
  `ProNRiesgoCteID` varchar(3) DEFAULT NULL,
  `CveInstrumento` varchar(20) DEFAULT NULL,
  `ModuloInstrumento` varchar(45) DEFAULT NULL,
  `MontoOperacion` decimal(12,2) DEFAULT NULL,
  `MonedaID` int(11) DEFAULT NULL,
  `TuvoEscalam` char(1) DEFAULT NULL,
  `ConsecEscalam` tinyint(4) DEFAULT NULL,
  `TuvoSeguim` char(1) DEFAULT NULL,
  `ConsecSeguim` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OpeAltoRiesgoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de operaciones de alto riesgo '$$