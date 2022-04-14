DELIMITER ;
DROP PROCEDURE IF EXISTS `VALCARGAMASIVADISPLIS`;

DELIMITER $$
CREATE PROCEDURE `VALCARGAMASIVADISPLIS`(
	Par_NumLista			INT(11),		-- Numero de lista 

	Par_EmpresaID			INT(11),		-- Parametros de Auditoria
	Aud_Usuario				INT(11),		-- Parametros de Auditoria	
	Aud_FechaActual			DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal			INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametros de Auditoria
)
TerminaStore:BEGIN
	-- Delcaracion de constantes
	DECLARE Lis_Validacion	INT(11);

	-- Seteo de valores
	SET Lis_Validacion := 1;

	IF Par_NumLista = Lis_Validacion THEN
		SELECT Val.Fila, Cat.Validacion 
		FROM VALCARGAMASIVADISP Val
		INNER JOIN CATCARGAMASIVADISP Cat ON Val.CatDispMasivaID = Cat.CatDispMasivaID
		WHERE Val.NumTransaccion = Aud_NumTransaccion;
	END IF;
END TerminaStore$$  