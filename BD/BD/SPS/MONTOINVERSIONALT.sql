-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOINVERSIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOINVERSIONALT`;
DELIMITER $$


CREATE PROCEDURE `MONTOINVERSIONALT`(
	Par_TipoInversion		INT,
	Par_MontoInferior		DECIMAL(12,2),
	Par_MontoSuperior		DECIMAL(12,2),
	Par_Empresa				INT,

	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)

TerminaStore: BEGIN

	DECLARE	Var_MontoID				INT;
    DECLARE Var_EstatusTipoInver	CHAR(2);			-- Estatus del Tipo Inversion
	DECLARE Var_Descripcion			VARCHAR(45);		-- Descripcion Tipo Inversion

	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
    DECLARE Estatus_Inactivo    	CHAR(1); 			-- Estatus Inactivo

	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;

	SET Var_MontoID			:= 0;
    SET Estatus_Inactivo	:= 'I';

	SET Aud_FechaActual		:= NOW();

    SELECT 	Estatus,				Descripcion
	INTO	Var_EstatusTipoInver,	Var_Descripcion
	FROM  CATINVERSION
	WHERE TipoInversionID  = Par_TipoInversion;

	IF(IFNULL(Par_MontoInferior, Entero_Cero)) < Entero_Cero THEN
		SELECT '001' AS NumErr,
			 'El inferior esta vacio.' AS ErrMen,
			 'plazoInferior' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_MontoSuperior, Entero_Cero)) = Entero_Cero THEN
		SELECT '002' AS NumErr,
			 'El superior esta vacio.' AS ErrMen,
			 'plazoSuperior' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(Var_EstatusTipoInver = Estatus_Inactivo) THEN
		SELECT '003' AS NumErr,
			 CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
			 'tipoInversionID' AS control;
		LEAVE TerminaStore;
	END IF;

	SET Var_MontoID := (SELECT IFNULL(MAX(MontoInversionID),Entero_Cero) + 1
					FROM MONTOINVERSION);

	INSERT MONTOINVERSION VALUES (
		Var_MontoID, 	Par_TipoInversion,	Par_MontoInferior,	Par_MontoSuperior,	Par_Empresa	,
		Aud_Usuario	,	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion	);

	SELECT '000' AS NumErr,
	  CONCAT("Se agrego satisfactoriamente: ", CONVERT(Var_MontoID, CHAR))  AS ErrMen,
	  'tipoInversionID' AS control;


END TerminaStore$$