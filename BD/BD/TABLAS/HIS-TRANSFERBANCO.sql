-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-TRANSFERBANCO
DELIMITER ;
DROP TABLE IF EXISTS `HIS-TRANSFERBANCO`;
DELIMITER $$


CREATE TABLE `HIS-TRANSFERBANCO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `FechaCorte` date NOT NULL COMMENT 'Fecha de Corte',
  `TransferBancoID` int(11) NOT NULL COMMENT 'ID de la Transferencia de Banco',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Id Del Banco (Institucion) de donde es la Cuenta',
  `NumCtaInstit` varchar(20) DEFAULT NULL COMMENT 'Numero de Cuenta En el Banco(Institucion)',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal a la que pertenece la Caja 	',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Identificador de la Caja que envia o Recibe Efectivo',
  `MonedaID` int(11) DEFAULT NULL,
  `Cantidad` decimal(14,2) DEFAULT NULL COMMENT 'Monto de Efectivo a Enviar o Recibir',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Corresponde con la tabla\\nPOLIZACONTABLE, nos ayuda a\\ncuadrar la poliza cuando \\ntransfiere y recibe efectivo',
  `DenominacionID` int(11) DEFAULT NULL COMMENT 'Corresponde a la Tabla DENOMINACIONES, para definir el tipo de denominacion\\\\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Transferencia\\nE.- Envio  R.- Recibido',
  `Fecha` date DEFAULT NULL,
  `Referencia` varchar(50) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `HIS-TRANSFERBANCO` (`FechaCorte`,`SucursalID`,`CajaID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de Transferencias de Efectivo entre Cajas Principa'$$
