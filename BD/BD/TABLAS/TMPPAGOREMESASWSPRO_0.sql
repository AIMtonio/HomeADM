DELIMITER ;
DROP TABLE IF EXISTS TMPPAGOREMESASWSPRO_0;
DELIMITER $$
CREATE TABLE TMPPAGOREMESASWSPRO_0(
	TmpID				INT(11)			UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID tmp.',
	DenominacionID		INT(11)			DEFAULT 0	COMMENT 'Identificador de la denominacion',
	Valor				INT(11)			DEFAULT 0	COMMENT 'Valor de la denominacion actual',
	CantidadDispon		DECIMAL(14,2)	DEFAULT 0.0	COMMENT 'Cantidad disponible de la remesa',
	Cantidad			DECIMAL(14,2)	DEFAULT 0.0	COMMENT 'Cantidad de la remesa',
	MontoPen			DECIMAL(14,2)	DEFAULT 0.0	COMMENT 'Monto pendiente en aplicar la remesa',
	Monto				DECIMAL(14,2)	DEFAULT 0.0	COMMENT 'Monto de la remesa',
	NumTransaccion		BIGINT(20)		DEFAULT 0	COMMENT 'Numero de la transaccion',
PRIMARY KEY(TmpID),
KEY INDEX_TMPPAGOREMESASWSPRO_1(NumTransaccion),
KEY INDEX_TMPPAGOREMESASWSPRO_2(DenominacionID, NumTransaccion),
KEY INDEX_TMPPAGOREMESASWSPRO_3(Cantidad, NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Auxiliar para guardar la informacion de las denominaciones de las remesas.'$$