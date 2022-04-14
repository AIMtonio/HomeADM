-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELAACT`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELAACT`(

	Par_ClienteCancelaID		INT(11),
    Par_UsuarioAutoriza 		INT(11),
	Par_NumAct					TINYINT UNSIGNED,
    Par_Salida					CHAR(1),
    INOUT	Par_NumErr 			INT,

    INOUT	Par_ErrMen  		VARCHAR(350),
    Par_EmpresaID				INT,
	Aud_Usuario         		INT,
    Aud_FechaActual     		DATETIME,
    Aud_DireccionIP     		VARCHAR(15),

    Aud_ProgramaID      		VARCHAR(50),
    Aud_Sucursal        		INT,
    Aud_NumTransaccion  		BIGINT
		)
TerminaStore: BEGIN


DECLARE Var_ClienteID		INT(11);
DECLARE Var_UsuarioReg		INT(11);
DECLARE VarControl			CHAR(50);
DECLARE	Var_Fecha			DATE;
DECLARE	Var_EstatusDes		VARCHAR(30);

DECLARE	Var_Estatus			CHAR(1);
DECLARE	Var_EsMenor			CHAR(1);
DECLARE	Var_AreaCancela		CHAR(3);
DECLARE	Var_NomCom			VARCHAR(200);
DECLARE Var_CantidadRecibir	DECIMAL(14,2);

DECLARE	VarConcepConta		INT;
DECLARE	VarTipoCtaBeneCan	INT;
DECLARE	Par_Poliza			BIGINT;
DECLARE VarPerfilAutoriProtec	INT;
DECLARE Var_RolID			INT(11);


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12,2);
DECLARE	Act_Autorizar		INT;

DECLARE	Var_SI		       	CHAR(1);
DECLARE	PagoCreProtecSi    	CHAR(1);
DECLARE	CancelaPROFUNSi    	CHAR(1);
DECLARE	Salida_SI       	CHAR(1);
DECLARE	Salida_NO       	CHAR(1);

DECLARE	Var_NO		       	CHAR(1);
DECLARE	AltaEncPolizaNO    	CHAR(1);
DECLARE	Est_Autorizado		CHAR(1);
DECLARE	Est_Registrado		CHAR(1);
DECLARE	Est_Pagado			CHAR(1);

DECLARE	Var_AtencioSoc		CHAR(3);
DECLARE	Var_Proteccion		CHAR(3);
DECLARE	Var_Cobranza		CHAR(3);
DECLARE Var_Vigente			CHAR(1);


SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Decimal_Cero			:= 0.0;
SET	Act_Autorizar			:= 1;

SET Est_Autorizado			:= 'A';
SET Est_Registrado			:= 'R';
SET Est_Pagado				:= 'P';
SET Var_SI					:= 'S';
SET Salida_SI				:= 'S';

SET PagoCreProtecSi			:= 'S';
SET CancelaPROFUNSi			:= 'S';
SET Salida_NO				:= 'N';
SET Var_NO					:= 'N';
SET AltaEncPolizaNO			:= 'N';

SET Var_AtencioSoc			:= 'Soc';
SET Var_Proteccion			:= 'Pro';
SET Var_Cobranza			:= 'Cob';
SET	VarConcepConta			:= 805;
SET Var_Vigente				:= 'V';


SET Par_NumErr  		:= Entero_Cero;
SET Par_ErrMen  		:= Cadena_Vacia;
SET Aud_FechaActual 	:= NOW();
SET Var_Fecha			:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Par_Poliza			:= 0;

ManejoErrores:BEGIN


SELECT	CC.ClienteID,	CC.Estatus, 	CC.UsuarioRegistra,	CC.AreaCancela,		CL.NombreCompleto,
		CL.EsMenorEdad
INTO 	Var_ClienteID,	Var_Estatus,	Var_UsuarioReg,		Var_AreaCancela,	Var_NomCom,
		Var_EsMenor
FROM	CLIENTESCANCELA CC ,
		CLIENTES CL
WHERE 	CC.ClienteID		= CL.ClienteID
 AND 	CC.ClienteCancelaID	= Par_ClienteCancelaID;

SET Var_ClienteID := (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Var_ClienteID);
IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
	SET Par_NumErr   := 04;
	SET Par_ErrMen   := 'El safilocale.cliente No Existe';
	SET VarControl   := 'clienteID';
	LEAVE ManejoErrores;
END IF;


IF(Par_NumAct = Act_Autorizar) THEN
	IF(IFNULL(Var_Estatus,Cadena_Vacia ) != Est_Registrado)THEN
		CASE Var_Estatus
			WHEN Est_Pagado 	THEN  SET Var_EstatusDes	:= "PAGADA";
			WHEN Est_Autorizado THEN  SET Var_EstatusDes	:= "AUTORIZADA";
		END CASE;
		SET Par_NumErr   := 01;
		SET Par_ErrMen   := CONCAT('El safilocale.cliente Cuenta con una Solicitud de Cancelacion ',Var_EstatusDes);
		SET VarControl   := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_UsuarioAutoriza, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr   := 03;
		SET Par_ErrMen   := 'El Usuario que Autoriza esta Vacio';
		SET VarControl   := 'usuario';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_UsuarioAutoriza = Var_UsuarioReg) THEN
		SET Par_NumErr   := 03;
		SET Par_ErrMen   := 'El Usuario que Autoriza no puede ser el mismo que registro la Solicitud.';
		SET VarControl   := 'usuario';
		LEAVE ManejoErrores;
	END IF;



	SELECT	PerfilAutoriProtec
	INTO	VarPerfilAutoriProtec
		FROM PARAMETROSCAJA
		WHERE  EmpresaID = Par_EmpresaID;

	SELECT  	RolID
		INTO	Var_RolID
		FROM USUARIOS
		WHERE UsuarioID = Par_UsuarioAutoriza;


	SELECT	SaldoFavorCliente
	INTO 	Var_CantidadRecibir
	FROM 	PROTECCIONES
	WHERE	ClienteID = Var_ClienteID;

	SET Var_CantidadRecibir := IFNULL(Var_CantidadRecibir, Decimal_Cero);

	IF(Var_AreaCancela = Var_Proteccion) THEN

		CALL PROTECCIONESVAL(
			Var_ClienteID, 		Var_AreaCancela,	Salida_NO,				Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SELECT	SaldoFavorCliente
	INTO 	Var_CantidadRecibir
	FROM 	PROTECCIONES
	WHERE	ClienteID = Var_ClienteID;

	SET Var_CantidadRecibir := IFNULL(Var_CantidadRecibir, Decimal_Cero);

	UPDATE CLIENTESCANCELA SET
		Estatus			= Est_Autorizado,
		UsuarioAutoriza	= Par_UsuarioAutoriza,
		FechaAutoriza	= Var_Fecha,
		SucursalAutoriza= Aud_Sucursal,
		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,

		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE	ClienteCancelaID = Par_ClienteCancelaID;

	SET Par_NumErr  := 000;
	SET Par_ErrMen  := CONCAT('Solicitud de Cancelacion Autorizada Exitosamente: ',CONVERT(Par_ClienteCancelaID,CHAR));
	SET varControl	:= 'clienteCancelaID';

	CASE Var_AreaCancela
		WHEN Var_AtencioSoc		THEN
			IF(Var_CantidadRecibir > Decimal_Cero)THEN
				CALL CLICANCELAENTREGAALT(

					Par_ClienteCancelaID,	Var_ClienteID,		Entero_Cero,	Entero_Cero,			Entero_Cero,
					Entero_Cero,			Var_NomCom,			100,			Var_CantidadRecibir,	Cadena_Vacia,
					Salida_NO,				Par_NumErr,			Par_ErrMen,		Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);
			END IF;
		WHEN Var_Proteccion		THEN

			IF(Var_EsMenor = Var_SI)THEN

				SET VarTipoCtaBeneCan := (SELECT TipoCuentaID FROM CUENTASAHO WHERE ClienteID = Var_ClienteID AND EsPrincipal = Var_SI);
			ELSE

				SET VarTipoCtaBeneCan := (SELECT TipoCtaBeneCancel FROM PARAMETROSCAJA);
			END IF;

			IF EXISTS (SELECT ClienteID FROM CLIENTESPROFUN WHERE ClienteID = Var_ClienteID)THEN
					SET CancelaPROFUNSi := Var_SI;
			ELSE
					SET CancelaPROFUNSi	:= Var_NO;
			END IF;

			CALL CLIENTESCANCELCTAPRO(
				Var_ClienteID,		Par_ClienteCancelaID,	Var_Fecha,			AltaEncPolizaNO,		VarConcepConta,
				Entero_Cero,		Cadena_Vacia,			Var_NO,				Var_NO,					Var_NO,
				Var_NO,				Var_NO,					Var_NO,				CancelaPROFUNSi,		Var_NO,
				Var_NO,				Var_NO,					PagoCreProtecSi,	Salida_NO,				Par_NumErr,
				Par_ErrMen,			Par_Poliza,				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			SET @VarCliCancelaEntregaID := (SELECT IFNULL(MAX(CliCancelaEntregaID),Entero_Cero) + 1 FROM CLICANCELAENTREGA);
			SET @VarCliCancelaEntregaID := IFNULL(@VarCliCancelaEntregaID,Entero_Cero);

			INSERT INTO CLICANCELAENTREGA (
				CliCancelaEntregaID,	ClienteCancelaID,		ClienteID,				CuentaAhoID,		PersonaID,
				ClienteBenID,			Parentesco,				NombreBeneficiario,		Porcentaje,			CantidadRecibir,
				Estatus,				NombreRecibePago,		EmpresaID,				Usuario,			FechaActual,
				DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
			SELECT
				(@VarCliCancelaEntregaID := @VarCliCancelaEntregaID + 1) ,
										Par_ClienteCancelaID,	CA.ClienteID,			CP.CuentaAhoID ,	CP.PersonaID,
				CP.ClienteID,			CP.ParentescoID,		CP.NombreCompleto,		CP.Porcentaje,		(PR.SaldoFavorCliente*CP.Porcentaje)/100,
				Est_Autorizado,			Cadena_Vacia,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
				FROM	CUENTASPERSONA	CP,
						CUENTASAHO		CA,
						PROTECCIONES	PR,
						CLIENTESCANCELA     CC
				WHERE	CP.CuentaAhoID		= CA.CuentaAhoID
				 AND 	PR.ClienteID		= CA.ClienteID
				 AND 	CP.EsBeneficiario	= Var_SI
			     AND 	CP.EstatusRelacion  = Var_Vigente
				 AND	CA.ClienteID		= Var_ClienteID
				 AND 	SaldoFavorCliente	> Decimal_Cero
				 AND 	CA.TipoCuentaID		= VarTipoCtaBeneCan
                 AND 	CC.ClienteCancelaID = Par_ClienteCancelaID
				 AND 	CA.FechaCan = CC.FechaRegistro;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Solicitud de Cancelacion Autorizada Exitosamente: ',CONVERT(Par_ClienteCancelaID,CHAR));
			SET varControl	:= 'clienteCancelaID';
		WHEN Var_Cobranza		THEN
			IF(Var_CantidadRecibir > Decimal_Cero)THEN
				CALL CLICANCELAENTREGAALT(

					Par_ClienteCancelaID,	Var_ClienteID,		Entero_Cero,	Entero_Cero,			Entero_Cero,
					Entero_Cero,			Var_NomCom,			100,			Var_CantidadRecibir,	Cadena_Vacia,
					Salida_NO,				Par_NumErr,			Par_ErrMen,		Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);
			END IF;
		ELSE
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := CONCAT('EL area que cancela no es valida');
			LEAVE ManejoErrores;
	END CASE;


	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	ELSE
		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Solicitud de Cancelacion Autorizada Exitosamente: ',CONVERT(Par_ClienteCancelaID,CHAR));
		SET varControl	:= 'clienteCancelaID';
	END IF;
END IF;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Par_ClienteCancelaID AS consecutivo;
END IF;

END TerminaStore$$