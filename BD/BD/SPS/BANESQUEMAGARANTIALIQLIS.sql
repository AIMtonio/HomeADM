-- SP BANESQUEMAGARANTIALIQLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS BANESQUEMAGARANTIALIQLIS;

DELIMITER $$

CREATE PROCEDURE BANESQUEMAGARANTIALIQLIS(
	-- SP que lista los equemas de garantía líquida para un producto de credito.

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
	DECLARE Lis_Principal		INT(1);					-- Lista Principal
	
	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal			:= 1;					 -- Lista Principal

	-- 1.- Lista Principal.
	IF(Par_NumLis = Lis_Principal) THEN
	
		SELECT 	EsquemaGarantiaLiqID, 		ProducCreditoID, 		Clasificacion, 		LimiteInferior, 		LimiteSuperior,
				Porcentaje, 				BonificacionFOGA 
		FROM 	ESQUEMAGARANTIALIQ 
		WHERE 	ProducCreditoID = Par_ProductoCreditoID;

	END IF;
	
END TerminaStore$$

