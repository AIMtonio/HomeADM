-- BANPSLPARAMBROKERLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS BANPSLPARAMBROKERLIS;

DELIMITER $$

CREATE PROCEDURE BANPSLPARAMBROKERLIS (
	Par_NumLis						TINYINT UNSIGNED,

	Aud_EmpresaID 					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal 					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore:BEGIN
	DECLARE Var_LisPrincipal		TINYINT;

	SET Var_LisPrincipal 			:= 1;


	IF(Par_NumLis = Var_LisPrincipal) THEN
		SELECT LlaveParametro, ValorParametro
			FROM PSLPARAMBROKER;
	END IF;
END TerminaStore$$
