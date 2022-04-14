-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUTFONDEOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUTFONDEOCON`;DELIMITER $$

CREATE PROCEDURE `INSTITUTFONDEOCON`(
# =====================================================================
# ----- STORE QUE REALIZA CONSULTA DE INSTITUCIONES DE FONDEO------
# =====================================================================
	Par_InstFondID		INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	/* Declaracion de Constantes */
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE EstadoActivo	CHAR(1);
	DECLARE	Con_Principal	INT;
	DECLARE	Con_Foranea		INT;
	DECLARE Con_Institucion	INT;

	/* Asignacion de Constantes */
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Con_Principal	:= 1;
	SET	Con_Foranea		:= 2;
	SET Con_Institucion := 3;
	SET EstadoActivo    := 'A';

	IF(Par_NumCon = Con_Principal) THEN
		SELECT  InstitutFondID, 	TipoFondeador,		CobraISR,			NombreInstitFon,    RazonSocInstFo,
				Estatus ,			InstitucionID,		ClienteID,			NumCtaInstit,	    CuentaClabe,
				NombreTitular,		IDInstitucion,  	CentroCostos,		RFC,	 			EstadoID,
				MunicipioID, 		LocalidadID, 		ColoniaID, 			Calle, 				NumeroCasa,
				NumInterior, 		Piso, 				PrimeraEntreCalle, 	SegundaEntreCalle, 	CP,
				DireccionCompleta,	RepresentanteLegal,	CapturaIndica
		FROM INSTITUTFONDEO
			WHERE   InstitutFondID  = Par_InstFondID;
	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT IFN.InstitutFondID, IFN.NombreInstitFon, INS.TipoInstitID, TI.Descripcion, TI.NacionalidadIns,
				IFN.TipoFondeador,
			CASE TI.NacionalidadIns WHEN 'E' THEN 'EXTRANJERA'
				WHEN 'N' THEN 'NACIONAL'
                ELSE Cadena_Vacia END AS DescripNac, CobraISR,
			CapturaIndica
		FROM INSTITUTFONDEO IFN
				 LEFT OUTER JOIN INSTITUCIONES INS ON IFN.InstitucionID 	= INS.InstitucionID
				 LEFT OUTER JOIN TIPOSINSTITUCION TI ON  INS.TipoInstitID	= TI.TipoInstitID
			WHERE  IFN.InstitutFondID	= Par_InstFondID;
	END IF;

	IF(Par_NumCon = Con_Institucion) THEN
		SELECT	InstitutFondID,	NombreInstitFon
			FROM INSTITUTFONDEO
				WHERE Estatus = EstadoActivo;
	END IF;

END TerminaStore$$