-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATSTATUSDISPERSIONES
DELIMITER ;
DROP TABLE IF EXISTS `CATSTATUSDISPERSIONES`;
DELIMITER $$

CREATE TABLE `CATSTATUSDISPERSIONES` (
	`CodigoID`				VARCHAR(3) COMMENT 'Codigo de rechazo',
	`Descripcion`			VARCHAR(100) COMMENT 'Descripcion de rechazo',
    `Banco`					CHAR(1) COMMENT 'Banco\n S.-Santander',
    `TipoOper`				CHAR(1) COMMENT 'Tipo de operacion\n O.-Orden de Pago\n T.-Transferencias\n D.-DEFAULT(Todos)',
    `EmpresaID` 			INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`Usuario` 				INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`FechaActual` 			DATETIME DEFAULT NULL COMMENT 'AUDITORIA',
	`DireccionIP` 			VARCHAR(15) DEFAULT NULL COMMENT 'AUDITORIA',
	`ProgramaID` 			VARCHAR(50) DEFAULT NULL COMMENT 'AUDITORIA',
	`Sucursal` 				INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`NumTransaccion` 		BIGINT(20) DEFAULT NULL COMMENT 'AUDITORIA',
	PRIMARY KEY (`CodigoID`,`Descripcion`,`Banco`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo de estatus de dispersiones'$$



