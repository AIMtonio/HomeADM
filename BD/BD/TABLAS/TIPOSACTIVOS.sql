-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSACTIVOS`;
DELIMITER $$

CREATE TABLE `TIPOSACTIVOS` (
  `TipoActivoID` int(11) NOT NULL COMMENT 'Idetinficador del tipo de activo',
  `Descripcion` varchar(300) NOT NULL COMMENT 'Descripcion larga del tipo de activo',
  `DescripcionCorta` varchar(15) NOT NULL COMMENT 'Descripcion corta del tipo de activo',
  `DepreciacionAnual` decimal(14,2) NOT NULL COMMENT 'Indica el % que corresponde al tipo de activo, puede ser un valor a dos decimales en un rango del 1 al 100',
  `ClasificaActivoID` int(11) NOT NULL COMMENT 'Indica el tipo de clasificacion del activo de la tabla CLASIFICACTIVOS',
  `TiempoAmortiMeses` int(11) NOT NULL COMMENT 'Indica el tiempo en meses que se consideraran para amortizar el activo esto solo tratandose de "Otros Activos", en el caso de "Activo Fijo" su valor sera 12 ya que corresponde al periodo de un anio',
  `Estatus` char(1) NOT NULL COMMENT 'Indica el estatus del tipo de activo, este puede ser A=ACTIVO o I=INACTIVO',
  `ClaveTipoActivo` CHAR(3) NOT NULL COMMENT 'Indica la clave a 3 Digitos del Activo la cual se compone de las 3 primeras letras de la Descripción Corta',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`TipoActivoID`),
  KEY `idx_TIPOSACTIVOS_1` (`ClasificaActivoID`),
  KEY `idx_TIPOSACTIVOS_2` (`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacacena datos de los tipos de activos'$$