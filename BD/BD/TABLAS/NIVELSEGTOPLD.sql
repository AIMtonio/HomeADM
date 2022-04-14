-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NIVELSEGTOPLD
DELIMITER ;
DROP TABLE IF EXISTS `NIVELSEGTOPLD`;DELIMITER $$

CREATE TABLE `NIVELSEGTOPLD` (
  `NivelSegtoID` int(11) NOT NULL COMMENT 'clave de nivel se segto',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'descripcion del nivel de seguimiento',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NivelSegtoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de tipos de nivel de seguimiento para los fines de '$$