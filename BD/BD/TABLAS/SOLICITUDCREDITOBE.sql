-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOBE
DELIMITER ;
DROP TABLE IF EXISTS `SOLICITUDCREDITOBE`;DELIMITER $$

CREATE TABLE `SOLICITUDCREDITOBE` (
  `SolicitudCreditoID` bigint(20) NOT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `ProspectoID` int(11) DEFAULT NULL,
  `FolioCtrl` varchar(20) DEFAULT NULL COMMENT 'Numero de control que la institucion de nomina tiene para el control de sus empleados',
  `InstitNominaID` int(11) DEFAULT NULL,
  `NegocioAfiliadoID` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SolicitudCreditoID`),
  KEY `SOLICITUDCREDITOBE_2` (`ClienteID`),
  KEY `SOLICITUDCREDITOBE_3` (`ProspectoID`),
  KEY `SOLICITUDCREDITOBE_4` (`InstitNominaID`),
  KEY `SOLICITUDCREDITOBE_5` (`NegocioAfiliadoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que sirve guardar los creditos dados de alta en Banca '$$