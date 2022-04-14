-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICACONTAREGLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICACONTAREGLIS`;DELIMITER $$

CREATE PROCEDURE `CLASIFICACONTAREGLIS`(
# =====================================================================================
# -----       STORE DE LISTA CLASIFICACION CONTABLE DE REGULATORIOS  		 	 ------
# ====================================================================================
	Par_ClasiPlazo			INT(11),					-- Clasificacion del plazo
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
	DECLARE Lis_Principal		INT(11);
    DECLARE Lis_Foranea			INT(11);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);

	-- Asignacion de Constantes
	SET Lis_Principal			:= 1;
	SET Lis_Foranea				:= 2;
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;


	IF (Par_NumLis = Lis_Principal)THEN
		SELECT CodigoOpcion,	Descripcion
			FROM CATCLASIFICACONTAREG;
	END IF;

	IF (Par_NumLis = Lis_Foranea)THEN
		SELECT CodigoOpcion,		Descripcion
			FROM CATCLASIFICACONTAREG
				WHERE Plazo = Par_ClasiPlazo;
	END IF;

END TerminaStore$$