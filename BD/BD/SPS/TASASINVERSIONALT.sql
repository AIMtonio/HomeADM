-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASINVERSIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASINVERSIONALT`;
DELIMITER $$


CREATE PROCEDURE `TASASINVERSIONALT`(
	Par_TipoInversion		INT,
	Par_TipoInversionDia	INT,
	Par_TipoInversionMonto	INT,
	Par_ConceptoInversion	FLOAT,
	Par_GatInformativo		DECIMAL(12,2),
	Par_EmpresaID			INT,


	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)

TerminaStore: BEGIN

	DECLARE Var_DiaInferior			INT;
	DECLARE Var_DiaSuperior			INT;
	DECLARE Var_MontoInferior		FLOAT;
	DECLARE Var_MontoSuperior		FLOAT;
    DECLARE Var_EstatusTipoInver	CHAR(2);			-- Estatus del Tipo Inversion
	DECLARE Var_Descripcion			VARCHAR(45);		-- Descripcion Tipo Inversion


	DECLARE Var_Cero				INT;
	DECLARE Var_Cero_Flotante		FLOAT;
	DECLARE Var_TipoInversion 		INT;
	DECLARE Var_TipoInversionDia	INT;
	DECLARE Var_TipoInversionMonto	INT;
	DECLARE Var_ConceptoInversion	FLOAT;
	DECLARE Var_Num					INT;
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
    DECLARE Estatus_Inactivo    	CHAR(1); 			-- Estatus Inactivo


	SET Var_Cero				:= 0 ;
	SET Var_Cero_Flotante		:= 0.0;
	SET Var_TipoInversion 		:= 0 ;
	SET Var_TipoInversionDia	:= 0 ;
	SET Var_TipoInversionMonto	:= 0 ;
	SET Var_ConceptoInversion	:= 0 ;
	SET Var_Num					:= 0 ;
	SET Cadena_Vacia			:= "";
	SET Fecha_Vacia				:= "1900-01-01";
    SET Estatus_Inactivo		:= 'I';

	SET Aud_FechaActual	:=NOW();

    SELECT 	Estatus,				Descripcion
	INTO	Var_EstatusTipoInver,	Var_Descripcion
	FROM  CATINVERSION
	WHERE TipoInversionID  = Par_TipoInversion;

	IF(IFNULL(Par_TipoInversion, Var_Cero)) = Var_Cero THEN
		SELECT '001' AS NumErr,
			  'El tipo de Inversion esta vacio' AS ErrMen,
			  'tipoInvercionID' AS control,
              Par_TipoInversion  AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_TipoInversionDia, Var_Cero)) = Var_Cero THEN
		SELECT '002' AS NumErr,
			  'El dia esta vacio' AS ErrMen,
			  'diaInversionID' AS control,
              Par_TipoInversion  AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_TipoInversionMonto, Var_Cero)) = Var_Cero THEN
		SELECT '003' AS NumErr,
			  'El monto esta vacio' AS ErrMen,
			  'montoInversionID' AS control,
              Par_TipoInversion  AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_ConceptoInversion, Var_Cero_Flotante)) = Var_Cero_Flotante THEN
		SELECT '004' AS NumErr,
			  'El porcentaje esta en 0.0' AS ErrMen,
			  'conceptoInversion' AS control,
              Par_TipoInversion  AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_ConceptoInversion, Var_Cero)) = Var_Cero THEN
		SELECT '005' AS NumErr,
			  'El porcentaje esta en cero' AS ErrMen,
			  'conceptoInversion' AS control,
              Par_TipoInversion  AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(Var_EstatusTipoInver = Estatus_Inactivo) THEN
		SELECT '006' AS NumErr,
			 CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
			 'tipoInvercionID' AS control,
			  Par_TipoInversion  AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	SET Var_Num := (SELECT IFNULL(MAX(TasaInversionID),Var_Cero) + 1 FROM TASASINVERSION);

	INSERT INTO TASASINVERSION(
		TasaInversionID,	TipoInversionID,		DiaInversionID,		MontoInversionID,	ConceptoInversion,
		FechaCreacion,		FechaActualizacion, 	GatInformativo,		EmpresaID,			Usuario,
		FechaActual,		DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
	VALUES(
		Var_Num,			Par_TipoInversion,	Par_TipoInversionDia,	Par_TipoInversionMonto,	Par_ConceptoInversion,
		(SELECT NOW()),		Fecha_Vacia	, 		Par_GatInformativo,		Par_EmpresaID,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);


	SELECT	Dia.PlazoInferior, Dia.PlazoSuperior, Mon.PlazoInferior, Mon.PlazoSuperior INTO
					Var_DiaInferior, Var_DiaSuperior, Var_MontoInferior, Var_MontoSuperior
		FROM  DIASINVERSION Dia,
			MONTOINVERSION Mon
		WHERE Dia.DiaInversionID	= Par_TipoInversionDia
		  AND	Dia.TipoInversionID	= Par_TipoInversion
		  AND	Mon.MontoInversionID	= Par_TipoInversionMonto
		  AND	Mon.TipoInversionID	= Par_TipoInversion;

	INSERT `HIS-TASASINVERSION` VALUES(
		Aud_FechaActual,		Par_TipoInversion,	Var_DiaInferior, Var_DiaSuperior, Var_MontoInferior,
		Var_MontoSuperior,	Par_ConceptoInversion,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

SELECT '000' AS NumErr,
	  concat("Tasa Agregada Exitosamente: ", CONVERT(Var_Num, CHAR))  AS ErrMen,
	  'tipoInvercionID' AS control,
	  Par_TipoInversion  AS consecutivo;

END TerminaStore$$