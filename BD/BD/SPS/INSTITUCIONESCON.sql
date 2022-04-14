-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUCIONESCON`;
DELIMITER $$


CREATE PROCEDURE `INSTITUCIONESCON`(
# =====================================================
# ------- STORED DE CONSULTA DE INSTITUCIONES ---------
# =====================================================
	Par_InstitucionID		INT,			-- ID de la institucion
	Par_NumCon				TINYINT UNSIGNED,-- numero de consulta

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
	DECLARE	Con_Foranea			INT(11);

	DECLARE Con_Folio        	INT(11);
	DECLARE Con_ParticipaSpei 	INT(11);

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Con_Principal		:= 1;
	SET	Con_Foranea			:= 2;

	SET Con_Folio       	:= 3;
	SET Con_ParticipaSpei 	:= 4;

	-- Consulta 1
	IF(Par_NumCon = Con_Principal) THEN

		SELECT	InstitucionID,	EmpresaID,			Nombre,			NombreCorto, 	TipoInstitID,
				Folio,			ClaveParticipaSpei,	Direccion,		GeneraRefeDep,	AlgoritmoID,
				NumConvenio,	ConvenioInter,		Domicilia,		NumContrato,	CveEmision
		FROM INSTITUCIONES
		WHERE  InstitucionID = Par_InstitucionID;

	END IF;

	-- Consulta 2
	IF(Par_NumCon = Con_Foranea) THEN

		SELECT	InstitucionID,	EmpresaID,	Nombre,	NombreCorto
		FROM INSTITUCIONES
		WHERE  InstitucionID = Par_InstitucionID;

	END IF;

	-- Consulta 3
	IF(Par_NumCon = Con_Folio) THEN

		SELECT 	Folio
		FROM INSTITUCIONES
		WHERE  Folio = Par_InstitucionID;

	END IF;

	-- Consulta 4
	IF(Par_NumCon = Con_ParticipaSpei) THEN

		SELECT	InstitucionID,	ClaveParticipaSpei, EmpresaID,	Nombre,	NombreCorto, Domicilia
		FROM INSTITUCIONES
		WHERE  ClaveParticipaSpei = Par_InstitucionID;

	END IF;

END TerminaStore$$
