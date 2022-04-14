
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTASOCIODEVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTASOCIODEVPRO`;

DELIMITER $$
CREATE PROCEDURE `APORTASOCIODEVPRO`(
	Par_ClienteID			BIGINT,
	Par_NumeroMov			BIGINT,
	Par_CantidadMov			DECIMAL(12,2),
	Par_MonedaID			INT,
	Par_AltaEncPoliza		CHAR(1),

	Par_SucursalID			INT(2),
	INOUT Par_Poliza		BIGINT,
	Par_AltaDetPol			CHAR(1),
	Par_CajaID				INT(11),
	Par_UsuarioID			INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	Par_EmpresaID			INT,
	Aud_Usuario				INT,

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)

TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_FechaOper 	  	 DATE;
DECLARE Var_FechaApl       	DATE;
DECLARE Var_EsHabil        	CHAR(1);
DECLARE Var_SucCliente		INT(5);
DECLARE Var_ReferDetPol		VARCHAR(11);

-- Declaracion de Constantes
DECLARE ConContaAportSocio	INT(11);
DECLARE ConceptosCaja		INT(11);
DECLARE NatCargo			CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE	descrpcionMov		VARCHAR(100);
DECLARE Entero_Cero			INT(1);
DECLARE TipoAportacion		CHAR(1);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Est_Vigente     	CHAR(1);
DECLARE Est_Vencido     	CHAR(1);
DECLARE Est_Castigo     	CHAR(1);
DECLARE EstatusInvVigente	CHAR(1);
DECLARE Decimal_Cero		DECIMAL;
DECLARE TipoInstrumentoID	INT(11);
DECLARE Var_NumErr			INT(11);
DECLARE Esta_Inactivo		CHAR(1);
DECLARE BajaVoluntaria		INT(11);
DECLARE BajaVoluntariaTxt	VARCHAR(20);
-- Asignacion de Constantes

SET ConContaAportSocio	:= 401;        	  				-- Concepto Contable de Devolucion Aportacion Socio tabla CONCEPTOSCONTA
SET ConceptosCaja		:=1;					 		-- Conceptos caja	Aportacion Social
SET NatCargo			:='C';							-- Naturaleza Abono
SET SalidaNO			:='N';							-- Salida No
SET SalidaSI			:='S';							-- Salida Si
SET descrpcionMov		:='DEVOLUCION APORTACION SOCIAL';-- Descripcion del Movimiento
SET Entero_Cero			:=0;
SET TipoAportacion		:='D';							-- Tipo de Movimiento Aportacion
SET Cadena_Vacia		:='';							-- Cadena Vacia
SET Est_Vigente         := 'V';         -- Estatus del Credito: Vigente
SET Est_Vencido         := 'B';         -- Estatus del Credito: Vencido
SET Est_Castigo         := 'K';         -- Estatus del Credito: Castigado
SET EstatusInvVigente	:='N';			-- Estatus Vigente (INVERSIONES)
SET Decimal_Cero		:=0.00;			-- Decimal 0
SET TipoInstrumentoID	:=4;			-- Corresponde TIPOINSTRUMENTOS (Cliente)
SET Var_NumErr			:=0;						-- se inicializa el valor del error
SET Esta_Inactivo 		:= 'I' ; -- Estatus Inactivo --
SET BajaVoluntaria		:= 13;		-- Baja Voluntaria
SET BajaVoluntariaTxt	:='BAJA VOLUNTARIA';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SP-APORTASOCIODEVPRO[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		END;

	-- Inicializacion
	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := Cadena_Vacia;
	SET Aud_FechaActual := NOW();
	SET Var_FechaOper   := (SELECT FechaSistema FROM PARAMETROSSIS);

	-- Validamos que el Cliente no Tenga un Credito Vigente
	IF EXISTS (SELECT Cre.ClienteID
				FROM CREDITOS Cre
					WHERE Cre.ClienteID = Par_ClienteID
				  AND ( Cre.Estatus = Est_Vigente
				   OR   Cre.Estatus = Est_Vencido
				   OR   Cre.Estatus = Est_Castigo   ) )THEN

		SET Par_NumErr := 1;
		SET Par_ErrMen := "El Socio tiene un Credito Vigente. No se puede Realizar la Devolucion de la Aportacion";
		LEAVE ManejoErrores;
	END IF;

	-- Validamos que el Cliente no Tenga una Inversion Vigente
	IF EXISTS (SELECT ClienteID
				FROM INVERSIONES
					WHERE Estatus=EstatusInvVigente
					AND ClienteID=Par_ClienteID)THEN

		SET Par_NumErr := 2;
		SET Par_ErrMen := "El Socio tiene una Inversion Vigente. No se puede Realizar la Devolucion de la Aportacion";
		LEAVE ManejoErrores;

	END IF;

	--  se valida que el cliente no tenga cuentas con Saldo
	IF EXISTS(SELECT Saldo
				FROM CUENTASAHO
				WHERE ClienteID=Par_ClienteID
				AND Saldo > Decimal_Cero)THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := "El Socio aun tiene cuentas con saldo. No se puede Realizar la Devolucion de la Aportacion";
		LEAVE ManejoErrores;
	END IF;

	-- calcula la fecha de la aplicacion y operacion
	CALL DIASFESTIVOSCAL(
		Var_FechaOper,		Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	-- Consulta la sucursal del Cliente
	SELECT  Cli.SucursalOrigen  INTO Var_SucCliente
		FROM  CLIENTES Cli
		WHERE Cli.ClienteID   = Par_ClienteID;

	-- alta en APORTASOCIOMOV,alta y actualizacion en APORTACIONSOCIO
	CALL APORTASOCIOMOVALT(
		Par_ClienteID,	Par_CantidadMov,TipoAportacion,	Par_SucursalID,	Par_CajaID,
		Var_FechaOper,	Par_UsuarioID,	descrpcionMov,	Par_NumeroMov,	Par_MonedaID,
		SalidaNO,		Par_NumErr,		Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	-- Alta en Encabezado y Detalle de la poliza contable
	SET Var_ReferDetPol 	:= CONVERT(Par_ClienteID, CHAR);

	CALL CONTACAJAPRO(
		Par_NumeroMov,		Var_FechaApl,		Par_CantidadMov,	descrpcionMov,		Par_MonedaID,
		Var_SucCliente,		Par_AltaEncPoliza,	ConContaAportSocio,	Par_Poliza,			Par_AltaDetPol,
		ConceptosCaja,		NatCargo,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
		TipoInstrumentoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	/** REGISTRO EN LA BITÁCORA DE ACTIVACIONES E INACTIVACIONES, ANTES DE LA ACTUALIZACION
	 ** DE ESTATUS DEL CLIENTE.*/
	CALL BITACTIVACIONESCTESALT(
		Par_ClienteID,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	UPDATE CLIENTES
	SET Estatus			= Esta_Inactivo,
		TipoInactiva	= BajaVoluntaria,
		MotivoInactiva	= BajaVoluntariaTxt
	WHERE ClienteID = Par_ClienteID;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := "Devolucion Realizada Exitosamente.";

END ManejoErrores;  -- End del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen AS ErrMen,
			'tipoOperacion' AS control,
			Par_Poliza AS consecutivo;
	END IF;

END TerminaStore$$

