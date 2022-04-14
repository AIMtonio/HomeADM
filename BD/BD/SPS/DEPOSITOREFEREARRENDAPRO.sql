-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEREARRENDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEREARRENDAPRO`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFEREARRENDAPRO`(
  	-- SP QUE REGISTRA EL DEPOSITO REFERENCIADO DEL ARRENDAMIENTO*/
	Par_DepRefereID				BIGINT,			-- FOLIO DE CARGA A PROCESAR
	Par_InstitucionID   		INT,			-- ID DE LA INSTITUCION BANCARIA
	Par_NumCtaInstit    		VARCHAR(20),	-- NUMERO DE CUENTA BANCARIA
	Par_FechaOperacion			DATE,			-- FECHA DE OPERACION
	Par_ReferenciaMov			VARCHAR(150),	-- VALOR DE REFERENCIA

	Par_DescripcionMov			VARCHAR(150),	-- DESCRIPCION DEL MOVIMIENTO
	Par_NatMovimiento			CHAR(1),		-- NATURALEZA DEL MOVIMIENTO
	Par_MontoMov				DECIMAL(14,2),	-- MONTO DEL MOVIMIENTO
	Par_TipoCanal				INT,			-- ARRENDAMIENTO = 1 CLIENTE = 2
	Par_TipoDeposito			CHAR(1),		-- TIPO DE DEPOSITO

	Par_Salida					CHAR(1),		-- INDICA SI EXISTE O NO UNA SALIDA
	INOUT Par_NumErr			INT(11),		-- NUMERO DE ERROR
	INOUT Par_ErrMen			VARCHAR(400),	-- MENSAJE DE ERROR
	INOUT Par_Consecutivo		BIGINT,			-- NUMERO DE FOLIO QUE SE DIO DE ALTA
	INOUT Var_FolioDepRefe		BIGINT,			-- NUMERO DE FOLIO DE DEPOSITO REFERENCIADO

	Aud_EmpresaID				INT(11),		-- PARAMETRO DE AUDITORIA
	Aud_Usuario					INT(11),		-- PARAMETRO DE AUDITORIA
	Aud_FechaActual				DATETIME,		-- PARAMETRO DE AUDITORIA
	Aud_DireccionIP				VARCHAR(15),	-- PARAMETRO DE AUDITORIA
	Aud_ProgramaID				VARCHAR(50),    -- PARAMETRO DE AUDITORIA
	Aud_Sucursal				INT(11),		-- PARAMETRO DE AUDITORIA
	Aud_NumTransaccion			BIGINT(20)		-- PARAMETRO DE AUDITORIA
  )
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);		-- VALOR CERO
	DECLARE Cadena_Vacia			CHAR(1);		-- CADENA VACIA
	DECLARE Decimal_Cero			DECIMAL(14,2);	-- VALOR CERO
	DECLARE Nat_Abono				CHAR(1);		-- ABONO
	DECLARE Var_CanalArrenda		INT(11);    	-- INDICA QUE SE DEPOSITA REFERENCIANDO UN ARRENDAMIENTO
	DECLARE Var_CanalCliente		INT(11);    	-- INDICA QUE SE DEPOSITA REFERENCIANDO UN CLIENTE
	DECLARE Var_Identificado		CHAR(1);  		-- ESTATUS IDENTIFICADO
	DECLARE Var_NoIdentificado		CHAR(2);  		-- ESTATUS NO IDENTIFICADO

	DECLARE TipoMovDepRef			CHAR(4); 		-- corresponde con la tabla TIPOSMOVTESO
	DECLARE Var_FechaSistema		DATE;			-- FECHA DE SISTEMA
	DECLARE Var_NO					CHAR(1);		-- VALOR NO
	DECLARE Var_SI					CHAR(1);		-- VALOR SI

	-- Declaracion de Variables
	DECLARE Var_Cargos				DECIMAL(14,4);	-- CARGIS
	DECLARE Var_Abonos				DECIMAL(14,4);	-- ABONOS
	DECLARE Var_FolioOperacion		INT(11);		-- FOLIO DE OPERACION
	DECLARE Var_Estatus				CHAR(2);		-- ESTATUS
	DECLARE Var_ArrendaID			BIGINT(12);		-- ID DE ARRENDAMIENTO
	DECLARE Var_ClienteID			BIGINT;			-- ID CLIENTE
	DECLARE Var_CuentaBancaria		VARCHAR(20);	-- CUENTA BANCO
	DECLARE Var_Descripcion			VARCHAR(50);	-- DESCRIPCION
	DECLARE Var_DescripArrenda		VARCHAR(50);	-- DESCRIPCION DE ARRENDAMIENTO
	DECLARE Var_DescripCli			VARCHAR(50);	-- DESCRIPCION DE CLIENTE
	DECLARE Var_Poliza				BIGINT(20);		-- NUMERO DE POLIZA
	DECLARE Var_Control				VARCHAR(30);	-- VALOR DE CONTROL
	DECLARE Var_Instrumento			VARCHAR(20);	-- INSTRUMENTO

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;										-- VALOR CERO
	SET Decimal_Cero		:= 0;										-- CADENA VACIA
	SET Cadena_Vacia		:= '';										-- VALOR CERO
	SET Nat_Abono			:= 'A';										-- ABONO
	SET Var_CanalArrenda	:= 1;										-- INDICA QUE SE DEPOSITA REFERENCIANDO UN ARRENDAMIENTO
	SET Var_CanalCliente	:= 2; 										-- INDICA QUE SE DEPOSITA REFERENCIANDO UN CLIENTE
	SET TipoMovDepRef   	:= '1';										-- corresponde con la tabla TIPOSMOVTESO (deposito Referenciado)
	SET Var_NO        		:= 'N';										-- VALOR NO
	SET Var_SI        		:= 'S';										-- VALOR SI

	-- Asignacion de Variables
	SET Aud_FechaActual		:= CURRENT_TIMESTAMP();						-- VALOR DE AUDITORIA
	SET Var_Identificado 	:= 'N';										-- IDENTIFICADO
	SET Var_NoIdentificado  := 'NI';									-- NO IDENTIFICADO
	SET Var_Estatus     	:= 'NI';									-- ESTATUSÂ´POR DEFAULT
	SET Var_ArrendaID   	:= 0;										-- ID DE ARRENDAMIENTO
	SET Var_ClienteID   	:= 0;										-- ID DE CLIENTE
	SET Var_DescripArrenda  := 'DEPOSITO REFERENCIADO ARRENDAMIENTO';	-- DESCRIPCION DE ARRENDAMIENTO
	SET Var_DescripCli    	:= 'DEPOSITO REFERENCIADO CLIENTE';			-- DECRIPCION DE CLIENTE
	SET Var_Poliza      	:= 0;										-- POLIZA POR DEFAULT
	SET Par_Consecutivo   	:= Entero_Cero;								-- CONSECUTIVO
	SET Par_NumErr      	:= Entero_Cero;								-- NUMERO DE ERROR
	SET Par_ErrMen       	:= Cadena_Vacia;							-- MENSAJE DE ERROR

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-DEPOSITOREFEREARRENDAPRO');
			SET Var_Control:= 'sqlException' ;
		END;

		SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS  );
		SET Var_FolioOperacion	:= (SELECT IFNULL(MAX(FolioCargaID),Entero_Cero)+1 FROM DEPOSITOREFEARRENDA);

		SET Par_DepRefereID		:= IFNULL(Par_DepRefereID,Entero_Cero);
		IF(Par_DepRefereID = Entero_Cero)THEN
			SET Par_DepRefereID := (SELECT IFNULL(MAX(DepRefereID),Entero_Cero)+1 FROM DEPOSITOREFEARRENDA);
		END IF;
		SELECT    NumCtaInstit
			INTO  Var_CuentaBancaria
			FROM CUENTASAHOTESO
				WHERE InstitucionID = Par_InstitucionID
					AND NumCtaInstit = Par_NumCtaInstit
					LIMIT 1;

		IF(IFNULL(Var_CuentaBancaria,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr      := 001;
			SET Par_ErrMen      := 'No Existe el Numero de Cuenta Bancaria.';
			SET Var_Control   := 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoCanal,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr      := 002;
			SET Par_ErrMen      := 'El Tipo de Canal esta Vacio.';
			SET Var_Control   := 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaOperacion > Var_FechaSistema) THEN
			SET Par_NumErr      := 003;
			SET Par_ErrMen      := 'La Fecha de Operacion no debe ser mayor a la del sistema.';
			SET Var_Control   := 'institucionID';
			LEAVE ManejoErrores;
		END IF;


		IF(NOT EXISTS (SELECT ArrendaID FROM ARRENDAMIENTOS WHERE ArrendaID = Par_ReferenciaMov ))THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen		:= CONCAT('El numero de arrendamiento[',Par_ReferenciaMov,'] no se encuentra registrado en el Sistema.');
			SET Var_Control		:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;


		-- SI SE TRATA DE UN CANAL DE ARRENDAMIENTO
		IF(Var_CanalArrenda = Par_TipoCanal)THEN  -- ******************************************************************************************************
			SELECT		ArrendaID,		ClienteID
			INTO		Var_ArrendaID,  Var_ClienteID
				FROM ARRENDAMIENTOS
				WHERE ArrendaID = Par_ReferenciaMov;

			--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
			SET Var_Descripcion := Var_DescripArrenda;
			SET Var_Instrumento := Var_ArrendaID;
	  END IF;

	  -- SI SE TRATA DE UN CANAL DE CLIENTE
		IF(Var_CanalCliente = Par_TipoCanal)THEN -- **********************************************************************************************************************
			SELECT    ArrendaID,		ClienteID
				INTO  Var_ArrendaID,	Var_ClienteID
					FROM ARRENDAMIENTOS
					WHERE ClienteID = Par_ReferenciaMov
					LIMIT 1;

			--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
			SET Var_Descripcion := Var_DescripCli;
			SET Var_Instrumento := Var_ArrendaID;
		END IF;

		-- SI EL NUMERO DE CUENTAS NO EXISTE, LA BANDERA DE ESTATUS QUEDA CON VALOR NO IDENTIFICADO
		IF(IFNULL(Var_ArrendaID, Entero_Cero) <> Entero_Cero)THEN
			SET Var_Estatus   := Var_Identificado;
		ELSE
			SET Var_Estatus   := Var_NoIdentificado;
		END IF;

		--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
		SET Var_Cargos    := Decimal_Cero;  -- VALOR DE CARGOS
		SET Var_Abonos    := Par_MontoMov;  -- VALOR DE ABONOS


		INSERT INTO DEPOSITOREFEARRENDA (
			DepRefereID,			FolioCargaID,			InstitucionID,			NumCtaInstit,			NumeroMov,
			FechaCarga,				FechaAplica,			NatMovimiento,			MontoMov,				TipoMov,
			DescripcionMov,			ReferenciaMov,			Estatus,				TipoCanal,				TipoDeposito,
			PolizaID,				EmpresaID,				Usuario,				FechaActual,			DireccionIP,
			ProgramaID,				Sucursal,				NumTransaccion)
		VALUES (
			Par_DepRefereID,		Var_FolioOperacion,   	Par_InstitucionID,		Par_NumCtaInstit,		Aud_NumTransaccion,
			Var_FechaSistema,		Par_FechaOperacion,   	Nat_Abono,      		Par_MontoMov, 			TipoMovDepRef,
			Par_DescripcionMov,		Par_ReferenciaMov,    	Var_Estatus,    		Par_TipoCanal, 			Par_TipoDeposito,
			Entero_Cero,			Aud_EmpresaID,      	Aud_Usuario,    		Aud_FechaActual,  		Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		-- SI TERMINA CON EXITO SE SETEAN LOS VALORES
		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT("Deposito referenciado Agregado: ", CONVERT(Var_FolioOperacion, CHAR));
		SET Par_Consecutivo := Par_DepRefereID;
		SET Var_Control		:= 'institucionID';

	END ManejoErrores;

	-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
	IF (Par_Salida = Var_SI) THEN
	    SELECT  Par_NumErr,
				Par_ErrMen,
				Var_Control,
				Par_Consecutivo;
	END IF;

END TerminaStore$$