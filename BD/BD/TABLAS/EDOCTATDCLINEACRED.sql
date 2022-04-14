-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCLINEACRED
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATDCLINEACRED`;
DELIMITER $$

CREATE TABLE `EDOCTATDCLINEACRED` (
  `Periodo` INT(11) NOT NULL COMMENT 'anio y mes de la fecha que se realizara el corte',
  `DiaCorte` INT(11) NOT NULL COMMENT 'Dia de la fecha que se realizara el corte',
  `LineaTarCredID` BIGINT(20) NOT NULL COMMENT 'Linea del credito',
  `ClienteID` INT(11) NOT NULL COMMENT 'ID del cliente',
  `TipoTarjetaDebID` INT(11) NOT NULL COMMENT 'Tipo de tarjeta de debito',
  `DescripcionProd` VARCHAR(150) NOT NULL COMMENT 'Descripción del producto',
  `NumTarjeta` VARCHAR(20) NOT NULL COMMENT 'Número de trajeta',
  `FechaGenera` DATE NOT NULL COMMENT 'Fecha en que se genero',
  `FechaCorte` DATE NOT NULL COMMENT 'Fecha de corte',
  `PeriodoFechas` VARCHAR(150) DEFAULT '' COMMENT 'Descripcion del periodo',
  `DiasPeriodo` INT(11) NOT NULL COMMENT 'Días que dura el periodo',
  `FechaProxCorte` DATE NOT NULL COMMENT 'Fecha del proximo corte',
  `FechaExigible` DATE NOT NULL COMMENT 'Fecha exigible',
  `CuentaClabe` CHAR(18) NOT NULL COMMENT 'Cuenta CLABE para pago de credito',
  `MesesPagMin` INT(11) NOT NULL COMMENT 'Numero de Meses para pagar el credito actual, solo con el pago minimo',
  `PagoDoceMeses` DECIMAL(16,2) NOT NULL COMMENT 'Monto para liquidar el credito en 12 meses',
  `EmpresaID` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` DATE NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`Periodo`,`DiaCorte`,`LineaTarCredID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
