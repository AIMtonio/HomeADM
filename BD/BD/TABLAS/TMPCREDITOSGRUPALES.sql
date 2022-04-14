-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOSGRUPALES
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOSGRUPALES`;
DELIMITER $$

CREATE TABLE `TMPCREDITOSGRUPALES` (
	`CreditoGrupID`		INT(11)		NOT NULL DEFAULT '0' COMMENT 'ID CRedito grupal',
	`CreditoID`			BIGINT(12)	DEFAULT NULL COMMENT 'CreditoID Individual',
	`GrupoID`			INT(11)		DEFAULT NULL COMMENT 'ID del Grupo',
	`ProductoCred`		INT(11)		DEFAULT NULL COMMENT 'ID del producto de credito',
	`FechaVencimien`	DATE		DEFAULT NULL COMMENT 'Fecha de Vencimiento del Credito',
	`Estatus`			CHAR(1)		DEFAULT NULL COMMENT 'Estatus del credito',
	`TipoPrepago`		CHAR(1)		DEFAULT NULL COMMENT 'Tipo de prepago del credito',
	`FechaInicioAmo`	DATE		DEFAULT NULL COMMENT 'Fecha de Inicio del Credito',
	`EmpresaID`			INT(11)		DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Usuario`			INT(11)		DEFAULT NULL COMMENT 'Parametro de auditoria',
	`FechaActual`		DATETIME 	DEFAULT NULL COMMENT 'Parametro de auditoria',
	`DireccionIP`		VARCHAR(15)	DEFAULT NULL COMMENT 'Parametro de auditoria',
	`ProgramaID`		VARCHAR(50)	DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Sucursal`			INT(11)		DEFAULT NULL COMMENT 'Parametro de auditoria',
	`NumTransaccion`	BIGINT(20)	NOT NULL DEFAULT '0' COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`CreditoGrupID`,`NumTransaccion`),
	KEY `IDX_CREDGRUP_1` (`CreditoID`),
	KEY `IDX_CREDGRUP_2` (`GrupoID`),
	KEY `IDX_CREDGRUP_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal Física para la Ministración de los Créditos grupales.'$$
