-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_CARDETPOLIZA
DELIMITER ;
DROP TABLE IF EXISTS TMP_MASIVOPOLIZA;
DELIMITER $$

CREATE TABLE TMP_MASIVOPOLIZA (
    ID 					BIGINT(20)  NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla',
    CreditoID 			BIGINT(12) 							COMMENT 'ID del Credito',
	MonedaID 			INT(11) 							COMMENT 'ID de la Moneda',
	SaldoCapVigent		DECIMAL(14,2) 						COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros\n',			
	SaldoCapAtrasad		DECIMAL(14,2) 						COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros\n',
	SaldoCapVencido     DECIMAL(14,2) 						COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros\n',
	SaldCapVenNoExi		DECIMAL(14,2) 						COMMENT 'Saldo de Capital Vencido no Exigible, en el alta nace con ceros\n',
	SaldoInterOrdin		DECIMAL(14,4) 						COMMENT 'Saldo de Interes Ordinario, en el alta nace con ceros\n',
	SaldoInterAtras		DECIMAL(14,4) 						COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros\n',
	SaldoInterVenc		DECIMAL(14,4) 						COMMENT 'Saldo de Interes Vencido, en el alta nace con ceros\n',
	SaldoInterProvi		DECIMAL(14,4) 						COMMENT 'Saldo de Provision, en el alta nace con ceros\n',
	SaldoMoratorios		DECIMAL(14,2) 						COMMENT 'Saldo Moratorios, en el alta nace con ceros\n',
	SaldComFaltPago		DECIMAL(12,2) 						COMMENT 'Saldo Comision Falta Pago, en el alta nace con ceros\n',
	SaldoOtrasComis		DECIMAL(12,2) 						COMMENT 'Saldo Otras Comisiones, en el alta nace con ceros\n',
	SaldoMoraVencido	DECIMAL(14,2) 						COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
	SaldoMoraCarVen		DECIMAL(14,2) 						COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
	SaldoComAnual		DECIMAL(14,2) 						COMMENT 'Saldo Comision Anual',
	InstitutFondActID	INT(11) 							COMMENT 'id de institucion de fondeo actual',
	InstitutFondNueID	INT(11) 							COMMENT 'id de institucion de fondeo Nueva',		
    NumTransaccion 		BIGINT(20)							COMMENT 'Numero de Transaccion',

    INDEX(CreditoID),
    INDEX(NumTransaccion),
    INDEX(CreditoID, NumTransaccion),
    PRIMARY KEY(ID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: almacena los saldos para cambio de fuente masivo'$$