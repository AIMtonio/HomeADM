-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBTIPOSACLARA
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBTIPOSACLARA`;DELIMITER $$

CREATE TABLE `TARDEBTIPOSACLARA` (
  `TipoAclaraID` int(11) NOT NULL COMMENT 'Llave Principal para Catalogo de Tipo de Aclaraciones ',
  `Descripcion` varchar(70) DEFAULT NULL COMMENT 'Descripcion del Tipo de Aclaración',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de Tipo de Aclaración, solo los activos se muestran en pantalla\nA = Activo \nI = Inactivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoAclaraID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Catalogo de Tipos de Aclaraciones.'$$