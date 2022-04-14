-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDATASASAPORTACIONES
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDATASASAPORTACIONES`;DELIMITER $$

CREATE PROCEDURE `VALIDATASASAPORTACIONES`(
# ================================================================
# ------------ SP QUE VALIDA LA TASA DE APORTACIONES -------------
# ================================================================
	Par_TasaID				INT(11),		-- ID de la tasa
	Par_TipoProdID			INT(11),		-- Tipo de producto
	Par_MontoInferior		DECIMAL(18,2),	-- Monto inferior
	Par_MontoSuperior		DECIMAL(18,2),	-- Monto superios
	Par_PlazoInferior		INT(11),		-- Plazo inferior

	Par_PlazoSuperior		INT(11),		-- Plazo superior
	Par_Calificacion		CHAR(1),		-- Calificacion para la tasa
	Par_SucursalID			INT(11),		-- ID de la sucursal
	Par_TipoInstrumento		INT(11),		-- Tipo de instrumento

    Par_TipoPersona			CHAR(1),		-- Tipo de persona para la que aplica la tasa

    Par_Salida				CHAR(1),		-- Especifica salida
	INOUT Par_NumErr 		INT(11),		-- INOUT Par_NumErr
	INOUT Par_ErrMen  		VARCHAR(400),	-- INOUT Par_ErrMen

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
	DECLARE Var_TasaAportacionID		INT(11);		-- ID de la tasa de aportacion
	DECLARE Var_TipoAportacionID		INT(11);		-- ID del tipo de aportacion
	DECLARE Var_Contador		 		INT(11);		-- Contador
	DECLARE Var_Control			 		VARCHAR(30);	-- Variable de control
	DECLARE Var_Consecutivo 	 		INT(11);		-- Consecutivo

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		 		CHAR(1);
	DECLARE Entero_Cero			 		INT(11);
	DECLARE Decimal_Cero		 		DECIMAL(12,2);
	DECLARE SalidaSI			 		CHAR(1);
	DECLARE Validar				 		CHAR(1);
	DECLARE TipoInstrumentoAPORTACION 	INT(11);
	DECLARE ValidarSI			 		CHAR(1);
	DECLARE ValidarNO					CHAR(1);
	DECLARE ConstanteDos		 		INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';			-- Constante Cadena Vacia
	SET Entero_Cero						:= 0;			-- Constante Entero Cero
	SET Decimal_Cero					:= 0.0;			-- Constante DECIMAL Cero
	SET SalidaSI						:= 'S';			-- Constante Salida SI
	SET Validar							:= "";			-- Contador Auxiliar
	SET TipoInstrumentoAPORTACION		:= 28; 			-- Tipo InstrumentoID de la tabla TIPOSINSTRUMENTOS
	SET ValidarSI						:= "S";			-- Constante Validar SI
	SET ValidarNO						:= "N";			-- Constante Validar No

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								    'Disculpe las molestias que esto le ocasiona. Ref: SP-VALIDATASASAPORTACIONES');
		END;

		SET Var_Consecutivo	:= Entero_Cero;


		IF IFNULL(Par_TipoProdID,Entero_Cero)=Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Tipo de Producto esta Vacio.';
			SET Var_Control	:= 'tipoProdID';
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


		IF IFNULL(Par_Calificacion,Cadena_Vacia) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 6;
			SET	Par_ErrMen	:= 'La Calificacion esta Vacia.';
			SET Var_Control	:= 'calificacion';
			LEAVE ManejoErrores;
		END IF;


		 IF (Par_TipoInstrumento = TipoInstrumentoAPORTACION) THEN
			SELECT TipoAportacionID INTO Var_TipoAportacionID
				FROM 	TIPOSAPORTACIONES
                WHERE 	TipoAportacionID = Par_TipoProdID;
		 END IF;


		SET Var_TipoAportacionID := IFNULL(Var_TipoAportacionID,Entero_Cero);
		IF (Var_TipoAportacionID=Entero_Cero) THEN
			SET	Par_NumErr 	:= 8;
			SET	Par_ErrMen	:= 'El Tipo de Producto no existe.';
			SET Var_Control	:= 'tipoProdID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoInstrumento = TipoInstrumentoAPORTACION) THEN
			DROP TABLE IF EXISTS  VALIDATASAS;
			CREATE TEMPORARY TABLE VALIDATASAS(
				SELECT TasaAportacionID,TipoAportacionID
					FROM 	TASASAPORTACIONES
					WHERE 	TipoAportacionID	= Par_TipoProdID
					AND   	MontoInferior		= Par_MontoInferior
					AND   	MontoSuperior		= Par_MontoSuperior
					AND   	PlazoInferior		= Par_PlazoInferior
					AND   	PlazoSuperior		= Par_PlazoSuperior
					AND   	Calificacion		= Par_Calificacion);


			SELECT VT.TasaAportacionID INTO Var_TasaAportacionID
				FROM	VALIDATASAS VT
						INNER JOIN TASAAPORTSUCURSALES TC ON TC.TipoAportacionID = VT.TipoAportacionID
														AND TC.TasaAportacionID = VT.TasaAportacionID
				WHERE	TC.SucursalID=Par_SucursalID
				LIMIT	1;

			IF IFNULL(Par_TasaID,Entero_Cero)>Entero_Cero THEN
				SET Validar =ValidarNO;
			ELSE
				SET Validar =ValidarSI;
			END IF;

			IF(Validar = ValidarNO AND Var_TasaAportacionID > Entero_Cero AND Par_TasaID <> Var_TasaAportacionID)THEN
				IF(Var_TasaAportacionID > Entero_Cero)THEN
					SET	Par_NumErr 	:= 10;
					SET	Par_ErrMen	:= 'Existe un Esquema de Tasa con las Caracteristicas Seleccionadas.';
					SET Var_Control	:= 'tasaAportacionID';
					LEAVE ManejoErrores;
				END IF;
			ELSEIF(Validar = ValidarSI AND Var_TasaAportacionID > Entero_Cero)THEN
				IF(Var_TasaAportacionID>Entero_Cero)THEN
					SET	Par_NumErr 	:= 10;
					SET	Par_ErrMen	:= 'Existe un Esquema de Tasa con las Caracteristicas Seleccionadas.';
					SET Var_Control	:= 'tasaAportacionID';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET	Par_NumErr 		:= 0;
		SET	Par_ErrMen		:= 'Validacion concretada';
		SET Var_Control		:= 'tasaID';
		SET Var_Consecutivo	:= Var_Contador;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END  TerminaStore$$