-- BITACORAPAGOSSAFI
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAPAGOSSAFI`;
DELIMITER $$

CREATE TABLE `BITACORAPAGOSSAFI` (
	`RegistroID` bigint UNSIGNED AUTO_INCREMENT,
	`Folio`        			BIGINT(20)         	NOT NULL       COMMENT 'Numero del Registro',
	`DispositivoID`         VARCHAR(32)        	NOT NULL       COMMENT 'Identificador del dispositivo',
	`FechaHoraOper`         DATETIME           	NOT NULL       COMMENT 'Fecha y hora de la operacion',
	`ClaveProm`             VARCHAR(45)        	NOT NULL       COMMENT 'Numero del promotor',
	`SucursalID`            INT(11)            	NOT NULL       COMMENT 'Numero de la Sucursal',
	`ClienteID`             INT(11)            	NOT NULL       COMMENT 'Numero de cliente',
	`CajaID`                INT(11)            	NOT NULL       COMMENT 'Numero de caja',
	`FechaHoraAplic`        DATE           	   	NOT NULL       COMMENT 'Fecha y hora de la operacion',
	`NumTransaccionBit`     BIGINT(20)         	NOT NULL       COMMENT 'Numero de transaccion de la bitacora',
	`TipoPago`              CHAR(1)            	NOT NULL       COMMENT 'Tipo de pago (E = Efectivo, C = Cargo a cuenta)',
	`CreditoID`             BIGINT(12)         	NOT NULL       COMMENT 'Numero del Credito',
	`CuentaAhoID`           BIGINT(12)         	NOT NULL       COMMENT 'Numero de cuenta de ahorro',
	`Monto`                 DECIMAL(12,2)      	NOT NULL       COMMENT 'Monto cobrado',
	`FolioMovil`            VARCHAR(100)		NOT NULL       COMMENT 'Folio de pago movil',
	`EmpresaID`             INT(11)            	NOT NULL       COMMENT 'Parametro de auditoria',
	`Usuario`               INT(11)           	NOT NULL       COMMENT 'Parametro de auditoria',
	`FechaActual`           DATETIME           	NOT NULL       COMMENT 'Parametro de auditoria',
	`DireccionIP`           VARCHAR(15)        	NOT NULL       COMMENT 'Parametro de auditoria',
	`ProgramaID`            VARCHAR(50)        	NOT NULL       COMMENT 'Parametro de auditoria',
	`Sucursal`              INT(11)            	NOT NULL       COMMENT 'Parametro de auditoria',
	`NumTransaccion`        BIGINT(20)         	NOT NULL       COMMENT 'Parametro de auditoria',
	CONSTRAINT `fk_BitSafiClienteID` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_BitSafiSucursalID` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_BitSafiCreditoID` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_BitSafiCuentaAhoID` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Guarda la bitacora de pagos desde el WS'$$
