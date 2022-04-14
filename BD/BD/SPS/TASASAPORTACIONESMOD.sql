-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAPORTACIONESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAPORTACIONESMOD`;DELIMITER $$

CREATE PROCEDURE `TASASAPORTACIONESMOD`(
# =========================================================================
# ----------- SP PARA MODIFICAR LAS TASAS DE APORTACIONES -----------------
# =========================================================================
	Par_TasaAportacionID	INT(11),		-- ID de la tasa de Aportacion
	Par_TipoAportacionID	INT(11),		-- ID del tipo de Aportacion
	Par_MontoInferior		DECIMAL(18,2),	-- Monto inferior
	Par_MontoSuperior		DECIMAL(18,2),	-- Monto superior
	Par_PlazoInferior		INT(11),		-- Plazo inferior

	Par_PlazoSuperior		INT(11),		-- Plazo superior
	Par_Calificacion		CHAR(1),		-- Calificacion asignada a la tasa
	Par_TasaFija			DECIMAL(12,4),	-- Tasa fija
	Par_TasaBase			INT(1),			-- Tasa base
	Par_SobreTasa			DECIMAL(12,4),	-- Sobretasa

	Par_PisoTasa			DECIMAL(12,4),	-- Piso de la tasa
	Par_TechoTasa			DECIMAL(12,4),	-- Techo de la tasa
	Par_CalculoInteres		INT(11),		-- Calculo de interes

	Par_Salida				CHAR(1),		-- Especifica salida
	INOUT	Par_NumErr 		INT(11),		-- Numero de error
	INOUT	Par_ErrMen  	VARCHAR(400),	-- Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario         	INT(11),		-- Parametro de auditoria
	Aud_FechaActual     	DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal        	INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion  	BIGINT(20)		-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_TasaAportacionID	INT(11);	-- Almacena el ID de la tasa
	DECLARE Var_TipoAportacionID	INT(11);	-- Almacena el tipo de aportacion

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE SalidaSI			CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';		-- Cadena vacia
	SET Entero_Cero				:=  0;		-- Cadena vacia
	SET Decimal_Cero			:= 0.0;		-- Decimal cero
	SET SalidaSI				:= 'S';		-- Indica salida

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TASASAPORTACIONESMOD');
			END;



		IF IFNULL(Par_TipoAportacionID,Entero_Cero)= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Tipo de Aportacion esta Vacio.';
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_MontoInferior,Decimal_Cero) = Decimal_Cero THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= 'El Monto Inferior esta Vacio.';
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_MontoSuperior,Decimal_Cero) = Decimal_Cero THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= 'El Monto Superior esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_PlazoInferior,Entero_Cero) = Entero_Cero THEN
			SET	Par_NumErr 	:= 4;
			SET	Par_ErrMen	:= 'El Plazo Inferior esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_PlazoSuperior,Entero_Cero) = Entero_Cero THEN
			SET	Par_NumErr 	:= 5;
			SET	Par_ErrMen	:= 'El Plazo Superior esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Calificacion,Cadena_Vacia) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 6;
			SET	Par_ErrMen	:= 'La Calificacion esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		SELECT TipoAportacionID INTO Var_TipoAportacionID
			FROM TIPOSAPORTACIONES WHERE TipoAportacionID = Par_TipoAportacionID;

		SET Var_TipoAportacionID := IFNULL(Var_TipoAportacionID,Entero_Cero);

		IF Var_TipoAportacionID=Entero_Cero THEN
			SET	Par_NumErr 	:= 8;
			SET	Par_ErrMen	:= 'El Tipo de Aportacion no existe.';
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := NOW();

		UPDATE  TASASAPORTACIONES SET
				MontoInferior	= Par_MontoInferior,
				MontoSuperior	= Par_MontoSuperior,
				PlazoInferior	= Par_PlazoInferior,
				PlazoSuperior	= Par_PlazoSuperior,
				TasaFija		= Par_TasaFija,
				TasaBase		= Par_TasaBase,
				SobreTasa		= Par_SobreTasa,
				PisoTasa		= Par_PisoTasa,
				TechoTasa		= Par_TechoTasa,
				CalculoInteres	= Par_CalculoInteres,
				Calificacion	= Par_Calificacion,
				EmpresaID		= Par_EmpresaID,
				UsuarioID		= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
		WHERE 	TipoAportacionID 	= Par_TipoAportacionID
        AND 	TasaAportacionID	= Par_TasaAportacionID;

		DELETE FROM TASAAPORTSUCURSALES WHERE TasaAportacionID = Par_TasaAportacionID AND TipoAportacionID = Par_TipoAportacionID;

		SET	Par_NumErr 	:= 0;
		SET	Par_ErrMen	:= CONCAT('Tasa Modificada Exitosamente: ',CONVERT(Par_TasaAportacionID,CHAR));


	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'tasaAportacionID' AS control,
				Par_TasaAportacionID AS consecutivo;
	END IF;
END  TerminaStore$$