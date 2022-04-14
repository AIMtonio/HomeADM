-- SPEICUENTASCLABPMORALALT
DELIMITER ;
	DROP PROCEDURE IF EXISTS SPEICUENTASCLABPMORALALT;
DELIMITER $$

CREATE PROCEDURE SPEICUENTASCLABPMORALALT(
	Par_ClienteID			INT(11),
	Par_CuentaClabe			VARCHAR(18),
	Par_Instrumento			BIGINT(12),

	Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(20),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN
	
	-- Declaracion de constantes
	DECLARE Cadena_Vacia				CHAR(1);				-- Cadena vacia
	DECLARE Entero_Cero					INT(11);				-- Entero Cero
	DECLARE Decimal_Cero				DECIMAL(18,2);			-- Decimal _cero
	DECLARE Fecha_Vacia					DATE;					-- Fecha Vacia
	DECLARE Salida_SI					CHAR(1);				-- Salida si
	DECLARE Salida_NO					CHAR(1);				-- Salida no
	DECLARE EstInactiva					CHAR(1);				-- Estatus Inactivo
	DECLARE InstrumentoCH				CHAR(2);				-- Tipo de instrumento Cuenta Ahorro.
	DECLARE Con_TipoMoral				CHAR(1);				-- Tipo de Persona Moral
	
	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(200);			-- Variable de control
	DECLARE Var_Consecutivo				BIGINT(20);				-- Variable consecutivo
	DECLARE Var_FechaSis				DATE;					-- Variable para la fecha del sistema;
	DECLARE Var_RazonSocial				VARCHAR(150);			-- Razon Social del Cliente
	DECLARE Var_RazonSocialSTP			VARCHAR(150);			-- Razon Social del Cliente
	DECLARE Var_RFC						VARCHAR(18);			-- RFC del Cliente
	DECLARE Var_CURP					VARCHAR(18);			-- CURP del Cliente
	DECLARE Var_FechaConst				DATE;					-- Fecha de constitucion
	DECLARE Var_ClavePaisSTP			INT(11);				-- Clave de Pais de constitucion (Clave STP)
	DECLARE Var_EmpresaSTP				CHAR(15);				-- Nombre de la empresa de STP
	DECLARE Var_ClienteID				INT(11);				-- ID de Cliente
	DECLARE Var_TipoPersona				CHAR(1);				-- Tipo de Persona (F = Fisica, M = Moral, A = Fisica con actividad empresarial)
	DECLARE Var_CuentaAhoID				BIGINT(12);				-- ID de la Cuenta Ahorro
	
	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';					-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero						:= 0;					-- Entero Cero
	SET Decimal_Cero					:= 0.0;					-- Decimal cero
	SET Salida_SI						:= 'S';					-- Salida SI
	SET Salida_NO						:= 'N';					-- Salida NO
	SET EstInactiva						:= 'I';					-- Estatus Inactivo
	SET InstrumentoCH					:= 'CH';				-- Tipo de instrumento Cuenta Ahorro
	SET Con_TipoMoral					:= 'M';					-- Tipo de Persona Moral


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEICUENTASCLABPMORALALT');
				SET Var_Control	:= 'sqlException';
			END;

		
		IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'EL numero del cliente esta vacio';
			SET Var_Control:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT 		ClienteID,				TipoPersona
			INTO 	Var_ClienteID,			Var_TipoPersona
			FROM CLIENTES 
			WHERE ClienteID = Par_ClienteID;
		
		IF (IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'EL cliente no existe';
			SET Var_Control:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_TipoPersona <> Con_TipoMoral) THEN
			SET	Par_NumErr 	:= 003;
			SET	Par_ErrMen	:= "El cliente no se encuentra registrado como persona moral.";
			SET Var_Control := 'clienteID';
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;
		
		IF(IFNULL(Par_CuentaClabe,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'La cuenta clabe esta vacio';
			SET Var_Control:= 'cuentaClabe';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Instrumento, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := 'La numero de Cuenta de Ahorro esta vacio.';
			SET Var_Control:= 'instrumento';
			LEAVE ManejoErrores;
		END IF;

		SELECT 		CuentaAhoID
			INTO 	Var_CuentaAhoID
			FROM CUENTASAHO
			WHERE CuentaAhoID = Par_Instrumento;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero) = Entero_Cero) THEN
			SET	Par_NumErr 	:= 006;
			SET	Par_ErrMen	:= "Especifique un numero de Cuenta de Ahorro valido.";
			SET Var_Control := 'clienteID';
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;
		
		SELECT FechaSistema INTO Var_FechaSis FROM PARAMETROSSIS;
		CALL FOLIOSAPLICAACT('SPEICUENTASCLABPMORAL',Var_Consecutivo);

		SELECT 		C.RazonSocial,			C.RFCpm,				C.CURP,				P.ClaveSTP,				C.FechaConstitucion
			INTO 	Var_RazonSocial,		Var_RFC,				Var_CURP,			Var_ClavePaisSTP,		Var_FechaConst
			FROM CLIENTES C
			LEFT JOIN PAISES P ON P.PaisID = C.PaisConstitucionID
			WHERE ClienteID = Par_ClienteID;

		SET Var_RazonSocial := IFNULL(Var_RazonSocial, Cadena_Vacia);
		SET Var_ClavePaisSTP := IFNULL(Var_ClavePaisSTP, Entero_Cero);
		SET Var_RazonSocialSTP := SUBSTRING(Var_RazonSocial, 1, 50);
		SET Var_RFC := IFNULL(Var_RFC, Cadena_Vacia);
		SET Var_CURP := IFNULL(Var_CURP, Cadena_Vacia);
		SET Var_FechaConst := IFNULL(Var_FechaConst, Fecha_Vacia);

		IF(Var_RazonSocialSTP = Cadena_Vacia) THEN
			SET	Par_NumErr 	:= 007;
			SET	Par_ErrMen	:= "Actualice la razon social del cliente.";
			SET Var_Control := 'clienteID';
			SET Var_Consecutivo := Par_ClienteID;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_ClavePaisSTP = Entero_Cero) THEN
			SET	Par_NumErr 	:= 007;
			SET	Par_ErrMen	:= "Actualice el pais de constitucion del cliente.";
			SET Var_Control := 'clienteID';
			SET Var_Consecutivo := Par_ClienteID;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_FechaConst = Fecha_Vacia) THEN
			SET	Par_NumErr 	:= 007;
			SET	Par_ErrMen	:= "Actualice la fecha de constitucion del cliente.";
			SET Var_Control := 'clienteID';
			SET Var_Consecutivo := Par_ClienteID;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		EmpresaSTP
			INTO 	Var_EmpresaSTP
			FROM PARAMETROSSPEI;

		INSERT INTO SPEICUENTASCLABPMORAL(
				SpeiCuentaPMoralID,		ClienteID,				CuentaClabe,		FechaCreacion,		Estatus,
				TipoInstrumento,		Instrumento,			RazonSocial,		EmpresaSTP,			RFC,
				CURP,					FechaConstitucion,		ClavePaisSTP,		Firma,				PIDTarea,
				IDRespuesta,			DescripcionRespuesta,	NumIntentos,		Comentario,			EmpresaID,
				Usuario,				FechaActual,			DireccionIP,		ProgramaID,			Sucursal,
				NumTransaccion
			)
			VALUES(
				Var_Consecutivo,		Par_ClienteID,			Par_CuentaClabe,	Var_FechaSis,		EstInactiva,
				InstrumentoCH,			Par_Instrumento,		Var_RazonSocialSTP,	Var_EmpresaSTP,		Var_RFC,
				Var_CURP,				Var_FechaConst,			Var_ClavePaisSTP,	Cadena_Vacia,		Cadena_Vacia,
				Entero_Cero,			Cadena_Vacia,			Entero_Cero,		Cadena_Vacia,		Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion
			);

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT("Cuenta Clabe para SPEI Agregado Exitosamente: ", CONVERT(Var_Consecutivo, CHAR));
		SET Var_Control:= 'speiCuentaPMoralID';
			
	END ManejoErrores;
	
	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS Consecutivo;
	END IF;
		
END TerminaStore$$
