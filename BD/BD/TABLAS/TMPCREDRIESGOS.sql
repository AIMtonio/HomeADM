-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDRIESGOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDRIESGOS`;

DELIMITER $$
CREATE TABLE `TMPCREDRIESGOS` (
	CreditoID			BIGINT(12)		NOT NULL COMMENT 'ID de Crédito',
	MontoCredito		DECIMAL(14,2)	NOT NULL COMMENT 'Monto de Crédito',
	SolCreditoID		BIGINT(20)		NOT NULL COMMENT 'ID de Solicitud de Credito',
	PRIMARY KEY (`CreditoID`),
	KEY `IDX_TMPCREDRIESGOS_1` (`SolCreditoID` ASC)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla de validación de riesgo comun.'$$