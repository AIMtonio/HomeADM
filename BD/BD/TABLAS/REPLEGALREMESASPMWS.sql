-- REPLEGALREMESASPMWS
DELIMITER ;
DROP TABLE IF EXISTS `REPLEGALREMESASPMWS`;
DELIMITER $$

CREATE TABLE `REPLEGALREMESASPMWS` (
  `RepLegalRemWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla',
  `RemesaWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla REMESASWS ',
  `NombreRepresenLegal` varchar(50) NOT NULL COMMENT 'Indica el nombre del representante legal para persona moral',
  `PaisID` int(11) NOT NULL COMMENT 'Indica el país del representante legal para persona moral codigo del país del catálogo de SAFI',
  `FechaNacimiento` date NOT NULL COMMENT 'Indica la fecha de nacimiento del representante legal de la personas moral formato valido (aaaa-MM-dd)',
  `Nacionalidad` char(1) NOT NULL COMMENT 'Indica la nacionalidad del representante legal N.- Nacional , E .- Extranjero',
  `DirecRepLegRemWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla DIRREPLEGALREMESAPMWS',
  `CURP` char(18) NOT NULL COMMENT 'Indica la CURP del representante legal de la persona moral',
  `RFC` char(13) NOT NULL COMMENT 'Indica el RFC del representante legal de la persona moral',
  `TipoIdendificacionID` int(11) NOT NULL COMMENT 'Indica el identificador del tipo de identificación del represetante legal de la persona moral',
  `IdentificacionID` int(11) NOT NULL COMMENT 'Indica el numero de identificación del representante legal de la persona moral',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`RepLegalRemWSID`),
  KEY `fk_REPLEGALREMESASPMWS_1` (`RemesaWSID`),
  KEY `fk_REPLEGALREMESASPMWS_2` (`PaisID`),
  KEY `fk_REPLEGALREMESASPMWS_3` (`TipoIdendificacionID`),
  KEY `fk_REPLEGALREMESASPMWS_4` (`IdentificacionID`),
  KEY `fk_REPLEGALREMESASPMWS_5` (`DirecRepLegRemWSID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla detalle para almacenar la información de los representantes legales de las personas morales de las remesas.'$$