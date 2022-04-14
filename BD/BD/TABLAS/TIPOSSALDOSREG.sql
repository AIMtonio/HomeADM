-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSSALDOSREG
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSSALDOSREG`;
DELIMITER $$


CREATE TABLE TIPOSSALDOSREG(
	`ConceptoID`		INT(11)			NOT NULL		COMMENT 'ID del concepto. CONCEPTOSREGREP.ConceptoID',
	`ReporteID`			VARCHAR(20)		NOT NULL		COMMENT 'Identificador del reporte ej. A2021 u otro valor con el que se identifique el reporte',
	`NumeroCliente`		INT(11)			NOT NULL		COMMENT 'Numero de cliente especifico',
	`TipoSaldoID`		INT(11)			NOT NULL		COMMENT 'Consecutivo por concepto para el tipo de saldo.',
	`ClaveSaldo`		INT(11)			NOT NULL		COMMENT 'ID del tipo de saldo de acuerdo a la CNBV',
	`Descripcion`		VARCHAR(300)	NOT NULL		COMMENT 'Descripcion del tipo de saldo',
	`ClaveCampo`		VARCHAR(5)		NOT NULL		COMMENT 'Clave de Campo para ser usado en una formula',
	`FormulaContable`	VARCHAR(20)		DEFAULT ''		COMMENT 'Formula contable',
	`FormulaReporte`	VARCHAR(20)		DEFAULT ''		COMMENT 'Formula del Reportes "Este campo tiene prioridad sobre el campo FormulaContable"',
	`OrdenCalculo`		INT(11)			DEFAULT 0		COMMENT 'Indica el orden en el que se debe calcular la formula de reporte',
	`FuncionCalculo`	VARCHAR(20)		DEFAULT ''		COMMENT 'Nombre de funcion a ejecutar para calcular el saldo del concepto',
	`CampoReporte`		VARCHAR(300)	NOT NULL		COMMENT 'Campo a mostrar en reporte',
	`Presentacion`		CHAR(3)			NOT NULL		COMMENT 'Presentación \n"SCI"- Saldo Contable Inicial \n"SIF".- Saldo Inicial-Final \n"SFI".- Saldo Final-Inicial \n"SCF".- Saldo Contable Final',
	`EmpresaID`			INT(11)			DEFAULT NULL	COMMENT 'Campo de Auditoria',
	`Usuario`			INT(11)			DEFAULT NULL	COMMENT 'Campo de Auditoria',
	`FechaActual`		DATETIME		DEFAULT NULL	COMMENT 'Campo de Auditoria',
	`DireccionIP`		VARCHAR(20)		DEFAULT NULL	COMMENT 'Campo de Auditoria',
	`ProgramaID`		VARCHAR(50)		DEFAULT NULL	COMMENT 'Campo de Auditoria',
	`Sucursal`			INT(11)			DEFAULT NULL	COMMENT 'Campo de Auditoria',
	`NumeroTransaccion`	BIGINT(20)		NOT NULL		COMMENT 'Campo de Auditoria',

	PRIMARY KEY (`ConceptoID`, `ReporteID`, `NumeroCliente`, `TipoSaldoID`),
	KEY `FK_TIPOSSALDOSREG_1` (`ConceptoID`, `ReporteID`, `NumeroCliente`),

	CONSTRAINT `FK_TIPOSSALDOSREG_1` FOREIGN KEY (`ConceptoID`, `ReporteID`, `NumeroCliente`) REFERENCES `CONCEPTOSREG` (`ConceptoID`, `ReporteID`, `NumeroCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para tipos de saldos regulatorios y su forma de calculo'$$