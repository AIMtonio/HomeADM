-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORASEGCOB
DELIMITER ;
DROP TABLE IF EXISTS `BITACORASEGCOB`;DELIMITER $$

CREATE TABLE `BITACORASEGCOB` (
  `BitacoraID` int(11) NOT NULL COMMENT 'Identificador consecutivo del registro de la bitacora',
  `Fecha` date NOT NULL COMMENT 'Fecha del sistema',
  `UsuarioID` int(11) NOT NULL COMMENT 'Identificador del usuario',
  `SucursalID` int(11) NOT NULL COMMENT 'Identificador de la sucursal',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Identificador del credito',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente',
  `AccionID` int(11) NOT NULL COMMENT 'Identificador del tipo de accion tabla TIPOACCIONCOB',
  `RespuestaID` int(11) NOT NULL COMMENT 'Identificador del tipo de respuesta tabla TIPORESPUESTACOB',
  `Comentario` varchar(300) NOT NULL COMMENT 'Comentario bitacora se seguimiento de cobranza',
  `EtiquetaEtapa` varchar(10) NOT NULL COMMENT 'Etiqueta etapa tabla ESQUEMANOTICOB',
  `FechaEntregaDoc` date NOT NULL COMMENT 'Fecha entrega documento',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`BitacoraID`),
  KEY `IDX_BITACORASEGCOB_1` (`UsuarioID`),
  KEY `IDX_BITACORASEGCOB_2` (`SucursalID`),
  KEY `IDX_BITACORASEGCOB_3` (`CreditoID`),
  KEY `IDX_BITACORASEGCOB_4` (`ClienteID`),
  KEY `IDX_BITACORASEGCOB_5` (`AccionID`),
  KEY `IDX_BITACORASEGCOB_6` (`RespuestaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena la bitacora de seguimiento de cobranza'$$