-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCRECONSOLIDAAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCRECONSOLIDAAGRO`;

DELIMITER $$
CREATE TABLE `TMPCRECONSOLIDAAGRO` (
	`RegistroID`				INT(11) 	NOT NULL COMMENT 'ID de Tabla',
	`DetalleFolioConsolidaID`	BIGINT(12) 	NOT NULL COMMENT 'ID o Referencia de Detalle de Consolidación',
	`FolioConsolidaID`			BIGINT(12) 	NOT NULL COMMENT 'ID o Referencia de Consolidación',
	`SolicitudCreditoID`		BIGINT(20) 	NOT NULL COMMENT 'Número de Solicitud de Crédito',
	`CreditoID`					BIGINT(12) 	NOT NULL COMMENT 'Número de Crédito',
	`Transaccion`				BIGINT(20) 	NOT NULL COMMENT 'Número de Transacción de la tabla en sesión',
	`EmpresaID`					INT(11) 	NOT NULL COMMENT 'Campo de Auditoria Número de Empresa',
	`Usuario`					INT(11) 	NOT NULL COMMENT 'Campo de Auditoria Número de Usuario',
	`FechaActual`				DATETIME 	NOT NULL COMMENT 'Campo de Auditoria Fecha Actual',
	`DireccionIP`				VARCHAR(15) NOT NULL COMMENT 'Campo de Auditoria Direccion IP',
	`ProgramaID`				VARCHAR(50) NOT NULL COMMENT 'Campo de Auditoria Programa ID',
	`Sucursal`					INT(11)		NOT NULL COMMENT 'Campo de Auditoria Sucursal ID',
	`NumTransaccion`			BIGINT(20) 	NOT NULL COMMENT 'Campo de Auditoria Número de Transacción',
	PRIMARY KEY (`RegistroID`,`DetalleFolioConsolidaID`,`FolioConsolidaID`,`Transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal Física para la proyección de Intereses.'$$