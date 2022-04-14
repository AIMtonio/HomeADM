-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESBMX
DELIMITER ;
DROP TABLE IF EXISTS `ACTIVIDADESBMX`;
DELIMITER $$


CREATE TABLE `ACTIVIDADESBMX` (
  `ActividadBMXID` varchar(15) NOT NULL COMMENT 'ID o Numero de Actividad BMX',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(200) NOT NULL COMMENT 'Descripción de la Actividad\n',
  `ActividadINEGIID` int(11) DEFAULT NULL COMMENT 'Numero Segun INEGI\n',
  `ActividadFR` bigint(20) DEFAULT NULL COMMENT 'Clave de la Actividad Financiera Rural con respecto a la Actividad BMX\n',
  `ActividadFOMUR` int(11) DEFAULT NULL,
  `NumeroBuroCred` int(8) DEFAULT NULL COMMENT 'Numero Segun Buro de Credito\n',
  `NumeroCNBV` varchar(8) DEFAULT NULL COMMENT 'Numero Segun Buro de CNBV\n',
  `ActividadGuber` char(1) DEFAULT NULL COMMENT 'Actividad Gubernamental\n''S''  .- Si\n''N''  .- No',
  `ClaveRiesgo` char(1) DEFAULT NULL COMMENT 'Clave Riesgo\n''A''  .- Alto\n''M''  .- Medio\n''B''  .- Bajo\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\n''A''  .- Activo\n''I''  .- Inactivo',
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'Clasificacion Segun Reportes Regulatorios',
  `ActividadSCIANID` varchar(8) DEFAULT NULL COMMENT 'Clave de Actividad SCIAN',
  `ActividadFIRAID` int(11) DEFAULT NULL COMMENT 'Activadad con equivalencia con el catalogo de FIRA.',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ActividadBMXID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Actividades Segun Banco de Mexico'$$