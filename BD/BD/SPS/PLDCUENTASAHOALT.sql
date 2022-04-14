-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCUENTASAHOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCUENTASAHOALT`;
DELIMITER $$


CREATE PROCEDURE `PLDCUENTASAHOALT`(
	-- SP para dar de alta Cuentas de Ahorro Externas al SAFI
	Par_TipoOperacion				CHAR(2),			-- Tipo de operacion  AC = Alta CUENTA, MC = Modifica CUENTA
	Par_CuentaAhoIDClie				VARCHAR(20),		-- Cuenta de Ahorro Externa
	Par_SucursalID 					INT(11),			-- Numero de Sucursal
	Par_ClienteIDExt				VARCHAR(20),		-- Cliente ID Externo
	Par_Clabe 						VARCHAR(18),		-- Clabe
	Par_MonedaID 					INT(11),			-- Clave de la Moneda
	Par_TipoCuentaID 				INT(11),			-- Tipo de Cuenta
	Par_Etiqueta 					VARCHAR(50),		-- Etiqueta
	Par_EdoCta 			    		CHAR(1),			-- Indicador de Estado de Cuenta
	Par_InstitucionID				INT(11),			-- Numero de Institucion
	Par_EsPrincipal					CHAR(1),			-- Indicador de si es Cuenta Principal
    Par_TelefonoCelular     		VARCHAR(20),		-- Telefono Celular
    INOUT Par_CuentaAho  			BIGINT(12),			-- No se tomara en cuenta con los clientes externos, no se requerira

	Par_Salida						CHAR(1),			-- Parametro indicador si el SP devolvera una respuesta o no
	INOUT	Par_NumErr				INT(11),			-- Parametro indicador del numero de error
	INOUT	Par_ErrMen				VARCHAR(400),		-- Parametro indicador del mensaje de error

	Aud_EmpresaID					INT(11),			-- Parametro de auditoria
	Aud_Usuario						INT(11),			-- Parametro de auditoria
	Aud_FechaActual					DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal					INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametro de auditoria
)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Var_Control					VARCHAR(100);	-- Control en Pantalla
	DECLARE Var_Consecutivo				VARCHAR(20);	-- Consecutivo del Registro
	DECLARE Entero_Cero					INT(11);		-- Entero Cero
	DECLARE Fecha_Vacia					DATE;			-- Fecha Vacia
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena Vacia
	DECLARE Salida_SI					CHAR(1);		-- Indicador de Salida SI
	DECLARE Salida_NO					CHAR(1);		-- Indicador de Salida NO
	DECLARE Var_Fecha_Actual			DATETIME;		-- Fecha Actual

	DECLARE Var_ClienteID				INT(11);		-- Cliente ID del SAFI
	DECLARE Var_CuentaAhoIDClie			VARCHAR(20);	-- Cuenta de Ahorro Externa
	DECLARE Var_NumCuenta				BIGINT(12);		-- Numero de Cuenta
	DECLARE Var_Existencia				VARCHAR(20);	-- Valida la existencia de la Cuenta de Ahorro Externa
	DECLARE Var_FechaActual			DATE;			-- fECHA DEL SISTEMA safi
	DECLARE Var_FechaReg				DATE;			-- Fecha de registro
	
	DECLARE Var_OpAltaCuenta			CHAR(2);		-- Operacion alta cuenta
	DECLARE Var_OpModificaCuenta		CHAR(2);		-- Operacion Modifica cuenta


	--  Asignacion de Constantes
	SET Entero_Cero						:= 0;
	SET Cadena_Vacia					:= '';
	SET Fecha_Vacia						:= '1900-01-01';
	SET Salida_SI						:= 'S';
	SET Salida_NO						:= 'N';
	SET Var_Fecha_Actual				:= NOW();
	
	SET Var_OpAltaCuenta				:= 'AC';			-- Alta cuenta
	SET Var_OpModificaCuenta			:= 'MC';			-- Modifica cuenta

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDCUENTASAHOALT');
				SET Var_Control = 'sqlException';
			END;
			
		IF(Par_TipoOperacion = Cadena_Vacia) THEN
				SET Par_NumErr	:=   003;
				SET Par_ErrMen	:= 'El tipo de operacion se ecuentra vacio';
				SET Var_Control	:= 'ClienteIDExt';
				LEAVE ManejoErrores;
		END IF;
		
		IF(Par_TipoOperacion != Var_OpAltaCuenta AND Par_TipoOperacion != Var_OpModificaCuenta) THEN
				SET Par_NumErr	:=   004;
				SET Par_ErrMen	:= 'El tipo de operacion no es valido';
				SET Var_Control	:= 'ClienteIDExt';
				LEAVE ManejoErrores;
		END IF;
		
			
		SET Var_FechaActual	:= (SELECT FechaSistema FROM PARAMETROSSIS);

		-- Obtenemos el cliente ID de la tabla PLDCLIENTES
		SELECT ClienteID
		INTO Var_ClienteID
		FROM PLDCLIENTES
		WHERE ClienteIDExt = Par_ClienteIDExt;

		SET Var_ClienteID		:= IFNULL(Var_ClienteID,Entero_Cero);
		SET Par_ClienteIDExt	:= IFNULL(Par_ClienteIDExt,Cadena_Vacia);
		SET Par_CuentaAhoIDClie	:= IFNULL(Par_CuentaAhoIDClie,Cadena_Vacia);

		IF(Par_CuentaAhoIDClie = Cadena_Vacia) THEN
				SET Par_NumErr	:=   001;
				SET Par_ErrMen	:= 'El Numero de Cuenta se encuentra vacio.';
				SET Var_Control	:= 'ClienteIDExt';
				LEAVE ManejoErrores;
		END IF;
		
		IF(Par_InstitucionID = Entero_Cero) THEN
			SET Par_InstitucionID := (SELECT InstitucionID FROM PARAMETROSSIS);
		END IF;

		IF(Par_ClienteIDExt = Cadena_Vacia) THEN
				SET Par_NumErr	:=   002;
				SET Par_ErrMen	:= 'El Cliente se encuentra vacio.';
				SET Var_Control	:= 'ClienteIDExt';
				LEAVE ManejoErrores;
		END IF;

		IF(Var_ClienteID = Entero_Cero) THEN
				SET Par_NumErr	:=   003;
				SET Par_ErrMen	:= 'El Cliente no existe.';
				SET Var_Control	:= 'ClienteIDExt';
				LEAVE ManejoErrores;
		END IF;

		SELECT CuentaAhoIDClie
		INTO Var_Existencia
		FROM PLDCUENTASAHO
		WHERE CuentaAhoIDClie = Par_CuentaAhoIDClie;

		SET Var_Existencia := IFNULL(Var_Existencia,Cadena_Vacia);


		
		-- Registro de cuenta ahorro
		IF(Par_TipoOperacion = Var_OpAltaCuenta ) THEN
		
			IF(Var_Existencia != Cadena_Vacia) THEN
					SET Par_NumErr	:=   004;
					SET Par_ErrMen	:= 'La Cuenta ya existe.';
					SET Var_Control	:= 'CuentaAhoIDClie';
					LEAVE ManejoErrores;
			END IF;
		
			CALL CUENTASAHOALT(
				Par_SucursalID,			Var_ClienteID,			Par_Clabe,			Par_MonedaID,			Par_TipoCuentaID,
				Var_FechaActual,			Par_Etiqueta,			Par_EdoCta,			Par_InstitucionID,		Par_EsPrincipal,
				Par_TelefonoCelular,	Par_CuentaAho,			Salida_NO,			Par_NumErr,				Par_ErrMen,
				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion
			);

			IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
			END IF;
			
			-- AUTORZAMOS LA CUENTA DE AHORRO
			CALL CUENTASAHOACT(	
					Par_CuentaAho,			1,						Aud_FechaActual,	Cadena_Vacia,			1,
					Salida_NO,				Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
					
			IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
			END IF;

			INSERT INTO PLDCUENTASAHO(
				CuentaAhoIDClie,		CuentaAhoID,			EmpresaID,			Usuario,				FechaActual,
				DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion
			) VALUES (
				Par_CuentaAhoIDClie,	Par_CuentaAho,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
			);
			
		END IF;
		
		IF(Par_TipoOperacion = Var_OpModificaCuenta ) THEN
		
			SELECT 	PLD.CuentaAhoID,	CUE.FechaReg
			INTO 	Par_CuentaAho,		Var_FechaReg
			FROM PLDCUENTASAHO PLD
			INNER JOIN CUENTASAHO CUE ON PLD.CuentaAhoID = CUE.CuentaAhoID
			WHERE CuentaAhoIDClie = Par_CuentaAhoIDClie;
			
			IF(IFNULL(Par_CuentaAho, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:=   005;
				SET Par_ErrMen	:= 'La cuenta de ahorro no existe';
				SET Var_Control	:= 'CuentaAhoID';
				LEAVE ManejoErrores;
			END IF;
			
			SET Var_FechaReg := IFNULL(Var_FechaReg,Fecha_Vacia);
			
			IF(Par_Salida = Salida_SI) THEN				
				CALL CUENTASAHOMOD(
					Par_CuentaAho,		Par_SucursalID,			Var_ClienteID,		Par_Clabe,		Par_MonedaID,
					Par_TipoCuentaID,	Var_FechaReg,			Par_Etiqueta,		Par_EdoCta,		Par_InstitucionID,
					Par_EsPrincipal,	Par_TelefonoCelular,	Aud_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
					
				LEAVE TerminaStore;
			END IF;

			
		END IF;
		

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Cuenta Agregada Exitosamente: ', Par_CuentaAhoIDClie);
		SET Var_Control	:= 'CuentaAhoIDClie' ;
		SET Var_Consecutivo	:= Par_CuentaAhoIDClie;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr			AS	NumErr,
				Par_ErrMen			AS	ErrMen,
				Var_Control			AS	control,
				IFNULL(Var_Consecutivo, Cadena_Vacia)		AS	consecutivo;
	END IF;

END TerminaStore$$
