-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGI039100006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGI039100006REP`;DELIMITER $$

CREATE PROCEDURE `REGI039100006REP`(
/************************************************************************
--- -- -- -- GENERA EL REGULATORIO I0391 SOCAP ---- -- -- --          --
************************************************************************/
    Par_Anio            INT,	-- Ano del reporte
    Par_Mes             INT, 	-- Mes del reporte
    Par_TipoInstitucion INT, 	-- Tipo de Institucion
	Par_NumLis		    TINYINT UNSIGNED, 	-- Tipo de reporte

	Aud_Empresa		    INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN
DECLARE Principal 		INT;
DECLARE Rep_Excel     	INT;
DECLARE Rep_CSV      	INT;
DECLARE Men_Institu		INT;
DECLARE Men_ClasfCre	INT;
DECLARE Men_FormaAdq	INT;
DECLARE Men_GrupRies 	INT;
DECLARE Men_TipIntru 	INT;

SET Principal    	:= 1; 	-- Para llenar el grid de la pantalla de captura
SET Rep_Excel		:= 2; 	-- Para el reporte en formato Excel
SET Rep_CSV         := 3; 	-- Para el reporte en formato CSV
SET Men_Institu		:= 1; 	-- ID del Menu Instituciones
SET Men_ClasfCre	:= 2; 	-- Id del menu clasificacion credito
SET Men_FormaAdq	:= 3;   -- id del menu forma adquisicion
SET Men_GrupRies	:= 4; 	-- id del menu grupo de riesgo
SET Men_TipIntru	:= 5; 	-- id del tipo de instrumento

IF(Par_NumLis = Principal) THEN
	SELECT
    Anio, 			Mes, 			ClaveEntidad, 		Subreporte, 		Entidad,
    Emisora, 		Serie, 			FormaAdqui, 		TipoInstru, 		ClasfConta,
    FechaContra,	FechaVencim,	NumeroTitu, 		CostoAdqui, 		TasaInteres AS TasaInteres,
    GrupoRiesgo, 	Valuacion, 		ResValuacion,		TipoValorID,		TipoInversion,
    TipoInstitucionID
    FROM `HIS-REGULATORIOI0391` WHERE Anio = Par_Anio AND Mes = Par_mes AND TipoInstitucionID = Par_TipoInstitucion;
END IF;


IF(Par_NumLis = Rep_Excel) THEN

    DROP TABLE IF EXISTS TMP_CASLFCREDITO;
	CREATE TEMPORARY TABLE TMP_CASLFCREDITO(
		ClasfCreditoID 		VARCHAR(50),
        Descripcion			VARCHAR(250)
    );

    INSERT INTO TMP_CASLFCREDITO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = Men_ClasfCre;

    DROP TABLE IF EXISTS TMP_FORMAADQUI;
	CREATE TEMPORARY TABLE TMP_FORMAADQUI(
		FormaAdquiID 		VARCHAR(50),
        Descripcion			VARCHAR(250)
    );

    INSERT INTO TMP_FORMAADQUI SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = Men_FormaAdq;

    DROP TABLE IF EXISTS TMP_GRUPORIESG;
	CREATE TEMPORARY TABLE TMP_GRUPORIESG(
		GrupoRiesgID 		VARCHAR(50),
        Descripcion			VARCHAR(250)
    );

    INSERT INTO TMP_GRUPORIESG SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = Men_GrupRies;

    DROP TABLE IF EXISTS TMP_TIPOINSTRU;
	CREATE TEMPORARY TABLE TMP_TIPOINSTRU(
		TipoInstruID 		VARCHAR(50),
        Descripcion			VARCHAR(250)
    );

    INSERT INTO TMP_TIPOINSTRU SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = Men_TipIntru;


	SELECT
    His.Periodo,		His.ClaveEntidad, 				His.Subreporte, 					Ent.Descripcion AS Entidad, 				His.Emisora,
    His.Serie, 			Foa.Descripcion AS FormaAdqui, 	Tip.Descripcion AS TipoInstru, 		Cla.Descripcion AS ClasfConta, 				His.FechaContra,
    His.FechaVencim, 	His.NumeroTitu, 				His.CostoAdqui, 					His.TasaInteres AS TasaInteres, 			Gru.Descripcion AS GrupoRiesgo,
    His.Valuacion, 		His.ResValuacion
    FROM `HIS-REGULATORIOI0391` His 			INNER JOIN TMP_CASLFCREDITO Cla
    ON His.ClasfConta 	= Cla.ClasfCreditoID 	INNER JOIN TMP_FORMAADQUI Foa
    ON His.FormaAdqui 	= Foa.FormaAdquiID 		INNER JOIN TMP_GRUPORIESG Gru
    ON His.GrupoRiesgo 	= Gru.GrupoRiesgID 		INNER JOIN TMP_TIPOINSTRU Tip
    ON His.TipoInstru 	= Tip.TipoInstruID 		INNER JOIN OPCIONESMENUREG Ent
    ON His.Entidad    	= Ent.CodigoOpcion
    WHERE His.Anio = Par_Anio AND His.Mes = Par_mes AND Ent.MenuID = Men_Institu
    AND His.TipoInstitucionID = Par_TipoInstitucion
    ORDER BY His.Consecutivo;
END IF;

IF(Par_NumLis = Rep_CSV) THEN
	SELECT CONCAT(
    His.Subreporte,';', 		His.Entidad,';', 				His.Emisora,';',				His.Serie,';', 				His.FormaAdqui,';',
    His.TipoInstru,';', 		His.ClasfConta,';', 			His.FechaContra,';',		    His.FechaVencim,';',	    His.NumeroTitu,';',
    His.CostoAdqui,';', 			His.TasaInteres,';', 		His.GrupoRiesgo,';', 		    His.Valuacion,';',
    His.ResValuacion) AS Renglon
    FROM `HIS-REGULATORIOI0391` His
	WHERE His.Anio = Par_Anio AND His.Mes = Par_mes
    AND  His.TipoInstitucionID = Par_TipoInstitucion
    ORDER BY Consecutivo;
END IF;


END TerminaStore$$