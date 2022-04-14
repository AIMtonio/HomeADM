-- Creacion de tabla TMPLISTAACCESORIOSSIMULADOS

DELIMITER ;

DROP TABLE IF EXISTS `TMPLISTAACCESORIOSSIMULADOS`;

DELIMITER $$

CREATE TABLE `TMPLISTAACCESORIOSSIMULADOS` (
	`RegistroID`				BIGINT UNSIGNED		AUTO_INCREMENT	NOT NULL	COMMENT 'Identificador de la tabla',
	`AccesorioID`				INT(11)								NOT NULL	COMMENT 'Identificador de la tabla cabecera',
	`AmortizacionID`			INT(11)								NOT NULL	COMMENT 'Identificador del credito a depurar',
	`MontoCuota`				DECIMAL(14,2)						NOT NULL	COMMENT 'Monto del Accesorio por cuota',
	`MontoIVACuota`				DECIMAL(14,2)						NOT NULL	COMMENT 'Monto del IVA del Accesorio por cuota',
	`MontoIntCuota`				DECIMAL(14,2)						NOT NULL	COMMENT 'Monto del Interes del Accesorio por cuota',
	`MontoIVAIntCuota`			DECIMAL(14,2)						NOT NULL	COMMENT 'Monto del IVA de Interes del Accesorio por cuota',
	`MontoAccesorio`			DECIMAL(14,2)						NOT NULL	COMMENT 'Monto del Accesorio',
	`MontoIVAAccesorio`			DECIMAL(14,2)						NOT NULL	COMMENT 'Monto del IVA del Accesorio',
	`MontoInteres`				DECIMAL(14,2)						NOT NULL	COMMENT 'Monto del Interes del Accesorio',
	`MontoIVAInteres`			DECIMAL(14,2)						NOT NULL	COMMENT 'Monto del IVA de Interes del Accesorio',
	`GeneraInteres`				CHAR(2)								NOT NULL	COMMENT 'Indica si el Accesorio cobra o no Interes',
	`ContadorAccesorios`		INT(11)								NOT NULL	COMMENT 'Numero de Accesorios diferentes tomados en cuenta en la simulacion',
	`EncabezadoLista`			VARCHAR(5000)						NOT NULL	COMMENT 'Texto con el texto de las columnas de cada accesorio',
	`NumAmortizacion`			INT(11)								NOT NULL	COMMENT 'Numero de amortizaciones simuladas',
	`CreditoID`					BIGINT(12)							NOT NULL	COMMENT 'Identificador de un credito',
	`NumTransaccion`			BIGINT(20)							NOT NULL	COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`RegistroID`),
	INDEX `INDEX_TMPLISTAACCESORIOSSIMULADOS_1` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla para listar los accesorios desglosados por simulacion o por credito'$$