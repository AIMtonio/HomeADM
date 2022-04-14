-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNAGARANTIAS
DELIMITER ;
DROP TABLE IF EXISTS `ASIGNAGARANTIAS`;DELIMITER $$

CREATE TABLE `ASIGNAGARANTIAS` (
  `SolicitudCreditoID` int(11) DEFAULT NULL COMMENT 'Solicitud de Credito',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID o Numero de Credito',
  `GarantiaID` int(11) NOT NULL COMMENT 'ID de la Garantia',
  `MontoAsignado` decimal(14,2) NOT NULL COMMENT 'Monto Asignado de la Garantia',
  `FechaRegistro` date NOT NULL COMMENT 'Fecha de Registro o Captura',
  `Estatus` char(1) NOT NULL COMMENT 'A .- Asignada  U .- Autorizada',
  `EstatusSolicitud` char(1) DEFAULT '' COMMENT 'Estatus de la Solicitud \nO: Origen\nN: Nuevo',
  `SustituyeGL` char(1) DEFAULT 'N' COMMENT 'Indica si la garantia   prendaría o hipotecaría podrá considerarse como garantía liquida. S= Si N= No',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_ASIGNAGARANTIAS_1` (`GarantiaID`),
  KEY `fk_ASIGNAGARANTIAS_2` (`SolicitudCreditoID`),
  KEY `fk_ASIGNAGARANTIAS_3` (`CreditoID`),
  CONSTRAINT `fk_ASIGNAGARANTIAS_1` FOREIGN KEY (`GarantiaID`) REFERENCES `GARANTIAS` (`GarantiaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Relacion de Garantias Asignadas al Credito o Solicitud'$$