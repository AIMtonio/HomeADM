-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSINSTITUCION
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSINSTITUCION`;DELIMITER $$

CREATE TABLE `TIPOSINSTITUCION` (
  `TipoInstitID` int(11) NOT NULL COMMENT 'Tipo de Institucion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del \nTipo de \nInstitucion',
  `NombreCorto` varchar(45) DEFAULT NULL COMMENT 'Descripcion Corta que servira para identificar el locale a ocupar en el sistema',
  `EsBancaComercial` char(1) NOT NULL COMMENT 'Define si es \nBanco Comercial\nS .- Si es\nN .- No es',
  `EsBancaDesarrollo` char(1) NOT NULL COMMENT 'Define si es \nBanco de Desarrollo\nS .- Si es\nN .- No es',
  `EsSOFIPO` char(1) NOT NULL COMMENT 'Define si es \nSOFIPO\nS .- Si es\nN .- No es',
  `EsSCAP` char(1) NOT NULL COMMENT 'Define si es \nSociedad de \nCredito Y Ahorro\nPopular\nS .- Si es\nN .- No es',
  `EsSOFOM` char(1) NOT NULL COMMENT 'Define si es \nSOFOM\nS .- Si es\nN .- No es',
  `EsSOFOL` char(1) NOT NULL COMMENT 'Define si es \nSOFOL\nS .- Si es\nN .- No es',
  `EsFideicomiso` char(1) NOT NULL COMMENT 'Define si es \nFideicomiso\n\nS .- Si es\nN .- No es',
  `NacionalidadIns` char(1) DEFAULT NULL COMMENT 'Nacionalidad de Institucion\nN .- Nacional\nE .- Extranjera',
  `TieneRegulatorios` char(1) DEFAULT NULL,
  `EntidadRegulada` varchar(2) DEFAULT 'S' COMMENT 'Indica si la Institución Financiera es una Entidad Regulada.\nS.- Sí (default)\nN.- No.\nNA.- No Aplica.',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoInstitID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Tipos de Institucion'$$