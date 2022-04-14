-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASCEDESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASCEDESALT`;
DELIMITER $$


CREATE PROCEDURE `TASASCEDESALT`(
# =================================================================
# ----------- SP PARA REGISTRAR LAS TASAS DE CEDES-----------------
# =================================================================
	Par_TipoCedeID			INT(11),
	Par_MontoInferior		DECIMAL(18,2),
	Par_MontoSuperior		DECIMAL(18,2),
	Par_PlazoInferior		INT(11),
	Par_PlazoSuperior		INT(11),

	Par_Calificacion		CHAR(1),
	Par_TasaFija			DECIMAL(12,4),
	Par_TasaBase			INT(1),
	Par_SobreTasa			DECIMAL(12,4),
	Par_PisoTasa			DECIMAL(12,4),

	Par_TechoTasa			DECIMAL(12,4),
	Par_CalculoInteres		INT(11),
	Par_Validacion			CHAR(1),

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)

TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_TasaCedeID			INT(11);
	DECLARE Var_TipoCedeID			INT(11);
	DECLARE Var_Control				VARCHAR(30);
	DECLARE Var_ExisteTasa			INT(11);
	DECLARE Var_Consecutivo 		INT(11);
    DECLARE Var_EstatusTipoCede		CHAR(2);					-- Estatus del Tipo Cede
	DECLARE Var_Descripcion			VARCHAR(200);				-- Descripcion Tipo Cede


    -- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE SalidaSI				CHAR(1);
    DECLARE Estatus_Inactivo		CHAR(1);					-- Estatus Inactivo


    -- Asginacion de constantes
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:=  0;
	SET Decimal_Cero			:= 0.0;
	SET SalidaSI				:= 'S';
    SET Estatus_Inactivo		:= 'I';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TASASCEDESALT');
			END;

		SET Var_Consecutivo	:= Entero_Cero;

		IF IFNULL(Par_TipoCedeID,Entero_Cero)= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Tipo de CEDES esta Vacio.';
			SET Var_Control	:= 'tipoCedeID';
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

		SELECT 	TipoCedeID,		Estatus,				Descripcion
		INTO 	Var_TipoCedeID,	Var_EstatusTipoCede,	Var_Descripcion
			FROM TIPOSCEDES
			WHERE TipoCedeID	= Par_TipoCedeID;

		SET Var_TipoCedeID := IFNULL(Var_TipoCedeID,Entero_Cero);

		IF Var_TipoCedeID=Entero_Cero THEN
			SET	Par_NumErr 	:= 8;
			SET	Par_ErrMen	:= 'El Tipo de CEDES no existe.';
			SET Var_Control	:= 'tipoCedeID';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Validacion,Cadena_Vacia)<>Cadena_Vacia THEN
			IF (Par_Validacion ="N") THEN
				SELECT TasaCedeID INTO Var_ExisteTasa
					FROM	TASASCEDES
					WHERE 	TipoCedeID		= Par_TipoCedeID
					AND   	MontoInferior	= Par_MontoInferior
					AND   	MontoSuperior	= Par_MontoSuperior
					AND   	PlazoInferior	= Par_PlazoInferior
					AND   	PlazoSuperior	= Par_PlazoSuperior
					AND   	Calificacion	= Par_Calificacion;

				IF IFNULL(Var_ExisteTasa,Entero_Cero)<>Entero_Cero THEN
					SET	Par_NumErr 	:= 9;
					SET	Par_ErrMen	:= CONCAT('Ya Existe un Esquema de Tasa con las Caracteristicas Seleccionadas: ',CONVERT(Var_ExisteTasa,CHAR));
					SET Var_Control	:= 'tasaCedeID';
					SET Var_Consecutivo :=Var_ExisteTasa;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

        IF(Var_EstatusTipoCede = Estatus_Inactivo) THEN
			SET Par_NumErr	:=	010;
			SET Par_ErrMen	:=	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control	:=	'tipoCedeID';
			LEAVE ManejoErrores;
		END IF;

		SELECT MAX(TasaCedeID) INTO Var_TasaCedeID FROM TASASCEDES;
		SET Var_TasaCedeID 	:= IFNULL(Var_TasaCedeID,Entero_Cero) +1;
		SET Aud_FechaActual := NOW();

		INSERT INTO TASASCEDES(
			TasaCedeID,			TipoCedeID,		 	MontoInferior,		MontoSuperior,		PlazoInferior,
			PlazoSuperior,		Calificacion,	  	TasaFija,			TasaBase,			SobreTasa,
            PisoTasa,			TechoTasa,			CalculoInteres,	 	EmpresaID,			UsuarioID,
            FechaActual,      	DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
			Var_TasaCedeID,		Par_TipoCedeID,   	Par_MontoInferior,  Par_MontoSuperior,	Par_PlazoInferior,
			Par_PlazoSuperior,	Par_Calificacion, 	Par_TasaFija, 		Par_TasaBase,		Par_SobreTasa,
            Par_PisoTasa,       Par_TechoTasa,		Par_CalculoInteres,	Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		SET	Par_NumErr 	:= 0;
		SET	Par_ErrMen	:= CONCAT('Tasa Agregada Exitosamente: ',CONVERT(Var_TasaCedeID,CHAR));
		SET Var_Control	:= 'tasaCedeID';
		SET Var_Consecutivo:=Var_TasaCedeID;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;

	END IF;

END  TerminaStore$$