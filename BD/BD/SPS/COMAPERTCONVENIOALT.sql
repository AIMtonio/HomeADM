-- SP COMAPERTCONVENIOALT

DELIMITER ;

DROP PROCEDURE IF EXISTS COMAPERTCONVENIOALT;

DELIMITER $$

CREATE PROCEDURE  COMAPERTCONVENIOALT(
-- SP PARA CONSULTAR ESQUEMA DE COMISION POR APERTURA POR CONVENIO DE NOMINA
	Par_EsqComApertID		INT(11),
	Par_ConvenioNominaID	BIGINT UNSIGNED,
	Par_FormCobroComAper	CHAR(1),
	Par_TipoComApert		CHAR(1),
	Par_PlazoID				VARCHAR(20),
	Par_MontoMin			DECIMAL(12,2),
	Par_MontoMax			DECIMAL(12,2),
	Par_Valor				DECIMAL(12,2),
	Par_Fila				DECIMAL(12,2),

	Par_Salida				CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria ID de la Empresa
	Aud_Usuario				INT(11),			-- Parametro de Auditoria ID del Usuario
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria ID de la Sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control
	DECLARE Var_EsqConvComAperID	BIGINT(12);			-- Consecutivo siguiente al ultimo ID de la tabla ESQUEMAQUINQUENIOS

	-- Declaracion de Constantes
	DECLARE Var_Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Var_Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Var_Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Var_Fecha_Vacia				DATE;				-- Constante para fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);			-- Salida Si
	DECLARE Var_SalidaNO				CHAR(1);			-- Salida No
	DECLARE Var_MontoMinimo				DECIMAL(12,2);
	DECLARE Var_MontoMaximo				DECIMAL(12,2);
	DECLARE Var_ProducCreditoID			INT(11);

	-- Asignacion de Constantes
	SET Var_Cadena_Vacia				:= '';				-- Constante Cadena Vacia
	SET Var_Entero_Cero					:= 0;				-- Entero Cero
	SET Var_Decimal_Cero				:= 0.0;				-- Decimal Cero
	SET Var_Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET Var_SalidaSI					:= 'S';				-- Salida Si

	SET Var_SalidaNO					:= 'N';				-- Salida No

ManejoErrores:BEGIN


	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr	:= 999;
		SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-COMAPERTCONVENIOALT');
		SET Var_Control	:= 'SQLEXCEPTION';
	END;

	IF(IFNULL(Par_EsqComApertID, Var_Entero_Cero) = Var_Entero_Cero) THEN
		SET Par_NumErr	:= 001;
		SET Par_ErrMen	:= 'El Esquema de Comisión Apertura se encuentra Vacio.';
		SET Var_Control	:= 'esqComApertID';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT EsqComApertID FROM ESQCOMAPERNOMINA WHERE EsqComApertID = Par_EsqComApertID) THEN
		SET Par_NumErr	:= 002;
		SET Par_ErrMen	:= 'El esquema de cobro de comisión por apertura no existe.';
		SET Var_Control	:= 'EsqComApertID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ConvenioNominaID>0) THEN
		IF NOT EXISTS (SELECT ConvenioNominaID FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Par_ConvenioNominaID) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El convenio de nomina no existe.';
			SET Var_Control	:= 'EsqComApertID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF NOT EXISTS (SELECT PlazoID FROM CREDITOSPLAZOS WHERE PlazoID = Par_PlazoID) THEN
		SET Par_NumErr	:= 004;
		SET Par_ErrMen	:= 'El plazo no existe.';
		SET Var_Control	:= 'PlazoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FormCobroComAper, Var_Cadena_Vacia) = Var_Cadena_Vacia) THEN
		SET Par_NumErr	:= 005;
		SET Par_ErrMen	:= 'La Forma de Cobro se encuentra Vacia.';
		SET Var_Control	:= 'formCobroComAper';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoComApert, Var_Cadena_Vacia) = Var_Cadena_Vacia) THEN
		SET Par_NumErr	:= 006;
		SET Par_ErrMen	:= 'El Tipo de Comisión se encuentra Vacia.';
		SET Var_Control	:= 'tipoComApert';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_FormCobroComAper NOT IN('F','D','A','P')) THEN
		SET Par_NumErr	:= 007;
		SET Par_ErrMen	:= 'La Forma de Cobro no es válida.';
		SET Var_Control	:= 'formCobroComAper';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TipoComApert NOT IN('P','M')) THEN
		SET Par_NumErr	:= 008;
		SET Par_ErrMen	:= 'El Tipo de Comisión no es válido.';
		SET Var_Control	:= 'tipoComApert';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PlazoID, Var_Cadena_Vacia) = Var_Cadena_Vacia) THEN
		SET Par_NumErr	:= 009;
		SET Par_ErrMen	:= 'El Plazo se encuentra Vacio.';
		SET Var_Control	:= 'plazoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoMin, Var_Decimal_Cero) = Var_Decimal_Cero) THEN
		SET Par_NumErr	:= 010;
		SET Par_ErrMen	:= 'El Monto Minimo se encuentra Vacio.';
		SET Var_Control	:= 'montoMin';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoMax, Var_Decimal_Cero) = Var_Decimal_Cero) THEN
		SET Par_NumErr	:= 011;
		SET Par_ErrMen	:= 'El Monto Maximo se encuentra Vacio.';
		SET Var_Control	:= 'montoMax';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Valor, Var_Decimal_Cero) = Var_Decimal_Cero) THEN
		SET Par_NumErr	:= 012;
		SET Par_ErrMen	:= 'El Valor se encuentra Vacio.';
		SET Var_Control	:= 'valor';
		LEAVE ManejoErrores;
	END IF;

	SELECT	ProducCreditoID INTO Var_ProducCreditoID FROM ESQCOMAPERNOMINA WHERE EsqComApertID = Par_EsqComApertID LIMIT 1;

	SELECT	MontoMinimo,		MontoMaximo
	INTO	Var_MontoMinimo,	Var_MontoMaximo
	FROM	PRODUCTOSCREDITO
	WHERE	ProducCreditoID = Var_ProducCreditoID LIMIT 1;

	IF(Par_MontoMin < Var_MontoMinimo) THEN
		SET Par_NumErr	:= 013;
		SET Par_ErrMen	:= 'El Monto Minimo es menor al límite del producto.';
		SET Var_Control	:= 'valor';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_MontoMax > Var_MontoMaximo) THEN
		SET Par_NumErr	:= 014;
		SET Par_ErrMen	:= 'El Monto Máximo excede el límite del producto.';
		SET Var_Control	:= 'valor';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Valor < 0) THEN
		SET Par_NumErr	:= 015;
		SET Par_ErrMen	:= 'El Valor es negativo.';
		SET Var_Control	:= 'valor';
		LEAVE ManejoErrores;
	END IF;

	SET Var_EsqConvComAperID := (SELECT IFNULL(MAX(EsqConvComAperID),Var_Entero_Cero)+1 FROM COMAPERTCONVENIO);


	SET Aud_FechaActual := NOW();

	INSERT INTO COMAPERTCONVENIO(
		EsqConvComAperID,		EsqComApertID,		ConvenioNominaID,		FormCobroComAper,		TipoComApert,
		PlazoID,				MontoMin,			MontoMax,				Valor,					Fila,
		EmpresaID,				Usuario,			FechaActual,			DireccionIP,			ProgramaID,
		Sucursal,				NumTransaccion)

	VALUES(
		Var_EsqConvComAperID,	Par_EsqComApertID,	Par_ConvenioNominaID, 	Par_FormCobroComAper,	Par_TipoComApert,
		Par_PlazoID,			Par_MontoMin,		Par_MontoMax,   		Par_Valor,				Par_Fila,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);

	SET Par_NumErr	:= 	Var_Entero_Cero;
	SET Par_ErrMen	:= 'Esquema Cobro de Comision por Apertura por Convenio Grabado Exitosamente.';
	SET Var_Control	:= 'convenioNominaID';

END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control,
				Var_EsqConvComAperID	AS Consecutivo;

	END IF;

END TerminaStore$$