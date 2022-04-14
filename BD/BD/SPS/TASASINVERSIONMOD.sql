-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASINVERSIONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASINVERSIONMOD`;
DELIMITER $$


CREATE PROCEDURE `TASASINVERSIONMOD`(
	Par_TasaInversionID		INT,
	Par_TipoInversion		INT,
	Par_DiaInversion		INT,
	Par_MontoInversion		INT,
	Par_ConceptoInvercion	FLOAT,
	Par_GatInformativo		DECIMAL(12,2),
	Par_EmpresaID			INT,

	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion	BIGINT

	)

TerminaStore: BEGIN

	DECLARE Var_DiaInferior			INT;
	DECLARE Var_DiaSuperior			INT;
	DECLARE Var_MontoInferior		FLOAT;
	DECLARE Var_MontoSuperior		FLOAT;
	DECLARE Var_EstatusTipoInver	CHAR(2);			-- Estatus del Tipo Inversion
	DECLARE Var_Descripcion			VARCHAR(45);		-- Descripcion Tipo Inversion


	DECLARE Var_Cero	INT;
	DECLARE Var_Num		INT;
	DECLARE Estatus_Inactivo    	CHAR(1); 			-- Estatus Inactivo


	SET Var_Cero	:=0;
	SET Var_Num		:=0;
    SET Estatus_Inactivo	:= 'I';

	SET Aud_FechaActual	:=NOW();

    SELECT 	Estatus,				Descripcion
	INTO	Var_EstatusTipoInver,	Var_Descripcion
	FROM  CATINVERSION
	WHERE TipoInversionID  = Par_TipoInversion;

	IF(IFNULL(Par_ConceptoInvercion, Var_Cero)) = Var_Cero THEN
		SELECT '001' AS NumErr,
			  'La Tasa Anualizada esta en cero' AS ErrMen,
			  'conceptoInversion' AS control,
              Par_TipoInversion AS consecutivo;
		LEAVE TerminaStore;
	END IF;

    IF(Var_EstatusTipoInver = Estatus_Inactivo) THEN
		SELECT '002' AS NumErr,
			  CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
			  'tipoInvercionID' AS control,
			Par_TipoInversion AS consecutivo;
		LEAVE TerminaStore;
	END IF;


	SELECT	Dia.PlazoInferior, Dia.PlazoSuperior, Mon.PlazoInferior, Mon.PlazoSuperior
    INTO
			Var_DiaInferior, Var_DiaSuperior, Var_MontoInferior, Var_MontoSuperior
	FROM  	DIASINVERSION Dia,
			MONTOINVERSION Mon
	WHERE Dia.DiaInversionID	= Par_DiaInversion
	AND	Dia.TipoInversionID	= Par_TipoInversion
	AND	Mon.MontoInversionID	= Par_MontoInversion
	AND	Mon.TipoInversionID	= Par_TipoInversion;

INSERT `HIS-TASASINVERSION` VALUES(
	Aud_FechaActual,		Par_TipoInversion,	Var_DiaInferior, Var_DiaSuperior, Var_MontoInferior,
	Var_MontoSuperior,		Par_ConceptoInvercion,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


UPDATE TASASINVERSION  SET
	ConceptoInversion 	=  Par_ConceptoInvercion,
	FechaActualizacion 	= (SELECT NOW()),
	GatInformativo 		= Par_GatInformativo,
	Usuario			= Aud_Usuario,
	FechaActual 	= Aud_FechaActual,
	DireccionIP 	= Aud_DireccionIP,
	ProgramaID  	= Aud_ProgramaID,
	Sucursal		= Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion

	WHERE TipoInversionID = Par_TipoInversion
	  AND DiaInversionID = Par_DiaInversion
	  AND MontoInversionID = Par_MontoInversion
	  AND TasaInversionID = Par_TasaInversionID;

SELECT '000' AS NumErr,
	  CONCAT("Tasa Modificada Exitosamente: ", CONVERT(Par_TipoInversion, CHAR))  AS ErrMen,
	  'tipoInvercionID' AS control,
	  Par_TipoInversion  AS consecutivo;

END TerminaStore$$