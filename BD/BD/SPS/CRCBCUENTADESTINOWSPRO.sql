-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCUENTADESTINOWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCUENTADESTINOWSPRO`;

DELIMITER $$
CREATE PROCEDURE `CRCBCUENTADESTINOWSPRO`(
# =======================================================================
# ------- STORE PARA DAR DE ALTA CUENTAS DESTINO  POR WS---------
# =======================================================================
	Par_ClienteID			INT(11),		-- Cliente que realiza el alta
	Par_CuentaTranID		INT(11),		-- ID de la cuenta destino
	Par_InstitucionID		INT(11),		-- Clave del participante SPEI
	Par_TipoCuenta  		INT(11),		-- Tipo de cuenta Spei
	Par_Cuenta				VARCHAR(20),	-- Numero de cuenta externa

    Par_Beneficiario		VARCHAR(100),	-- Nombre del beneficiario
	Par_Alias				VARCHAR(30),	-- Alias del benificiario
    Par_NumOperacion		INT(11),		-- 1.- ALta 2.- Actualizacion

	Par_Salida				CHAR(1),		-- Salida
	INOUT Par_NumErr		INT(11),		-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de error
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11) ,		-- EmpresaID
	Aud_Usuario				INT(11) ,		-- Usuario ID
	Aud_FechaActual			DATETIME,		-- Fecha Actual
	Aud_DireccionIP			VARCHAR(15),	-- Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Nombre de programa
	Aud_Sucursal			INT(11) ,		-- Sucursal ID
	Aud_NumTransaccion		BIGINT(20)		-- Numero de transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_CuentaTranID 	BIGINT(12);		-- Numero de cuenta agregado
	DECLARE Var_Control			VARCHAR(50);	-- Variable de control
	DECLARE Var_InstitucionID	INT(11);		-- Guardara el numero de institucion
	DECLARE Var_CueClave		VARCHAR(20);	-- Numero de cuenta clabe
	DECLARE Var_FolioClabe		CHAR(5);		-- Folio de institucion para SPEI
	DECLARE Var_Contador		INT(11);		-- Contador
	DECLARE Var_ValorNumero		INT(11);		-- Valor del numero de cuenta clabe a evaluar
	DECLARE Var_ValPondera		INT(11);		-- Valida la ponderacion
	DECLARE Var_Ponderacion		INT(11);		-- Valor de la ponderacion
	DECLARE Var_Resultado		INT(11);		-- Resultado de multiplicar numero * ponderacion
	DECLARE	Var_Suma			INT(11);		-- Suma de todos los resultados
	DECLARE Var_Total			INT(11);		-- Resulatado total del MOD
	DECLARE Var_ValResta		INT(11);		-- Resta de valores totales
	DECLARE Var_DigitoVeri		INT(11);		-- Digito verificador obtenido
	DECLARE Var_UltDigito 		INT(11);		-- Ultimo digito de la cuenta clabe
	DECLARE Var_FechaSis		DATE;			-- Fecha del sistema
	DECLARE Var_AutFecha		DATE;			-- Valor de salida fecha
	DECLARE Var_EstatusCli		CHAR(1);		-- Estatus del cliente
	DECLARE Var_ClienteID		INT(11);		-- ID cliente
    DECLARE Var_UsuarioID		INT(11);		-- ID Usario
    DECLARE Var_EjecutaCierre	CHAR(1);		-- indica si se esta realizando el cierre de dia
	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia      	CHAR(1);		-- cadena vacia
	DECLARE Entero_Cero        	INT(11);		-- entero cero
	DECLARE Entero_Uno			INT(11);		-- entero uno
	DECLARE Entero_Tres			INT(11);		-- entero 3
	DECLARE Entero_Dos			INT(11);		-- entero 2
	DECLARE Entero_Siete		INT(11);		-- entero 7
	DECLARE Entero_Diez 		INT(11);		-- entero 10
	DECLARE Fecha_Vacia         DATE;			-- fecha vacia
	DECLARE SalidaSI			CHAR(1); 		-- salida si
	DECLARE SalidaNO			CHAR(1); 		-- salida no
	DECLARE TipoTarjeta			INT(11);		-- tipo cuenta por tarjeta
	DECLARE TipoCelular			INT(11);		-- tipo cuenta por numero telefonico
	DECLARE TipoClabe			INT(11);		-- tipo cuenta por clabe interbancaria
	DECLARE LongitudTarjeta		INT(11);		-- longitud de tarjeta
	DECLARE LongNumCelular		INT(11);		-- longitud nuemero telefonico
	DECLARE LongitudClabe		INT(11);		-- longitud cuenta clabe
	DECLARE CuentaExterna		CHAR(1);		-- tipo de cuenta Externa
    DECLARE EstatusActivo		CHAR(1);		-- Estatus activo
    DECLARE Tipo_Alta			INT;			-- Indica que se realiza el alta de la cuenta
    DECLARE ValorCierre			VARCHAR(30);	-- iNDICA SI SE REALIZA EL CIERRE DE DIA.
    DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Aplica_Cuenta		CHAR(1);		-- Constante Aplica a Cuenta de Ahorro
	DECLARE EstatusAmbas		CHAR(1);		-- Estatus que maneja Ambas "Cuenta y Credito"

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia    		:= '1900-01-01';
	SET Entero_Cero        	:= 0;
	SET Entero_Uno			:= 1;
	SET Entero_Tres			:= 3;
	SET Entero_Dos			:= 2;
	SET Entero_Siete		:= 7;
	SET Entero_Diez 		:= 10;
	SET SalidaSI      		:= 'S';
	SET	SalidaNO			:= 'N';
	SET TipoTarjeta			:= 3;
	SET TipoCelular			:= 10;
	SET TipoClabe			:= 40;
	SET LongitudTarjeta		:= 16;
	SET LongNumCelular		:= 10;
	SET LongitudClabe		:= 18;
	SET CuentaExterna		:= 'E';
    SET EstatusActivo		:= 'A';
    SET Tipo_Alta			:= 1;
    SET ValorCierre			:= 'EjecucionCierreDia';
    SET Con_NO 				:= 'N';
	SET Aplica_Cuenta		:= 'S';
    SET EstatusAmbas		:= 'A';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr    := 999;
			SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCUENTADESTINOWSPRO');
			SET Var_Control   := 'SQLEXCEPTION';
		END;

		SET Par_EmpresaID := (SELECT EmpresaID FROM PARAMETROSSIS LIMIT 1);

		SET Var_FechaSis  := (SELECT (IFNULL(FechaSistema,Fecha_Vacia))
							FROM PARAMETROSSIS
							WHERE EmpresaID = Par_EmpresaID);

		SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

		SELECT ClienteID, Estatus INTO 	Var_ClienteID,	Var_EstatusCli
			FROM CLIENTES WHERE ClienteID = Par_ClienteID;

		SET Par_Beneficiario	:= UPPER(Par_Beneficiario);
		SET Par_Alias		 	:= UPPER(Par_Alias);

		-- Obtenemos usuario
        SELECT UsuarioID INTO   Var_UsuarioID
            FROM USUARIOS WHERE UsuarioID = Aud_Usuario;

        -- Validamos que no se este ejecutando el cierre de dia
        IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=SalidaSI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
        END IF;

		-- Validamos el cliente
		IF (IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := CONCAT('El Numero de Cliente Indicado No Existe.');
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_EstatusCli,Cadena_Vacia) != EstatusActivo) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'Estimado Usuario(a), su Estatus No le Permite Realizar la Operacion';
			SET Var_Control:= 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		-- Validamos que la institucion Exista y participe de SPEI
		SELECT	InstitucionID, Folio INTO Var_InstitucionID,	Var_CueClave
			FROM INSTITUCIONES
				WHERE  ClaveParticipaSpei = Par_InstitucionID LIMIT 1;

		SET Var_CueClave := IFNULL(Var_CueClave,Cadena_Vacia);

		IF(IFNULL(Var_InstitucionID,Entero_Cero) = Entero_Cero) THEN
			  SET Par_NumErr  := 3;
			  SET Par_ErrMen  := 'La Clave de la Institucion es Incorrecta';
			  SET Var_Control := 'idInstitucion';
			  LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Cuenta,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := CONCAT('El numero de Cuenta Esta Vacio.');
			SET Var_Control := 'cuenta';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Beneficiario,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := CONCAT('El Nombre del Beneficiario Esta Vacio.');
			SET Var_Control := 'beneficiario';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Alias,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := CONCAT('El Alias del Beneficiario Esta Vacio.');
			SET Var_Control := 'alias';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_InstitucionID,Entero_Cero) = Entero_Cero) THEN
			  SET Par_NumErr  := 7;
			  SET Par_ErrMen  := 'La Institucion es Incorrecta';
			  SET Var_Control := 'idInstitucion';
			  LEAVE ManejoErrores;
		END IF;

		-- Se valida los Tipos de cuentas spei
		IF(Par_TipoCuenta != TipoTarjeta AND Par_TipoCuenta != TipoCelular AND Par_TipoCuenta != TipoClabe)THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'El Tipo de Cuenta SPEI No Existe';
			SET Var_Control := 'cuenta';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para cuenta Tipo Tarjeta
		IF(Par_TipoCuenta = TipoTarjeta)THEN

			SET Par_Cuenta := FNLIMPIACARACTERESGEN(Par_Cuenta,'MA');

			IF(LENGTH(Par_Cuenta)<> LongitudTarjeta)THEN
				SET Par_NumErr  := 9;
				SET Par_ErrMen  := 'El Numero de Tarjeta debe Tener 16 Digitos';
				SET Var_Control := 'cuenta';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Validacion para numero de celular
		IF(Par_TipoCuenta = TipoCelular)THEN
			IF(LENGTH(Par_Cuenta)<> LongNumCelular)THEN
				SET Par_NumErr  := 10;
				SET Par_ErrMen  := 'El Numero de Telefono debe Tener 10 Digitos';
				SET Var_Control := 'cuenta';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Validacion para Cuenta Clave
		IF(Par_TipoCuenta = TipoClabe)THEN
			-- longitud
			IF(LENGTH(Par_Cuenta) != LongitudClabe)THEN
				SET Par_NumErr  := 11;
				SET Par_ErrMen  := 'La Clabe Interbancaria debe Tener 18 Digitos';
				SET Var_Control := 'cuenta';
				LEAVE ManejoErrores;
			END IF;

			SET Var_FolioClabe:= substring(Par_Cuenta,Entero_Uno,Entero_Tres);
			-- folio de la institucion
			IF(Var_CueClave != Var_FolioClabe )THEN
				SET Par_NumErr  := 12;
				SET Par_ErrMen  := 'La Cuenta Clabe no coincide con la Institucion.';
				SET Var_Control := 'cuenta';
				LEAVE ManejoErrores;
			END IF;

            IF (IFNULL(Var_UsuarioID,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  := 13;
				SET Par_ErrMen  := 'Usuario Incorrecto.';
				LEAVE ManejoErrores;
			END IF;

			-- Validacion de numero verificador
			SET Var_Contador := Entero_Uno;
			SET Var_Suma	 := Entero_Cero;

			WHILE (Var_Contador < LongitudClabe) DO

				SET Var_ValorNumero := substring(Par_Cuenta,Var_Contador,Entero_Uno);
				SET Var_ValPondera  := Var_Contador%Entero_Tres;

				IF(Var_ValPondera = Entero_Cero)THEN
					SET Var_Ponderacion := Entero_Uno;
				ELSE
					IF(Var_ValPondera = Entero_Dos)THEN
						SET Var_Ponderacion := Entero_Siete;
					ELSE
						SET Var_Ponderacion := Entero_Tres;
					END IF;
				END IF;

				SET Var_Resultado := Var_ValorNumero * Var_Ponderacion;
				SET Var_Suma      := Var_Suma + Var_Resultado;
				SET Var_Contador  := Var_Contador + Entero_Uno;

			END WHILE;

			SET Var_Total 		:= Var_Suma%Entero_Diez;
			SET Var_ValResta	:= Entero_Diez-Var_Total;
			SET Var_DigitoVeri	:= Var_ValResta%Entero_Diez;
			SET Var_UltDigito	:= substring(Par_Cuenta,LongitudClabe,Entero_Uno);

			IF(Var_DigitoVeri != Var_UltDigito)THEN
				SET Par_NumErr  := 14;
				SET Par_ErrMen  := 'Digito verificador incorrecto.';
				SET Var_Control := 'cuenta';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Aud_FechaActual := NOW();

		IF(Par_NumOperacion = Tipo_Alta)THEN

			CALL CUENTASTRANSFERALT(
				Par_ClienteID, 		Entero_Cero,		Par_InstitucionID,		Par_Cuenta,			Par_Beneficiario,
				Par_Alias,			Var_FechaSis,		CuentaExterna,			Entero_Cero,		Entero_Cero,
				Entero_Cero,		Entero_Cero,		Par_TipoCuenta,			Cadena_Vacia,		Con_NO,
				Aplica_Cuenta,		Entero_Cero,
				SalidaNO,			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_CuentaTranID 	:= (SELECT CuentaTranID FROM CUENTASTRANSFER WHERE NumTransaccion = Aud_NumTransaccion);
			SET	Par_NumErr 			:=  Entero_Cero;
			SET	Par_ErrMen 			:= 'Cuenta Destino Agregada Exitosamente';

        ELSE

			CALL CUENTASTRANSFERMOD(
				Par_ClienteID, 		Par_CuentaTranID,		Par_InstitucionID,		Par_TipoCuenta,			Par_Cuenta,
                Par_Beneficiario,	Par_Alias,				CuentaExterna,			Entero_Cero,			Entero_Cero,
				SalidaNO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_CuentaTranID 	:=  Par_CuentaTranID;
			SET	Par_NumErr 			:=  Entero_Cero;
			SET	Par_ErrMen 			:= 'Cuenta Destino Modificada Exitosamente';

		END IF;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Var_CuentaTranID    AS CuentaTranID,
				Par_ClienteID	 	AS ClienteID,
				Par_NumErr      	AS NumErr,
				Par_ErrMen      	AS ErrMen;
	END IF;

END TerminaStore$$