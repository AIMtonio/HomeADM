-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCLAJUSESCINTER
DELIMITER ;
DROP TABLE IF EXISTS `PLDCLAJUSESCINTER`;DELIMITER $$

CREATE TABLE `PLDCLAJUSESCINTER` (
  `ClaveJustEscIntID` int(11) NOT NULL COMMENT 'ID o Consecutivo de la Clave de Justificacion',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion de la justificacion',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus \nV=Vigente\nB=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Registro',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa Origen',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal Origen',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`ClaveJustEscIntID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Claves o Motivos de Justificacion de las Operaciones de Esca'$$