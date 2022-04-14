-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSAPORTACIONESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSAPORTACIONESALT`;DELIMITER $$

CREATE PROCEDURE `PLAZOSAPORTACIONESALT`(
# ===================================================================
# ----------- SP PARA REGISTRAR LOS PLAZOS DE APORTACIONES ----------
# ===================================================================
	Par_TipoAportacionID	INT(11),		-- Numero del tipo de Aportacion
	Par_PlazosInferior		INT(11),		-- Plazo inferior
	Par_PlazosSuperior		INT(11),		-- Plazo superior

	Par_Salida				CHAR(1),		-- especifica salida
    INOUT Par_NumErr		INT(11),		-- INOUT NumErr
    INOUT Par_ErrMen		VARCHAR(400),	-- INOUT ErrMen

	Par_Empresa				INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de variables
	DECLARE Var_Control		VARCHAR(50);		-- Valor de control
	DECLARE Var_Consecutivo INT(11);			-- Valor consecutivo

    -- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE SalidaSI		CHAR(1);

    -- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;				-- Constante entero cero
	SET Aud_FechaActual		:= NOW();			-- Obtiene Fecha actual
	SET SalidaSI			:= 'S';				-- Salida si

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-PLAZOSAPORTACIONESALT');
			END;

		IF (IFNULL(Par_TipoAportacionID,Entero_Cero)) < Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Tipo de Aportacion esta vacio.';
			SET Var_Control	:= 'tipoAportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_PlazosInferior,Entero_Cero)) < Entero_Cero THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= 'El Monto Inferior esta vacio.';
			SET Var_Control	:= 'plazoInferior';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_PlazosSuperior,Entero_Cero)) < Entero_Cero THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= 'El Monto Superior esta vacio.';
			SET Var_Control	:= 'plazoSuperior';
			LEAVE ManejoErrores;
		END IF;


		INSERT PLAZOSAPORTACIONES VALUES (
			Par_TipoAportacionID, 	Par_PlazosInferior,		Par_PlazosSuperior,	Par_Empresa	,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr		:= 000;
        SET Par_ErrMen		:= "Rango(s) de Plazo(s) Agregado(s) Exitosamente.";
		SET Var_Control		:= 'tipoAportacionID';
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$