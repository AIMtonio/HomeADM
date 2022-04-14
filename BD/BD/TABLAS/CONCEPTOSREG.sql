-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSREG
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSREG`;
DELIMITER $$


CREATE TABLE `CONCEPTOSREG` (
	`ConceptoID`	INT(11)			NOT NULL	COMMENT 'Llave primaria de la tabla',
	`ReporteID`		VARCHAR(20)		NOT NULL	COMMENT 'Identificador del reporte ej. A2021 u otro valor con el que se identifique el reporte',
	`NumeroCliente`	INT(11)			NOT NULL	COMMENT 'Numero de cliente especifico',
	`Descripcion`	VARCHAR(500)	DEFAULT ''	COMMENT 'Descripcion del concepto',
	`EsNegrita`		CHAR(1)			DEFAULT 'N'	COMMENT 'Indica si la fuente del Indicador es negrita S=si, N=no',
	`ClaveConcepto`	VARCHAR(12)		NOT NULL	COMMENT 'Clave CNBV del concepto',
	PRIMARY KEY (`ConceptoID`,`ReporteID`,`NumeroCliente`),
	KEY `CONCEPTOSREG_IDX1` (`ReporteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los conceptos y sus caracteristicas mostrados en los reportes regulatorios de contabilidad'$$