-- TMPCREDATRASADOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDATRASADOS`;
DELIMITER $$

CREATE TABLE `TMPCREDATRASADOS` (
	`TmpID` 			BIGINT(20) 		NOT NULL COMMENT 'Numero consecutivo.',
	`FechaExigible` 	DATE 			NOT NULL COMMENT 'Minima Fecha Exigible ',
	`TotalAplicar` 		DECIMAL(14,4) 	NOT NULL COMMENT 'Monto total de interes y capital que se adeuda del credito',
	`CreditoID` 		BIGINT(12) 		NOT NULL COMMENT 'Numero de Credito',
	`EmpresaID` 		INT(11) 		NOT NULL COMMENT 'Parametro Auditoria',
	`Usuario` 			INT(11) 		NOT NULL COMMENT 'Parametro Auditoria',
	`FechaActual` 		DATE 			NOT NULL COMMENT 'Parametro Auditoria',
	`DireccionIP` 		VARCHAR(15) 	NOT NULL COMMENT 'Parametro Auditoria',
	`ProgramaID` 		VARCHAR(50) 	NOT NULL COMMENT 'Parametro Auditoria',
	`Sucursal` 			INT(11) 		NOT NULL COMMENT 'Parametro Auditoria',
	`NumTransaccion` 	BIGINT(20)  	NOT NULL COMMENT 'Parametro Auditoria',
	PRIMARY KEY (`CreditoID`),
	KEY `INDEX_TMPCREDATRASADOS_1` (`NumTransaccion`),
	KEY `INDEX_TMPCREDATRASADOS_2` (`CreditoID`,`NumTransaccion`),
	KEY `INDEX_TMPCREDATRASADOS_3` (`FechaExigible`,`TmpID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal para almacenar los creditos con dias de atras'$$