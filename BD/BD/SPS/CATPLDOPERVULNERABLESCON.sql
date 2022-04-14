-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATPLDOPERVULNERABLESCON`;
DELIMITER $$


CREATE PROCEDURE `CATPLDOPERVULNERABLESCON`(
# ==============================================================================================
# ------- STORED DE CONSULTA DE DATOS DE LAS INSTITUCIONES PLD OPERACIONES VULNERABLES ---------
# ==============================================================================================
	Par_InstitucionID		INT,			-- ID de la institucion
	Par_NumCon				TINYINT UNSIGNED,-- Numero de consulta

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Con_Principal		INT(11);


	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Con_Principal		:= 1;
	
	-- Consulta 1
	IF(Par_NumCon = Con_Principal) THEN

		SELECT 	InstitucionID,					ClaveEntidadColegiada,			ClaveSujetoObligado,
				ClaveActividad,					Exento,							DominioPlataforma,
				ReferenciaAviso,				Prioridad,						FolioModificacion,
				DescripcionModificacion,		TipoAlerta,						DescripcionAlerta,
				RutaArchivo
		FROM CATPLDOPERVULNERABLES
		WHERE  InstitucionID = Par_InstitucionID;

	END IF;

	

END TerminaStore$$

