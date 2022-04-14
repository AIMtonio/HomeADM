-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPARAMGENTARJETACON
DELIMITER ;

DROP PROCEDURE IF EXISTS `TARDEBPARAMGENTARJETACON`;

DELIMITER $$

CREATE PROCEDURE `TARDEBPARAMGENTARJETACON`(
	Par_Bin 			VARCHAR(8),				-- Bin de la tarjeta
	Par_NumCon			INT(11),				-- Numero de consulta
	
	Aud_EmpresaID		INT(11),				-- Auditoria
	Aud_Usuario			INT(11),				-- Auditoria

	Aud_FechaActual		DATETIME,				-- Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Auditoria
	Aud_Sucursal		INT,					-- Auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia				CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);		-- Entero Cero
    DECLARE Decimal_Cero				DECIMAL(12,2);	-- Decimal Cero
    DECLARE Con_ColTarjetas				INT(11);		-- Consulta de cantidad de tarjetas restantes
	
	-- Declaracion de Variables
	DECLARE Var_CantTarjetas			INT(11);			-- Cantidad de tarjetas
	DECLARE Var_Bin						VARCHAR(8);			-- Bin de la tarjeta
	DECLARE	Var_SubBin					VARCHAR(2);			-- SubBin de la tarjeta

	-- Asignacion de constantes
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia 					:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Decimal_Cero					:= 0.00;			-- Decimal Cero
	SET Con_ColTarjetas				:= 1;				-- Consulta de cantidad de tarjetas restantes

	IF(Par_NumCon = Con_ColTarjetas) THEN
		SELECT 		Bin,			ColeccionTarjetas
			FROM TARDEBPARAMGENTARJETA
			WHERE Bin = Par_Bin;
	END IF;

END TerminaStore$$
