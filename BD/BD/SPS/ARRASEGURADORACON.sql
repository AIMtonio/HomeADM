-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRASEGURADORACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRASEGURADORACON`;DELIMITER $$

CREATE PROCEDURE `ARRASEGURADORACON`(
# =====================================================================================
# -- -- SP PARA LA CONSULTA DE UNA ASEGURADORA
# =====================================================================================

	Par_AseguradoraID		BIGINT(12),				-- Id de la aseguradora
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID			INT,					-- Id de la empresa
	Aud_Usuario         	INT,					-- Usuario
	Aud_FechaActual     	DATETIME,				-- Fecha actual
	Aud_DireccionIP     	VARCHAR(15),			-- Descripcion IP
	Aud_ProgramaID      	VARCHAR(50),			-- Id del programa
	Aud_Sucursal        	INT(11),				-- Numero de sucursal
	Aud_NumTransaccion  	BIGINT(20)				-- Numero de transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Con_Principal	INT;
	DECLARE Var_SegMueble	INT(11);	-- Seguro mueble
	DECLARE Var_SegVida		INT(11);	-- Seguro de vida
	DECLARE Var_SegAmbos	INT(11);	-- Seguro mueble y de vida
	DECLARE Est_Activo		CHAR(1);	-- Estatus activo
	DECLARE Var_ConMueble	INT(11);	-- Consulta de seguros mueble
	DECLARE Var_ConVida		INT(11);	-- Consulta de seguros de vida

	-- Asignacion de Contantes
	SET Con_Principal		:=1;		-- consulta principal
	SET Var_SegMueble		:= 1;		-- Seguro mueble
	SET Var_SegVida			:= 2;		-- Seguro de vida
	SET Var_SegAmbos		:= 3;		-- Seguro mueble y de vida
	SET Est_Activo			:= 'A';		-- Estatus activo
	SET Var_ConMueble		:= 2;		-- Consulta de seguros mueble
	SET Var_ConVida			:= 3;		-- Consulta de seguros de vida

	-- Consulta los datos de una aseguradora --
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	AseguradoraID,		Descripcion,		Estatus,		TipoSeguro
		FROM	ARRASEGURADORA
		WHERE	AseguradoraID = Par_AseguradoraID;
	END IF;

	-- Consulta los datos de una aseguradora mueble
	IF(Par_NumCon = Var_ConMueble) THEN
		SELECT	AseguradoraID,	Descripcion,	Estatus,	TipoSeguro
			FROM	ARRASEGURADORA
			WHERE	AseguradoraID = Par_AseguradoraID
			  AND	TipoSeguro IN (Var_SegMueble, Var_SegAmbos)
			  AND	Estatus = Est_Activo;
	END IF;

	-- Consulta los datos de una aseguradora de vida
	IF(Par_NumCon = Var_ConVida) THEN
		SELECT	AseguradoraID,	Descripcion,	Estatus,	TipoSeguro
			FROM	ARRASEGURADORA
			WHERE	AseguradoraID = Par_AseguradoraID
			  AND	TipoSeguro IN (Var_SegVida, Var_SegAmbos)
			  AND	Estatus = Est_Activo;
	END IF;

END TerminaStore$$