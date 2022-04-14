-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELAPRO`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELAPRO`(


    Par_ClienteID			INT,
    Par_AreaCancela			CHAR(3),
    Par_UsuarioRegistra 	INT(11),
    Par_MotivoActivaID		INT(11),
    Par_Comentarios			VARCHAR(500),

	Par_AplicaSeguro		CHAR(1),
	Par_ActaDefuncion		VARCHAR(100),
	Par_FechaDefuncion		DATE,
    Par_Salida				CHAR(1),
    INOUT	Par_NumErr 		INT(11),

    INOUT	Par_ErrMen  	VARCHAR(400),
    Par_EmpresaID			INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),

    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE Var_ClienteID		INT(11);
DECLARE Var_ClienteCancel	INT(11);
DECLARE VarClienteCancelaID	INT(11);
DECLARE VarControl			VARCHAR(100);
DECLARE	VarFechaRegistro	DATE;
DECLARE	Par_Poliza			BIGINT;
DECLARE Var_FolioHis        INT(11);
DECLARE Var_ClienteIDProtec INT(11);
DECLARE Var_Consecutivo VARCHAR(20);


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12,2);
DECLARE	Salida_SI       	CHAR(1);
DECLARE	Salida_NO       	CHAR(1);
DECLARE	Var_NO				CHAR(1);
DECLARE	Var_SI				CHAR(1);
DECLARE	Est_Registrado		CHAR(1);
DECLARE	AltaEncPolizaSI		CHAR(1);
DECLARE	AltaEncPolizaNO		CHAR(1);
DECLARE	VarConcepConta		INT;
DECLARE TipoInsCuenta 		INT(11);
DECLARE TipoInsCliente 		INT(11);
DECLARE	Var_AtencioSoc		CHAR(3);
DECLARE	Var_Proteccion		CHAR(3);
DECLARE	Var_Cobranza		CHAR(3);
DECLARE DesbloqSaldosSi		CHAR(1);
DECLARE GenIntISRAhoSi		CHAR(1);
DECLARE MoverSaldoCuentasSi	CHAR(1);
DECLARE CancelarCuentaSi	CHAR(1);
DECLARE AportSocialSi		CHAR(1);
DECLARE CobroPROFUNSi		CHAR(1);
DECLARE CobroPROFUNNo		CHAR(1);
DECLARE InactivaCteSi		CHAR(1);
DECLARE VencimInverSi		CHAR(1);
DECLARE VencimInverNo		CHAR(1);
DECLARE FiniquitoCreSi		CHAR(1);
DECLARE FiniquitoCreNo		CHAR(1);
DECLARE PagoCreProtecSi		CHAR(1);
DECLARE PagoCreProtecNo		CHAR(1);
DECLARE CancelaPROFUN		CHAR(1);
DECLARE CancelaPROFUNNo		CHAR(1);


SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Decimal_Cero			:= 0.0;
SET Est_Registrado			:= 'R';
SET Salida_SI				:= 'S';
SET Salida_NO				:= 'N';
SET Var_NO					:= 'N';
SET Var_SI					:= 'S';
SET AltaEncPolizaSI			:= 'S';
SET AltaEncPolizaNO			:= 'N';
SET	VarConcepConta			:= 805;
SET	TipoInsCliente			:= 4;
SET	TipoInsCuenta			:= 2;
SET Var_AtencioSoc			:= 'Soc';
SET Var_Proteccion			:= 'Pro';
SET Var_Cobranza			:= 'Cob';
SET DesbloqSaldosSi			:= 'S';
SET GenIntISRAhoSi			:= 'S';
SET MoverSaldoCuentasSi		:= 'S';
SET CancelarCuentaSi		:= 'S';
SET AportSocialSi			:= 'S';
SET CobroPROFUNSi			:= 'S';
SET CobroPROFUNNo			:= 'N';
SET InactivaCteSi			:= 'S';
SET VencimInverSi			:= 'S';
SET VencimInverNo			:= 'N';
SET FiniquitoCreSi			:= 'S';
SET FiniquitoCreNo			:= 'N';
SET PagoCreProtecSi			:= 'S';
SET PagoCreProtecNo			:= 'N';
SET CancelaPROFUN			:= 'N';
SET CancelaPROFUNNo			:= 'N';

SET Par_NumErr  		:= Entero_Cero;
SET Par_ErrMen  		:= Cadena_Vacia;
SET Aud_FechaActual 	:= NOW();
SET VarFechaRegistro	:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Par_Poliza			:= 0;

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
        'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIENTESCANCELAPRO');
        SET Var_Consecutivo := Entero_Cero;
        SET VarControl := 'sqlException' ;
    END;

	IF(IFNULL(Par_UsuarioRegistra, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr   := 03;
		SET Par_ErrMen   := 'El Usuario que Registra esta Vacio';
		SET VarControl   := 'usuario';
		LEAVE ManejoErrores;
	END IF;

	SET Var_ClienteID := (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID);
    IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr   := 04;
		SET Par_ErrMen   := 'El safilocale.cliente No Existe';
		SET VarControl   := 'clienteID';
		LEAVE ManejoErrores;
    END IF;

	CALL CLIENTESCANCELAVAL(
		Par_ClienteID, 		Par_AreaCancela,	Salida_NO,				Par_Poliza,			Par_NumErr,
		Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	CALL CLIENTESCANCELAALT(
		Par_ClienteID,		Par_AreaCancela,		Par_UsuarioRegistra,	Par_MotivoActivaID,		Par_Comentarios,
		Par_AplicaSeguro,	Par_ActaDefuncion,		Par_FechaDefuncion,		Salida_NO,				Par_NumErr,
		Par_ErrMen,			VarClienteCancelaID,	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	SET Var_ClienteID := (SELECT ClienteID FROM CLIENTESPROFUN WHERE ClienteID = Par_ClienteID);
	IF(IFNULL(Var_ClienteID, Entero_Cero) != Entero_Cero) THEN
		SET CancelaPROFUN := Var_SI;
	ELSE
		SET CancelaPROFUN := Var_NO;
    END IF;

	CASE Par_AreaCancela
		WHEN Var_AtencioSoc	THEN

			SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
			SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);

			IF(Var_ClienteIDProtec != Entero_Cero)THEN
				CALL HISPROTECCIONESALT(
					Par_ClienteID,		Salida_NO,			Par_NumErr,			Par_ErrMen, 	Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID, Aud_Sucursal,
					Aud_NumTransaccion);
				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			CALL CLIENTESCANCELCTAPRO(
				Par_ClienteID,		VarClienteCancelaID,	VarFechaRegistro,	AltaEncPolizaNO,		VarConcepConta,
				Par_MotivoActivaID,	Par_Comentarios,		DesbloqSaldosSi,	GenIntISRAhoSi,			MoverSaldoCuentasSi,
				CancelarCuentaSi,	AportSocialSi,			CobroPROFUNSi,		CancelaPROFUN, 			InactivaCteSi,
				VencimInverNo,		FiniquitoCreNo,			PagoCreProtecNo,	Salida_NO,				Par_NumErr,
				Par_ErrMen,			Par_Poliza,				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_ErrMen  := CONCAT('Solicitud de Cancelacion Agregada Exitosamente: ',CONVERT(VarClienteCancelaID,CHAR));

		WHEN Var_Proteccion	THEN

			SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
			SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);

			IF(Var_ClienteIDProtec != Entero_Cero)THEN
				CALL HISPROTECCIONESALT(
					Par_ClienteID,		Salida_NO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID, Aud_Sucursal,
					Aud_NumTransaccion);
				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			CALL CLIENTESCANCELCTAPRO(
				Par_ClienteID,		VarClienteCancelaID,	VarFechaRegistro,	AltaEncPolizaNO,		VarConcepConta,
				Par_MotivoActivaID,	Par_Comentarios,		DesbloqSaldosSi,	GenIntISRAhoSi,			MoverSaldoCuentasSi,
				CancelarCuentaSi,	AportSocialSi,			CobroPROFUNSi,		CancelaPROFUNNo,		InactivaCteSi,
				VencimInverSi,		FiniquitoCreNo,			PagoCreProtecNo,	Salida_NO,				Par_NumErr,
				Par_ErrMen,			Par_Poliza,				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
            IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Solicitud de Cancelacion Agregada Exitosamente: ',CONVERT(VarClienteCancelaID,CHAR),'.',
										'<br> Recuerde Tramitar SERVIFUN, PROFUN y Proteccion al Ahorro y Credito antes ',
										' de autorizar la solicitud.');
			SET varControl	:= 'clienteID';
		WHEN Var_Cobranza	THEN

			SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
			SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
			IF(Var_ClienteIDProtec != Entero_Cero)THEN
				CALL HISPROTECCIONESALT(
					Par_ClienteID,		Salida_NO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID, Aud_Sucursal,
					Aud_NumTransaccion);
				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			CALL CLIENTESCANCELCTAPRO(
				Par_ClienteID,		VarClienteCancelaID,	VarFechaRegistro,	AltaEncPolizaNO,		VarConcepConta,
				Par_MotivoActivaID,	Par_Comentarios,		DesbloqSaldosSi,	GenIntISRAhoSi,			MoverSaldoCuentasSi,
				CancelarCuentaSi,	AportSocialSi,			CobroPROFUNSi,		CancelaPROFUN,			InactivaCteSi,
				VencimInverSi,		FiniquitoCreSi,			PagoCreProtecNo,	Salida_NO,				Par_NumErr,
				Par_ErrMen,			Par_Poliza,				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Solicitud de Cancelacion Agregada Exitosamente: ',CONVERT(VarClienteCancelaID,CHAR));
			SET varControl	:= 'clienteID';
		ELSE

			SET Par_NumErr  := 1;
			SET Par_ErrMen  := CONCAT('El Area Que Cancela no es Valida.');
			SET varControl	:= 'areaCancela';
	END CASE ;

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr  := 000;
    SET Par_ErrMen	:= 'Cliente Cancelado exitosamente.';
	SET varControl	:= 'clienteCancelaID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			VarClienteCancelaID	 AS consecutivo;
END IF;

END TerminaStore$$