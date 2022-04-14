-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEREARRENDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEREARRENDACON`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFEREARRENDACON`(
	--  SP  QUE LISTA DEPOSITOS REFERENCIADOS DE ARRENDAMIENTO
	Par_DepRefereID		BIGINT,       		-- FOLIO DE CARGA A PROCESAR
	Par_NumCon        	TINYINT UNSIGNED,	-- TIPO DE CINSULTA

	Aud_EmpresaID     	INT(11),      		-- PARAMETRO DE AUDITORIA
	Aud_Usuario			INT(11),      		-- PARAMETRO DE AUDITORIA
	Aud_FechaActual		DATETIME,     		-- PARAMETRO DE AUDITORIA
	Aud_DireccionIP     VARCHAR(15),		-- PARAMETRO DE AUDITORIA
	Aud_ProgramaID      VARCHAR(50),		-- PARAMETRO DE AUDITORIA
	Aud_Sucursal		INT(11),			-- PARAMETRO DE AUDITORIA
	Aud_NumTransaccion	BIGINT(20)			-- PARAMETRO DE AUDITORIA
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);			-- VALOR CERP
	DECLARE Cadena_Vacia    CHAR(1);			-- CADENA VACIA
	DECLARE Con_Principal   CHAR(1);			-- CONSULTA PRINCIPAL
	DECLARE Est_NoAplicado	CHAR(1);			-- ESTATUS NO APLICADO
	-- Declaracion de Variables


	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- VALOR CERP
	SET Cadena_Vacia		:= '';				-- CADENA VACIA
	SET Con_Principal		:= 1; 				-- CONSULTA PRINCIPAL
	SET Est_NoAplicado		:= 'N';				-- ESTATUS NO APLICADO

	-- Asignacion de Variables
	SET Aud_FechaActual		:= CURRENT_TIMESTAMP();	-- FECHA ACTUAL

	-- LISTA PRINCIPAL
	IF (Con_Principal = Par_NumCon) THEN
		SELECT DISTINCT D.DepRefereID,  D.InstitucionID, D.NumCtaInstit, D.FechaCarga,  D.Estatus
			FROM  DEPOSITOREFEARRENDA D
			WHERE D.DepRefereID = Par_DepRefereID;
	END IF;

END TerminaStore$$