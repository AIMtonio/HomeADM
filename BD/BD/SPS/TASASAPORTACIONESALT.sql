-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAPORTACIONESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAPORTACIONESALT`;DELIMITER $$

CREATE PROCEDURE `TASASAPORTACIONESALT`(
# =========================================================================
# ----------- SP PARA REGISTRAR LAS TASAS DE APORTACIONES -----------------
# =========================================================================
	Par_TipoAportacionID	INT(11),		-- ID del tipo de aportacion
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
	Par_Validacion			CHAR(1),		-- Si requiere validacion

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
	-- Declaracion de variables
	DECLARE Var_TasaAportacionID	INT(11);		-- Utilizada para almacenar el ID de la tasa
	DECLARE Var_TipoAportacionID	INT(11);		-- Almacena el ID del tipo de aportacion
	DECLARE Var_Control				VARCHAR(30);	-- Control
	DECLARE Var_ExisteTasa			INT(11);		-- Tasa existente
	DECLARE Var_Consecutivo 		INT(11);		-- Numero consecutivo

    -- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE SalidaSI			CHAR(1);

    -- Asginacion de constantes
	SET Cadena_Vacia			:= '';			-- Cadena vacia
	SET Entero_Cero				:=  0;			-- Entero cero
	SET Decimal_Cero			:= 0.0;			-- Decimal cero
	SET SalidaSI				:= 'S';			-- Indica salida

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TASASAPORTACIONESALT');
			END;

		SET Var_Consecutivo	:= Entero_Cero;

		IF IFNULL(Par_TipoAportacionID,Entero_Cero)= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Tipo de Aportacion esta Vacio.';
			SET Var_Control	:= 'tipoAportacionID';
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_MontoInferior,Decimal_Cero) = Decimal_Cero THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= 'El Monto Inferior esta Vacio.';
			SET Var_Control	:= 'montoID';
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_MontoSuperior,Decimal_Cero) = Decimal_Cero THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= 'El Monto Superior esta Vacio.';
			SET Var_Control	:= 'montoID';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_PlazoInferior,Entero_Cero) = Entero_Cero THEN
			SET	Par_NumErr 	:= 4;
			SET	Par_ErrMen	:= 'El Plazo Inferior esta Vacio.';
			SET Var_Control	:= 'plazoID';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_PlazoSuperior,Entero_Cero) = Entero_Cero THEN
			SET	Par_NumErr 	:= 5;
			SET	Par_ErrMen	:= 'El Plazo Superior esta Vacio.';
			SET Var_Control	:= 'plazoID';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Calificacion,Cadena_Vacia) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 6;
			SET	Par_ErrMen	:= 'La Calificacion esta Vacia.';
			SET Var_Control	:= 'calificacion';
			LEAVE ManejoErrores;
		END IF;

		SELECT TipoAportacionID INTO Var_TipoAportacionID
			FROM TIPOSAPORTACIONES
			WHERE TipoAportacionID	= Par_TipoAportacionID;

		SET Var_TipoAportacionID := IFNULL(Var_TipoAportacionID,Entero_Cero);

		IF Var_TipoAportacionID=Entero_Cero THEN
			SET	Par_NumErr 	:= 8;
			SET	Par_ErrMen	:= 'El Tipo de Aportacion no existe.';
			SET Var_Control	:= 'tipoAportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Validacion,Cadena_Vacia)<>Cadena_Vacia THEN
			IF (Par_Validacion ="N") THEN
				SELECT TasaAportacionID INTO Var_ExisteTasa
					FROM	TASASAPORTACIONES
					WHERE 	TipoAportacionID	= Par_TipoAportacionID
					AND   	MontoInferior		= Par_MontoInferior
					AND   	MontoSuperior		= Par_MontoSuperior
					AND   	PlazoInferior		= Par_PlazoInferior
					AND   	PlazoSuperior		= Par_PlazoSuperior
					AND   	Calificacion		= Par_Calificacion;

				IF IFNULL(Var_ExisteTasa,Entero_Cero)<>Entero_Cero THEN
					SET	Par_NumErr 	:= 9;
					SET	Par_ErrMen	:= CONCAT('Ya Existe un Esquema de Tasa con las Caracteristicas Seleccionadas: ',CONVERT(Var_ExisteTasa,CHAR));
					SET Var_Control	:= 'tasaAportacionID';
					SET Var_Consecutivo :=Var_ExisteTasa;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;


		SELECT MAX(TasaAportacionID) INTO Var_TasaAportacionID FROM TASASAPORTACIONES;
		SET Var_TasaAportacionID 	:= IFNULL(Var_TasaAportacionID,Entero_Cero) +1;
		SET Aud_FechaActual := NOW();

		INSERT INTO TASASAPORTACIONES(
			TasaAportacionID,	TipoAportacionID,	MontoInferior,		MontoSuperior,		PlazoInferior,
			PlazoSuperior,		Calificacion,	  	TasaFija,			TasaBase,			SobreTasa,
            PisoTasa,			TechoTasa,			CalculoInteres,	 	EmpresaID,			UsuarioID,
            FechaActual,      	DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
			Var_TasaAportacionID,	Par_TipoAportacionID,   Par_MontoInferior,  Par_MontoSuperior,	Par_PlazoInferior,
			Par_PlazoSuperior,		Par_Calificacion, 		Par_TasaFija, 		Par_TasaBase,		Par_SobreTasa,
            Par_PisoTasa,       	Par_TechoTasa,			Par_CalculoInteres,	Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		SET	Par_NumErr 	:= 0;
		SET	Par_ErrMen	:= CONCAT('Tasa Agregada Exitosamente: ',CONVERT(Var_TasaAportacionID,CHAR));
		SET Var_Control	:= 'tasaAportacionID';
		SET Var_Consecutivo:=Var_TasaAportacionID;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;

	END IF;

END  TerminaStore$$