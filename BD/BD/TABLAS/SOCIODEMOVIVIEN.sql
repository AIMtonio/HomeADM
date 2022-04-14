-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOVIVIEN
DELIMITER ;
DROP TABLE IF EXISTS `SOCIODEMOVIVIEN`;DELIMITER $$

CREATE TABLE `SOCIODEMOVIVIEN` (
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a PROSPECTOS (sin Integridad Relacional)',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a CLIENTES (Sin Integridad relacional)',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en la que se capturo los datos del conyuge',
  `TipoViviendaID` int(11) DEFAULT NULL COMMENT 'Llave Foranea al Catalogo de Tipo de Vivienda',
  `ConDrenaje` char(1) DEFAULT NULL COMMENT 'Indica si la vivienda cuenta con Drenaje	',
  `ConElectricidad` char(1) DEFAULT NULL COMMENT 'Indica si la vivienda cuenta con Energia Electrica',
  `ConAgua` char(1) DEFAULT NULL COMMENT 'Indica si la vivienda cuenta con Agua',
  `ConGas` char(1) DEFAULT NULL COMMENT 'Indica si la vivienda cuenta con Gas	',
  `ConPavimento` char(1) DEFAULT NULL COMMENT 'Indica si la calle de la vivienda se encuentra pavimentada	',
  `TipoMaterialID` int(11) DEFAULT NULL COMMENT 'Llave Foranea al catalogo de Tipo de Material de la vivienda',
  `TiempoHabitarDom` int(11) DEFAULT NULL COMMENT 'Tiempo de Vivivir en el domicilio expresado en meses',
  `ValorVivienda` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Valor de la Vivienda',
  `Descripcion` varchar(500) DEFAULT NULL COMMENT 'Descripcion de la Vivienda',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  KEY `fk_SOCIODEMOVIVIEN_1_idx` (`TipoViviendaID`),
  KEY `fk_SOCIODEMOVIVIEN_2_idx` (`TipoMaterialID`),
  CONSTRAINT `fk_SOCIODEMOVIVIEN_1` FOREIGN KEY (`TipoViviendaID`) REFERENCES `TIPOVIVIENDA` (`TipoViviendaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOCIODEMOVIVIEN_2` FOREIGN KEY (`TipoMaterialID`) REFERENCES `TIPOMATERIALVIV` (`TipoMaterialID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de Datos de Vivienda'$$