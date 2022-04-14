-- DETDIRECFISCALREMESASWS
DELIMITER ;
DROP TABLE IF EXISTS `DETDIRECFISCALREMESASWS`;
DELIMITER $$

CREATE TABLE `DETDIRECFISCALREMESASWS` (
  `DetDirecFiscalRemWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla',
  `RemesaWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla REMESASWS ',
  `Calle` varchar(500) NOT NULL COMMENT 'Indica la calle del detalle de la direccion de la persona fisica con actividad empresarial o moral',
  `Numero` int(11) NOT NULL COMMENT 'Indica el numero del domicilio de la persona fisica o fisica con activida empresarial',
  `ColoniaID` int(11) NOT NULL COMMENT 'Indica la colonia del domicilio de la persona fisica o fisica con actividad empresarial',
  `MunicipioID` int(11) NOT NULL COMMENT 'Indica el municipio del domicilio de la persona fisica o fisica con actividad empresarial',
  `CiudadID` int(11) NOT NULL COMMENT 'Indica la ciudad del domicilio de la persona fisica o fisica con actividad empresarial',
  `EstadoID` int(11) NOT NULL COMMENT 'Indica el estado de la persona fisica o fisica con actividad empresarial ',
  `CodigoPostal` char(5) DEFAULT NULL COMMENT 'Indica el codígo postal de la persona fisica con actividad empresarial o moral',
  `PaisID` int(11) NOT NULL COMMENT 'Indica el País de nacimiento del cliente o usuario este valor debe existir en el catálogo del PAISES del SAFI',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`DetDirecFiscalRemWSID`),
  KEY `fk_DETDIRECFISCALREMESASWS_1` (`RemesaWSID`),
  KEY `fk_DETDIRECFISCALREMESASWS_2` (`ColoniaID`),
  KEY `fk_DETDIRECFISCALREMESASWS_3` (`MunicipioID`),
  KEY `fk_DETDIRECFISCALREMESASWS_4` (`CiudadID`),
  KEY `fk_DETDIRECFISCALREMESASWS_5` (`EstadoID`),
  KEY `fk_DETDIRECFISCALREMESASWS_6` (`PaisID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla detalle para almacenar las direcciones fiscales de los clientes o usuarios de servicios.'$$