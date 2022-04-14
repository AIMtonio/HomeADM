-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMDEPREFER
DELIMITER ;
DROP TABLE IF EXISTS `PARAMDEPREFER`;
DELIMITER $$

CREATE TABLE `PARAMDEPREFER` (
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Numero Consecutivo',
  `TipoArchivo` int(11) NOT NULL COMMENT 'Tipo de Layout para los Depositos Referenciados\n1) Archivo Estandar\n2) Banorte\n3) Banamex',
  `DescripcionArch` varchar(100) NOT NULL DEFAULT '' COMMENT 'Descripción del tipo de Archivo',
  `PagoCredAutom` char(1) NOT NULL DEFAULT 'N' COMMENT 'Indica SI aplica en automatico o NO el pago de credito\nS) SI aplica\nN) NO aplica',
  `Exigible` char(1) NOT NULL DEFAULT 'A' COMMENT 'Indica la Accion a Realizar en caso de NO tener exigible\nA) Abono a cuenta\nP) Prepago de credito',
  `Sobrante` char(1) NOT NULL DEFAULT 'A' COMMENT 'Indica la accion a realizar en caso de tener Sobrante\nP) Prepago de Credito\nA) Ahorro',
  `InstitucionID` int(11) NOT NULL,
  `LecturaAutom` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si la institucion requiere lectura Automatica de los archivos de deposito referenciados \nS = SI\nN = NO',
  `RutaArchivos` VARCHAR(150) NULL COMMENT 'Ruta donde se encuentran los archivos para la lectura automantica',
  `TiempoLectura` INT(11) NULL COMMENT 'tiempo en minutos para que se compruebe nuevos datos de lectura',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'ID de la institucion Bancaria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  UNIQUE KEY `TipoArchivo_UNIQUE` (`TipoArchivo`),
  KEY `fk_PARAMDEPREFER_1_idx` (`InstitucionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Par: Tabla que guarda los parámetros para ejecutar los procesos de Depositos Referenciados'$$