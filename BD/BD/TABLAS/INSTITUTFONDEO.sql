-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUTFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `INSTITUTFONDEO`;DELIMITER $$

CREATE TABLE `INSTITUTFONDEO` (
  `InstitutFondID` int(11) NOT NULL COMMENT 'ID de Instituciones de Fondeo\n',
  `TipoFondeador` char(1) DEFAULT NULL COMMENT 'Tipo Fondeador:\n\nG=Gubernamental, F=Persona Física, M=Persona Moral, A=Persona Física Con Actividad Empresarial',
  `CobraISR` char(1) DEFAULT NULL COMMENT 'S=Sí\nN=No',
  `RazonSocInstFo` varchar(200) DEFAULT NULL COMMENT 'Razon Social Institucion de Fondeo',
  `NombreInstitFon` varchar(200) DEFAULT NULL COMMENT 'Nombre Corto Institucion Fondeo\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la institucion\n\nA=Activo, I=Inactivo\n',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'ID de instituciones',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'indica el número de cliente',
  `NumCtaInstit` varchar(20) DEFAULT NULL COMMENT 'Indica el número de cta del banco perteneciente',
  `CuentaClabe` varchar(18) DEFAULT NULL COMMENT 'Indica la cuenta interbancaria de la institución',
  `NombreTitular` varchar(50) DEFAULT NULL COMMENT 'Indica el nombre del titular de la Cuenta Clabe',
  `IDInstitucion` int(11) DEFAULT NULL COMMENT 'ID de la institucion bancaria',
  `CentroCostos` int(11) DEFAULT NULL COMMENT 'Guarda el Centro de Costos cuando de se de alta el fondeador',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes del Fondeador',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del estado del Fondeador',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del muncipio del Fondeador',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Numero de Localidad Correspondiente al Municipio',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'ID de la colonia',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle',
  `NumeroCasa` char(10) DEFAULT NULL COMMENT 'Numero de casa, depto, oficina o negocio',
  `NumInterior` char(10) DEFAULT NULL COMMENT 'Numero interior de la casa o edificio.',
  `Piso` char(50) DEFAULT NULL COMMENT 'Número de piso.',
  `PrimeraEntreCalle` varchar(50) DEFAULT NULL COMMENT 'Primer entrecalle en la que se encuentra la direccion',
  `SegundaEntreCalle` varchar(50) DEFAULT NULL COMMENT 'Segunda entrecalle en la que se encuentra la direccion',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Este campo se arma con los campos calle, numero, colonia, y CP.',
  `RepresentanteLegal` varchar(100) DEFAULT NULL COMMENT 'Nombre del Representante legal para Tipo Fondeador Morales',
  `CapturaIndica` varchar(50) DEFAULT NULL COMMENT 'Indica si se captura o no el Credito y el Acreditado FIRA',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InstitutFondID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Lineas de Credito Por Fondeadores\n'$$