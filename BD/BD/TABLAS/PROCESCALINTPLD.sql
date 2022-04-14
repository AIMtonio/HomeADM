-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROCESCALINTPLD
DELIMITER ;
DROP TABLE IF EXISTS `PROCESCALINTPLD`;DELIMITER $$

CREATE TABLE `PROCESCALINTPLD` (
  `ProcesoEscID` varchar(16) NOT NULL COMMENT 'clave del proceso de escalamiento',
  `Descripcion` varchar(30) DEFAULT NULL COMMENT 'descripcion del proceso de escalamiento',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden en el que se listan los procesos.',
  `AplicaCaptacion` char(1) DEFAULT 'S' COMMENT 'Indica si el proceso de escalamiento debe de mostrar los instrumentos de captación \ndependiendo del Tipo de Institución Financienra.\nS.- SI (Default)\nN.- NO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProcesoEscID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo  de procesos que generan escalamiento interno'$$