-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSOCIEDAD
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSOCIEDAD`;DELIMITER $$

CREATE TABLE `TIPOSOCIEDAD` (
  `TipoSociedadID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `AbreviCNBV` varchar(50) DEFAULT NULL COMMENT 'Abreviacion del Tipo de Sociedad segun CNBV',
  `EsFinanciera` char(1) DEFAULT 'N' COMMENT 'Define si el tipo de sociedad es una financiera.',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoSociedadID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalgo de tipos de Sociedad para Persona Moral'$$