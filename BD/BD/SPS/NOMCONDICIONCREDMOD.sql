-- SP NOMCONDICIONCREDMOD

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCONDICIONCREDMOD;

DELIMITER $$

CREATE PROCEDURE NOMCONDICIONCREDMOD(
	-- STORE PROCEDURE PARA MODIFICAR TODOS LOS CAMPOS DE LA TABLA NOMCONDICIONCRED
	Par_CondicionCredID				BIGINT(20),				-- identificador de la condicion de credito
	Par_InstitNominaID				INT(11),				-- identificador del instituto de nomina
    Par_ConvenioNominaID			BIGINT UNSIGNED,				-- identificador del convenio de nomina
	Par_ProducCreditoID				INT(11),				-- identificador del producto de credito
	Par_TipoTasa					CHAR(1),				-- tipo de tasa de la condicion de credito
	Par_ValorTasa					DECIMAL(12,4),			-- valor de la tasa de la condicion de credito
	Par_TipoCobMora					CHAR(1),				-- Tipo de cobro mora, N- N veces tasa,T-Tasa fija anualizada, D- Convenio no cobra mora
	Par_ValorMora					DECIMAL(12,4),			-- valor de la tasa de la condicion de credito

	Par_Salida						CHAR(1),				-- Parametro que establece si requiere Salida
	INOUT Par_NumErr				INT(11),				-- Parametro del Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro del Mensaje de Error

	Par_EmpresaID					INT(11),				-- Parametro de Auditoria EmpresaID
	Aud_Usuario						INT(11),				-- Parametro de Auditoria Usuario
	Aud_FechaActual					DATETIME,				-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de Auditoria Programa ID
	Aud_Sucursal					INT(11),				-- Parametro de Auditoria Sucursal
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de Auditoria Numero de Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control de errores
	DECLARE Var_CondicionCredID		BIGINT(20);				-- Variable para obtener el identificador de la condicion de credito
	DECLARE Var_ConvenioNominaID	INT(11);				-- Variable para obtener el identificador del convenio
	DECLARE Var_InstitNominaID		INT(11);				-- Variable para obtener el identificador del instituto de nomina
	DECLARE Var_ProducCreditoID		INT(11);				-- Variable para obtener el identificador del producto de credito
	DECLARE Var_CondicionFecha		BIGINT(20);				-- Variable para obtener el identificador de la condicion de credito con la misma fecha programada


	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Entero_Cero				INT(11);				-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(12,2);			-- Decimal cero
	DECLARE Fecha_Vacia				DATE;					-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Cadena SI
    DECLARE SalidaNO				CHAR(1);				-- Cadena NO
	DECLARE Var_TasaFija			CHAR(1);				-- Tasa fija

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';					-- Cadena vacia
	SET Entero_Cero					:= 0;					-- Entero cero
	SET Decimal_Cero				:= 0.00;				-- Decimal cero
	SET Fecha_Vacia					:= '1900-01-01';		-- Fecha vacia
	SET SalidaSI					:= 'S';					-- Cadena SI
    SET SalidaNO					:= 'N';					-- Cadena NO
	SET Var_TasaFija				:= 'F';					-- Tasa fija


	-- asignacion de valores por defecto
	SET Par_CondicionCredID			:= IFNULL(Par_CondicionCredID, Entero_Cero);
	SET Par_ConvenioNominaID 		:= IFNULL(Par_ConvenioNominaID,Entero_Cero);
	SET Par_InstitNominaID			:= IFNULL(Par_InstitNominaID,Entero_Cero);
	SET Par_ProducCreditoID			:= IFNULL(Par_ProducCreditoID, Entero_Cero);
	SET Par_TipoTasa				:= IFNULL(Par_TipoTasa, Cadena_Vacia);
	SET Par_ValorTasa				:= IFNULL(Par_ValorTasa, Decimal_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-NOMCONDICIONCREDMOD');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		IF (Par_CondicionCredID = Entero_Cero) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El numero de condicion de credito esta vacio';
			SET Var_Control := 'condicionCredID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CondicionCredID
			INTO Var_CondicionCredID
			FROM NOMCONDICIONCRED
			WHERE CondicionCredID	= Par_CondicionCredID
			LIMIT 1;

		SET Var_CondicionCredID := IFNULL(Var_CondicionCredID, Entero_Cero);

		IF(Var_CondicionCredID = Entero_Cero) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'La condicion de credito no existe';
			SET Var_Control := 'condicionCredID';
			LEAVE ManejoErrores;
		END IF;

        IF (Par_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr		:= 003;
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
			SET Par_NumErr		:= 004;
			SET Par_ErrMen 		:= CONCAT('El instituto de nomina de la condicion de credito no existe: ', Par_InstitNominaID);
			SET Var_Control		:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;


		IF (Par_ConvenioNominaID = Entero_Cero) THEN
			SET Par_NumErr		:= 005;
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
			SET Par_NumErr		:= 006;
			SET Par_ErrMen 		:= CONCAT('El convenio nomina de la condicion de credito no existe: ', Par_ConvenioNominaID);
			SET Var_Control		:= 'convenioNominaID';
			LEAVE ManejoErrores;
		END IF;


		IF(Par_ProducCreditoID = Entero_Cero) THEN
			SET Par_NumErr		:= 007;
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
			SET Par_NumErr		:= 008;
			SET Par_ErrMen		:= CONCAT('El producto de nomina de la condicion de credito no existe :', Par_ProducCreditoID);
			SET Var_Control		:= 'producCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoTasa = Cadena_Vacia) THEN
			SET Par_NumErr  := 009;
			SET Par_ErrMen  := 'El tipo de tasa de la condicion de credito esta vacio';
			SET Var_Control := 'tipoTasa';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoTasa = Var_TasaFija) THEN
			IF(Par_ValorTasa = Decimal_Cero) THEN
				SET Par_NumErr		:= 010;
				SET Par_ErrMen		:= 'El valor de tasa de la condicion de credito esa vacio';
				SET Var_Control		:= 'valorTasa';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_TipoCobMora = Cadena_Vacia OR Par_TipoCobMora NOT IN('N','T','D')) THEN
			SET Par_NumErr		:= 010;
			SET Par_ErrMen		:= 'El tipo de cobro mora de la condicion de credito es inválido';
			SET Var_Control		:= 'tipoCobMora';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ValorMora < Decimal_Cero) THEN
			SET Par_NumErr		:= 011;
			SET Par_ErrMen		:= 'El valor de cobro mora de la condicion de credito es inválido';
			SET Var_Control		:= 'valorMora';
			LEAVE ManejoErrores;
		END IF;



		UPDATE NOMCONDICIONCRED SET
			InstitNominaID			= Par_InstitNominaID,
            ConvenioNominaID		= Par_ConvenioNominaID,
			ProducCreditoID 		= Par_ProducCreditoID,
			TipoTasa				= Par_TipoTasa,
			ValorTasa				= Par_ValorTasa,
			TipoCobMora				= Par_TipoCobMora,
			ValorMora				= Par_ValorMora,
			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,
			DireccionIP 			= Aud_DireccionIP,
			ProgramaID  			= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
			WHERE CondicionCredID 	= Par_CondicionCredID;


		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT("La condicion de credito ha sido modificada exitosamente: ", Par_CondicionCredID);
		SET Var_Control :=	'condicionCredID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT			Par_NumErr			AS	NumErr,
						Par_ErrMen 			AS 	ErrMen,
						Var_Control 		AS 	Control;
	END IF;

END TerminaStore$$
