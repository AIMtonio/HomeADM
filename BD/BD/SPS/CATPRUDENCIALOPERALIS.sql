-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPRUDENCIALOPERALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATPRUDENCIALOPERALIS`;DELIMITER $$

CREATE PROCEDURE `CATPRUDENCIALOPERALIS`(
# =====================================================================================
# -----       STORE DE LISTA TIPO DE NIVEL DE ENTIDAD DE REGULATORIOS
# ====================================================================================
	Par_NumLis				TINYINT UNSIGNED,			-- Tipo  de lista

	Par_EmpresaID			INT(11),					-- Parametros de Auditoria
	Aud_Usuario         	INT(11),					-- Parametros de Auditoria
	Aud_FechaActual     	DATETIME,					-- Parametros de Auditoria
	Aud_DireccionIP     	VARCHAR(15),				-- Parametros de Auditoria
	Aud_ProgramaID      	VARCHAR(50),				-- Parametros de Auditoria
	Aud_Sucursal        	INT(11),					-- Parametros de Auditoria
	Aud_NumTransaccion  	BIGINT(20)					-- Parametros de Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Descripcion   VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE Lis_NivOperacion		INT(11);	-- Nivel de Operaciones
	DECLARE Lis_NivPrudencial		INT(11); 	-- Nivel Prudencial
	DECLARE	Cadena_Vacia			CHAR(1); 	-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE; 		-- Fecha vacia
	DECLARE	Entero_Cero				INT(11); 	-- Entero Cero

	-- Asignacion de Constantes
	SET Lis_NivOperacion			:= 1;
	SET Lis_NivPrudencial			:= 3;
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;

	-- Lista Nivel de Operaciones
	IF (Par_NumLis = Lis_NivOperacion)THEN
		SELECT NivelID,	DescOpera
			FROM CATPRUDENCIALOPERA
		WHERE MuestraReg IN ('A','O');
	END IF;

	-- Lista Nivel Prudencial
	IF (Par_NumLis = Lis_NivPrudencial)THEN
		SELECT NivelID,	DescPrudencial
			FROM CATPRUDENCIALOPERA
		WHERE MuestraReg IN ('A','P');
	END IF;
END TerminaStore$$