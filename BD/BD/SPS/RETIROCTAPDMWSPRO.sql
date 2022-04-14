-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RETIROCTAPDMWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RETIROCTAPDMWSPRO`;DELIMITER $$

CREATE PROCEDURE `RETIROCTAPDMWSPRO`(



	Par_Num_Socio		INT(11),
	Par_Num_Cta			BIGINT(12),
	Par_Monto			DECIMAL(14,2),
	Par_Fecha_Mov		DATE,
	Par_Folio_Pda		VARCHAR(20),

	Par_Id_Usuario		VARCHAR(100),
	Par_Clave			VARCHAR(40),
	Par_IdServ			INT(11),
	Par_TipoOp			CHAR(1),
	Par_Referencia		VARCHAR(50),

    Par_Salida			CHAR(1),
	INOUT Par_NumErr   	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN


    DECLARE Var_Control	    	VARCHAR(100);
	DECLARE Var_CodigoResp		INT(1);
	DECLARE Var_CodigoDesc		VARCHAR(100);
	DECLARE Var_FechaAutoriza	VARCHAR(20);
	DECLARE Var_Saldo			DECIMAL(14,2);
	DECLARE Var_SaldoDisp		DECIMAL(14,2);
	DECLARE Var_DescripcionMov	VARCHAR(45);
	DECLARE Var_MonedaID		INT(11);
	DECLARE Var_SucurCliente	INT(5);
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_Poliza			BIGINT;
    DECLARE Var_Denominacion	BIGINT;
	DECLARE Var_UsuarioID		INT(11);
	DECLARE Var_SucursalID		INT(11);
	DECLARE Var_CajaID			INT(11);
    DECLARE Var_Origen			CHAR(1);
    DECLARE Var_CobraComision	CHAR(1);
    DECLARE Var_MontoServicio	DECIMAL(14,2);
    DECLARE Var_IvaServicio		DECIMAL(14,2);
    DECLARE Var_Comision		DECIMAL(14,2);
    DECLARE Var_IVAComision		DECIMAL(14,2);
    DECLARE Var_TipoDenom       CHAR(1);
    DECLARE Var_CatalogoServID	INT(11);
	DECLARE TipoMov				INT(4);




	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Entero_Cero			INT(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE NatMovimiento		CHAR(1);
	DECLARE AltaEncPoliza		CHAR(1);
    DECLARE AltaPoliza			CHAR(1);
	DECLARE ConceptoConta		INT(4);
	DECLARE ConceptoAho			INT(4);
	DECLARE NatMovConta			CHAR(1);
	DECLARE TipoOperacion		INT(1);
	DECLARE NatMoviDeno			INT(1);
	DECLARE Var_DenominacionID 	INT(4);
	DECLARE DesMovCaja 			VARCHAR(50);
	DECLARE	Cliente				INT;
	DECLARE	EstatusC			CHAR(1);
	DECLARE	SaldoDisp			DECIMAL(14,2);
	DECLARE	MonedaCon			INT;
	DECLARE	EstatusActivo		CHAR(1);
    DECLARE Var_TipoOpRetiro	CHAR(1);
    DECLARE Var_TipoOpComision	CHAR(1);
    DECLARE Var_TipoOpIvaComi	CHAR(1);
    DECLARE	Pol_Automatica		CHAR(1);
    DECLARE AltaPagoServ		CHAR(1);
    DECLARE OrigenPago			CHAR(1);
    DECLARE Var_NatMoviServ		CHAR(1);
    DECLARE Var_ParBcaMovil		CHAR(1);
	DECLARE Var_Tercero			CHAR(1);
	DECLARE Var_SI	 			CHAR(1);
    DECLARE	Var_NO				CHAR(1);
    DECLARE	Var_Ejecuta			CHAR(1);
    DECLARE Con_Divisa     		INT;
	DECLARE Con_DescMovMoviles 	VARCHAR(40);
	DECLARE Con_MovRetCta		INT(4);
   	DECLARE Con_MovComSer		INT(4);
   	DECLARE Con_MovIVASer		INT(4);


	SET Decimal_Cero			:= 0.0;
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Estatus_Activo			:= 'A';
	SET Salida_NO				:= 'N';
    SET Salida_SI				:= 'S';
	SET TipoMov					:= 29;
	SET NatMovimiento			:= 'C';
	SET AltaEncPoliza			:= 'S';
    SET AltaPoliza				:= 'S';
	SET ConceptoConta			:= 46;
	SET ConceptoAho				:= 1;
	SET NatMovConta				:= 'C';
	SET	EstatusActivo			:= 'A';
	SET TipoOperacion			:= 62;
	SET NatMoviDeno				:= 2;
	SET Var_DenominacionID		:= 7;
	SET DesMovCaja 				:= 'RETIRO DE EFECTIVO A CUENTA';
    SET Var_TipoOpRetiro		:= 'O';
    SET Var_TipoOpComision		:= 'C';
    SET Var_TipoOpIvaComi		:= 'I';
    SET	Pol_Automatica			:= 'A';
    SET AltaPagoServ			:= 'S';
    SET OrigenPago				:= 'M';
    SET Var_NatMoviServ			:= 'A';
    SET Var_ParBcaMovil			:= 'S';
    SET Var_Tercero 			:= 'T';
    SET Var_SI					:= 'S';
    SET Var_NO					:= 'N';
    SET Con_Divisa      		:= 1;
	SET Con_DescMovMoviles		:= 'MEDIOS MOVILES';
 	SET Con_MovRetCta			:= 29;
	SET Con_MovComSer			:= 402;
	SET Con_MovIVASer			:= 403;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-RETIROCTAPDMWSPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

        SET Var_FechaAutoriza	:= CONCAT(CURRENT_DATE,'T',CURRENT_TIME);
		SET Aud_FechaActual		:= NOW();
		SET Var_FechaSistema	:= (SELECT	FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_MonedaID		:= (SELECT	MonedaID FROM CUENTASAHO WHERE CuentaAhoID = Par_Num_Cta);
		SET Var_SucurCliente	:= (SELECT	SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_Num_Socio);
		SET Par_Referencia 		:= CONCAT(Par_Referencia,'-',Par_Folio_Pda);
		SET Var_Saldo 			:= Decimal_Cero;
		SET Var_SaldoDisp  		:= Decimal_Cero;

		SELECT Usu.UsuarioID, Usu.SucursalUsuario, 	CajaID
          INTO Var_UsuarioID, Var_SucursalID, 		Var_CajaID
			FROM CAJASVENTANILLA Ven,
				USUARIOS Usu
			WHERE	Ven.UsuarioID	= Usu.UsuarioID
			  AND	Usu.UsuarioID	= Aud_Usuario
			LIMIT 1;

		SELECT	CatalogoServID, 	Origen,		CobraComision
		  INTO	Var_CatalogoServID, Var_Origen,	Var_CobraComision
			FROM CATALOGOSERV
			WHERE	NumServProve	= Par_IdServ;


		IF(Var_Origen = Var_Tercero) THEN
			IF(Par_TipoOp = Var_TipoOpRetiro) THEN
				SET Var_MontoServicio	:= Par_Monto;
				SET Var_IvaServicio		:= Decimal_Cero;
				SET Var_Comision		:= Decimal_Cero;
				SET Var_IVAComision		:= Decimal_Cero;
                SET Var_Ejecuta			:= Var_SI;
				SET TipoMov				:= Con_MovRetCta;

			ELSEIF(Par_TipoOp = Var_TipoOpComision AND Var_CobraComision = Var_SI) THEN
				SET Var_MontoServicio	:= Decimal_Cero;
				SET Var_IvaServicio		:= Decimal_Cero;
				SET Var_Comision		:= Par_Monto;
				SET Var_IVAComision		:= Decimal_Cero;
				SET Var_Ejecuta			:= Var_SI;
				SET TipoMov				:= Con_MovComSer;

			ELSEIF(Par_TipoOp = Var_TipoOpIvaComi AND Var_CobraComision = Var_SI) THEN
				SET Var_MontoServicio	:= Decimal_Cero;
				SET Var_IvaServicio		:= Decimal_Cero;
				SET Var_Comision		:= Decimal_Cero;
				SET Var_IVAComision		:= Par_Monto;
				SET Var_Ejecuta			:= Var_SI;
				SET TipoMov				:= Con_MovIVASer;

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
				SET TipoMov				:= Con_MovRetCta;

			ELSEIF(Par_TipoOp = Var_TipoOpComision) THEN
				SET Var_MontoServicio	:= Par_Monto;
				SET Var_IvaServicio		:= Decimal_Cero;
				SET Var_Comision		:= Decimal_Cero;
				SET Var_IVAComision		:= Decimal_Cero;
				SET Var_Ejecuta			:= Var_SI;
				SET TipoMov				:= Con_MovComSer;

			ELSEIF(Par_TipoOp = Var_TipoOpIvaComi) THEN
				SET Var_MontoServicio	:= Decimal_Cero;
				SET Var_IvaServicio		:= Par_Monto;
				SET Var_Comision		:= Decimal_Cero;
				SET Var_IVAComision		:= Decimal_Cero;
				SET Var_Ejecuta			:= Var_SI;
				SET TipoMov				:= Con_MovIVASer;
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

            SET Par_NumErr := 002;
			SET Par_ErrMen := 'Estimado Usuario(a), por el Momento No se Pueden Realizar Operaciones Con el Servicio';
            LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Num_Socio,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'El numero de socio esta vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Num_Cta,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'El numero de cuenta esta vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := 'El monto es cero.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Fecha_Mov,Fecha_Vacia))= Fecha_Vacia THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'La Fecha esta vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Id_Usuario,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'El Usuario esta vacio.';
            LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Clave,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'La clave del usuario esta vacia.';
			LEAVE ManejoErrores;
		END IF;


		IF NOT EXISTS(SELECT ClienteID
			FROM CLIENTES
			WHERE	ClienteID	= Par_Num_Socio
			  AND	Estatus		= Estatus_Activo) THEN

            SET Par_NumErr := 009;
			SET Par_ErrMen := 'El cliente no existe.';
			LEAVE ManejoErrores;
		END IF;


		IF NOT EXISTS(SELECT CuentaAhoID
			FROM CUENTASAHO
			WHERE	CuentaAhoID = Par_Num_Cta
			  AND	ClienteID 	= Par_Num_Socio
			  AND	Estatus 	= Estatus_Activo) THEN

            SET Par_NumErr := 010;
			SET Par_ErrMen := 'La cuenta es incorrecta.';
            LEAVE ManejoErrores;
		END IF;

        SELECT 	ClienteID, 	SaldoDispon, 	MonedaID, 	Estatus
		  INTO 	Cliente, 	SaldoDisp,		MonedaCon,	EstatusC
			FROM CUENTASAHO
			WHERE	CuentaAhoID = Par_Num_Cta;

		IF(EstatusC<>EstatusActivo) THEN
			SET Par_NumErr := 011;
			SET Par_ErrMen := 'No se pueden hacer movimientos en esta cuenta.';
            LEAVE ManejoErrores;
		END IF;

		IF(EstatusC = EstatusActivo) THEN
			IF(SaldoDisp < Par_Monto) THEN
				SET Par_NumErr := 012;
				SET Par_ErrMen := 'Saldo Insuficiente.';
                LEAVE ManejoErrores;
			END IF;
		END IF;

        SELECT TipoDenominacion INTO Var_TipoDenom
			FROM DENOMINACIONES
			WHERE	DenominacionID = Var_DenominacionID
			  AND	MonedaID       = Var_MonedaID;

		IF(IFNULL(Var_TipoDenom, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:= 013;
			SET Par_ErrMen		:= 'La Denominacion no Existe.';
			SET Var_Control		:= 'monto';
			LEAVE ManejoErrores;
		END IF;


		SET Var_DescripcionMov	:= (SELECT	Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = TipoMov);
		SET Var_DescripcionMov	:= RTRIM(LTRIM(CONCAT(IFNULL(Var_DescripcionMov,Cadena_Vacia),' ' ,Con_DescMovMoviles)));


		CALL CONTAAHOPRO(
			Par_Num_Cta,		Par_Num_Socio,		Aud_NumTransaccion,		Par_Fecha_Mov,		Var_FechaSistema,
			NatMovimiento,		Par_Monto,		 	Var_DescripcionMov,		Par_Referencia,		TipoMov,
			Var_MonedaID,		Var_SucurCliente,	AltaEncPoliza,			ConceptoConta,		Var_poliza,
			AltaPoliza,			ConceptoAho,		NatMovConta,			Entero_Cero,		Salida_NO,
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Par_NumErr := 014;
			SET Par_ErrMen := 'Error en el retiro de ahorro.';
			LEAVE ManejoErrores;
		END IF;

		CALL CAJASMOVSALT(
			Var_SucursalID, 	Var_CajaID, 	Par_Fecha_Mov, 		Aud_NumTransaccion, 	Var_MonedaID,
			Par_Monto,			Decimal_Cero,	TipoOperacion,		Var_CajaID,				Par_Referencia,
			Decimal_Cero,		Decimal_Cero,	Salida_NO,			Par_NumErr,				Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

        IF (Par_NumErr != Entero_Cero) THEN
			SET Par_NumErr := 015;
			SET Par_ErrMen := 'Error al realizar movimiento en caja.';
			LEAVE ManejoErrores;
		END IF;

		SET TipoOperacion	:= 63;
		CALL CAJASMOVSALT(
			Var_SucursalID, 	Var_CajaID, 	Par_Fecha_Mov, 		Aud_NumTransaccion, 	Var_MonedaID,
			Par_Monto,			Decimal_Cero,	TipoOperacion,		Var_CajaID,				Par_Referencia,
			Decimal_Cero,		Decimal_Cero,	Salida_NO,			Par_NumErr,				Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Par_NumErr := 016;
			SET Par_ErrMen := 'Error al realizar movimiento en caja.';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Ejecuta = Var_SI) THEN

			SET AltaEncPoliza  := 'N';
			CALL CONTAPAGOSERVPDMPRO(
				Var_CatalogoServID,		Entero_Cero,		Aud_Sucursal,		Var_CajaID,			Par_Fecha_Mov,
				Par_Referencia,			Par_Referencia,		Var_MonedaID,		Var_MontoServicio,	Var_IvaServicio,
				Var_Comision,			Var_IVAComision,	Par_Monto,			Par_Num_Socio,		Entero_Cero,
				Entero_Cero,			AltaPagoServ,		AltaEncPoliza,		AltaPoliza,	        Var_NatMoviServ,
				OrigenPago,				Var_Poliza,			Salida_NO,      	Par_NumErr,         Par_ErrMen,
				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Par_NumErr := 021;
				SET Par_ErrMen := 'Error en Movimientos de los Servicios.';
				LEAVE ManejoErrores;
			END IF;

		END IF;

        SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= 'Transaccion Aceptada';

		SELECT IFNULL(Saldo,Decimal_Cero),	IFNULL(SaldoDispon,Decimal_Cero)
		  INTO Var_Saldo,					Var_SaldoDisp
			FROM CUENTASAHO WHERE	CuentaAhoID	= Par_Num_Cta;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr 			AS NumErr,
					Par_ErrMen 			AS ErrMen,
					Var_FechaAutoriza	AS AutFecha,
					Aud_NumTransaccion 	AS FolioAut,
					Var_Saldo			AS SaldoTot,
					Var_SaldoDisp		AS SaldoDisp;
		END IF;

END TerminaStore$$