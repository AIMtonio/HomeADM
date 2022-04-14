-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIOA1713
DELIMITER ;
DROP TABLE IF EXISTS `HIS-REGULATORIOA1713`;DELIMITER $$

CREATE TABLE `HIS-REGULATORIOA1713` (
  `Fecha` int(8) NOT NULL COMMENT 'Fecha que se reporta',
  `ClaveEntidad` varchar(6) NOT NULL COMMENT 'Clave de la Entidad',
  `Subreporte` int(4) NOT NULL COMMENT 'Numero de Subreporte Regulatorio',
  `TipoMovimiento` varchar(3) NOT NULL COMMENT 'Tipo de movimiento se refiere a si es Nombramiento, Renuncia o Remocion',
  `NombreFuncionario` varchar(100) NOT NULL COMMENT 'Nombre del Funcionario',
  `RFC` varchar(13) NOT NULL COMMENT 'RFC del funcionario',
  `CURP` varchar(18) NOT NULL COMMENT 'CURP del funcionario',
  `Profesion` int(3) NOT NULL COMMENT 'Titulo o Profesion del funcionario',
  `CalleDomicilio` varchar(150) NOT NULL COMMENT 'Calle del domicilio del funcionario',
  `NumeroExt` varchar(10) NOT NULL COMMENT 'Numero Ext. del domicilio del funcionario',
  `NumeroInt` varchar(10) NOT NULL COMMENT 'Numero Int. del domicilio del funcionario',
  `ColoniaDomicilio` varchar(150) NOT NULL COMMENT 'Colonia del domicilio',
  `CodigoPostal` varchar(5) NOT NULL COMMENT 'Codigo Postal del domicilio',
  `Localidad` varchar(12) NOT NULL COMMENT 'Localidad del domicilio',
  `Estado` int(3) NOT NULL COMMENT 'Estado del domicilio',
  `Pais` int(8) NOT NULL COMMENT 'Pais del domicilio',
  `Telefono` varchar(20) NOT NULL COMMENT 'Telefono del funcionario',
  `Email` varchar(75) NOT NULL COMMENT 'Correo Electrónico',
  `FechaMovimiento` int(11) NOT NULL COMMENT 'Fecha en que ocurre el Nombramiento, Renuncia o Remocion',
  `FechaInicio` int(11) NOT NULL COMMENT 'Fecha de inicio o conclusión de gestión se refiere a la fecha en que entra en vigor en tipo de movimiento.',
  `OrganoPerteneciente` int(4) NOT NULL COMMENT 'Organo al que pertenece',
  `Cargo` int(3) NOT NULL COMMENT 'Cargo dentro de la sociedad, consejo o comité',
  `Permanente` int(3) NOT NULL COMMENT 'Permanente o suplente',
  `ManifestCumplimiento` int(3) NOT NULL COMMENT 'Manifestación de cumplimiento',
  `Municipio` int(11) NOT NULL COMMENT 'Municipio del Domicilio',
  `Consecutivo` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `INDEX_HIS-REGULATORIOI0A1713` (`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$