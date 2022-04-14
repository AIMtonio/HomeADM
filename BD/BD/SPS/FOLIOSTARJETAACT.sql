-- FOLIOSTARJETAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSTARJETAACT`;
DELIMITER $$


CREATE PROCEDURE `FOLIOSTARJETAACT`(
	Par_BINCompleto	CHAR(8),
	OUT	Par_FolioTar	BIGINT(12)
	)

TerminaStore: BEGIN


DECLARE	Entero_Cero		INT(11);
DECLARE	Salida_SI		CHAR(1);
DECLARE Var_ConsecutivoDef      BIGINT(11);

SET	Entero_Cero			:= 0;
SET	Salida_SI			:= 'S';
SET Var_ConsecutivoDef	:= 99999;


SELECT	FolioTarjetaID INTO Par_FolioTar
		FROM FOLIOSTARJETA
		WHERE	BINCompleto	= Par_BINCompleto
        FOR UPDATE;

IF Par_FolioTar is NULL THEN
	SET	Par_FolioTar	= Var_ConsecutivoDef;
	INSERT INTO FOLIOSTARJETA VALUES (
		Par_FolioTar,	Par_BINCompleto	);
ELSE
	UPDATE FOLIOSTARJETA SET
	FolioTarjetaID	= FolioTarjetaID - 1
	WHERE	BINCompleto	= Par_BINCompleto;
END IF;


SET Par_FolioTar := (SELECT	FolioTarjetaID
				FROM FOLIOSTARJETA
				WHERE	BINCompleto	= Par_BINCompleto);

END TerminaStore$$