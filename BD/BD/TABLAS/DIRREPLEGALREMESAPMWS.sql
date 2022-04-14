-- DIRREPLEGALREMESAPMWS
DELIMITER ;
DROP TABLE IF EXISTS `DIRREPLEGALREMESAPMWS`;
DELIMITER $$

CREATE TABLE `DIRREPLEGALREMESAPMWS` (
  `DirecRepLegRemWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla',
  `RemesaWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla REMESASWS ',
  `Calle` varchar(500) NOT NULL COMMENT 'Indica la calle del domicilio del representante legal',
  `Numero` int(11) NOT NULL COMMENT 'Indica el numero del domicilio del representant legal',
  `ColoniaID` int(11) NOT NULL COMMENT 'Indica la colonia del domicilio del representante legal codigo de la colonia del catálogo de SAFI',
  `MunicipioID` int(11) NOT NULL COMMENT 'Indica el municipio del domicilio del representante legal codigo del municipio del catálogo de SAFI',
  `CiudadID` int(11) NOT NULL COMMENT 'Indica la ciudad del domicilio del representante legal',
  `EstadoID` int(11) NOT NULL COMMENT 'Indica el estado de la persona fisica o fisica con actividad empresarial ',
  `CodigoPostal` char(5) DEFAULT NULL COMMENT 'Indica el codigo postal del domicilio del representante legal',
  `PaisID` int(11) NOT NULL COMMENT 'Indica el país del domicilio del representante legal codigo del país del catalogo de SAFI',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`DirecRepLegRemWSID`),
  KEY `fk_DIRREPLEGALREMESAPMWS_1` (`RemesaWSID`),
  KEY `fk_DIRREPLEGALREMESAPMWS_2` (`ColoniaID`),
  KEY `fk_DIRREPLEGALREMESAPMWS_3` (`MunicipioID`),
  KEY `fk_DIRREPLEGALREMESAPMWS_4` (`CiudadID`),
  KEY `fk_DIRREPLEGALREMESAPMWS_5` (`EstadoID`),
  KEY `fk_DIRREPLEGALREMESAPMWS_6` (`PaisID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla detalle para almacenar la información de las direcciones de los representantes legales de las personas morales de las remesas.'$$