-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROTECPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPLICAPROTECPRO`;
DELIMITER $$

CREATE PROCEDURE `CLIAPLICAPROTECPRO`(

	Par_ClienteID			INT(11),
	Par_UsuarioAut			INT(11),
	Par_Comentario			VARCHAR(300),

	Par_NumAct				INT,
	Par_Salida				CHAR(1),
	inout	Par_NumErr 		INT,
	inout	Par_ErrMen  	VARCHAR(350),
	Par_EmpresaID			INT,

	Aud_Usuario         	INT,
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),

	Aud_NumTransaccion  	bigint(20)
		)
TerminaStore:BEGIN


DECLARE Var_FechaSistema			DATE;
DECLARE Var_Clave					VARCHAR(45);
DECLARE Var_UsuarioID				INT(11);
DECLARE Var_UsuarioReg				INT(11);
DECLARE Var_Control					VARCHAR(100);
DECLARE Var_MonedaID				INT(11);
DECLARE Var_SucCliente				INT(11);
DECLARE var_Poliza					bigint;
DECLARE Var_CuentaProtecCta			VARCHAR(25);
DECLARE Var_HaberExSocios			VARCHAR(25);
DECLARE Var_CentroCostosID			INT(11);
DECLARE Var_PolizaID				bigint(20);
DECLARE Var_MontoMaxProtec			DECIMAL(14,2);
DECLARE Var_MontoAplicadoCreditos	DECIMAL(14,2);
DECLARE	Var_MonAplicaCuenta			DECIMAL(14,2);
DECLARE	Var_MontoTotal				DECIMAL(14,2);
DECLARE Var_Estatus 				CHAR(1);
DECLARE Var_NomCentroCostos			VARCHAR(30);

DECLARE Var_RolID			INT(11);

DECLARE Entero_Cero			INT;
DECLARE Salida_SI			CHAR(1);
DECLARE Salida_NO			CHAR(1);
DECLARE Cadena_Vacia		CHAR(1);

DECLARE Est_Autorizado		CHAR(1);
DECLARE Est_Pagado			CHAR(1);
DECLARE Est_Cancelado		CHAR(1);

DECLARE Nat_Cargo			CHAR(1);
DECLARE Nat_Abono			CHAR(1);
DECLARE DescripCargoCta		VARCHAR(100);
DECLARE DescripAbonoCta		VARCHAR(100);

DECLARE TipoMovAhoID		INT;
DECLARE VarPerfilAutoriProtec		INT;
DECLARE AltaEncPolizaNO		CHAR(1);
DECLARE AltaDetPolizaSI		CHAR(1);

DECLARE ConceptoCon			INT;
DECLARE ConceptoAho			INT;
DECLARE ConOpera			INT;
DECLARE ConceptoAhoCargo	INT;
DECLARE DescripcionMovi		VARCHAR(100);
DECLARE Programa			VARCHAR(100);
DECLARE PolAutomatica		CHAR(1);
DECLARE Rechazar			INT(11);
DECLARE Autorizar			INT(11);
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Var_Si				CHAR(1);
DECLARE Var_TipoInsCli		INT(11);
DECLARE	For_SucOrigen		CHAR(3);
DECLARE	For_SucCliente		CHAR(3);


SET Entero_Cero			:=0;
SET Decimal_Cero		:= 0.0;
SET Cadena_Vacia		:='';

SET Var_Si				:='S';
SET Salida_SI			:='S';
SET Salida_NO			:='N';

SET Est_Autorizado		:='A';
SET Est_Pagado			:='P';
SET Est_Cancelado		:='C';

SET Nat_Cargo			:='C';
SET Nat_Abono			:='A';
SET DescripCargoCta		:='FDO.PROT. AHRRO. P.SOC. Y PTMO PRIMERO SEGUROS';
SET DescripAbonoCta		:='HABERES DE EXSOCIOS';
SET TipoMovAhoID		:=89;
SET AltaEncPolizaNO		:='N';
SET AltaDetPolizaSI		:='S';
SET ConceptoCon			:=800;
SET ConceptoAho			:=31;
SET ConOpera			:=31;
SET ConceptoAhoCargo	:=30;
SET DescripcionMovi		:='PROTECCION AL AHORRO Y CREDITO';
SET Programa			:='CLIAPLICAPROTECPRO';
SET PolAutomatica		:='A';
SET Autorizar			:= 1;
SET Rechazar			:= 2;
SET Var_TipoInsCli		:= 4;
SET	For_SucOrigen		:= '&SO';
SET	For_SucCliente		:= '&SC';

ManejoErrores:Begin

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CLIAPLICAPROTECPRO');
		SET Var_Control = 'sqlException' ;
	END;



SET Aud_FechaActual		:= now();

SELECT		FechaSistema ,		MonedaBaseID
	INTO	Var_FechaSistema,	Var_MonedaID
	FROM	PARAMETROSSIS
	LIMIT 1;

IF not exists(SELECT ClienteID
				FROM CLIENTES
				 WHERE ClienteID = Par_ClienteID)THEN
	SET Par_NumErr	:=1;
	SET Par_ErrMen	:='El Cliente indicado no existe';
	SET Var_Control	:= 'clienteID';
	LEAVE ManejoErrores;
END IF;


SET Var_Estatus	:= ( SELECT Estatus
						FROM CLIAPLICAPROTEC WHERE ClienteID = Par_ClienteID);

SET Var_Estatus	:= ifnull(Var_Estatus,Cadena_Vacia);

CASE Var_Estatus
	WHEN Est_Autorizado	THEN
		SET Par_NumErr	:= 3;
		SET Par_ErrMen	:= 'La Solicitud de Proteccion al Ahorro y Credito esta Autorizada';
		SET Var_Control	:= 'clienteID';
		LEAVE ManejoErrores;
	WHEN Est_Pagado		THEN
		SET Par_NumErr	:= 3;
		SET Par_ErrMen	:= 'La Solicitud de Proteccion al Ahorro y Credito esta Pagada';
		SET Var_Control	:= 'clienteID';
		LEAVE ManejoErrores;
	WHEN Est_Cancelado	THEN
		SET Par_NumErr	:= 3;
		SET Par_ErrMen	:= 'La Solicitud de Proteccion al Ahorro y Credito esta Cancelada';
		SET Var_Control	:= 'clienteID';
		LEAVE ManejoErrores;
	ELSE
		SET Par_NumErr	:= 0;
END CASE;



SELECT UsuarioReg INTO Var_UsuarioReg
			FROM CLIAPLICAPROTEC
				WHERE ClienteID	= Par_ClienteID;



SELECT Cli.SucursalOrigen INTO Var_SucCliente
		FROM CLIENTES Cli
		WHERE Cli.ClienteID = Par_ClienteID;


SELECT	CtaProtecCta,			HaberExSocios,		MontoMaxProtec,			CCProtecAhorro,			PerfilAutoriProtec
INTO	Var_CuentaProtecCta,	Var_HaberExSocios,	Var_MontoMaxProtec,		Var_NomCentroCostos,	VarPerfilAutoriProtec
	FROM PARAMETROSCAJA
	WHERE  EmpresaID = Par_EmpresaID;

SET Var_CentroCostosID    := FNCENTROCOSTOS(Aud_Sucursal);

SET Var_CuentaProtecCta := ifnull(Var_CuentaProtecCta, Cadena_Vacia);
SET Var_HaberExSocios	:=ifnull(Var_HaberExSocios, Cadena_Vacia);
SET Var_CentroCostosID	:=ifnull(Var_CentroCostosID, Entero_Cero);

	SELECT  	RolID
		INTO	Var_RolID
		FROM USUARIOS
		WHERE UsuarioID = Par_UsuarioAut;


IF (Par_NumAct = Autorizar)THEN
	IF(Var_RolID != VarPerfilAutoriProtec)THEN
		SET Par_NumErr	:=5;
		SET Par_ErrMen	:= 'El Usuario no tiene El Perfil para Autorizar .';
		SET Var_Control	:= 'claveUsuario';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_UsuarioReg = Par_UsuarioAut)THEN
		SET Par_NumErr	:=5;
		SET Par_ErrMen	:='El Usuario que Autoriza no puede ser el mismo que Registra';
		SET Var_Control	:= 'claveUsuario';
		LEAVE ManejoErrores;
	END IF;


	SET Var_MontoAplicadoCreditos	:= ifnull((SELECT sum(MontoAplicaCred) FROM CLIAPROTECCRED WHERE ClienteID = Par_ClienteID), Decimal_Cero);
	SET Var_MonAplicaCuenta			:= ifnull((SELECT sum(MonAplicaCuenta) FROM CLIAPROTECCUEN WHERE ClienteID = Par_ClienteID), Decimal_Cero);
	SET Var_MontoTotal				:= Var_MonAplicaCuenta + Var_MontoAplicadoCreditos;

	SET Var_MontoAplicadoCreditos	:= ifnull(Var_MontoAplicadoCreditos,Decimal_Cero);
    SET Var_MonAplicaCuenta			:= ifnull(Var_MonAplicaCuenta,Decimal_Cero);
	IF(Var_MontoTotal > Var_MontoMaxProtec)THEN
		SET Par_NumErr	:=8;
		SET Par_ErrMen	:='La Suma de la Proteccion de Credito y Ahorro excede el Monto Maximo de la Proteccion';
		LEAVE ManejoErrores;
	END IF;


	IF LOCATE(For_SucOrigen, Var_NomCentroCostos) > 0 THEN
		SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
	ELSE
		IF LOCATE(For_SucCliente, Var_NomCentroCostos) > 0 THEN
				IF (Var_SucCliente > 0) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
				ELSE
					SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
				END IF;
		ELSE
			SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
		END IF;
	END IF;



	IF( Var_MonAplicaCuenta > Decimal_Cero )THEN

		CALL MAESTROPOLIZAALT(
			Var_PolizaID,		Par_EmpresaID,	Var_FechaSistema, 	PolAutomatica,		ConceptoCon,
			DescripcionMovi,	Salida_NO, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);



		CALL DETALLEPOLIZAALT(
			Par_EmpresaID,		Var_PolizaID,		Var_FechaSistema,		Var_CentroCostosID,			Var_CuentaProtecCta,
			Par_ClienteID,		Var_MonedaID,		Var_MonAplicaCuenta,	Entero_Cero,			DescripCargoCta,
			Par_ClienteID,		Programa,			Var_TipoInsCli,			Cadena_Vacia,			Cadena_Vacia,
			Cadena_Vacia,		Salida_NO,			Par_NumErr, 			Par_ErrMen,				Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
		);


		CALL DETALLEPOLIZAALT(
			Par_EmpresaID,		Var_PolizaID,		Var_FechaSistema,		Var_CentroCostosID,			Var_HaberExSocios,
			Par_ClienteID,		Var_MonedaID,		Entero_Cero,			Var_MonAplicaCuenta,	DescripAbonoCta,
			Par_ClienteID,		Programa,			Var_TipoInsCli,			Cadena_Vacia,			Cadena_Vacia,
			Cadena_Vacia,		Salida_NO,			Par_NumErr, 			Par_ErrMen,				Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
		);

		UPDATE PROTECCIONES SET
			AplicaProtecAho		= Var_Si,
			MontoProtecAho		= Var_MonAplicaCuenta,
			SaldoFavorCliente	= ifnull(SaldoFavorCliente,0) + Var_MonAplicaCuenta,
			TotalBeneAplicado	= ifnull(TotalBeneAplicado,0) + Var_MonAplicaCuenta
		WHERE ClienteID 		= Par_ClienteID;
	END IF;

	IF( Var_MontoAplicadoCreditos > Decimal_Cero )THEN

		UPDATE PROTECCIONES SET
			AplicaProtecCre		= Var_Si,
			MontoProtecCre		= Var_MontoAplicadoCreditos,
			TotalBeneAplicado	= ifnull(TotalBeneAplicado,0) + Var_MontoAplicadoCreditos,
			TotalAdeudoCre		= TotalAdeudoCre + Var_MontoAplicadoCreditos
		WHERE ClienteID 		= Par_ClienteID;
	END IF;


	UPDATE  CLIAPLICAPROTEC SET
		Estatus 		= Est_Autorizado,
		Comentario		= Par_Comentario,
		FechaAutoriza	= Var_FechaSistema,
		UsuarioAut		= Par_UsuarioAut,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE ClienteID = Par_ClienteID;

	SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= concat('Seguro de Proteccion al Ahorro y Credito del safilocale.cliente : ',
						convert(Par_ClienteID,CHAR),', Autorizado Exitosamente');
	SET Var_Control	:= 'clienteID';

END IF;


IF (Par_NumAct = Rechazar)THEN
	IF(Var_RolID != VarPerfilAutoriProtec)THEN
		SET Par_NumErr	:=5;
		SET Par_ErrMen	:= 'El Usuario no tiene El Perfil para Autorizar .';
		SET Var_Control	:= 'claveUsuario';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_UsuarioReg = Par_UsuarioAut)THEN
		SET Par_NumErr	:= 5;
		SET Par_ErrMen	:= 'El Usuario que Rechaza no puede ser el mismo que Registra';
		SET Var_Control	:= 'claveUsuario';
		LEAVE ManejoErrores;
	END IF;

	UPDATE  CLIAPLICAPROTEC SET
		Estatus 		= Est_Cancelado,
		Comentario		= Par_Comentario,
		FechaRechaza	= Var_FechaSistema,
		UsuarioRechaza	= Par_UsuarioAut,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE ClienteID = Par_ClienteID;

	SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= concat('Seguro de Proteccion al Ahorro y Credito del safilocale.cliente : ',
						convert(Par_ClienteID,CHAR),', Rechazado Exitosamente');
	SET Var_Control	:= 'clienteID';
END IF;

END ManejoErrores;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
			Var_Control as control,
            Entero_Cero as consecutivo;
END IF;

END TerminaStore$$