-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCUENTASAHOAUTWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCUENTASAHOAUTWSPRO`;
DELIMITER $$

CREATE PROCEDURE `CRCBCUENTASAHOAUTWSPRO`(
# =======================================================================
# ------- STORE PARA DAR DE ALTA CUENTAS DE AHORRO AUTORIZADAS POR WS----
# =======================================================================
	Par_SucursalID			INT(11),			-- ID de la Sucursal
	Par_ClienteID			INT(11),			-- ID del Cliente
	Par_TipoCuentaID		INT(11),			-- ID del tipo de Cuenta
	Par_EsPrincipal			CHAR(1),			-- Indica si la cuenta es principal  S o N
	Par_FechaContratacion	DATE,				-- Fecha de contratacion de la cuenta
	Par_TasaPactada			DECIMAL(14,2),		-- Tasa pactada al contratar la cuenta
    INOUT Par_CuentaAhoID	BIGINT,				-- ID  de la cuenta de ahorro creada

	Par_Salida				CHAR(1),			-- Salida
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11) ,			-- EmpresaID
	Aud_Usuario				INT(11) ,			-- Usuario ID
	Aud_FechaActual			DATETIME,			-- Fecha Actual
	Aud_DireccionIP			VARCHAR(15),		-- Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Nombre de programa
	Aud_Sucursal			INT(11) ,			-- Sucursal ID
	Aud_NumTransaccion		BIGINT(20)			-- Numero de transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_CuentaTranID 	BIGINT(12);		-- Numero de cuenta agregado
	DECLARE Var_Control			VARCHAR(50);	-- Variable de control
	DECLARE Var_InstitucionID	INT(11);		-- Guardara el numero de institucion
	DECLARE Var_FechaSis		DATE;			-- Guardara la fecha actual
	DECLARE Var_MonedaID		INT; 			-- salida no
	DECLARE Var_Etiqueta 		VARCHAR(50);	-- texto libre de etiqueta
	DECLARE Var_EstadoCta		CHAR(1);		-- Tipo de envio de edo cuenta
	DECLARE Var_CuentaAho		BIGINT;			-- Numero de Cuenta
    DECLARE Var_EjecutaCierre	CHAR(1);		-- indica si se esta realizando el cierre de dia

    /* === DATOS DEL CLIENTE ===============*/
    DECLARE Var_TelCelular		VARCHAR(20);	-- Telefono del cliente

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia      	CHAR(1);		-- cadena vacia
	DECLARE Entero_Cero        	INT(11);		-- entero cero
	DECLARE Act_CrcbWS        	INT;			-- Actualizacion de la cuenta.- autorizacion crcb sin pld
	DECLARE Fecha_Vacia         DATE;			-- fecha vacia
	DECLARE Salida_SI			CHAR(1); 		-- salida si
	DECLARE Salida_NO			CHAR(1); 		-- salida no
	DECLARE Key_MonedaID		VARCHAR(20); 	-- salida no
	DECLARE Key_Etiqueta		VARCHAR(20); 	-- salida no
	DECLARE Key_EstadoCta		VARCHAR(20); 	-- salida no
	DECLARE Es_Titular			CHAR(1); 	-- salida no
    DECLARE ValorCierre			VARCHAR(30);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia    		:= '1900-01-01';
	SET Entero_Cero        	:= 0;
	SET Salida_SI        	:= 'S';
	SET Salida_NO        	:= 'N';
	SET Key_MonedaID        := 'MonedaID';
	SET Key_Etiqueta        := 'Etiqueta';
	SET Key_EstadoCta       := 'EstadoCta';
    SET Es_Titular			:= 'S';
	SET Act_CrcbWS			:= 5;
	SET ValorCierre			:= 'EjecucionCierreDia'; -- INDICA SI SE REALIZA EL CIERRE DE DIA.

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr    := 999;
				SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCUENTASAHOAUTWSPRO');
				SET Var_Control   := 'SQLEXCEPTION';
			END;


		SELECT (IFNULL(FechaSistema,Fecha_Vacia))
			INTO Var_FechaSis
			FROM PARAMETROSSIS
			WHERE EmpresaID = Par_EmpresaID;

		SELECT ValorParametro
			INTO Var_MonedaID
            FROM PARAMETROSCRCBWS
            WHERE LlaveParametro = Key_MonedaID;

		SELECT ValorParametro
			INTO Var_Etiqueta
            FROM PARAMETROSCRCBWS
            WHERE LlaveParametro = Key_Etiqueta;

		SELECT ValorParametro
			INTO Var_EstadoCta
            FROM PARAMETROSCRCBWS
            WHERE LlaveParametro = Key_EstadoCta;


        SELECT TelefonoCelular
			INTO Var_TelCelular
            FROM CLIENTES
            WHERE ClienteID = Par_ClienteID;

        SET Var_EjecutaCierre 	:= (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

		-- Validamos que no se este ejecutando el cierre de dia
		IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Salida_SI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := CONCAT('El Numero de Cliente esta vacio.');
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
        END IF;

		-- Validamos el cliente
		IF NOT EXISTS(SELECT ClienteID
			FROM CLIENTES
				WHERE ClienteID = Par_ClienteID) THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := CONCAT('El Numero de Cliente Indicado No Existe.');
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
		END IF;


        IF IFNULL(Par_SucursalID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := CONCAT('El Numero de Sucursal esta vacio.');
			SET Var_Control := 'sucursalID';
			LEAVE ManejoErrores;
        END IF;


        IF NOT EXISTS(SELECT SucursalID
						FROM SUCURSALES
                        WHERE SucursalID = Par_SucursalID) THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := CONCAT('El Numero de Sucursal Indicado No Existe.');
				SET Var_Control := 'sucursalID';
				LEAVE ManejoErrores;
        END IF;



        IF IFNULL(Par_TipoCuentaID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := CONCAT('El Tipo de Cuenta esta vacio.');
			SET Var_Control := 'tipoCuentaID';
			LEAVE ManejoErrores;
        END IF;

        IF NOT EXISTS( SELECT TipoCuentaID
						FROM TIPOSCUENTAS
                        WHERE TipoCuentaID = Par_TipoCuentaID) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := CONCAT('El Tipo de Cuenta Indicado no existe.');
			SET Var_Control := 'tipoCuentaID';
			LEAVE ManejoErrores;
        END IF;

        IF IFNULL(Par_EsPrincipal,Cadena_Vacia)  = Cadena_Vacia THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := CONCAT('Indique si la cuenta es principal.');
			SET Var_Control := 'esPrincipal';
			LEAVE ManejoErrores;
        END IF;

        IF Par_EsPrincipal <> 'S' AND Par_EsPrincipal <> 'N' THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := CONCAT('Indique si la cuenta es principal.');
			SET Var_Control := 'esPrincipal';
			LEAVE ManejoErrores;
        END IF;


        IF NOT EXISTS(SELECT UsuarioID
						FROM USUARIOS
                        WHERE UsuarioID = Aud_Usuario) THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := CONCAT('El usuario de Auditoria no existe');
			SET Var_Control := 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT SucursalID
						FROM SUCURSALES
                        WHERE SucursalID = Aud_Sucursal) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := CONCAT('La Sucursal de Auditoria no existe');
			SET Var_Control := 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_FechaContratacion,Fecha_Vacia) = Fecha_Vacia THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := CONCAT('La Fecha de Contratacion esta vacia');
			SET Var_Control := 'fechaContratacion';
			LEAVE ManejoErrores;
		END IF;

        /* Llamada al alta de cuenta */
        CALL `CUENTASAHOALT`(
			Par_SucursalID,			Par_ClienteID,		Cadena_Vacia,		Var_MonedaID,		Par_TipoCuentaID,
			Par_FechaContratacion,	Var_Etiqueta,		Var_EstadoCta, 		Entero_Cero,		Par_EsPrincipal	,
			Var_TelCelular,			Var_CuentaAho,		Salida_NO,			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion
		);

        IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
        END IF;

        -- Actualizamos el campo de tasa pactada solo para este proceso del WS ya que en el proceso normal no existe.
        UPDATE CUENTASAHO SET
        TasaPactada = Par_TasaPactada
        WHERE CuentaAhoID = Var_CuentaAho;

		/* Autorizacion de la cuenta */
        CALL `CUENTASAHOACT`(Var_CuentaAho,		Aud_Usuario, 		Par_FechaContratacion, 		Cadena_Vacia, 		Act_CrcbWS,
							 Salida_NO,			Par_NumErr, 		Par_ErrMen,					Par_EmpresaID,		Aud_Usuario,
                             Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);

        IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
        END IF;

		SET	Par_NumErr 			:=  Entero_Cero;
		SET	Par_ErrMen 			:= CONCAT('Cuenta Agregada Exitosamente');
        SET Var_Control			:= 'cuentaAhoID';
        SET Par_CuentaAhoID		:= IFNULL(Var_CuentaAho,Entero_Cero);

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr      AS NumErr,
				Par_ErrMen      AS ErrMen,
                IFNULL(Par_CuentaAhoID,Entero_Cero) AS CuentaAhoID;
	END IF;

END TerminaStore$$