-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTIPOSSALDOSREG
DELIMITER ;
DROP TABLE IF EXISTS `TMPTIPOSSALDOSREG`;
DELIMITER $$


CREATE TABLE TMPTIPOSSALDOSREG(
	`ConceptoID`		INT(11)			NOT NULL	COMMENT 'ID del concepto. CONCEPTOSREGREP.ConceptoID',
	`TipoSaldoID`		INT(11)			NOT NULL	COMMENT 'Consecutivo por concepto para el tipo de saldo.',
	`ClaveSaldo`		VARCHAR(12)		NOT NULL	COMMENT 'Clave que para el tipo de saldo en el regulatorio.',
	`ClaveCampo`		VARCHAR(5)		NOT NULL	COMMENT 'Clave de Campo',
	`Descripcion`		VARCHAR(300)	NOT NULL	COMMENT 'Descripcion del tipo de saldo',
	`SaldoActual`		DECIMAL(18,2)	NOT NULL	COMMENT 'Saldo Actual del Reporte',
	`SaldoAnterior`		DECIMAL(18,2)	NOT NULL	COMMENT 'Saldo Actual del Reporte',
	`SaldoFinal`		DECIMAL(18,2)	NOT NULL	COMMENT 'Saldo Actual del Reporte',
	`CampoReporte`		VARCHAR(300)	NOT NULL	COMMENT 'Campo a mostrar en reporte',
	`Presentacion`		CHAR(3)			NOT NULL	COMMENT 'Presentación \n"SCI"- Saldo Contable Inicial \n"SIF".- Saldo Inicial-Final \n"SFI".- Saldo Final-Inicial \n"SCF".- Saldo Contable Final',
	`NumeroTransaccion`	BIGINT(20)		NOT NULL	COMMENT 'Numero de transaccion',
	KEY `IDX_TMPTIPOSSALDOSREG_1` (`ConceptoID`, `TipoSaldoID`, `NumeroTransaccion`),
	KEY `IDX_TMPTIPOSSALDOSREG_2` (`NumeroTransaccion`),
	KEY `IDX_TMPTIPOSSALDOSREG_3` (`ClaveCampo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para regulatorios contables'$$