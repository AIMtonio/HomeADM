-- SP BANCREDITOSPLAZOSLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS BANCREDITOSPLAZOSLIS;

DELIMITER $$

CREATE PROCEDURE BANCREDITOSPLAZOSLIS(
	-- SP que lista los plazos de un producto de credito.

	Par_ProductoCreditoID	INT(11),				-- Indica el ID del Producto de credito
	Par_NumLis		    	TINYINT UNSIGNED,		-- Indica Tipo de Lista

	Aud_EmpresaID		    INT(11),				-- Parametro de Auditoria
    Aud_UsuarioID		    INT(11),				-- Parametro de Auditoria
	Aud_Fecha				DATE,					-- Parametro de Auditoria
	Aud_DireccionIP		    VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID		    VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumeroTransaccion	BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN
	
	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				INT;					-- Entero 0
	DECLARE Var_Lis_Principal		INT(1);					-- Lista Principal
	
	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero					:= 0;					 -- Entero Cero
	SET Var_Lis_Principal			:= 1;					 -- Lista Principal

	-- 1.- Lista Principal.
	IF(Par_NumLis = Var_Lis_Principal) THEN
	
		SELECT 		Cre.PlazoID,		Cre.Descripcion,		Cre.Dias,		Cal.Frecuencias
		FROM CALENDARIOPROD AS Cal
		INNER JOIN CREDITOSPLAZOS AS Cre
			ON LOCATE(CONCAT(',',Cre.PlazoID,','), CONCAT(',',Cal.PlazoID,',')) > Entero_Cero
		WHERE Cal.ProductoCreditoID = Par_ProductoCreditoID
		ORDER BY Cre.Dias ASC;

	END IF;
	
END TerminaStore$$

