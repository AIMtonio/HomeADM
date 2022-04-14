-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOSOBJETADOS
DELIMITER ;
DROP TABLE IF EXISTS `CARGOSOBJETADOS`;
DELIMITER $$

CREATE TABLE `CARGOSOBJETADOS` (
  `CargoObjID` INT(11) COMMENT 'CargoObjID',
  `Folio` VARCHAR(12) COMMENT 'Folio',
  `Periodo` INT(11) DEFAULT NULL COMMENT 'Periodo del Cargo Objetado',
  `Fecha` DATE DEFAULT NULL COMMENT 'Fecha del Cargo Objetado',
  `TipoInstrumento` VARCHAR(50) DEFAULT NULL,
  `InstrumentoID` BIGINT(20),
  `Descripcion` VARCHAR(200) ,
  `Cargo`  DECIMAL(14,2),
  `Abono`  DECIMAL(14,2),
  `ClienteID`					  INT(11) 			DEFAULT NULL	COMMENT 'Numero de cliente',
  `FechaReporte`				DATE				DEFAULT NULL	COMMENT 'Fecha en la que se levanta el reporte',
  `FechaIncidencia`			DATE				DEFAULT NULL	COMMENT 'Fecha en la que el cliente alega que sucedio el cargo o incidencia',
  `MontoObjetado`				DECIMAL(14,2)		DEFAULT NULL	COMMENT 'Monto transaccionado en la incidencia',
  `Instrumento`				  VARCHAR(20)			DEFAULT NULL	COMMENT 'Identificador del instrumento con el que fue realizada la transaccion del reporte',
  `Estatus`					    CHAR(1)				DEFAULT NULL	COMMENT 'Estatus del reporte. P = En Proceso. R = Resuelta. N = No Procede.',
  `UsuarioAlta`				  INT(11)				DEFAULT NULL	COMMENT 'Usuario que dio de alta el registro del cargo a objetar',
  `UsuarioSolventa`			INT(11)				DEFAULT NULL	COMMENT 'Usuario que indico que la incidencia fue solventada o que el reporte no procede',
  `SucursalID`				  INT(11)				DEFAULT NULL	COMMENT 'Identificador de la sucursal del cliente',
  `EmpresaID` INT(11) DEFAULT NULL,
  `Usuario` INT(11) DEFAULT NULL,
  `FechaActual` DATETIME DEFAULT NULL,
  `DireccionIP` VARCHAR(15) DEFAULT NULL,
  `ProgramaID` VARCHAR(50) DEFAULT NULL,
  `Sucursal` INT(11) DEFAULT NULL,
  `NumTransaccion` BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (`CargoObjID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para guardar informacion de Cargos Objetados.'$$


