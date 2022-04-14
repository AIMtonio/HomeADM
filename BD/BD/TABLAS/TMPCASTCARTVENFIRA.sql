-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCASTCARTVENFIRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCASTCARTVENFIRA`;DELIMITER $$

CREATE TABLE `TMPCASTCARTVENFIRA` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `Numero` int(11) NOT NULL COMMENT 'Numero entero consecutivo que inicia en 1',
  `GrupoID` int(11) NOT NULL COMMENT 'Numero de Grupo ID',
  `Grupo` varchar(50) DEFAULT NULL COMMENT 'Corresponde al Castigo de cartera vencida o a la Venta de cartera vencida, este ultimo se reportara en ceros.',
  `Concepto` varchar(45) DEFAULT NULL COMMENT 'Muestra la etiqueta de acumulado del los meses correspondientes a cada grupo y el numero del mes',
  `Mes` varchar(45) DEFAULT NULL COMMENT ' Muestra el nombre del mes y el anio al que corresponde, ejemplo: enero de 2018.',
  `Anio` int(11) DEFAULT NULL COMMENT 'Numero de Anio',
  `MesNum` int(11) DEFAULT NULL COMMENT 'Numero de Mes',
  `Importe` decimal(18,2) DEFAULT '0.00' COMMENT 'Muestra el importe correspondiente al castigo o venta de cartera vencida del mes, en caso de no haber importe ingresar un cero en la columna.',
  `ImporteCalculado` decimal(18,2) DEFAULT NULL COMMENT 'Muestra el acumulado de cada grupo, este unicamente se mostrará en la fila correspondiente a "Acumulado ultimos 12 meses".',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Transaccion`,`Numero`,`GrupoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal fisica para almacenar la informacion para el reporte de la cartera castigada vencida de FIRA.'$$