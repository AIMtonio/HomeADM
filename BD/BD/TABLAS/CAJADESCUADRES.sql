-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJADESCUADRES
DELIMITER ;
DROP TABLE IF EXISTS `CAJADESCUADRES`;DELIMITER $$

CREATE TABLE `CAJADESCUADRES` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Id de la tabla ',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'La sucursal en donde se ejecuta la operacion',
  `CajaID` int(11) DEFAULT NULL COMMENT 'La caja Responsable de la Operacion',
  `MontoTotalEntrada` decimal(18,4) DEFAULT NULL COMMENT '\nEl monto total de Entrada ',
  `MontoTotalSalida` decimal(18,4) DEFAULT NULL COMMENT 'Em monto total de salida',
  `MontoOperacion` decimal(18,4) DEFAULT NULL COMMENT 'el monto total de la operacion',
  `OpcionCajaID` int(11) DEFAULT NULL COMMENT 'El tipo de Operacion que se ejecuto tabla OPCIONESCAJA',
  `DescripcionOperacion` varchar(100) DEFAULT NULL COMMENT 'El nombre o descripcion de la operacion',
  `DescripcionError` varchar(1000) DEFAULT NULL COMMENT 'Descripcion del Error o Descuadre',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la operacion',
  `PolizaID` int(11) DEFAULT NULL COMMENT 'Id de la Poliza',
  `Denominaciones` varchar(500) DEFAULT NULL COMMENT 'Denominaciones de Entrada y salida [1(DenominacionID)-CantidadDenominacion-MontoDenominacion,2(DenominacionID)-CantidadDenominacion-MontoDenominacion,3(DenominacionID)-CantidadDenominacion-MontoDenominacion, asi hasta llegar a la denominacion ID 7]',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`Transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tabla para guardar todas las Pólizas que salgan descuadradas en operaciones de ventanilla'$$