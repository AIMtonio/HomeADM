-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROREGA1713
DELIMITER ;
DROP TABLE IF EXISTS `REGISTROREGA1713`;DELIMITER $$

CREATE TABLE `REGISTROREGA1713` (
  `Fecha` date NOT NULL COMMENT 'Fecha que se reporta',
  `RegistroID` int(11) DEFAULT NULL COMMENT 'Consecutivo del registro en la fecha',
  `TipoMovimientoID` varchar(3) NOT NULL COMMENT 'Tipo de movimiento se refiere a si es Nombramiento, Renuncia o Remocion',
  `NombreFuncionario` varchar(100) NOT NULL COMMENT 'Nombre del Funcionario',
  `RFC` varchar(13) NOT NULL COMMENT 'RFC del funcionario',
  `CURP` varchar(18) NOT NULL COMMENT 'CURP del funcionario',
  `Profesion` int(3) NOT NULL COMMENT 'Titulo o Profesion del funcionario',
  `Telefono` varchar(60) NOT NULL COMMENT 'Telefono del funcionario',
  `Email` varchar(75) NOT NULL COMMENT 'Correo Electronico',
  `PaisID` int(8) NOT NULL COMMENT 'Pais del domicilio',
  `EstadoID` int(3) NOT NULL COMMENT 'Estado del domicilio',
  `MunicipioID` int(3) NOT NULL COMMENT 'Municipio del domicilio',
  `LocalidadID` varchar(16) NOT NULL COMMENT 'Localidad del domicilio',
  `ColoniaID` int(11) NOT NULL COMMENT 'Colonia del domicilio',
  `CodigoPostal` varchar(5) NOT NULL COMMENT 'Codigo Postal del domicilio',
  `Calle` varchar(150) NOT NULL COMMENT 'Calle del domicilio del funcionario',
  `NumeroExt` varchar(10) NOT NULL COMMENT 'Numero Ext. del domicilio del funcionario',
  `NumeroInt` varchar(10) NOT NULL COMMENT 'Numero Int. del domicilio del funcionario',
  `FechaMovimiento` date NOT NULL COMMENT 'Fecha en que ocurre el Nombramiento, Renuncia o Remocion',
  `FechaInicioGes` date NOT NULL COMMENT 'Fecha de inicio de gestion se refiere a la fecha en que entra en vigor en tipo de movimiento.',
  `FechaFinGestion` date NOT NULL COMMENT 'Fecha de conclusion de gestion se refiere a la fecha en que entra en vigor en tipo de movimiento.',
  `OrganoID` int(4) NOT NULL COMMENT 'Organo al que pertenece ',
  `CargoID` int(3) NOT NULL COMMENT 'Cargo dentro de la sociedad, consejo o comite : CATCARGOSOCIEDAD',
  `PermanenteID` int(3) NOT NULL COMMENT 'Permanente o suplente',
  `CausaBajaID` int(11) DEFAULT NULL,
  `ManifestCumpID` int(3) NOT NULL COMMENT 'Manifestacion de cumplimiento',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `INDEX_REGISTROREGA1713` (`Fecha`,`RegistroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los registros reportados de altas y bajas de personal para el regulatorio A1713'$$