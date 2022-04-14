-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCREDITPAYMENT
DELIMITER ;
DROP TABLE IF EXISTS PARAMCREDITPAYMENT;
DELIMITER $$

CREATE TABLE PARAMCREDITPAYMENT (
	ParamCreditPaymentID	INT(11) NOT NULL COMMENT 'Numero o ID de la tabla de Parametros de web service credito Payment',
	ProducCreditoID			INT(11) NOT NULL COMMENT 'ID o Numero del producto de credito',
	PagoCredAutom			CHAR(1) NOT NULL COMMENT 'Indica SI aplica en automatico o NO el pago de credito, S=SI, N=NO',
	Exigible				CHAR(1) NOT NULL COMMENT 'Indica la Accion a Realizar en caso de NO tener exigible, A=Abono a cuenta, P=Prepago de credito',
	Sobrante				CHAR(1) NOT NULL COMMENT 'Indica la accion a realizar en caso de tener Sobrante, P=Prepago de Credito,A=Ahorro',
	AplicaCobranzaRef		CHAR(1) NOT NULL COMMENT 'Indica SI aplica Cobranza Referenciado: S=SI ,N=NO',
	EmpresaID				INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario					INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual				DATETIME NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP				VARCHAR(15) NOT NULL COMMENT 'ID de la institucion Bancaria',
	ProgramaID				VARCHAR(50) NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal				INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion			BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (ParamCreditPaymentID),
	INDEX(ProducCreditoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla que guarda los parametros para ejecutar los procesos de pago credito mediante WS credit payment'$$
