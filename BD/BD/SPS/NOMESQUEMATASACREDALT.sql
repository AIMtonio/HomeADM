-- SP NOMESQUEMATASACREDALT
DELIMITER ;

DROP PROCEDURE IF EXISTS NOMESQUEMATASACREDALT;

DELIMITER $$

CREATE PROCEDURE NOMESQUEMATASACREDALT(
	-- STORE PROCEDURE PARA DAR DE ALTA ESQUEMAS DE TASA DE CREDITO
	Par_CondicionCredID			BIGINT(20),					-- Identificador de la condicion de credito
	Par_SucursalID				VARCHAR(500),				-- Identificador de la sucursalID
    Par_TipoEmpleadoID			VARCHAR(500),					-- Identificador del tipo de empleado de nomina
	Par_PlazoID					VARCHAR(5000)	,				-- Identificador de plazo de credito del esquema

	Par_MinCred					INT(11),					-- Indica el Minimo numeros de creditos
	Par_MaxCred					INT(11),					-- Indica el Maximo numeros de creditos
	Par_MontoMin				DECIMAL(12,2),				-- Indica Monto minimo del esquema
	Par_MontoMax				DECIMAL(12,2),				-- Indica Monto maximo del esquema
	Par_Tasa					DECIMAL(12,4),				-- Valor de la tasa del esquema

	Par_Salida					CHAR(1),					-- Parametro para salida de datos
	INOUT Par_NumErr			INT(11),					-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen			VARCHAR(400),				-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador


	Par_EmpresaID				INT(11),					-- Parametro de Auditoria EmpresaID
	Aud_Usuario					INT(11),					-- Parametro de Auditoria Usuario
	Aud_FechaActual				DATETIME,					-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP				VARCHAR(15),				-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),				-- Parametro de Auditoria Programa ID
	Aud_Sucursal				INT(11),					-- Parametro de Auditoria Sucursal
	Aud_NumTransaccion			BIGINT(20)					-- Parametro de Auditoria Numero de Transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_EsqTasaCredID		BIGINT(20);			-- Variable para obtener el ID generado
	DECLARE Var_CondicionCredID		BIGINT(20);			-- Variable para obtener el identificador de la condicion de credito
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control de errores
    DECLARE Var_SucursalID			INT(11);			-- Variable para obtener el identificador de la sucursal
	DECLARE Var_TipoEmpleadoID		INT(11);			-- Variable para obtener el identificador del tipo de empleado
	DECLARE Var_PlazoID				INT(11);			-- Variable para obtener el identificador del plazo
	DECLARE Var_MontoMin			DECIMAL(12,2);		-- Variable para obtener monto minimo del esquema de monto
	DECLARE Var_MontoMax			DECIMAL(12,2);		-- Variable para obtener monto maximo del esquema de monto
	DECLARE Var_TipoPlazo			CHAR(1);			-- Variable para obtener el tipo plazo del producto de credito

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE SalidaSI				CHAR(1);			-- Cadena SI
	DECLARE Var_CadenaNO			CHAR(1);			-- Cadena NO
	DECLARE Var_PlazoRango			CHAR(1);			-- Tipo plazo rango

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Decimal_Cero				:= 0.00;				-- Decimal Cero
	SET Cadena_Vacia				:= '';				-- Cadena vacia
	SET SalidaSI					:= 'S';				-- Cadena SI
	SET Var_CadenaNO				:= 'N';				-- Cadena NO
	SET Var_PlazoRango				:= 'R';				-- Tipo plazo rango

	-- Asignacion de valores por defecto

	SET	Par_CondicionCredID			:= IFNULL(Par_CondicionCredID, Entero_Cero);
	SET	Par_SucursalID				:= IFNULL(Par_SucursalID,Entero_Cero);
	SET Par_TipoEmpleadoID			:= IFNULL(Par_TipoEmpleadoID, Entero_Cero);
	SET Par_PlazoID					:= IFNULL(Par_PlazoID, Entero_Cero);
	SET Par_MontoMin				:= IFNULL(Par_MontoMin, Decimal_Cero);
	SET Par_MontoMax				:= IFNULL(Par_MontoMax, Decimal_Cero);
	SET Par_Tasa					:= IFNULL(Par_Tasa, Decimal_Cero);
    SET Par_MinCred					:= IFNULL(Par_MinCred, Entero_Cero);
	SET Par_MaxCred					:= IFNULL(Par_MaxCred, Entero_Cero);
    
  

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			'esto le ocasiona. Ref: NOMESQUEMATASACREDALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;
        
		IF (Par_CondicionCredID = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'La condicion de credito del esquema de tasa esta vacio';
			SET Var_Control		:= 'condicionCredID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CondicionCredID
			INTO Var_CondicionCredID
			FROM NOMCONDICIONCRED 
			WHERE CondicionCredID	= Par_CondicionCredID
			LIMIT 1;

		SET Var_CondicionCredID := IFNULL(Var_CondicionCredID, Entero_Cero);

		IF (Var_CondicionCredID = Entero_Cero) THEN
			SET Par_NumErr 		:= 002;
			SET Par_ErrMen		:= 'La condicion de credito del esquema de tasa no existe';
			SET Var_Control		:= 'condicionCredID';
			LEAVE ManejoErrores;
		END IF;
        

		SELECT SucursalID 
			INTO Var_SucursalID
			FROM SUCURSALES	 
            WHERE FIND_IN_SET(Par_SucursalID, SucursalID)=Entero_Cero
			LIMIT 1;

		SET Var_SucursalID := IFNULL(Var_CondicionCredID, Entero_Cero);

		IF (Var_SucursalID = Entero_Cero) THEN
			SET Par_NumErr 		:= 004;
			SET Par_ErrMen		:= 'La sucursal del esquema de tasa no existe';
			SET Var_Control		:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;


		-- Si no es la opcion todos en tipo empleado
		IF (Par_TipoEmpleadoID != Cadena_Vacia) THEN
			SELECT TipoEmpleadoID
			INTO Var_TipoEmpleadoID
			FROM CATTIPOEMPLEADOS
            WHERE FIND_IN_SET(Par_TipoEmpleadoID, TipoEmpleadoID)=Entero_Cero
			LIMIT 1;

			SET Var_TipoEmpleadoID	:= IFNULL(Var_TipoEmpleadoID, Entero_Cero);

			IF (Var_TipoEmpleadoID = Entero_Cero) THEN
				SET Par_NumErr		:= 005;
				SET Par_ErrMen		:= 'El tipo de empleado del esquema de tasa no existe';
				SET Var_Control		:= 'tipoEmpleadoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		-- si no es la opcion todos en plazo
		IF (Par_PlazoID != Cadena_Vacia) THEN
		
				SELECT PlazoID
				INTO Var_PlazoID
				FROM CREDITOSPLAZOS
                WHERE FIND_IN_SET(Par_PlazoID, PlazoID)=Entero_Cero
				LIMIT 1;

				SET Var_PlazoID		:= IFNULL(Var_PlazoID, Entero_Cero);

				IF (Var_PlazoID = Entero_Cero) THEN
					SET Par_NumErr		:= 006;
					SET Par_ErrMen 		:= 'El plazo del esquema de tasa no existe';
					SET Var_Control		:= 'plazoID';
					LEAVE ManejoErrores;
				END IF;
		
		END IF;
        
      
		IF (Par_MontoMax < Par_MontoMin) THEN
			SET Par_NumErr		:= 007;
			SET Par_ErrMen		:= 'El monto maximo del esquema de tasa es menor que el monto minimo';
			SET Var_Control		:= 'montoMax';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_MontoMin = Par_MontoMax) THEN
			SET Par_NumErr		:= 008;
			SET Par_ErrMen 		:= 'El monto minimo es igual al monto maximo del esquema de tasa';
			SET Var_Control		:= 'montoMin';
			LEAVE ManejoErrores;
		END IF;


		IF (Par_Tasa = Decimal_Cero) THEN
			SET Par_NumErr		:= 009;
			SET Par_ErrMen		:= 'La tasa del esquema de tasa esta vacio';
			SET Var_Control		:= 'tasa';
			LEAVE ManejoErrores;
		END IF;

		SET Var_EsqTasaCredID := (SELECT IFNULL(MAX(EsqTasaCredID),0) + 1 FROM NOMESQUEMATASACRED);

		INSERT INTO NOMESQUEMATASACRED (
				EsqTasaCredID,		CondicionCredID,		SucursalID,			TipoEmpleadoID,			PlazoID,
                MinCred,			MaxCred,				MontoMin,			MontoMax,				Tasa,
				EmpresaID,			Usuario,				FechaActual,		DireccionIP,			ProgramaID,			
                Sucursal,			NumTransaccion
			)
			VALUES(
				Var_EsqTasaCredID,	Par_CondicionCredID,	Par_SucursalID,		Par_TipoEmpleadoID,		Par_PlazoID,
                Par_MinCred,		Par_MaxCred,			Par_MontoMin,		Par_MontoMax,			Par_Tasa,		
                Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= CONCAT('El esquema de tasa de credito se ha agregado exitosamente: ', CONVERT(Var_EsqTasaCredID, CHAR));
		SET Var_Control		:= 'esqTasaCredID';
	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	Control,
				Var_EsqTasaCredID		AS	Consecutivo;
	END IF;

END TerminaStore$$
