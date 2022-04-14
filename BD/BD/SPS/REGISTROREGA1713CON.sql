-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROREGA1713CON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTROREGA1713CON`;DELIMITER $$

CREATE PROCEDURE `REGISTROREGA1713CON`(
	# ========== SP PARA CONSULTA DE REGULATORIO A1713 =============================================

	Par_Fecha               DATE,            		-- Fecha del Reporte
    Par_RegistroID	  		INT(11),			  	-- Consecutivo que identifica el registro
    Par_NumCon          	TINYINT UNSIGNED,   	-- Numero de consulta
	Par_EmpresaID			INT(11),				-- Auditoria

	Aud_Usuario				INT(11),				-- Auditoria
	Aud_FechaActual			DATETIME,				-- Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Auditoria
	Aud_Sucursal			INT(11),				-- Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Auditoria
		)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE	Con_Principal			INT;
	DECLARE	Con_Foranea				INT;

 -- Asignacion de constantes
    SET Cadena_Vacia                := '';              -- Cadena vacia
    SET Fecha_Vacia                 := '1900-01-01';    -- Fecha vacia
    SET Entero_Cero                 := 0;               -- Entero cero
    SET Con_Principal               := 1;               -- Consulta principal
    SET Con_Foranea                 := 2;               -- Consulta foranea

	IF(Par_NumCon = Con_Principal) THEN
	   SELECT	 Fecha,             RegistroID,         TipoMovimientoID,       NombreFuncionario,      RFC,
				 CURP,              Profesion,          Telefono,               Email,                  PaisID,
				 EstadoID,          MunicipioID,        LocalidadID,            ColoniaID,              CodigoPostal,
				 Calle,             NumeroExt,          NumeroInt,              FechaMovimiento,        FechaInicioGes,
				 FechaFinGestion,   OrganoID,           CargoID,                PermanenteID,           ManifestCumpID,
				CausaBajaID
			FROM REGISTROREGA1713
			WHERE RegistroID = Par_RegistroID
				  AND Fecha  = Par_Fecha;
	END IF;


END TerminaStore$$