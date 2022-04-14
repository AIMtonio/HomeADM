-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONES
DELIMITER ;
DROP TABLE IF EXISTS `INSTITUCIONES`;
DELIMITER $$

CREATE TABLE `INSTITUCIONES` (
  `InstitucionID` int(11) NOT NULL COMMENT 'Numero de \nInstitucion',
  `EmpresaID` varchar(45) DEFAULT NULL COMMENT 'Empresa ID',
  `Nombre` varchar(100) NOT NULL COMMENT 'Nombre de la\nInstitucion',
  `NombreCorto` varchar(45) NOT NULL COMMENT 'Nombre Corto de\nla Institucion',
  `TipoInstitID` int(11) NOT NULL COMMENT 'Tipo de \nInstitucion\n1 .- Banca Comercial\n2 .- Banca Desarrollo\n3 .- SOFIPO\n4 .- SOFOM\n5 .- SOFOL\n6 .- SOCAP\n7 .- FONDEADORES\n8 .- AC\n',
  `Direccion` varchar(250) DEFAULT NULL,
  `Folio` char(3) DEFAULT NULL,
  `DirFiscal` varchar(250) DEFAULT NULL COMMENT 'Direccion Fiscal de la Institucion',
  `RFC` varchar(15) DEFAULT NULL COMMENT 'RFC de la Institucion',
  `EstadoEmpresa` varchar(50) DEFAULT NULL,
  `MunicipioEmpresa` varchar(50) DEFAULT NULL,
  `ColoniaEmpresa` varchar(50) DEFAULT NULL,
  `LocalidadEmpresa` varchar(50) DEFAULT NULL,
  `CalleEmpresa` varchar(50) DEFAULT NULL,
  `NumIntEmpresa` varchar(50) DEFAULT NULL,
  `NumExtEmpresa` varchar(50) DEFAULT NULL,
  `CPEmpresa` varchar(50) DEFAULT NULL,
  `ClaveEntidad` varchar(300) DEFAULT NULL COMMENT 'Clave de la entidad',
  `ClaveParticipaSpei` int(5) DEFAULT NULL,
  `GeneraRefeDep` char(1) NOT NULL DEFAULT 'N' COMMENT 'Campo para saber si genera o no la referencia de depositos referenciados S=si, N=no',
  `AlgoritmoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Identificador de la tabla ALGORITMODEPREF, es el algoritmo que utiliza la institucion, 0 cuando el campo GeneraRefeDep sea N',
  `RutaLogo` varchar(100) NOT NULL DEFAULT '' COMMENT 'Ruta del logo de la institucion ',
  `TelefonoEmpresa` varchar(45) NOT NULL DEFAULT '' COMMENT 'Telefono de la institucion',
  `PaginaWeb` varchar(200) NOT NULL DEFAULT '' COMMENT 'Direccion de la pagina web de la institucion',
  `NumConvenio` VARCHAR(45) NULL DEFAULT '' COMMENT ' Campo de texto libre para poder ingresar el folio del convenio que tiene la institucion bancaria con la financiera para los depositos referenciados.',
  `ConvenioInter` VARCHAR(45) NULL DEFAULT '' COMMENT 'Campo de texto libre para poder ingresar el folio del convenio interbancario que tiene la institucion bancaria con la financiera para los depositos referenciados.',
  `Domicilia`     CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si la Institucion Maneja Domiciliacion de Pagos',
  `NumContrato` char(6) DEFAULT '' COMMENT ' Campo de texto libre para poder ingresar el numero de contrato . Valor proporcionado por la institución',
  `CveEmision` char(6) DEFAULT '' COMMENT ' Campo de texto libre para poder ingresar la clave de emision . Valor proporcionado por la institución',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InstitucionID`),
  KEY `fk_TipoInstitucion_idx` (`TipoInstitID`),
  CONSTRAINT `fk_TipoInstitucion` FOREIGN KEY (`TipoInstitID`) REFERENCES `TIPOSINSTITUCION` (`TipoInstitID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Instituciones o Participantes del Sistema Financier'$$