-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ABONOCTAPDMWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ABONOCTAPDMWSPRO`;DELIMITER $$

CREATE PROCEDURE `ABONOCTAPDMWSPRO`(
# =====================================================================================
# ------- STORE PARA REALIZAR UN ABONO A CUENTA Y MOSMTRAR LOS REULTADOS, WS ---------
# =====================================================================================
	Par_Num_Socio		INT(11),			-- numero de socio, ID de la tabla CLIENTES
	Par_Num_Cta			BIGINT(12),			-- numero de la cuenta, ID de la talba CUENTASAHO
	Par_Monto			DECIMAL(14,2),		-- monto a abonar
	Par_Fecha_Mov		DATE,				-- Fecha que se genero el movimiento
	Par_Id_Usuario		VARCHAR(100),		-- clave de usuario, ejemplo: glopez

	Par_Clave			VARCHAR(40),		-- contrasena del usuario
	Par_IdServ			INT(11),			-- Id del Servicio a Pagar
	Par_TipoOp			CHAR(1),			-- Tipo de Operacion a Realizar: Retiro de Capital o Comision
	Par_Referencia		VARCHAR(50),		-- Referencia de la Operacion
	Par_Folio_Pda		VARCHAR(20),
    Par_NumCon			TINYINT UNSIGNED,


	Par_Salida			CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr   	INT(11),			-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),		-- Descripcion del Error

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

	/* Declaracion de variables */
	DECLARE Var_Control	    	VARCHAR(100);
	DECLARE Var_Saldo			DECIMAL(14,2);
	DECLARE Var_SaldoDisp		DECIMAL(14,2);
	DECLARE Var_DescripcionMov	VARCHAR(45);
	DECLARE Var_MonedaID		INT(11);
	DECLARE Var_SucurCli		INT(5);
	DECLARE Var_Poliza			BIGINT;
	DECLARE Var_Denominacion	BIGINT;
	DECLARE Var_FechaSis		DATE;
	DECLARE Var_UsuarioID		INT(11);
	DECLARE Var_SucursalID		INT(11);
	DECLARE Var_CajaID			INT(11);
	DECLARE NatMovi				INT(1);
	DECLARE Var_Promotor    	INT(11);
	DECLARE Var_EstatusCaja		CHAR(1);
	DECLARE Var_RolFR			INT(11);
	DECLARE Var_EstatusUsuario	CHAR(1);
	DECLARE Var_Origen			CHAR(1);
    DECLARE Var_CobraComision	CHAR(1);
    DECLARE Var_MontoServicio	DECIMAL(14,2);
    DECLARE Var_IvaServicio		DECIMAL(14,2);
    DECLARE Var_Comision		DECIMAL(14,2);
    DECLARE Var_IVAComision		DECIMAL(14,2);
    DECLARE Var_TipoDenom       CHAR(1);
    DECLARE Var_CatalogoServID	INT(11);
	DECLARE TipoMov				INT(4);


	/* Declaracion de constantes */
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Entero_Cero			INT(1);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE NatMovimiento		CHAR(1);
	DECLARE AltaEncPoliza		CHAR(1);
	DECLARE ConceptoConta		INT(4);
	DECLARE AltaPoliza			CHAR(1);
	DECLARE NatMovConta			CHAR(1);
	DECLARE ConceptoAho			INT(4);
	DECLARE Aut_Fecha			VARCHAR(20);
	DECLARE TipoOperacion		INT(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Var_DenominacionID 	INT(4);
	DECLARE DesMovCaja 			VARCHAR(50);
    DECLARE AltaPagoServ		CHAR(1);
	DECLARE OrigenPago			CHAR(1);
	DECLARE Var_NatMoviServ		CHAR(1);
    DECLARE Var_ParBcaMovil		CHAR(1);	-- Si el Servicio Participa en Banca Movil
	DECLARE Var_TipoOpRetiro	CHAR(1);
    DECLARE Var_TipoOpComision	CHAR(1);
    DECLARE Var_TipoOpIvaComi	CHAR(1);
    DECLARE Var_Tercero			CHAR(1);
    DECLARE Var_SI	 			CHAR(1);
	DECLARE	Var_NO				CHAR(1);
    DECLARE	Var_Ejecuta			CHAR(1);	-- Variable que define si se ejecuta l parte contable de pago de servicio
    DECLARE Con_Divisa     		INT;
   	DECLARE Con_DescMovMoviles 	VARCHAR(40);
   	DECLARE Con_MovAboCta		INT(4);
   	DECLARE Con_MovComSer		INT(4);
   	DECLARE Con_MovIVASer		INT(4);

	/* Asignacion de constantes */
	SET Decimal_Cero		:= 0.0;
	SET Entero_Cero			:= 0;
    SET	Cadena_Vacia		:= '';
	SET Estatus_Activo		:= 'A';
	SET NatMovimiento		:= 'A';
	SET AltaEncPoliza		:= 'S';
	SET ConceptoConta		:= 45;
	SET AltaPoliza			:= 'S';
	SET NatMovConta			:= 'A';
	SET ConceptoAho			:= 1;
	SET TipoOperacion		:= 62;
	SET Salida_NO			:= 'N';
    SET Salida_SI			:= 'S';
	SET Var_DenominacionID	:= 7;
	SET DesMovCaja 			:= 'ABONO DE EFECTIVO EN CUENTA';
	SET NatMovi				:= 1;
    SET AltaPagoServ		:= 'S';						-- Alta Pago de Servicio: Si
    SET OrigenPago			:= 'M';						-- Origen de pago Banca Movil
    SET Var_NatMoviServ		:= 'C';						-- Naturaleza del Movimiento para el pago de servicio
	SET Var_ParBcaMovil		:= 'S';						-- Si el Servicio Participa en Banca Movil
	SET Var_TipoOpRetiro	:= 'O';
    SET Var_TipoOpComision	:= 'C';
    SET Var_TipoOpIvaComi	:= 'I';
	SET Var_Tercero 		:= 'T';						-- Tercero
    SET Var_SI				:= 'S';						-- Si
	SET Var_NO				:= 'N';						-- NO
	SET Con_Divisa      	:= 1;           			-- Concepto del Movimiento Contable: Divisa
	SET Con_DescMovMoviles	:= 'MEDIOS MOVILES';		-- Descripcion para medios moviles para edocta.
    SET Con_MovAboCta		:= 28; 						-- Abono a cuenta
	SET Con_MovComSer		:= 402; 					-- Comision Servicio
	SET Con_MovIVASer		:= 403; 					-- Iva Servicio


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ABONOCTAPDMWSPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SET Aud_FechaActual		:= NOW();
		SET Aut_Fecha			:= CONCAT(CURRENT_DATE,'T',CURRENT_TIME);
		SET Var_FechaSis		:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_MonedaID		:= (SELECT MonedaID FROM CUENTASAHO WHERE CuentaAhoID = Par_Num_Cta);
		SET Var_SucurCli		:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_Num_Socio);
		SET Par_Referencia 		:= CONCAT(Par_Referencia,'-',Par_Folio_Pda);
		SET Var_Saldo			:= Decimal_Cero;
		SET Var_SaldoDisp		:= Decimal_Cero;

		/* Valida que el usuario sea valido */
		IF EXISTS (SELECT Usu.UsuarioID
			FROM USUARIOS Usu,
				PARAMETROSCAJA Par,
				CAJASVENTANILLA Caj
			WHERE	Usu.Clave 			= Par_Id_Usuario
			  AND	Usu.Contrasenia 	= Par_Clave
			  AND	Usu.RolID 			= Par.EjecutivoFR
			  AND	Usu.Estatus 		= Estatus_Activo
			  AND	Usu.UsuarioID 		= Caj.UsuarioID
			  AND	Caj.Estatus 		= Estatus_Activo
			  AND	Caj.EstatusOpera	= Estatus_Activo)THEN


			SELECT	Usu.UsuarioId,	Usu.SucursalUsuario,	CajaID
			  INTO 	Var_UsuarioID,	Var_SucursalID,			Var_CajaID
				FROM CAJASVENTANILLA Ven,
					USUARIOS Usu
				WHERE	Ven.UsuarioID	= Usu.UsuarioID
				  AND	Ven.Estatus		= Estatus_Activo
				  AND	Usu.Clave		= Par_Id_Usuario
				  AND	Usu.Contrasenia = Par_Clave
				LIMIT 1;

			SELECT	CatalogoServID, 		Origen,		CobraComision
			  INTO	Var_CatalogoServID, 	Var_Origen,	Var_CobraComision
				FROM CATALOGOSERV
				WHERE	NumServProve	= Par_IdServ;

            -- Se valida el tipo de movimiento
			IF(Var_Origen = Var_Tercero) THEN
				IF(Par_TipoOp = Var_TipoOpRetiro) THEN
					SET Var_MontoServicio	:= Par_Monto;
					SET Var_IvaServicio		:= Decimal_Cero;
					SET Var_Comision		:= Decimal_Cero;
					SET Var_IVAComision		:= Decimal_Cero;
					SET Var_Ejecuta			:= Var_SI;
                    SET TipoMov				:= Con_MovAboCta; -- Abono a cuenta
				ELSEIF(Par_TipoOp = Var_TipoOpComision AND Var_CobraComision = Var_SI) THEN
					SET Var_MontoServicio	:= Decimal_Cero;
					SET Var_IvaServicio		:= Decimal_Cero;
					SET Var_Comision		:= Par_Monto;
					SET Var_IVAComision		:= Decimal_Cero;
					SET Var_Ejecuta			:= Var_SI;
					SET TipoMov				:= Con_MovComSer; -- Comision Servicio
				ELSEIF(Par_TipoOp = Var_TipoOpIvaComi AND Var_CobraComision = Var_SI) THEN
					SET Var_MontoServicio	:= Decimal_Cero;
					SET Var_IvaServicio		:= Decimal_Cero;
					SET Var_Comision		:= Decimal_Cero;
					SET Var_IVAComision		:= Par_Monto;
					SET Var_Ejecuta			:= Var_SI;
                    SET TipoMov				:= Con_MovIVASer; -- Iva Servicio
				ELSE
					SET Par_NumErr := 002;
					SET Par_ErrMen := 'El Servicio No Esta Configurado para Realizar la Operacion.';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				IF(Par_TipoOp = Var_TipoOpRetiro) THEN
					SET Var_MontoServicio	:= Decimal_Cero;
					SET Var_IvaServicio		:= Decimal_Cero;
					SET Var_Comision		:= Decimal_Cero;
					SET Var_IVAComision		:= Decimal_Cero;
					SET Var_Ejecuta			:= Var_NO;
					SET TipoMov				:= Con_MovAboCta; -- Abono a cuenta
				ELSEIF(Par_TipoOp = Var_TipoOpComision) THEN
					SET Var_MontoServicio	:= Par_Monto;
					SET Var_IvaServicio		:= Decimal_Cero;
					SET Var_Comision		:= Decimal_Cero;
					SET Var_IVAComision		:= Decimal_Cero;
                    SET Var_Ejecuta			:= Var_SI;
                    SET TipoMov				:= Con_MovComSer; -- Comision Servicio
				ELSEIF(Par_TipoOp = Var_TipoOpIvaComi) THEN
					SET Var_MontoServicio	:= Decimal_Cero;
					SET Var_IvaServicio		:= Par_Monto;
					SET Var_Comision		:= Decimal_Cero;
					SET Var_IVAComision		:= Decimal_Cero;
                    SET Var_Ejecuta			:= Var_SI;
                    SET TipoMov				:= Con_MovIVASer; -- Iva Servicio
				ELSE
					SET Par_NumErr := 002;
					SET Par_ErrMen := 'El Servicio No Esta Configurado para Realizar la Operacion.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

            IF NOT EXISTS(SELECT CatalogoServID
				FROM CATALOGOSERV
				WHERE	CatalogoServID	= Var_CatalogoServID
				  AND	BancaMovil		= Var_ParBcaMovil) THEN
					SET Par_NumErr := 003;
					SET Par_ErrMen := 'Estimado Usuario(a), por el Momento No se Pueden Realizar Operciones Con el Servicio';
					LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Num_Socio,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := 'El numero de socio esta vaci­o.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Num_Cta,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 005;
				SET Par_ErrMen := 'El numero de cuenta esta vaci­o.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto,Decimal_Cero))= Decimal_Cero THEN
				SET Par_NumErr := 006;
				SET Par_ErrMen := 'El monto es cero.';
				LEAVE ManejoErrores;
			END IF;

			/* Valida que la cuenta, el cliente sean validos*/
			IF NOT EXISTS (SELECT CuentaAhoID
				FROM CUENTASAHO Cue,
					CLIENTES Cli
				WHERE	Cue.CuentaAhoID = Par_Num_Cta
				  AND	Cli.ClienteID = Par_Num_Socio
				  AND	Cue.ClienteID = Cli.ClienteID
				  AND	Cli.Estatus = Estatus_Activo
				  AND	Cue.Estatus = Estatus_Activo)THEN

				SET Par_NumErr := 007;
				SET Par_ErrMen := 'La cuenta es incorrecta.';
				LEAVE ManejoErrores;
			END IF;

			SELECT TipoDenominacion INTO Var_TipoDenom
				FROM DENOMINACIONES
				WHERE	DenominacionID = Var_DenominacionID
				  AND	MonedaID       = Var_MonedaID;

			IF(IFNULL(Var_TipoDenom, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr		:= 008;
				SET Par_ErrMen		:= 'La Denominacion no Existe.';
				SET Var_Control		:= 'monto';
				LEAVE ManejoErrores;
			END IF;

            # Se consulta la descripcion del Movimiento
            SET Var_DescripcionMov	:= (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = TipoMov);
			SET Var_DescripcionMov	:= RTRIM(LTRIM(CONCAT(IFNULL(Var_DescripcionMov,Cadena_Vacia),' ' ,Con_DescMovMoviles)));

            CALL CONTAAHOPRO(
				Par_Num_Cta,		Par_Num_Socio,		Aud_NumTransaccion,		Var_FechaSis,		Var_FechaSis,
				NatMovimiento,		Par_Monto,		 	Var_DescripcionMov,		Par_Referencia,		TipoMov,
				Var_MonedaID,		Var_SucurCli,		AltaEncPoliza,			ConceptoConta,		Var_poliza,
				AltaPoliza,			ConceptoAho,		NatMovConta,			Entero_Cero,		Salida_NO,
                Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
                Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

            IF (Par_NumErr != Entero_Cero) THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen := 'Error en el Abono de Ahorro.';
				LEAVE ManejoErrores;
			END IF;

            # Realiza el alta de los Movimientos de Caja
			CALL CAJASMOVSALT(
			   Var_SucursalID, 	   	Var_CajaID, 	Var_FechaSis, 		Aud_NumTransaccion, 	Var_MonedaID,
			   Par_Monto,			Decimal_Cero,	TipoOperacion,		Var_CajaID,				Par_Referencia,
			   Decimal_Cero,		Decimal_Cero,	Salida_NO,			Par_NumErr, 			Par_ErrMen,
			   Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
			   Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Par_NumErr := 010;
				SET Par_ErrMen := 'Error al realizar movimiento en caja.';
				LEAVE ManejoErrores;
			END IF;

			SET TipoOperacion := 63;
			CALL CAJASMOVSALT(
				Var_SucursalID, 		Var_CajaID, 		Var_FechaSis, 		Aud_NumTransaccion, 	Var_MonedaID,
				Par_Monto,				Decimal_Cero,		TipoOperacion,		Var_CajaID,				Par_Referencia,
				Decimal_Cero,			Decimal_Cero,		Salida_NO,			Par_NumErr, 			Par_ErrMen,
				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Par_NumErr := 011;
				SET Par_ErrMen := 'Error al realizar movimiento en caja.';
				LEAVE ManejoErrores;
			END IF;

            # Generar los movimientos operativos de las denominaciones de la caja asi como la afectacion contable
            # Su ejecucion la Define el Servicio
			IF(Var_Ejecuta = Var_SI) THEN

                SET AltaEncPoliza  := 'N';
				CALL CONTAPAGOSERVPDMPRO(
					Var_CatalogoServID,	Entero_Cero,		Aud_Sucursal,		Var_CajaID,			Par_Fecha_Mov,
					Par_Referencia,		Par_Referencia,		Var_MonedaID,		Var_MontoServicio,	Var_IvaServicio,
					Var_Comision,		Var_IVAComision,	Par_Monto,			Par_Num_Socio,		Entero_Cero,
					Entero_Cero,		AltaPagoServ,		AltaEncPoliza,		AltaPoliza,			Var_NatMoviServ,
					OrigenPago,			Var_Poliza,			Salida_NO,      	Par_NumErr,			Par_ErrMen,
					Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Par_NumErr := 016;
					SET Par_ErrMen := 'Error en Movimientos de los Servicios.';
					LEAVE ManejoErrores;
				END IF;

			END IF;

			SELECT	IFNULL(Saldo,Decimal_Cero), IFNULL(SaldoDispon,Decimal_Cero)
			  INTO	Var_Saldo, 					Var_SaldoDisp
				FROM CUENTASAHO
                WHERE	CuentaAhoID	= Par_Num_Cta;

            SET Par_NumErr := 000;
			SET Par_ErrMen := 'Transaccion Realizada.';

		ELSE

			SELECT	Caj.CajaID,	Caj.EstatusOpera,	Usu.RolID,	Usu.Estatus
			  INTO	Var_CajaID, Var_EstatusCaja,	Var_RolFR,	Var_EstatusUsuario
				FROM USUARIOS Usu,
					PARAMETROSCAJA Par,
					CAJASVENTANILLA Caj
				WHERE	Usu.Clave		= Par_Id_Usuario
				  AND 	Usu.Contrasenia = Par_Clave
				  AND 	Usu.UsuarioID	= Caj.UsuarioID;


			SET Var_CajaID			:= IFNULL(Var_CajaID, Entero_Cero);
			SET Var_EstatusCaja		:= IFNULL(Var_EstatusCaja, Cadena_Vacia);
			SET Var_RolFR			:= IFNULL(Var_RolFR, Entero_Cero);
			SET Var_EstatusUsuario	:= IFNULL(Var_EstatusUsuario, Cadena_Vacia);

			SET Par_NumErr := 001;
			SET Par_ErrMen := CONCAT('Usuario y/o Contrasenia incorrectos.|  Caja: ',Var_CajaID, ' con estatus de operacion: ',Var_EstatusCaja, '  | El Rol del Usuario es: ',Var_RolFR , ' | con estatus: ',Var_EstatusUsuario );

		END IF;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr 			AS NumErr,
					Par_ErrMen 			AS ErrMen,
					Aut_Fecha			AS AutFecha,
					Aud_NumTransaccion 	AS FolioAut,
					Var_Saldo			AS SaldoTot,
					Var_SaldoDisp		AS SaldoDisp;
		END IF;

END TerminaStore$$