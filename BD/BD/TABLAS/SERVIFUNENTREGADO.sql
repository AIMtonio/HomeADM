-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNENTREGADO
DELIMITER ;
DROP TABLE IF EXISTS `SERVIFUNENTREGADO`;DELIMITER $$

CREATE TABLE `SERVIFUNENTREGADO` (
  `ServiFunEntregadoID` int(11) NOT NULL COMMENT 'Consecutivo',
  `ServiFunFolioID` int(11) NOT NULL COMMENT 'Folio o Consecutivo, del servicio Financiero',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'El numero del cliente de la persona relacionada(Solo si es cliente)',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre completo del clienete',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus en que se encuentra el registro del beneficiario para el programa\nP= Pagado\nA= Autorizado',
  `CantidadEntregado` int(11) DEFAULT NULL COMMENT 'Cantidad Total que le será entregado al Beneficiario',
  `NombreRecibePago` varchar(200) DEFAULT NULL COMMENT 'Nombre completo de la persona que realmente recibió el Pago del Programa',
  `TipoIdentiID` int(11) DEFAULT NULL COMMENT 'Tipo de identificación  con la que se identifico el cliente en ventanilla.',
  `FolioIdentific` varchar(30) DEFAULT NULL,
  `FechaEntrega` date DEFAULT NULL COMMENT 'Fecha en que se entrego el Apoyo al Beneficiario',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Indica la caja en la que se realizo el pago',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Indica la sucursal en donde se aplico el Pago',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ServiFunEntregadoID`),
  KEY `fk_SERVIFUNENTREGADO_1_idx` (`ServiFunFolioID`),
  CONSTRAINT `fk_SERVIFUNENTREGADO_1` FOREIGN KEY (`ServiFunFolioID`) REFERENCES `SERVIFUNFOLIOS` (`ServiFunFolioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registros autorizados y entregados del programa SERVIFUN de '$$