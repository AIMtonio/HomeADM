-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPGRUPOTASA
DELIMITER ;
DROP TABLE IF EXISTS `TMPGRUPOTASA`;

DELIMITER $$
CREATE TABLE `TMPGRUPOTASA` (
	`RegistroID`			INT(11)		NOT NULL COMMENT 'ID de Tabla',
	`Transaccion`			BIGINT(20) 	NOT NULL COMMENT 'ID de Tabla',
	`GrupoID`				INT(11)		NOT NULL COMMENT 'ID de Tabla GRUPOSCREDITO',
	`SolicitudCreditoID`	BIGINT(20)	NOT NULL COMMENT 'ID de Tabla SOLICITUDCREDITO',

	`EmpresaID`				INT(11) 	NOT NULL COMMENT 'Parametro de Auditoria Empresa ID',
	`Usuario`				INT(11) 	NOT NULL COMMENT 'Parametro de Auditoria Usuario ID',
	`FechaActual`			DATETIME 	NOT NULL COMMENT 'Parametro de Auditoria Fecha Actual',
	`DireccionIP`			VARCHAR(15) NOT NULL COMMENT 'Parametro de Auditoria Dirección IP',
	`ProgramaID`			VARCHAR(20) NOT NULL COMMENT 'Parametro de Auditoria Programa ID',
	`Sucursal`				INT(11) 	NOT NULL COMMENT 'Parametro de Auditoria Sucursal ID',
	`NumTransaccion`		BIGINT(20) 	NOT NULL COMMENT 'Parametro de Auditoria Número de Transacción',
	PRIMARY KEY (`RegistroID`,`Transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal Física para el rompimiento de Grupos de Crédito.'$$