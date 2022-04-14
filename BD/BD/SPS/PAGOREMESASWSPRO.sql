

DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOREMESASWSPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOREMESASWSPRO`(
	Par_Origin				VARCHAR(10),
	Par_UsuarioExt			VARCHAR(30),
	Par_RemesaCatalogoID	INT,
	Par_Monto               DECIMAL(14,2),
	Par_RemesaFolio         VARCHAR(45),

	Par_ClienteID			INT(11),
	Par_NombreCompleto		VARCHAR(200),
	Par_Direccion			VARCHAR(500),
	Par_NumTelefono			VARCHAR(20),
	Par_TipoIdentiID		INT(11),

	Par_FolioIdentific		VARCHAR(45)	,
	Par_FormaPago			CHAR(1),
	Par_NumeroCuenta		VARCHAR(18),

	Par_Salida              CHAR(1),


	INOUT Par_NumErr        INT,
	INOUT Par_ErrMen        VARCHAR(400),
	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,

	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore:BEGIN


DECLARE Var_ReferDetPol			VARCHAR(45);
DECLARE Var_FechaApl			DATE;
DECLARE Var_FechaOper			DATE;
DECLARE Var_EsHabil				CHAR(1);
DECLARE Var_SucCliente			INT(5);
DECLARE Var_EsMEnorEdad			CHAR(1);
DECLARE Var_CajaID				INT(11);
DECLARE Var_SucursalID			INT(11);
DECLARE Var_MonedaID			INT(11);
DECLARE Var_UsuarioID			INT(11);
DECLARE Var_Poliza				BIGINT(20);
DECLARE Var_EstatusCaja         CHAR(1);
DECLARE Var_EstatusOpera        CHAR(1);
DECLARE Var_LimiteEfectivoMN	DECIMAL(14,2);
DECLARE Var_SaldoEfecMN         DECIMAL(14,2);
DECLARE Var_MaximoRetiro        DECIMAL(14,2);
DECLARE Var_CantidadNeg			INT(11);
DECLARE	Var_Instrumento			BIGINT(20);
DECLARE Var_TipOpePag			INT(11);
DECLARE Var_TipOpeSal			INT(11);
DECLARE Var_CantidadApl			DECIMAL(14,2);
DECLARE Var_Naturaleza			INT(11);
DECLARE Var_DenominacionID		INT(11);
DECLARE Var_Monto				DECIMAL(14,2);
DECLARE Var_Consecutivo  		BIGINT;
DECLARE MontoAplicado			DECIMAL(14,2);
DECLARE MontoPendiente			DECIMAL(14,2);
DECLARE Var_Control				VARCHAR(100);


DECLARE SalidaSI				CHAR(1);
DECLARE Entero_Cero				INT;
DECLARE Cadena_Vacia			CHAR;
DECLARE NatCargo				CHAR(1);
DECLARE descrpcionMov			VARCHAR(100);
DECLARE ConContaPagoRemesa 		INT(11);
DECLARE ConceptosCaja			INT;
DECLARE SalidaNO				CHAR(1);
DECLARE TipoInstrumentoID		INT(11);
DECLARE AltaEncabePoliza_SI 	CHAR(1);
DECLARE AltaDetPoliza_SI    	CHAR(1);
DECLARE Esta_Activo             CHAR(1);
DECLARE EstO_Cerrado            CHAR(1);
DECLARE Decimal_Cero            DECIMAL(12, 2);
DECLARE Var_OpcionCaja			INT(11);
DECLARE Var_Contador			INT(11);
DECLARE Var_CargosPoliza	DECIMAL(14,4);
DECLARE Var_AbonosPoliza	DECIMAL(14,4);
DECLARE LimiteDifPoliza		DECIMAL;

SET SalidaSI					:='S';
SET Entero_Cero					:=0;
SET Cadena_Vacia				:='';
SET NatCargo					:='C';
SET descrpcionMov				:='PAGO DE REMESA';
SET ConContaPagoRemesa			:= 404;
SET ConceptosCaja				:=3;
SET SalidaNO					:='N';
SET TipoInstrumentoID			:=22;
SET AltaEncabePoliza_SI 		:='S';
SET AltaDetPoliza_SI  			:='S';
SET Esta_Activo                 := 'A';
SET EstO_Cerrado                :='C';
SET Decimal_Cero                := 0.00;
SET Var_Naturaleza				:= 2;
SET Var_OpcionCaja				:= 16;
SET MontoPendiente				:= 0;
SET LimiteDifPoliza			:=0.01;


SET Par_NumErr  				:= Entero_Cero;
SET Par_ErrMen  				:= Cadena_Vacia;
SET Var_MonedaID				:= 1;
SET Var_Instrumento 			:= 36;
SET Var_TipOpePag				:= 72;
SET Var_TipOpeSal				:= 73;
SET Var_CantidadApl				:= Decimal_Cero;

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOREMESASWSPRO [',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

	SET Par_EmpresaID  := 1;

	-- GENERAMOS UN NUMERO DE TRANSACCION SOLO SI VIENE VACÍO.
	IF(IFNULL(Aud_NumTransaccion,Entero_Cero)=Entero_Cero)THEN
		CALL TRANSACCIONESPRO(Aud_NumTransaccion);
	END IF;

	DELETE FROM TMPPAGOREMESASWSPRO_0 WHERE NumTransaccion = Aud_NumTransaccion;

	INSERT INTO TMPPAGOREMESASWSPRO_0 (
		DenominacionID,	Valor,			CantidadDispon,	Cantidad,	MontoPen,
		Monto,			NumTransaccion
	)VALUES(
		Entero_Cero,	Entero_Cero,	Entero_Cero,	1,			Entero_Cero,
		Entero_Cero,	Aud_NumTransaccion);

	SET Var_FechaOper  := (SELECT FechaSistema FROM PARAMETROSSIS);

	SELECT 	CAJ.CajaID, 			CAJ.SucursalID,		CAJ.UsuarioID,		CAJ.Estatus,   		CAJ.EstatusOpera,
			CAJ.LimiteEfectivoMN, 	CAJ.SaldoEfecMN,	CAJ.MaximoRetiroMN
	INTO 	Var_CajaID,				Var_SucursalID,		Var_UsuarioID,		Var_EstatusCaja, 	Var_EstatusOpera,
			Var_LimiteEfectivoMN,	Var_SaldoEfecMN,	Var_MaximoRetiro
		FROM CAJASVENTANILLA CAJ
		INNER JOIN USUARIOS USU ON USU.UsuarioID = CAJ.UsuarioID
		WHERE USU.UsuarioExt LIKE Par_UsuarioExt;


	IF(Var_EstatusCaja != Esta_Activo) THEN
		IF(Par_Salida = SalidaSI) THEN
			 SET Par_NumErr		:='001';
			 SET Par_ErrMen		:='La Caja no Existe o no se Encuentra Activa.';
		ELSE
			SET Par_NumErr		:='001';
			SET Par_ErrMen		:= 'La Caja no Existe o no se Encuentra Activa.';
		END IF;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_EstatusOpera, Cadena_Vacia)) = EstO_Cerrado THEN
		IF (Par_Salida = SalidaSI) THEN
			SET Par_NumErr		:='002';
			SET Par_ErrMen		:='La Caja se encuentra Cerrada.';
		ELSE
			SET	Par_NumErr 		:= '002';
			SET	Par_ErrMen 		:= 'La Caja se encuentra Cerrada.' ;
		END IF;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Monto, Decimal_Cero)) <= Decimal_Cero THEN
		IF(Par_Salida = SalidaSI) THEN
			SET Par_NumErr		:='003';
			SET Par_ErrMen		:= 'Monto del Movimiento Menor o Igual a Cero.';
		ELSE
			SET Par_NumErr		:= '003';
			SET Par_ErrMen		:= 'Monto del Movimiento Menor o Igual a Cero';
		END IF;
		LEAVE ManejoErrores;
	END IF;

	IF(Var_SaldoEfecMN < Par_Monto) THEN
		IF(Par_Salida = SalidaSI) THEN
			SET Par_NumErr      :='007';
			SET Par_ErrMen      :='Saldo de la Caja Insuficiente.';
		ELSE
			SET Par_NumErr      := '007';
			SET Par_ErrMen      := 'Saldo de la Caja Insuficiente.';
		END IF;
		LEAVE ManejoErrores;
	END IF;

	IF EXISTS(select RemesaFolio from PAGOREMESAS where RemesaFolio=Par_RemesaFolio)THEN
		set Par_NumErr  := '010';
		set Par_ErrMen  := CONCAT('La Remesa con folio ',Par_RemesaFolio,' ya fue Pagada.');
		LEAVE ManejoErrores;
	END IF;

	SELECT COUNT(*) INTO Var_Contador
		FROM BALANZADENOM Bal
		INNER JOIN DENOMINACIONES DEN ON DEN.DenominacionID = Bal.DenominacionID
		WHERE SucursalID     = Var_SucursalID
		  AND CajaID         = Var_CajaID;

	IF(IFNULL(Var_Contador, Entero_Cero)) > Entero_Cero THEN
		DELETE FROM TMPPAGOREMESASWSPRO_0 WHERE NumTransaccion = Aud_NumTransaccion;
	END IF;

	INSERT INTO TMPPAGOREMESASWSPRO_0(
		DenominacionID,		Valor,			CantidadDispon,	Cantidad,		MontoPen,
		Monto,				NumTransaccion)
	SELECT
		Bal.DenominacionID,	DEN.Valor,		Bal.Cantidad,	Entero_Cero,	Entero_Cero,
		DEN.Valor,			Aud_NumTransaccion
	FROM BALANZADENOM Bal
		INNER JOIN DENOMINACIONES DEN ON DEN.DenominacionID = Bal.DenominacionID
	WHERE SucursalID = Var_SucursalID
		AND CajaID = Var_CajaID;

	SET MontoPendiente := Par_Monto;

	UPDATE TMPPAGOREMESASWSPRO_0 SET
		Cantidad 	= CASE WHEN CantidadDispon <= IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) THEN CantidadDispon ELSE IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) END
	WHERE DenominacionID = 1
		AND NumTransaccion = Aud_NumTransaccion;

	SET MontoAplicado 	:=   (SELECT (Valor * Cantidad) FROM TMPPAGOREMESASWSPRO_0 WHERE DenominacionID = 1 AND NumTransaccion = Aud_NumTransaccion);
	SET MontoAplicado 	:=   IFNULL(MontoAplicado,Decimal_Cero);
	SET MontoPendiente	:= 	 MontoPendiente - MontoAplicado;

	UPDATE TMPPAGOREMESASWSPRO_0 SET
		Cantidad 	= CASE WHEN CantidadDispon <= IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) THEN CantidadDispon ELSE IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) END
	WHERE DenominacionID = 2
		AND NumTransaccion = Aud_NumTransaccion;

	SET MontoAplicado 	:=	(SELECT (Valor * Cantidad) FROM TMPPAGOREMESASWSPRO_0 WHERE DenominacionID = 2 AND NumTransaccion = Aud_NumTransaccion);
	SET MontoAplicado 	:= 	IFNULL(MontoAplicado,Decimal_Cero);
	SET MontoPendiente	:= 	MontoPendiente - MontoAplicado;

	UPDATE TMPPAGOREMESASWSPRO_0 SET
		Cantidad 	= CASE WHEN CantidadDispon <= IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) THEN CantidadDispon ELSE IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) END
	WHERE DenominacionID = 3
		AND NumTransaccion = Aud_NumTransaccion;

	SET MontoAplicado 	:=	(SELECT (Valor * Cantidad) FROM TMPPAGOREMESASWSPRO_0 WHERE DenominacionID = 3 AND NumTransaccion = Aud_NumTransaccion);
	SET MontoAplicado 	:= 	IFNULL(MontoAplicado,Decimal_Cero);
	SET MontoPendiente	:= 	MontoPendiente - MontoAplicado;

	UPDATE TMPPAGOREMESASWSPRO_0 SET
		Cantidad 	= CASE WHEN CantidadDispon <= IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) THEN CantidadDispon ELSE IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) END
	WHERE DenominacionID = 4
		AND NumTransaccion = Aud_NumTransaccion;

	SET MontoAplicado 	:=	(SELECT (Valor * Cantidad) FROM TMPPAGOREMESASWSPRO_0 WHERE DenominacionID = 4 AND NumTransaccion = Aud_NumTransaccion);
	SET MontoAplicado 	:= 	IFNULL(MontoAplicado,Decimal_Cero);
	SET MontoPendiente	:= 	MontoPendiente - MontoAplicado;

	UPDATE TMPPAGOREMESASWSPRO_0 SET
		Cantidad 	= CASE WHEN CantidadDispon <= IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) THEN CantidadDispon ELSE IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) END
	WHERE DenominacionID = 5
		AND NumTransaccion = Aud_NumTransaccion;

	SET MontoAplicado 	:=	(SELECT (Valor * Cantidad) FROM TMPPAGOREMESASWSPRO_0 WHERE DenominacionID = 5 AND NumTransaccion = Aud_NumTransaccion);
	SET MontoAplicado 	:= 	IFNULL(MontoAplicado,Decimal_Cero);
	SET MontoPendiente	:= 	MontoPendiente - MontoAplicado;

	UPDATE TMPPAGOREMESASWSPRO_0 SET
		Cantidad 	= CASE WHEN CantidadDispon <= IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) THEN CantidadDispon ELSE IFNULL(FLOOR(MontoPendiente/Valor),Decimal_Cero) END
	WHERE DenominacionID = 6
		AND NumTransaccion = Aud_NumTransaccion;

	SET MontoAplicado 	:=	(SELECT (Valor * Cantidad) FROM TMPPAGOREMESASWSPRO_0 WHERE DenominacionID = 6 AND NumTransaccion = Aud_NumTransaccion);
	SET MontoAplicado 	:= 	IFNULL(MontoAplicado,Decimal_Cero);
	SET MontoPendiente	:= 	MontoPendiente - MontoAplicado;

	UPDATE TMPPAGOREMESASWSPRO_0 SET
		Cantidad 	= CASE WHEN CantidadDispon <= MontoPendiente THEN CantidadDispon ELSE MontoPendiente END
	WHERE DenominacionID = 7
		AND NumTransaccion = Aud_NumTransaccion;

	SET MontoAplicado 	:=	(SELECT (Valor * Cantidad) FROM TMPPAGOREMESASWSPRO_0 WHERE DenominacionID = 7 AND NumTransaccion = Aud_NumTransaccion);
	SET MontoAplicado 	:= 	IFNULL(MontoAplicado,Decimal_Cero);
	SET MontoPendiente	:= 	MontoPendiente - MontoAplicado;

	UPDATE TMPPAGOREMESASWSPRO_0 SET
		Monto 		= Valor * Cantidad
	WHERE NumTransaccion = Aud_NumTransaccion;

	SET Var_CantidadNeg := (SELECT COUNT(*) FROM TMPPAGOREMESASWSPRO_0 WHERE Cantidad < 0 AND NumTransaccion = Aud_NumTransaccion);

	IF (Var_CantidadNeg > 0 OR MontoPendiente >0) THEN
		SET Par_NumErr      := '008';
		SET Par_ErrMen      := 'No existen denominaciones suficientes para el monto ingresado.';

		DELETE FROM TMPPAGOREMESASWSPRO_0 WHERE NumTransaccion = Aud_NumTransaccion;
		INSERT INTO TMPPAGOREMESASWSPRO_0 (
			DenominacionID,	Valor,			CantidadDispon,	Cantidad,	MontoPen,
			Monto,			NumTransaccion)
		VALUES(
			Entero_Cero,	Entero_Cero,	Entero_Cero,	1,			Entero_Cero,
			Entero_Cero,	Aud_NumTransaccion);
		LEAVE ManejoErrores;
	END IF;

	CALL DIASFESTIVOSCAL(
		Var_FechaOper,		Entero_Cero,		 Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
		Var_UsuarioID,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	SET Aud_FechaActual := NOW();

	SELECT  Cli.SucursalOrigen, Cli.EsMenorEdad  INTO Var_SucCliente, Var_EsMEnorEdad
		FROM  CLIENTES Cli
		WHERE Cli.ClienteID   = Par_ClienteID;

	CALL PAGOREMESASAALT(
		Par_RemesaFolio,		Par_Monto,			Par_ClienteID,		Par_NombreCompleto,	Par_Direccion,
		Par_NumTelefono,		Par_TipoIdentiID,	Par_FolioIdentific,	Par_FormaPago,		Par_NumeroCuenta,
		Var_FechaOper,			Var_SucursalID,		Var_CajaID,			Var_MonedaID,		Var_UsuarioID,
		Par_RemesaCatalogoID,	Par_NumeroCuenta,	Par_Origin,			SalidaNO,			Par_NumErr,
		Par_ErrMen,				Par_EmpresaID,		Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
		DELETE FROM TMPPAGOREMESASWSPRO_0 WHERE NumTransaccion = Aud_NumTransaccion;
		INSERT INTO TMPPAGOREMESASWSPRO_0 (
			DenominacionID,	Valor,			CantidadDispon,	Cantidad,	MontoPen,
			Monto,			NumTransaccion)
		VALUES(
			Entero_Cero,	Entero_Cero,	Entero_Cero,	1,			Entero_Cero,
			Entero_Cero,	Aud_NumTransaccion);
		LEAVE ManejoErrores;
	END IF;

	SET Var_ReferDetPol:=Par_RemesaFolio;

	CALL CONTACAJAPRO(
		Aud_NumTransaccion,	Var_FechaApl,			Par_Monto,			descrpcionMov,			Var_MonedaID,
		Var_SucCliente,		AltaEncabePoliza_SI,	ConContaPagoRemesa,	Var_Poliza,				AltaDetPoliza_SI,
		ConceptosCaja,		NatCargo,				Var_ReferDetPol,	Par_RemesaCatalogoID,	Par_RemesaCatalogoID,
		TipoInstrumentoID,	SalidaNO,				Par_NumErr,			Par_ErrMen,				Par_EmpresaID,
		Var_UsuarioID,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion);
	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


	CALL CAJASMOVSALT(
		Var_SucursalID,		Var_CajaID,				Var_FechaApl,		Aud_NumTransaccion,		Var_MonedaID,
		Par_Monto,			Entero_Cero,			Var_TipOpePag,		Var_Instrumento,		Par_RemesaFolio,
		Entero_Cero,		Entero_Cero,			SalidaNO,			Par_NumErr,				Par_ErrMen,
		Par_EmpresaID,		Var_UsuarioID,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);
	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


	CALL CAJASMOVSALT(
		Var_SucursalID,		Var_CajaID,				Var_FechaApl,		Aud_NumTransaccion,		Var_MonedaID,
		Par_Monto,			Entero_Cero,			Var_TipOpeSal,		Var_Instrumento,		Par_RemesaFolio,
		Entero_Cero,		Entero_Cero,			SalidaNO,			Par_NumErr,				Par_ErrMen,
		Par_EmpresaID,		Var_UsuarioID,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);
	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Var_CantidadApl	:= Decimal_Cero;

	SELECT
		Cantidad,			DenominacionID,		Monto
	INTO
		Var_CantidadApl,	Var_DenominacionID,	Var_Monto
	FROM TMPPAGOREMESASWSPRO_0
	WHERE Cantidad > Entero_Cero
		AND DenominacionID = 1
		AND NumTransaccion = Aud_NumTransaccion;

	IF(IFNULL(Var_CantidadApl,Entero_Cero) > Entero_Cero)THEN
		CALL DENOMINAMOVSALT(
			Var_SucursalID,		Var_CajaID,			Var_FechaApl,		Aud_NumTransaccion,	Var_Naturaleza,
			Var_DenominacionID,	Var_CantidadApl,	Var_Monto,			Var_MonedaID,		SalidaNO,
			Var_Instrumento,	Par_RemesaFolio,	SalidaNO,			Par_EmpresaID,		descrpcionMov,
			Par_ClienteID,		Var_Poliza,			Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
			Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Var_CantidadApl	:= Decimal_Cero;
	SELECT
		Cantidad,			DenominacionID,		Monto
	INTO
		Var_CantidadApl,	Var_DenominacionID,	Var_Monto
	FROM TMPPAGOREMESASWSPRO_0
	WHERE Cantidad > Entero_Cero
		AND DenominacionID = 2
		AND NumTransaccion = Aud_NumTransaccion;

	IF(IFNULL(Var_CantidadApl,Entero_Cero) > Entero_Cero)THEN
		CALL DENOMINAMOVSALT(
			Var_SucursalID,		Var_CajaID,			Var_FechaApl,		Aud_NumTransaccion,	Var_Naturaleza,
			Var_DenominacionID,	Var_CantidadApl,	Var_Monto,			Var_MonedaID,		SalidaNO,
			Var_Instrumento,	Par_RemesaFolio,	SalidaNO,			Par_EmpresaID,		descrpcionMov,
			Par_ClienteID,		Var_Poliza,			Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
			Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Var_CantidadApl	:= Decimal_Cero;
	SELECT
		Cantidad,			DenominacionID,		Monto
	INTO
		Var_CantidadApl,	Var_DenominacionID,	Var_Monto
	FROM TMPPAGOREMESASWSPRO_0
	WHERE Cantidad > Entero_Cero
		AND DenominacionID = 3
		AND NumTransaccion = Aud_NumTransaccion;

	IF(IFNULL(Var_CantidadApl,Entero_Cero) > Entero_Cero)THEN
		CALL DENOMINAMOVSALT(
			Var_SucursalID,		Var_CajaID,			Var_FechaApl,		Aud_NumTransaccion,	Var_Naturaleza,
			Var_DenominacionID,	Var_CantidadApl,	Var_Monto,			Var_MonedaID,		SalidaNO,
			Var_Instrumento,	Par_RemesaFolio,	SalidaNO,			Par_EmpresaID,		descrpcionMov,
			Par_ClienteID,		Var_Poliza,			Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
			Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Var_CantidadApl	:= Decimal_Cero;
	SELECT
		Cantidad,			DenominacionID,		Monto
	INTO
		Var_CantidadApl,	Var_DenominacionID,	Var_Monto
	FROM TMPPAGOREMESASWSPRO_0
	WHERE Cantidad > Entero_Cero
		AND DenominacionID = 4
		AND NumTransaccion = Aud_NumTransaccion;

	IF(IFNULL(Var_CantidadApl,Entero_Cero) > Entero_Cero)THEN
		CALL DENOMINAMOVSALT(
			Var_SucursalID,		Var_CajaID,			Var_FechaApl,		Aud_NumTransaccion,	Var_Naturaleza,
			Var_DenominacionID,	Var_CantidadApl,	Var_Monto,			Var_MonedaID,		SalidaNO,
			Var_Instrumento,	Par_RemesaFolio,	SalidaNO,			Par_EmpresaID,		descrpcionMov,
			Par_ClienteID,		Var_Poliza,			Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
			Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Var_CantidadApl	:= Decimal_Cero;
	SELECT
		Cantidad,			DenominacionID,		Monto
	INTO
		Var_CantidadApl,	Var_DenominacionID,	Var_Monto
	FROM TMPPAGOREMESASWSPRO_0
	WHERE Cantidad > Entero_Cero
		AND DenominacionID = 5
		AND NumTransaccion = Aud_NumTransaccion;

	IF(IFNULL(Var_CantidadApl,Entero_Cero) > Entero_Cero)THEN
		CALL DENOMINAMOVSALT(
			Var_SucursalID,		Var_CajaID,			Var_FechaApl,		Aud_NumTransaccion,	Var_Naturaleza,
			Var_DenominacionID,	Var_CantidadApl,	Var_Monto,			Var_MonedaID,		SalidaNO,
			Var_Instrumento,	Par_RemesaFolio,	SalidaNO,			Par_EmpresaID,		descrpcionMov,
			Par_ClienteID,		Var_Poliza,			Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
			Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Var_CantidadApl	:= Decimal_Cero;
	SELECT
		Cantidad,			DenominacionID,		Monto
	INTO
		Var_CantidadApl,	Var_DenominacionID,	Var_Monto
	FROM TMPPAGOREMESASWSPRO_0
	WHERE Cantidad > Entero_Cero
		AND DenominacionID = 6
		AND NumTransaccion = Aud_NumTransaccion;

	IF(IFNULL(Var_CantidadApl,Entero_Cero) > Entero_Cero)THEN
		CALL DENOMINAMOVSALT(
			Var_SucursalID,		Var_CajaID,			Var_FechaApl,		Aud_NumTransaccion,	Var_Naturaleza,
			Var_DenominacionID,	Var_CantidadApl,	Var_Monto,			Var_MonedaID,		SalidaNO,
			Var_Instrumento,	Par_RemesaFolio,	SalidaNO,			Par_EmpresaID,		descrpcionMov,
			Par_ClienteID,		Var_Poliza,			Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
			Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Var_CantidadApl	:= Decimal_Cero;
	SELECT
		Cantidad,			DenominacionID,		Monto
	INTO
		Var_CantidadApl,	Var_DenominacionID,	Var_Monto
	FROM TMPPAGOREMESASWSPRO_0
	WHERE Cantidad > Entero_Cero
		AND DenominacionID = 7
		AND NumTransaccion = Aud_NumTransaccion;

	IF(IFNULL(Var_CantidadApl,Entero_Cero) > Entero_Cero)THEN
		CALL DENOMINAMOVSALT(
			Var_SucursalID,		Var_CajaID,			Var_FechaApl,		Aud_NumTransaccion,	Var_Naturaleza,
			Var_DenominacionID,	Var_CantidadApl,	Var_Monto,			Var_MonedaID,		SalidaNO,
			Var_Instrumento,	Par_RemesaFolio,	SalidaNO,			Par_EmpresaID,		descrpcionMov,
			Par_ClienteID,		Var_Poliza,			Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
			Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


   SELECT ROUND(SUM(Cargos),2), ROUND(SUM(Abonos),2) INTO Var_CargosPoliza, Var_AbonosPoliza
		FROM DETALLEPOLIZA
		WHERE PolizaID = Var_Poliza;

	SET	Var_CargosPoliza	:= IFNULL(Var_CargosPoliza,Entero_Cero);
	SET	Var_AbonosPoliza	:= IFNULL(Var_AbonosPoliza,Entero_Cero);


	IF(ABS((Var_CargosPoliza - Var_AbonosPoliza)) > LimiteDifPoliza OR (Var_CargosPoliza + Var_AbonosPoliza)=Entero_Cero)THEN
			SET Par_NumErr		:='009';
			SET Par_ErrMen		:= CONCAT("-",Var_CargosPoliza,"1.- Poliza Descuadrada ",Var_CargosPoliza,"-",Var_AbonosPoliza);
			LEAVE ManejoErrores;
	END IF;

	CALL REIMPRESIONTICKETALT(
		Aud_NumTransaccion,		Var_TipOpePag,		Var_CajaID,			Var_SucursalID,		Var_UsuarioID,
		Var_OpcionCaja,			descrpcionMov,		Par_RemesaFolio,	Par_Monto,			Par_Monto,
		Entero_Cero,			Par_NombreCompleto,	Cadena_Vacia,		Par_ClienteID,		Entero_Cero,
		Entero_Cero,			Entero_Cero,		Entero_Cero,		'R',				Entero_Cero,
		Entero_Cero,			Entero_Cero,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,
		Entero_Cero,			Var_Poliza,			Par_NumTelefono,	Par_TipoIdentiID,	Par_FolioIdentific,
		Par_RemesaFolio,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,
		Var_MonedaID,			Entero_Cero,		Entero_Cero,		Cadena_Vacia,		Entero_Cero,
		Entero_Cero,			Entero_Cero,		Entero_Cero,		SalidaNO,			Par_NumErr,
		Par_ErrMen,				Par_EmpresaID,		Var_UsuarioID,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := "Remesa pagada exitosamente.";

END ManejoErrores;
IF (Par_Salida = SalidaSI) THEN
	SET  @Consecutivo := 0;
	SELECT
		CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
		Par_ErrMen AS ErrMen,
		Aud_NumTransaccion AS NumTransaccion,
		DenominacionID, Cantidad, Monto, @Consecutivo := @Consecutivo +1 AS recordNumber, Valor
	FROM TMPPAGOREMESASWSPRO_0
	WHERE Cantidad > 0
		AND NumTransaccion = Aud_NumTransaccion;
	-- Borramos la tabla temporal
	DELETE FROM TMPPAGOREMESASWSPRO_0 WHERE NumTransaccion = Aud_NumTransaccion;
END IF;

END TerminaStore$$

