-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDATASASCEDES
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDATASASCEDES`;DELIMITER $$

CREATE PROCEDURE `VALIDATASASCEDES`(
# ========================================================
# ------------ SP QUE VALIDA LA TASA DE CEDES-------------
# ========================================================
	Par_TasaID				INT(11),
	Par_TipoProdID			INT(11),
	Par_MontoInferior		DECIMAL(18,2),
	Par_MontoSuperior		DECIMAL(18,2),
	Par_PlazoInferior		INT(11),

	Par_PlazoSuperior		INT(11),
	Par_Calificacion		CHAR(1),
	Par_SucursalID			INT(11),
	Par_TipoInstrumento		INT(11),

    Par_TipoPersona			CHAR(1),

    Par_Salida				CHAR(1),
	INOUT Par_NumErr 		INT(11),
	INOUT Par_ErrMen  		VARCHAR(400),

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
	DECLARE Var_TasaCedeID		 INT(11);
	DECLARE Var_TipoCedeID		 INT(11);
	DECLARE Var_Contador		 INT(11);
	DECLARE Var_Control			 VARCHAR(30);
	DECLARE Var_Consecutivo 	 INT(11);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		 CHAR(1);
	DECLARE Entero_Cero			 INT(11);
	DECLARE Decimal_Cero		 DECIMAL(12,2);
	DECLARE SalidaSI			 CHAR(1);
	DECLARE Validar				 CHAR(1);
	DECLARE TipoInstrumentoCEDES INT(11);
	DECLARE ValidarSI			 CHAR(1);
	DECLARE ValidarNO			 CHAR(1);
	DECLARE ConstanteDos		 INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';			-- Constante Cadena Vacia
	SET Entero_Cero				:= 0;			-- Constante Entero Cero
	SET Decimal_Cero			:= 0.0;			-- Constante DECIMAL Cero
	SET SalidaSI				:= 'S';			-- Constante Salida SI
	SET Validar					:= "";			-- Contador Auxiliar
	SET TipoInstrumentoCEDES	:= 28; 			-- Tipo InstrumentoID de la tabla TIPOSINSTRUMENTOS
	SET ValidarSI				:= "S";			-- Constante Validar SI
	SET ValidarNO				:= "N";			-- Constante Validar No

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								    'Disculpe las molestias que esto le ocasiona. Ref: SP-VALIDATASASCEDES');
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


		 IF (Par_TipoInstrumento = TipoInstrumentoCEDES) THEN
			SELECT TipoCedeID INTO Var_TipoCedeID
				FROM 	TIPOSCEDES
                WHERE 	TipoCedeID = Par_TipoProdID;
		 END IF;


		SET Var_TipoCedeID := IFNULL(Var_TipoCedeID,Entero_Cero);
		IF (Var_TipoCedeID=Entero_Cero) THEN
			SET	Par_NumErr 	:= 8;
			SET	Par_ErrMen	:= 'El Tipo de Producto no existe.';
			SET Var_Control	:= 'tipoProdID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoInstrumento = TipoInstrumentoCEDES) THEN
			DROP TABLE IF EXISTS  VALIDATASAS;
			CREATE TEMPORARY TABLE VALIDATASAS(
				SELECT TasaCedeID,TipoCedeID
					FROM 	TASASCEDES
					WHERE 	TipoCedeID		= Par_TipoProdID
					AND   	MontoInferior	= Par_MontoInferior
					AND   	MontoSuperior	= Par_MontoSuperior
					AND   	PlazoInferior	= Par_PlazoInferior
					AND   	PlazoSuperior	= Par_PlazoSuperior
					AND   	Calificacion	= Par_Calificacion);


			SELECT VT.TasaCedeID INTO Var_TasaCedeID
				FROM	VALIDATASAS VT
						INNER JOIN TASACEDESUCURSALES TC ON TC.TipoCedeID = VT.TipoCedeID
														AND TC.TasaCedeID = VT.TasaCedeID
				WHERE	TC.SucursalID=Par_SucursalID
				LIMIT	1;

			IF IFNULL(Par_TasaID,Entero_Cero)>Entero_Cero THEN
				SET Validar =ValidarNO;
			ELSE
				SET Validar =ValidarSI;
			END IF;

			IF(Validar = ValidarNO AND Var_TasaCedeID > Entero_Cero AND Par_TasaID <> Var_TasaCedeID)THEN
				IF(Var_TasaCedeID > Entero_Cero)THEN
					SET	Par_NumErr 	:= 10;
					SET	Par_ErrMen	:= 'Existe un Esquema de Tasa con las Caracteristicas Seleccionadas.';
					SET Var_Control	:= 'tasaCedeID';
					LEAVE ManejoErrores;
				END IF;
			ELSEIF(Validar = ValidarSI AND Var_TasaCedeID > Entero_Cero)THEN
				IF(Var_TasaCedeID>Entero_Cero)THEN
					SET	Par_NumErr 	:= 10;
					SET	Par_ErrMen	:= 'Existe un Esquema de Tasa con las Caracteristicas Seleccionadas.';
					SET Var_Control	:= 'tasaCedeID';
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