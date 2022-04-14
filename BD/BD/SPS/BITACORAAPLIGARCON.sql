-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAAPLIGARCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAAPLIGARCON`;DELIMITER $$

CREATE PROCEDURE `BITACORAAPLIGARCON`(
# ==================================================================
# -------------- SP PARA APLICACION GARANTIAS FIRA ----------------
# ==================================================================
	Par_CreditoID			BIGINT(12),				-- Numero de credito
	Par_ClienteID			INT(11),				-- Numero de cliente
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de consulta

	Par_EmpresaID			INT(11),				-- Parametro de auditoria
	Aud_Usuario				INT(11),				-- Parametro de auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_ExisteGtia		CHAR(1);	-- Variable que guarda si la garantia ya fue aplicada al credito

	--  Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE ConApliGar			INT(11);
    DECLARE Con_Si				CHAR(1);
    DECLARE Con_No				CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';		-- Cadena Vacia
	SET Entero_Cero				:= 0;		-- Entero Cero
	SET ConApliGar				:= 1; 		-- Consulta principal
	SET	Con_Si					:= 'S';		-- Constante Si
	SET Con_No					:= 'N';		-- COnstante No

	IF(Par_NumCon = ConApliGar)THEN

        IF EXISTS (SELECT	CreditoID
						FROM 	BITACORAAPLIGAR
						WHERE	CreditoID = Par_CreditoID) THEN

			SET Var_ExisteGtia := Con_Si;
		ELSE
			SET Var_ExisteGtia := Con_No;
		END IF;

		SELECT Var_ExisteGtia AS ExisteGtia;

	END IF;

END TerminaStore$$