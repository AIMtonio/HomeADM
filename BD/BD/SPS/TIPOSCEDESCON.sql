-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCEDESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCEDESCON`;
DELIMITER $$


CREATE PROCEDURE `TIPOSCEDESCON`(
# =================================================================
# ----------- SP PARA CONSULTAR LOS TIPOS DE CEDES-----------------
# =================================================================
	Par_TipoCedeID		INT(11), 			-- Cede a Consultar
	Par_TipoConsulta	TINYINT UNSIGNED,	-- Tipo de Consulta

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria

)

TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Con_Principal 	INT(11);
	DECLARE ConGeneral		INT(11);
	DECLARE Entero_Cero		INT(11);

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';				-- Constante Cadena Vacia
	SET Con_Principal 		:= 1;				-- Consulta Principal
	SET ConGeneral			:= 2;				-- Consulta General
	SET Entero_Cero			:= 0;				-- Valor Entero Cero


	IF(Par_TipoConsulta = Con_Principal) THEN

		SELECT 	Tip.TipoCedeID, 					Tip.Descripcion, 		Tip.FechaCreacion , 	Tip.TasaFV,
				Anclaje,	 						Tip.TasaMejorada,   	EspecificaTasa,			Mon.MonedaID,
				Mon.Descripcion AS DescripcionMon, 	DiaInhabil,	 			IFNULL(MontoMinimoAnclaje,Entero_Cero) AS MontoMinAnclaje,
                Estatus
			FROM	TIPOSCEDES Tip
					INNER JOIN MONEDAS Mon ON Mon.MonedaID	= Tip.MonedaID
			WHERE 	Tip.TipoCedeID = Par_TipoCedeID;
	END IF;

	IF(Par_TipoConsulta = ConGeneral)THEN
		SELECT TipoCedeID, 		 Descripcion,	     Reinversion,		Reinvertir,         FechaCreacion,
				TasaFV, 	     Anclaje,		     TasaMejorada,	    EspecificaTasa,	    MonedaID,
				MinimoApertura,	 MontoMinimoAnclaje, Genero,	    	EstadoCivil,	    MinimoEdad,
				MaximoEdad,	     IFNULL(ActividadEcon,Cadena_Vacia) AS ActividadEcon,		NumRegistroRECA,
                FechaInscripcion,NombreComercial,	  DiaInhabil,		TipoPagoInt,		DiasPeriodo,
                PagoIntCal,		ClaveCNBV,			  ClaveCNBVAmpCred,	Estatus
			FROM	TIPOSCEDES
			WHERE	TipoCedeID	= Par_TipoCedeID;
	END IF;

END TerminaStore$$