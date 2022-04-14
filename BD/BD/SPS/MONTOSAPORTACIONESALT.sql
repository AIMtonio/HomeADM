-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSAPORTACIONESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSAPORTACIONESALT`;DELIMITER $$

CREATE PROCEDURE `MONTOSAPORTACIONESALT`(
# ===================================================================
# ----------- SP PARA REGISTRAR LOS MONTOS DE APORTACIONES ----------
# ===================================================================
	Par_TipoAportacionID	INT(11),		-- ID del tipo de aportacion
	Par_MontoInferior		DECIMAL(18,2),	-- Monto inferior
	Par_MontoSuperior		DECIMAL(18,2),	-- Monto superior

	Par_Salida				CHAR(1),		-- Especifica salida
    INOUT Par_NumErr		INT(11),		-- Numero de error
    INOUT Par_ErrMen		VARCHAR(400),	-- mensaje de error

	Par_Empresa				INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN

    -- Declaracion de variables
	DECLARE	Var_MontoID		INT(11);		-- Id para identificar el monto de la aportacion
	DECLARE Var_Control		VARCHAR(50);	-- variable de control
	DECLARE Var_Consecutivo INT(11);		-- Consecutivo

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
    DECLARE SalidaSI		CHAR(1);

    -- Asignacion de constantes
	SET	Cadena_Vacia		:= '';			-- cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';-- Fecha vacia
	SET	Entero_Cero			:= 0;			-- Entero cero
    SET SalidaSI			:= 'S';			-- Indica salida
	SET Var_MontoID			:= 0;			-- Asigna cero al id del monto
	SET Aud_FechaActual		:= NOW();		-- Almacena la fecha actual.

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-MONTOSAPORTACIONESALT');
			END;


		IF (IFNULL(Par_TipoAportacionID,Entero_Cero)) < Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Tipo de Aportacion esta vacio.';
			SET Var_Control	:= 'plazoInferior';
			LEAVE ManejoErrores;
		END IF;


		IF (IFNULL(Par_MontoInferior,Entero_Cero)) < Entero_Cero THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= 'El Monto Inferior esta vacio.';
			SET Var_Control	:= 'plazoInferior';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_MontoSuperior,Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= 'El Monto Superior esta vacio.';
			SET Var_Control	:= 'plazoSuperior';
			LEAVE ManejoErrores;
		END IF;



		INSERT MONTOSAPORTACIONES VALUES (
			Par_TipoAportacionID, Par_MontoInferior,		Par_MontoSuperior,	Par_Empresa	,	Aud_Usuario,
			Aud_FechaActual,Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr		:= 000;
        SET Par_ErrMen		:= "Rangos de Montos Agregados Exitosamente";
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