-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASINVERSIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASINVERSIONALT`;
DELIMITER $$


CREATE PROCEDURE `DIASINVERSIONALT`(
	Par_TipoInversion	INT,
	Par_PlazoInferior	INT,
	Par_PlazoSuperior	INT,
	Par_Empresa			INT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)

TerminaStore: BEGIN

	DECLARE	NumeDiaInversionID		INT;
	DECLARE	Entero_Cero				INT;
	DECLARE Estatus_Inactivo    	CHAR(1); 			-- Estatus Inactivo

	DECLARE Var_EstatusTipoInver		CHAR(2);		-- Estatus del Tipo Inversion
	DECLARE Var_Descripcion			VARCHAR(45);		-- Descripcion Tipo Inversion

	SET NumeDiaInversionID		:= 0;
	SET	Entero_Cero				:= 0;
    SET Estatus_Inactivo		:= 'I';

	SET Aud_FechaActual	:= NOW();

	SELECT 	Estatus,				Descripcion
	INTO	Var_EstatusTipoInver,	Var_Descripcion
	FROM  CATINVERSION
	WHERE TipoInversionID  = Par_TipoInversion;

	IF(IFNULL(Par_PlazoInferior, Entero_Cero)) = Entero_Cero THEN
		SELECT '001' AS NumErr,
			 'El inferior esta vacio.' AS ErrMen,
			 'plazoInferior' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_PlazoSuperior, Entero_Cero)) = Entero_Cero THEN
		SELECT '002' AS NumErr,
			 'El superior esta vacio.' AS ErrMen,
			 'plazoSuperior' AS control;
		LEAVE TerminaStore;
	END IF;

    IF(Var_EstatusTipoInver = Estatus_Inactivo) THEN
		SELECT '003' AS NumErr,
			 CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
			 'tipoInvercionID' AS control;
		LEAVE TerminaStore;
	END IF;

	SET NumeDiaInversionID := (SELECT IFNULL(MAX(DiaInversionID),Entero_Cero) + 1
						FROM DIASINVERSION);

	INSERT DIASINVERSION VALUES (
		NumeDiaInversionID,	Par_TipoInversion,	Par_PlazoInferior,	Par_PlazoSuperior, 	Par_Empresa,
		Aud_Usuario	,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);


	SELECT '000' AS NumErr,
		  CONCAT("Se agrego satisfactoriamente: ", CONVERT(NumeDiaInversionID, CHAR))  AS ErrMen,
		  'tipoInvercionID' AS control;

END TerminaStore$$