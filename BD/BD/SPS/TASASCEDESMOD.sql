-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASCEDESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASCEDESMOD`;
DELIMITER $$


CREATE PROCEDURE `TASASCEDESMOD`(
# =================================================================
# ----------- SP PARA MODIFICAT LAS TASAS DE CEDES-----------------
# =================================================================
	Par_TasaCedeID			INT(11),
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

	-- Declaracion de Variables
	DECLARE Var_TasaCedeID			INT(11);
	DECLARE Var_TipoCedeID			INT(11);
	DECLARE Var_EstatusTipoCede		CHAR(2);					-- Estatus del Tipo Cede
	DECLARE Var_Descripcion			VARCHAR(200);				-- Descripcion Tipo Cede


	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL;
	DECLARE SalidaSI				CHAR(1);
	DECLARE Estatus_Inactivo		CHAR(1);					-- Estatus Inactivo

	-- Asignacion de constantes
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
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TASASCEDESMOD');
			END;

		IF IFNULL(Par_TipoCedeID,Entero_Cero)= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Tipo de CEDES esta Vacio.';
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

		SELECT TipoCedeID,		Estatus,				Descripcion
		INTO 	Var_TipoCedeID,	Var_EstatusTipoCede,	Var_Descripcion
			FROM TIPOSCEDES WHERE TipoCedeID = Par_TipoCedeID;

		SET Var_TipoCedeID := IFNULL(Var_TipoCedeID,Entero_Cero);

		IF Var_TipoCedeID=Entero_Cero THEN
			SET	Par_NumErr 	:= 8;
			SET	Par_ErrMen	:= 'El Tipo de CEDES no existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusTipoCede = Estatus_Inactivo) THEN
			SET Par_NumErr	:=	009;
			SET Par_ErrMen	:=	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		UPDATE  TASASCEDES SET
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
		WHERE 	TipoCedeID 		= Par_TipoCedeID
        AND 	TasaCedeID		= Par_TasaCedeID;

		DELETE FROM TASACEDESUCURSALES WHERE TasaCedeID = Par_TasaCedeID AND TipoCedeID = Par_TipoCedeID;

		SET	Par_NumErr 	:= 0;
		SET	Par_ErrMen	:= CONCAT('Tasa Modificada Exitosamente: ',CONVERT(Par_TasaCedeID,CHAR));


	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'tasaCedeID' AS control,
				Par_TasaCedeID AS consecutivo;
	END IF;
END  TerminaStore$$