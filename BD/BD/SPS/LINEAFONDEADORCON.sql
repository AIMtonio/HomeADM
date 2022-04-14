-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEAFONDEADORCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEAFONDEADORCON`;
DELIMITER $$


CREATE PROCEDURE `LINEAFONDEADORCON`(
/* SP DE CONSULTA LINEAS DE FONDEO */
	Par_LineaFondID		INT(11),
	Par_NumCon			TINYINT UNSIGNED,
    /* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

-- declaracion de  constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Con_Principal		INT;
DECLARE	Con_Foranea			INT;
DECLARE Con_RedesCuento 	INT;
DECLARE Con_CondiLineaFon	INT;

-- asignacion de  constantes
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Con_Principal			:= 1;
SET	Con_Foranea				:= 2;
SET	Con_RedesCuento 		:= 3;
SET	Con_CondiLineaFon 		:= 4;

-- Consulta Principal
IF(Par_NumCon = Con_Principal) THEN
	SELECT	LineaFondeoID,		InstitutFondID,	DescripLinea,		FechInicLinea,		FechaFinLinea,
			TipoLinFondeaID,	MontoOtorgado,	SaldoLinea,			TasaPasiva,			FactorMora,
			DiasGraciaMora,		PagoAutoVenci,	FechaMaxVenci,		CobraMoratorios,	CobraFaltaPago,
			DiasGraFaltaPag,	MontoComFalPag, EsRevolvente,		TipoRevolvencia,	InstitucionID,
			NumCtaInstit,		CuentaClabe,	AfectacionConta,	ReqIntegracion,		TipoCobroMora,
			FolioFondeo,		CalcInteresID,	TasaBase,			Refinancia,			MonedaID
			FROM 	LINEAFONDEADOR
		WHERE  	LineaFondeoID = Par_LineaFondID;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
	SELECT	LineaFondeoID,	descripLinea
		FROM LINEAFONDEADOR
		WHERE  LineaFondeoID = Par_LineaFondID;
END IF;

IF(Par_NumCon = Con_RedesCuento) THEN
	SELECT	LineaFondeoID,	DescripLinea, TipoLinFondeaID,	MontoOtorgado,	SaldoLinea,
			InstitutFondID,	InstitucionID, NumCtaInstit,	CuentaClabe
		FROM 	LINEAFONDEADOR
		WHERE  	LineaFondeoID = Par_LineaFondID;
END IF;

IF(Par_NumCon = Con_CondiLineaFon) THEN
	SELECT	LineaFondeoID,		InstitutFondID,	DescripLinea,		FechInicLinea,		FechaFinLinea,
			TipoLinFondeaID,	MontoOtorgado,	SaldoLinea,			FechaMaxVenci
		FROM 	LINEAFONDEADOR
		WHERE  	LineaFondeoID = Par_LineaFondID;
END IF;

END TerminaStore$$
