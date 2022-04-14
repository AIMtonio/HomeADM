-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOTESOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOTESOALT`;
DELIMITER $$

CREATE PROCEDURE `CUENTASAHOTESOALT`(
# ==========================================================
# ------------SP PARA REGISTRAR CUENTAS BANCARIAS-----------
# ==========================================================
	Par_CuentaAhoID      	BIGINT(12), 		-- Numero de Cuenta de ahorro
	Par_InstitucionID    	INT(11), 			-- Numero de la institucion bancaria
	Par_SucursalInstit   	VARCHAR(50),		-- Numero de la sucursal
	Par_NumCtaInstit     	VARCHAR(20), 		-- Numero de Cuenta Bancaria
	Par_CueClave         	CHAR(18),			-- Numero de la cuenta CLABE

	Par_Chequera         	CHAR(1), 			-- Requiere Chequera S.- Si N.- No
	Par_CuentaCompletaID 	CHAR(25),			-- Numero de la Cuenta Contable
	Par_CentroCostoID    	INT(11), 			-- Numero del Centro de Costos
	Par_Saldo            	DECIMAL(12,2),		-- Saldo de la Cuenta
	Par_Principal        	CHAR(1), 			-- Es principal S.- Si N.- No

	Par_FolioUtilizar	 	BIGINT(20),			-- Numero de Folio de Cheque a Utilizar
	Par_RutaCheque		 	VARCHAR(100),		-- Formato de Impresion de Cheque (Nombre archivo prpt)
	Par_SobregirarSaldo  	CHAR(1),			-- Permirte sobregirar el saldo de la cuenta S.- Si N.- No
    Par_TipoChequera		CHAR(2),			-- Tipo Chequera A- ambas, P-Proforma, E-Estandar
	Par_FolioUtilizarEstan 	BIGINT(20),			-- Numero de Folio de Cheque formato estandar a Utilizar
	Par_RutaChequeEstan	 	VARCHAR(100),		-- Formato de Impresion de Cheque formato estandar(Nombre archivo prpt)
    Par_NumConvenio	 		VARCHAR(30),		-- Numero de convenio
    Par_DescConvenio	 	VARCHAR(100),		-- Descripcion del convenio
    Par_ProtecOrdenPago	 	CHAR(1),			-- Proteccion de ordenes de pago
    Par_AlgClaveRetiro		CHAR(1),			-- Indica si la generacion del la referencia de orden de pago sera Manual(M o Automatico(A)
    Par_VigClaveRetiro		INT(1),				-- Indica los dias de vigencia de la referencia de orden de pago

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario          	INT(11),
	Aud_FechaActual      	DATETIME,
	Aud_DireccionIP      	VARCHAR(20),
	Aud_ProgramaID       	VARCHAR(50),
	Aud_Sucursal         	INT(11),
	Aud_NumTransaccion   	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE VarControl 			VARCHAR(100);
	DECLARE	Var_Consecutivo		BIGINT(12);
	DECLARE Var_Cliente 		INT(11);
	DECLARE	Var_TipoCuentaID 	INT(11);
	DECLARE Var_CuentaAhoID  	BIGINT(12);
	DECLARE Var_NumCtaInstit  	VARCHAR(20);
	DECLARE Var_NumCuentaAhoID	CHAR(11);
	DECLARE Var_NumErr			INT(11);
	DECLARE Var_ErrMen			VARCHAR(100);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE	Estatus_Apert		CHAR(1);
	DECLARE	Var_CuentaBan 		VARCHAR(20);
	DECLARE	EdoCuenta			CHAR(1);
	DECLARE	Var_Moneda 			INT(11);
	DECLARE Var_Activar			INT(11);
	DECLARE	Var_Descripcion 	VARCHAR(50);
	DECLARE Var_Principal 		CHAR(1);
	DECLARE Var_NoPcpal 		CHAR(1);
	DECLARE Con_ChequeraSI		CHAR(1);
    DECLARE TipCheq_Proforma	CHAR(1);
    DECLARE TipCheq_Estandar	CHAR(1);
    DECLARE TipCheq_Ambas		CHAR(1);
    DECLARE Entero_Siete		INT(11);
    DECLARE Con_Manual			CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';						-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';			-- Fecha Vacia
	SET Entero_Cero				:= 0;						-- Entero Cero
    SET SalidaSI				:= 'S';						-- Salida SI
	SET SalidaNO				:= 'N';						-- Salida NO
	SET Decimal_Cero 			:= 0.00;					-- DECIMAL en cero
	SET Estatus_Apert			:= 'A';						-- Estatus Aperturado
	SET Var_CuentaBan 			:= 'Cuenta Bancaria';		-- Etiqueta para la cuenta de Ahorro
	SET EdoCuenta 				:= 'I';						-- El estado de cuenta sera enviado por I.- Internet
	SET Var_Moneda				:= 1;						-- Id de la Moneda Pesos Mexicanos
	SET Var_Activar				:= 1;						-- Numero de Actualizacion para la Apertura
	SET Var_Descripcion 		:= 'Activacion Automatica';	-- Motivo de Activacion
	SET Var_Principal			:= 'S';						-- Si es Principal
	SET Var_NoPcpal				:= 'N';						-- No es Principal
	SET Con_ChequeraSI			:= 'S';						-- Si cuenta con chequera
    SET TipCheq_Proforma		:= 'P';						-- Tipo chequera proforma
    SET TipCheq_Estandar		:= 'E';						-- Tipo chequera estandar
    SET TipCheq_Ambas			:= 'A';						-- Tipo Chequera Ambas
    SET Entero_Siete			:= 7;						-- Entero Siete
    SET Con_Manual				:= 'M';						-- Generacion manual de la referencia


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASAHOTESOALT');
				SET VarControl = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 002;
			SET Par_ErrMen      := 'La institucion esta vacia.';
            SET VarControl		:= 'institucionID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_SucursalInstit, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 003;
			SET Par_ErrMen      := 'La sucursal esta vacia.';
            SET VarControl		:= 'sucursalInstit';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCtaInstit, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 004;
			SET Par_ErrMen      := 'El numero de cuanta bancaria esta vacia.';
            SET VarControl		:= 'numCtaInstit';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CueClave, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 005;
			SET Par_ErrMen      := 'La cuenta clabe esta vacia.';
            SET VarControl		:= 'cueClave';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CueClave, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 006;
			SET Par_ErrMen      := 'No ha seleccionado si requiere de chequera.';
            SET VarControl		:= 'chequera';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaCompletaID, Cadena_Vacia)) != Cadena_Vacia THEN
				-- valida la Cuenta Constable EspecIFicada
				CALL CUENTASCONTABLESVAL(	Par_CuentaCompletaID,	SalidaNO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
											Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
											Aud_NumTransaccion);
				-- Validamos la respuesta
				IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr := 007;
					SET VarControl:= 'cuentaCompletaID';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			ELSE 
				SET Par_NumErr      := 007;
				SET Par_ErrMen      := 'La cuenta contable esta vacia.';
				SET VarControl		:= 'cuentaCompletaID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

		IF(IFNULL(Par_CentroCostoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 008;
			SET Par_ErrMen      := 'El centro de costos esta vacia.';
            SET VarControl		:= 'centroCostoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Saldo, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_Saldo:= Decimal_Cero;
		END IF;

		IF(Par_Saldo < 0)THEN
			SET Par_NumErr      := 009;
			SET Par_ErrMen      := 'El saldo no debe ser negativo';
            SET VarControl		:= 'Saldo';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET Par_VigClaveRetiro := IFNULL(Par_VigClaveRetiro,Entero_Cero);
		SET Par_AlgClaveRetiro := IFNULL(Par_AlgClaveRetiro,Cadena_Vacia);

		IF Par_AlgClaveRetiro = Cadena_Vacia THEN
			SET Par_AlgClaveRetiro := Con_Manual;
		END IF;

		IF Par_VigClaveRetiro = Entero_Cero THEN
			SET Par_VigClaveRetiro := Entero_Siete;
		END IF;


		SELECT 	ClienteInstitucion, TipoCuenta
		INTO 	Var_Cliente, 		Var_TipoCuentaID
			FROM PARAMETROSSIS;


		CALL TMPCUENTASAHOALT(
				Aud_Sucursal, 			Var_Cliente,		Par_CueClave,		Var_Moneda, 	Var_TipoCuentaID,
				Aud_FechaActual, 		Var_CuentaBan,		EdoCuenta,			Aud_EmpresaID, 	Aud_Usuario,
				Aud_FechaActual, 		Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal, 	Aud_NumTransaccion,
				Var_NumCuentaAhoID, 	Var_NumErr,			Var_ErrMen);


		CALL TMPCUENTASAHOACT(
				Var_NumCuentaAhoID,	Aud_Usuario,			Aud_FechaActual,	Var_Descripcion,	Var_Activar,
				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);


		IF EXISTS(SELECT CuentaAhoID
					FROM 	CUENTASAHOTESO
                    WHERE 	InstitucionID	= Par_InstitucionID
                    AND 	Principal		= Var_Principal LIMIT 1)THEN

			IF(Par_Principal = Var_Principal) THEN

				SELECT		CuentaAhoID,		NumCtaInstit
					INTO 	Var_CuentaAhoID,	Var_NumCtaInstit
					FROM 	CUENTASAHOTESO
					WHERE 	InstitucionID	= Par_InstitucionID
					AND 	Principal		= Var_Principal
					LIMIT 1;

				UPDATE CUENTASAHOTESO SET
						Principal 		= Var_NoPcpal,

						EmpresaID       = Aud_EmpresaID,
						Usuario         = Aud_Usuario,
						FechaActual     = Aud_FechaActual,
						DireccionIP     = Aud_DireccionIP,
						ProgramaID      = Aud_ProgramaID,
						Sucursal        = Aud_Sucursal,
						NumTransaccion  = Aud_NumTransaccion
				WHERE 	InstitucionID	= Par_InstitucionID
				AND 	CuentaAhoID 	= Var_CuentaAhoID
				AND 	NumCtaInstit 	= Var_NumCtaInstit;
			END IF;

		ELSE
			SET   Par_Principal := Var_Principal;
		END IF;

		IF(Par_Chequera = Con_ChequeraSI) THEN

			IF(IFNULL(Par_TipoChequera, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr      := 010;
				SET Par_ErrMen      := 'El tipo de Chequera esta Vacia.';
				SET VarControl		:= 'tipoChequera';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoChequera = TipCheq_Proforma)THEN
				IF(Par_FolioUtilizar = Entero_Cero)THEN
					SET Par_NumErr      := 010;
					SET Par_ErrMen      := 'El Ultimo Folio a Utilizar de chequera proforma esta Vacio.';
					SET VarControl		:= 'folioUtilizar';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				SET Par_RutaCheque 	:= IFNULL(Par_RutaCheque,Cadena_Vacia);

				IF(Par_RutaCheque=Cadena_Vacia)THEN
					SET Par_NumErr      := 011;
					SET Par_ErrMen      := 'El Formato de Impresion de Cheque proforma esta Vacio';
					SET VarControl		:= 'rutaCheque';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

			ELSEIF(Par_TipoChequera = TipCheq_Estandar)THEN
				IF(Par_FolioUtilizarEstan = Entero_Cero)THEN
					SET Par_NumErr      := 012;
					SET Par_ErrMen      := 'El Ultimo Folio a Utilizar de chequera estandar esta Vacio.';
					SET VarControl		:= 'folioUtilizarEStan';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				SET Par_RutaChequeEstan := IFNULL(Par_RutaChequeEstan,Cadena_Vacia);

				IF(Par_RutaChequeEstan = Cadena_Vacia)THEN
					SET Par_NumErr      := 013;
					SET Par_ErrMen      := 'El Formato de Impresion de Cheque estandar esta Vacio';
					SET VarControl		:= 'rutaChequeEstan';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

			ELSEIF (Par_TipoChequera = TipCheq_Ambas)THEN
				IF(Par_FolioUtilizar = Entero_Cero)THEN
					SET Par_NumErr      := 010;
					SET Par_ErrMen      := 'El Ultimo Folio a Utilizar de chequera proforma esta Vacio.';
					SET VarControl		:= 'folioUtilizar';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				SET Par_RutaCheque 	:= IFNULL(Par_RutaCheque,Cadena_Vacia);

				IF(Par_RutaCheque = Cadena_Vacia)THEN
					SET Par_NumErr      := 011;
					SET Par_ErrMen      := 'El Formato de Impresion de Cheque proforma esta Vacio';
					SET VarControl		:= 'rutaCheque';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				IF(Par_FolioUtilizarEstan = Entero_Cero)THEN
					SET Par_NumErr      := 012;
					SET Par_ErrMen      := 'El Ultimo Folio a Utilizar de chequera estandar esta Vacio.';
					SET VarControl		:= 'folioUtilizarEStan';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				SET Par_RutaChequeEstan 	:= IFNULL(Par_RutaChequeEstan,Cadena_Vacia);
				IF(Par_RutaChequeEstan = Cadena_Vacia)THEN
					SET Par_NumErr      := 013;
					SET Par_ErrMen      := 'El Formato de Impresion de Cheque estandar esta Vacio';
					SET VarControl		:= 'rutaChequeEstan';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
            END IF;
		END IF;

		INSERT INTO CUENTASAHOTESO (
				CuentaAhoID,			InstitucionID,			SucursalInstit,		NumCtaInstit,		CueClave,
				Chequera, 				CuentaCompletaID, 		CentroCostoID, 		Estatus, 			Saldo,
				SobregirarSaldo, 		Principal, 				TipoChequera,		FolioUtilizar, 		RutaCheque,
                FolioUtilizarEstan, 	RutaChequeEstan, 		NumConvenio,		DescConvenio,		ProtecOrdenPago,
                AlgClaveRetiro,			VigClaveRetiro,
                EmpresaID, 				Usuario, 				FechaActual, 		DireccionIP, 		ProgramaID,
                Sucursal,				NumTransaccion)
		VALUES (
				Var_NumCuentaAhoID,		Par_InstitucionID, 		Par_SucursalInstit, Par_NumCtaInstit, 	Par_CueClave,
				Par_Chequera, 			Par_CuentaCompletaID, 	Par_CentroCostoID, 	Estatus_Apert, 		Par_Saldo,
				Par_SobregirarSaldo,	Par_Principal,		    Par_TipoChequera,	Par_FolioUtilizar, 	Par_RutaCheque,
                Par_FolioUtilizarEstan, Par_RutaChequeEstan,	Par_NumConvenio,	Par_DescConvenio,	Par_ProtecOrdenPago,
                Par_AlgClaveRetiro,		Par_VigClaveRetiro,
                Aud_EmpresaID,			Aud_Usuario,        	Aud_FechaActual,   	Aud_DireccionIP, 	Aud_ProgramaID,
                Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT('Cuenta Bancaria Agregada Exitosamente: ', CONVERT(Par_NumCtaInstit, CHAR));
		SET VarControl		:= 'numCtaInstit';
		SET Var_Consecutivo := Par_NumCtaInstit;

	END ManejoErrores;  -- END del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
