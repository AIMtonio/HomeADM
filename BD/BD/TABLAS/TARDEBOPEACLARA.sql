-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBOPEACLARA
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBOPEACLARA`;DELIMITER $$

CREATE TABLE `TARDEBOPEACLARA` (
  `TipoAclaraID` int(11) NOT NULL COMMENT 'Llave Principal para Catalogo de Tipo de Aclaraciones ',
  `OpeAclaraID` int(11) NOT NULL COMMENT 'Llave primaria de la Operación que se va a aclarar\n(Consecutivo por Tipo de Aclaración)',
  `Descripcion` varchar(70) DEFAULT NULL COMMENT 'Descripcion de la Operación que se va a aclarar',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Operación a Aclarar, solo los activos se muestran en pantalla\nA = Activo \nI = Inactivo',
  `ComercioObl` char(1) DEFAULT NULL COMMENT 'Indica si el campo de Tienda o Comercio es Obligatorio\nS = Si\nN = No',
  `CajeroObl` char(1) DEFAULT NULL COMMENT 'Indica si el Campo de Numero de Cajero es Obligatorio o no\nS = Si\nN = No',
  `TipoTarjeta` char(1) DEFAULT NULL COMMENT 'Tipo de Tarjeta \nD = Debito\nC = Credito\nA = Ambas',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OpeAclaraID`,`TipoAclaraID`),
  KEY `fk_TARDEBOPEACLARA_1_idx` (`TipoAclaraID`),
  CONSTRAINT `fk_TARDEBOPEACLARA_1` FOREIGN KEY (`TipoAclaraID`) REFERENCES `TARDEBTIPOSACLARA` (`TipoAclaraID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Catalogo de Operaciones que se pueden Aclarar para '$$