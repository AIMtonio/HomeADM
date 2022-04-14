-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CASASCOMERCIALES
DELIMITER ;
DROP TABLE IF EXISTS `CASASCOMERCIALES`;
DELIMITER $$

CREATE TABLE `CASASCOMERCIALES` (
  `CasaComercialID` bigint(11) NOT NULL COMMENT 'ID Número de la Casa Comercial.',
  `NombreCasaCom` varchar(200) DEFAULT '' COMMENT 'Nombre completo de la Casa Comercial.',
  `TipoDispersionCasa` char(1) DEFAULT '' COMMENT 'Tipo o Medio de Dispersión para la Casa Comercial.\nC: Cheque\nS: SPEI\nO: Orden de Pago',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'ID de la Institución de la Cuenta Bancaria de la Casa Comercial\nsólo si el tipo de dispersión es SPEI.',
  `CuentaCLABE` char(18) DEFAULT '' COMMENT 'Cuenta CLABE de la Casa Comercial\ncuando el Tipo de Dispersión es por SPEI.',
  `Estatus` char(1) DEFAULT 'A' COMMENT 'Estatus de la Casa Comercial.\nA: Activo\nI: Inactivo',
  `RFC` char(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes de la Casa Comercial',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CasaComercialID`),
  KEY `FK_CASASCOMERCIALES_1_idx` (`InstitucionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Casas Comerciales para la Compra de Cartera.'$$
