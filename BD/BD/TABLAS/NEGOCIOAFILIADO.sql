-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NEGOCIOAFILIADO
DELIMITER ;
DROP TABLE IF EXISTS `NEGOCIOAFILIADO`;DELIMITER $$

CREATE TABLE `NEGOCIOAFILIADO` (
  `NegocioAfiliadoID` int(11) NOT NULL COMMENT 'Folio o Consecutivo del Negocio Afiliado',
  `RazonSocial` varchar(200) NOT NULL COMMENT 'Razon Social',
  `RFC` char(12) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes',
  `DireccionCompleta` varchar(400) NOT NULL COMMENT 'Domicilio del Negocio Afiliado',
  `TelefonoContacto` varchar(20) NOT NULL COMMENT 'Telefono de Contacto',
  `NombreContacto` varchar(400) NOT NULL COMMENT 'Nombre de Contacto',
  `Email` varchar(50) NOT NULL COMMENT 'Email o Correo electronico del Contacto',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de Alta o Registro',
  `PromotorOrigen` int(11) DEFAULT NULL COMMENT 'Promotor Inicial del Negocio Afiliado',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente, hace referencia a tabla CLIENTES',
  `Estatus` char(1) DEFAULT NULL COMMENT 'A - ALTA\nB - BAJA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NegocioAfiliadoID`),
  KEY `fk_NEGOCIOAFILIADO_1_idx` (`PromotorOrigen`),
  KEY `index_ClienteID` (`ClienteID`),
  CONSTRAINT `fk_NEGOCIOAFILIADO_1` FOREIGN KEY (`PromotorOrigen`) REFERENCES `PROMOTORES` (`PromotorID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$