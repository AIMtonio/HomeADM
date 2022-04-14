-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPRUDENCIALOPERA
DELIMITER ;
DROP TABLE IF EXISTS `CATPRUDENCIALOPERA`;DELIMITER $$

CREATE TABLE `CATPRUDENCIALOPERA` (
  `NivelID` int(11) NOT NULL COMMENT 'Nivel de Operaciones y Prudencial',
  `DescOpera` varchar(30) NOT NULL COMMENT 'Descripcion de Nivel de Operaciones',
  `DescPrudencial` varchar(30) NOT NULL COMMENT 'Descripcion de Nivel Prudencial',
  `ClavePrudencial` varchar(4) NOT NULL COMMENT 'Clave SITI de Nivel Prudencial',
  `MuestraReg` char(1) NOT NULL COMMENT 'Indica si se muesta el campo:  A : Ambos, O : Operacion, P: Prudencial',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usario ID',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`NivelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de niveles prudencial y de operacion para instituciones'$$