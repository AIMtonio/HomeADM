-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOFIRAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOFIRAPRO`;DELIMITER $$

CREATE PROCEDURE `CRECASTIGOFIRAPRO`(
-- ==================================================================
-- SP QUE REALIZA EL PROCESO GENERAL DE LOS CASTIGOS EN CARTERA AGRO
-- Y VALIDA QUE CREDITO (R O RC) SE APLICARA EL CASTIGO.
-- ==================================================================

	Par_CreditoID     		BIGINT(12),		-- ID de Credito a la cual se va a Castigar
	Par_TipoCredCastigo		INT(11),		-- Tipo de Crédito a la que se aplicara el castigo
	INOUT Par_PolizaID		BIGINT(20),		-- ID de Poliza
	Par_MotivoCastigoID 	INT(11),		-- ID de Motivo de Castigo
	Par_Observaciones		VARCHAR(500),	-- Observaciones referente al Castigo
	Par_TipoCastigo			CHAR(1),		-- Tipo de Castigo
    Par_TipoCobranza	    INT,			-- Parametro de Tipo de Cobranza
	Par_AltaEncPoliza       CHAR(1),		-- Alta de encabezado de la Poliza
    Par_Salida        		CHAR(1),		-- Parametro de Salida
	INOUT   Par_NumErr 		INT(11),		-- Parametro de Numero de Error
	INOUT	Par_ErrMen		VARCHAR(400),	-- Parametro de Error de Mensaje
	Par_EmpresaID     		INT,			-- Paramerto de Auditoria Empresa ID
	Aud_Usuario				INT(11),		-- Parametro de Auditoria Usuario
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria Programa ID
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria Sucursal ID
	Aud_NumTransaccion 		BIGINT(20)		-- Parametro de Auditoria numero de Transaccion
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE var_GarantiaID 	INT (11);			-- Variable para almacenar la Garantia FIRA
DECLARE Var_CreditoID	BIGINT(12);			-- Variable de Credito ID
DECLARE Var_CredAgro	CHAR(1);			-- Constante S


-- Declaracion de Constantes
DECLARE Entero_Cero		INT(11);			-- Constante Entero Cero
DECLARE creditoR		INT(11);			-- Constante de Credito Residual
DECLARE creditoRC		INT(11);			-- Constante de Credito Contingente
DECLARE creditoAM		INT(11);			-- Constante de Ambios Creditos Residual y Constante
DECLARE SalidaSI		CHAR(1);			-- Constante S de Parametro de Salida
DECLARE SalidaNO		CHAR(1);			-- Constante S de Parametro de Salida
DECLARE Var_EsAgro		CHAR(1);			-- Constante S
DECLARE Var_Desembolsado CHAR(1);			-- Constante D
DECLARE Var_Cancelado	 CHAR(1);			-- Constante C
DECLARE EstatusCancelado CHAR(1);			-- Estatus de Ministracion Cancelado


-- Seteo de Constantes
SET Entero_Cero	:= 0;
SET creditoR 	:=  1;
SET creditoRC 	:= 2;
SET creditoAM 	:= 3;
SET SalidaSI	:= 'S';
SET SalidaNO	:= 'N';
SET Var_EsAgro	:= 'S';
SET Var_Desembolsado	:= 'D';
SET Var_Cancelado		:= 'C';
SET EstatusCancelado	:= 'C';

ManejoErrores : BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECASTIGOFIRAPRO');
			END;

SET Var_CreditoID := (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);

    IF(Var_CreditoID  = Entero_Cero) THEN
		SET Par_NumErr   := 01;
		SET Par_ErrMen   := 'El credito no Existe';
		LEAVE ManejoErrores;
    END IF;

SET Var_CredAgro := (SELECT EsAgropecuario FROM CREDITOS WHERE CreditoID = Par_CreditoID);
    IF(Var_CredAgro != Var_EsAgro) THEN
		SET Par_NumErr   := 02;
		SET Par_ErrMen   := 'El credito no es Agropecuario';
		LEAVE ManejoErrores;
    END IF;

    IF(Par_TipoCredCastigo = Entero_Cero) THEN
		SET Par_NumErr   := 03;
		SET Par_ErrMen   := 'Seleccionar el Tipo de Cédito a Castigar';
		LEAVE ManejoErrores;
    END IF;

SET Par_TipoCredCastigo := IFNULL(Par_TipoCredCastigo,creditoR );

IF(Par_TipoCredCastigo = Entero_Cero)THEN
	SET Par_TipoCredCastigo := creditoR;
END IF;

-- Validaciones para entrar a aplicar el Castigo al Credito Residual
IF(Par_TipoCredCastigo = creditoR) THEN
	CALL  CRECASTIGOAGROPRO (
		Par_CreditoID,			Par_PolizaID,			Par_MotivoCastigoID,		Par_Observaciones,		Par_TipoCastigo,
		Par_TipoCobranza,		Par_AltaEncPoliza,		SalidaNO,					Par_NumErr,				Par_ErrMen,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

    -- Se cancelan todas las ministraciones pendientes.
	 UPDATE MINISTRACREDAGRO SET
				Estatus 			= EstatusCancelado,
				FechaMinistracion 	= Aud_FechaActual,
				UsuarioAutoriza 	= Aud_Usuario,
				FechaAutoriza 		= Aud_FechaActual,
				EmpresaID 			= Par_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID 			= Aud_ProgramaID,
				Sucursal 			= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE CreditoID 		= Par_CreditoID
				AND Estatus 		 NOT IN(Var_Desembolsado,Var_Cancelado);

	END IF;


-- Validacion para entrar a aplicar el castigo solo a un Credito Contingente
IF(Par_TipoCredCastigo = creditoRC) THEN
	CALL  CRECASTIGOCONTPRO (
		Par_CreditoID,			Par_PolizaID,			Par_MotivoCastigoID,		Par_Observaciones,		Par_TipoCastigo,
		Par_TipoCobranza,		Par_AltaEncPoliza,		SalidaNO,					Par_NumErr,				Par_ErrMen,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;
END IF;

-- Validacion para entrar a aplicar a los dos Creditos Residual y Contingente
IF(Par_TipoCredCastigo = creditoAM) THEN
	CALL  CRECASTIGOAGROPRO (
		Par_CreditoID,			Par_PolizaID,			Par_MotivoCastigoID,		Par_Observaciones,		Par_TipoCastigo,
		Par_TipoCobranza,		Par_AltaEncPoliza,		SalidaNO,					Par_NumErr,				Par_ErrMen,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

     UPDATE MINISTRACREDAGRO SET
				Estatus 			= EstatusCancelado,
				FechaMinistracion 	= Aud_FechaActual,
				UsuarioAutoriza 	= Aud_Usuario,
				FechaAutoriza 		= Aud_FechaActual,
				EmpresaID 			= Par_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID 			= Aud_ProgramaID,
				Sucursal 			= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE CreditoID 		= Par_CreditoID
				AND Estatus 		 NOT IN(Var_Desembolsado,Var_Cancelado);


	CALL  CRECASTIGOCONTPRO (
		Par_CreditoID,			Par_PolizaID,			Par_MotivoCastigoID,		Par_Observaciones,		Par_TipoCastigo,
		Par_TipoCobranza,		Par_AltaEncPoliza,		SalidaNO,					Par_NumErr,				Par_ErrMen,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;
END IF;

SET Par_NumErr      := '000';
SET Par_ErrMen      := CONCAT('Credito Castigado Exitosamente: ',CONVERT(Par_CreditoID,CHAR));

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen,
           'creditoID' AS control,
           Par_PolizaID AS consecutivo;
END IF;

END TerminaStore$$