-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMDEPREFERCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMDEPREFERCON`;
DELIMITER $$


CREATE PROCEDURE `PARAMDEPREFERCON`(
	-- ----------------------------------------------------------------
	-- ----------- SP PARA CONSULTAR LA TABLA PARAMDEPREFER -----------
	-- ----------------------------------------------------------------
	Par_ConsecutivoID	CHAR(1),		-- ID Consecutivo de la tabla PARAMDEPREFER (PK)
	Par_NumCon			TINYINT,		-- Numero de Consulta

	Par_EmpresaID		INT(11),		-- Parametro de Auditoria
	Aud_Usuario			INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de Auditoria
)

TerminaStore: BEGIN

-- DECLARACION DE VARIABLES


-- DECLARACION DE CONSTANTES
DECLARE Con_Principal			TINYINT;	-- Consulta Principal
DECLARE Con_PagoCredAutom		TINYINT;	-- Consulta si esta parametrizado el Pago de Credito Automatico
DECLARE Con_Exigible			TINYINT;	-- Consulta la accion a realizar en caso de NO exigible
DECLARE Con_Sobrante			TINYINT;	-- Consulta la accion a realizar en caso de sobrante.



-- ASIGNACION DE CONSTANTES
SET Con_Principal			:= 1;



-- 1.- Consulta Principal
IF(Par_NumCon = Con_Principal) THEN
	SELECT
		ConsecutivoID,		TipoArchivo,		DescripcionArch,		PagoCredAutom,
		Exigible ,			Sobrante,			LecturaAutom,			RutaArchivos,
		TiempoLectura
	FROM PARAMDEPREFER
	WHERE ConsecutivoID = Par_ConsecutivoID;
END IF;


END TerminaStore$$
