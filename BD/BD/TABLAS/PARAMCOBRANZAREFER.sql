-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCOBRANZAREFER
DELIMITER ;
DROP TABLE IF EXISTS `PARAMCOBRANZAREFER`;
DELIMITER $$

CREATE TABLE `PARAMCOBRANZAREFER`(
	ParamCobranzaReferID	INT(11) NOT NULL COMMENT 'Numero Consecutivo o ID de la Tabla ',
	ConsecutivoID			INT(11) NOT NULL COMMENT 'ID o Numero de Parametros de Deposito referenciados',
	AplicaCobranzaRef		CHAR(1) NOT NULL COMMENT 'Indica SI aplica Cobranza Referenciado: S=SI ,N=NO',
	ProducCreditoID			INT(11) NOT NULL COMMENT 'ID o Numero del producto de credito',
	EmpresaID				INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario					INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual				DATETIME NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP				VARCHAR(15) NOT NULL COMMENT 'ID de la institucion Bancaria',
	ProgramaID				VARCHAR(50) NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal				INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion			BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (ParamCobranzaReferID),
	INDEX (ConsecutivoID),
	INDEX (ProducCreditoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla que guarda los parametros para ejecutar los procesos de Cobranza Referenciados '$$
