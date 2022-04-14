-- BITACORAPAGOSMOVILDET
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAPAGOSMOVILDET`;
DELIMITER $$

CREATE TABLE `BITACORAPAGOSMOVILDET` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `BitacoraHeadID`        BIGINT(20)         NOT NULL       COMMENT 'Numero del Registro',
  `ClienteID`             INT(11)            NOT NULL       COMMENT 'Numero de cliente',
  `ClaveProm`             VARCHAR(45)        NOT NULL       COMMENT 'Numero del promotor',
  `SucursalID`            INT(11)            NOT NULL       COMMENT 'Numero de la Sucursal',
  `DispositivoID`         VARCHAR(32)        NOT NULL       COMMENT 'Identificador del dispositivo',
  `ModeloDispos`          VARCHAR(50)        NOT NULL       COMMENT 'Modelo del dispositivo',
  `TipoPago`              CHAR(1)            NOT NULL       COMMENT 'Tipo de pago (E = Efectivo, C = Cargo a cuenta)',
  `CreditoID`             BIGINT(12)         NOT NULL       COMMENT 'Numero del Credito',
  `CuentaAhoID`           BIGINT(12)         NOT NULL       COMMENT 'Numero de cuenta de ahorro',
  `Monto`                 DECIMAL(12,2)      NOT NULL       COMMENT 'Monto cobrado',
  `CajaID`                INT(11)            NOT NULL       COMMENT 'Numero de caja',
  `FechaHoraOper`         DATETIME           NOT NULL       COMMENT 'Fecha y hora de la operacion',
  `NumTransaccionBit`     BIGINT(20)         NOT NULL       COMMENT 'Numero de transaccion de la bitacora',
  `FolioMovil`     		  VARCHAR(100)       NOT NULL       COMMENT 'Folio del pago generado por la aplicacion movil',
  `EmpresaID`             INT(11)            NOT NULL       COMMENT 'Parametro de auditoria',
  `Usuario`               INT(11)            NOT NULL       COMMENT 'Parametro de auditoria',
  `FechaActual`           DATETIME           NOT NULL       COMMENT 'Parametro de auditoria',
  `DireccionIP`           VARCHAR(15)        NOT NULL       COMMENT 'Parametro de auditoria',
  `ProgramaID`            VARCHAR(50)        NOT NULL       COMMENT 'Parametro de auditoria',
  `Sucursal`              INT(11)            NOT NULL       COMMENT 'Parametro de auditoria',
  `NumTransaccion`        BIGINT(20)         NOT NULL       COMMENT 'Parametro de auditoria',
  CONSTRAINT `fk_BitacoraClienteID` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_BitacoraSucursalID` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_BitacoraCreditoID` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Guarda la bitacora de pagos de la App Movil'$$
