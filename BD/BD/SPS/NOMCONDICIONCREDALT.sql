-- SP NOMCONDICIONCREDALT
DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCONDICIONCREDALT;

DELIMITER $$

CREATE PROCEDURE NOMCONDICIONCREDALT(
	-- STORE PROCEDURE PARA DAR DE ALTA Y MODIFICAR CONDICIONES DE CREDITO

	Par_InstitNominaID		INT(11),		-- Numero del instituto de nomina
    Par_ConvenioNominaID	BIGINT UNSIGNED,		-- Numero del convenio de nomina
	Par_ProducCreditoID		INT(11),		-- Numero del producto de credito
	Par_TipoTasa			CHAR(1),		-- Tipo de tasa, puede ser fija o por esquema
	Par_ValorTasa			DECIMAL(12,4),	-- Indica el valor de la tasa, es necesario solo cuando se indica Par_TipoTasa como tasa fija
	Par_TipoCobMora			CHAR(1),		-- Tipo de cobro mora, N- N veces tasa,T-Tasa fija anualizada, D- Convenio no cobra mora
	Par_ValorMora			DECIMAL(12,4),	-- Indica el valor de cobro moratorio

	Par_Salida				CHAR(1),		-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),		-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID			INT(11),		-- Parametros de auditoria
	Aud_Usuario				INT(11),		-- Parametros de auditoria
	Aud_FechaActual			DATETIME,		-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametros de auditoria
	Aud_Sucursal			INT(11),		-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametros de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CondicionCredID		BIGINT(20);		-- Variable para guardar el ID generado
	DECLARE Var_ConvenioNominaID	INT(11);		-- Variable para obtener el identificador del convenio
	DECLARE Var_InstitNominaID		INT(11);		-- Variable para obtener el identificador del instituto de nomina
	DECLARE Var_ProducCreditoID		INT(11);		-- Variable para obtener el identificador del producto de credito
	DECLARE Var_Control				VARCHAR(50);	-- Variable de control de errores
	DECLARE Var_CondicionFecha		BIGINT(20);		-- Variable para obtener el identificador de la condicion de credito con la misma fecha programada


	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(1);			-- Entero Cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE SalidaSI			CHAR(1);		-- Cadena SI
	DECLARE Var_TasaFija		CHAR(1);		-- Tasa fija
	DECLARE Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Decimal cero


	-- Asignacion de constantes
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Cadena_Vacia		:= '';				-- Cadena vacia
	SET SalidaSI			:= 'S';				-- Cadena SI
	SET Var_TasaFija		:= 'F';				-- Tasa fija
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET Decimal_Cero		:= 0.00;			-- Decimal cero


	-- Asignacion de valores por defecto
	SET Par_ConvenioNominaID 	:= IFNULL(Par_ConvenioNominaID,Entero_Cero);
	SET Par_InstitNominaID		:= IFNULL(Par_InstitNominaID,Entero_Cero);
	SET Par_ProducCreditoID		:= IFNULL(Par_ProducCreditoID,Entero_Cero);
	SET Par_TipoTasa			:= IFNULL(Par_TipoTasa,Cadena_Vacia);
	SET Par_ValorTasa			:= IFNULL(Par_ValorTasa,Decimal_Cero);


	ManejoErrores:	BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			'esto le ocasiona. Ref: NOMCONDICIONCREDALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF (Par_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El instituto de nomina de la condicion de credito esta vacio';
			SET Var_Control		:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;


		SELECT InstitNominaID
		INTO Var_InstitNominaID
		FROM INSTITNOMINA
		WHERE InstitNominaID = Par_InstitNominaID
		LIMIT 1;

		SET Var_InstitNominaID := IFNULL(Var_InstitNominaID, Entero_Cero);

		IF (Var_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen 		:= CONCAT('El instituto de nomina de la condicion de credito no existe: ', Par_InstitNominaID);
			SET Var_Control		:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ConvenioNominaID = Entero_Cero) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'El convenio de nomina de la condicion de credito esta vacio';
			SET Var_Control		:= 'convenioNominaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT ConvenioNominaID
		INTO Var_ConvenioNominaID
		FROM CONVENIOSNOMINA
		WHERE ConvenioNominaID = Par_ConvenioNominaID
		LIMIT 1;

		SET Var_ConvenioNominaID := IFNULL(Var_ConvenioNominaID, Entero_Cero);

		IF (Var_ConvenioNominaID = Entero_Cero) THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen 		:= CONCAT('El convenio nomina de la condicion de credito no existe: ', Par_ConvenioNominaID);
			SET Var_Control		:= 'convenioNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ProducCreditoID = Entero_Cero) THEN
			SET Par_NumErr		:= 005;
			SET Par_ErrMen		:= 'El producto de credito de la condicion de credito esta vacio';
			SET Var_Control		:= 'tipoCuentaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT 	ProducCreditoID
		INTO 	Var_ProducCreditoID
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID  = Par_ProducCreditoID AND ProductoNomina = SalidaSI
		LIMIT 1;

		SET Var_ProducCreditoID := IFNULL(Var_ProducCreditoID, Entero_Cero);

		IF (Var_ProducCreditoID = Entero_Cero) THEN
			SET Par_NumErr		:= 006;
			SET Par_ErrMen		:= CONCAT('El producto de nomina de la condicion de credito no existe :', Par_ProducCreditoID);
			SET Var_Control		:= 'producCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoTasa = Cadena_Vacia) THEN
			SET Par_NumErr		:= 007;
			SET Par_ErrMen		:= 'El tipo de tasa de la condicion de credito esta vacio';
			SET Var_Control		:= 'tipoTasa';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoTasa = Var_TasaFija) THEN
			IF(Par_ValorTasa = Decimal_Cero) THEN
				SET Par_NumErr		:= 008;
				SET Par_ErrMen		:= 'El valor de tasa de la condicion de credito esta vacio';
				SET Var_Control		:= 'valorTasa';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_TipoCobMora = Cadena_Vacia OR Par_TipoCobMora NOT IN('N','T','D')) THEN
			SET Par_NumErr		:= 009;
			SET Par_ErrMen		:= 'El tipo de cobro mora de la condicion de credito es inválido';
			SET Var_Control		:= 'tipoCobMora';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ValorMora < Decimal_Cero) THEN
			SET Par_NumErr		:= 010;
			SET Par_ErrMen		:= 'El valor de cobro mora de la condicion de credito es inválido';
			SET Var_Control		:= 'valorMora';
			LEAVE ManejoErrores;
		END IF;


        SET Var_CondicionCredID := (SELECT (IFNULL(MAX(CondicionCredID),0) + 1) AS CondicionCredID  FROM NOMCONDICIONCRED);

		INSERT INTO NOMCONDICIONCRED (
					CondicionCredID,			InstitNominaID,				ConvenioNominaID,			ProducCreditoID,		TipoTasa,
					ValorTasa,					TipoCobMora,				ValorMora,					EmpresaID,				Usuario,
					FechaActual,				DireccionIP,				ProgramaID,					Sucursal,				NumTransaccion
				)
				VALUES(
					Var_CondicionCredID,		Par_InstitNominaID,			Par_ConvenioNominaID,		Par_ProducCreditoID,	Par_TipoTasa,
					Par_ValorTasa,				Par_TipoCobMora,			Par_ValorMora,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion
				);



		SET Par_NumErr    := Entero_Cero;
		SET Par_ErrMen    := CONCAT('La condicion de producto de credito se ha agregado exitosamente: ', CONVERT(Var_CondicionCredID, CHAR));
		SET Var_Control   := 'condicionCredID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	Control,
				Var_CondicionCredID		AS	Consecutivo;
	END IF;
END TerminaStore$$
