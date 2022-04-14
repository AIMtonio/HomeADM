-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCACLARACIONES
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATDCACLARACIONES`;
DELIMITER $$

CREATE TABLE `EDOCTATDCACLARACIONES` (
  `Periodo` INT(11) NOT NULL COMMENT 'anio y mes de la fecha que se realizara el corte',
  `DiaCorte` INT(11) NOT NULL COMMENT 'Dia de la fecha que se realizara el corte',
  `LineaTarCredID` INT(11) NOT NULL COMMENT 'numero de linea de credito del cliente',
  `TarjetaDebID` CHAR(16) NOT NULL COMMENT 'Tarjeta de debito',
  `Fecha` DATE NOT NULL COMMENT 'Campo correspondiente con FechaOperacion',
  `Descripcion` VARCHAR(2000) NOT NULL COMMENT 'Campo correspondiente con DetalleReporte, Descripción detallada el problema ocurrido para facilitar la resolución de la aclaración',
  `FolioAclaracion` BIGINT(20) NOT NULL COMMENT 'Campo correspondiente con TransaccionRep, Transacción de la operación de la tarjeta que se esta reportando para aclarar',
  `FechaApertura` DATE NOT NULL COMMENT 'Campo correspondiente con FechaAclaracion, Fecha en la que se registra la Aclaración',
  `Importe` DECIMAL(12,2) NOT NULL COMMENT 'Campo correspondiente con MontoOperacion',
  `EmpresaID` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` DATE NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  KEY `IDX_EDOCTATDCACLARACIONES_01` (`Periodo`,`DiaCorte`,`TarjetaDebID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los datos de TARDEBACLARACION'$$
