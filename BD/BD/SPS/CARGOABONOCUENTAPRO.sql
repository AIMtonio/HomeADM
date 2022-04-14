
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOABONOCUENTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGOABONOCUENTAPRO`;

DELIMITER $$
CREATE PROCEDURE `CARGOABONOCUENTAPRO`(
	Par_CuentaAhoID			BIGINT(12),
	Par_ClienteID			BIGINT,
	Par_NumeroMov			BIGINT,
	Par_Fecha				DATE,
	Par_FechaAplicacion		DATE,

	Par_NatMovimiento		CHAR(1),
	Par_CantidadMov			DECIMAL(12,2),
	Par_DescripcionMov		VARCHAR(150),
	Par_ReferenciaMov		VARCHAR(50),
	Par_TipoMovAhoID		CHAR(4),

	Par_MonedaID			INT,
	Par_SucCliente			INT,
	Par_AltaEncPoliza		CHAR(1),
	Par_ConceptoCon			INT,
	INOUT Par_Poliza		BIGINT,

	Par_AltaPoliza			CHAR(1),
	Par_ConceptoAho			INT,
	Par_NatConta			CHAR(1),
    Par_Consecutivo			BIGINT,
	Par_Salida				CHAR(1),

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

# DECLARACIÓN DE VARIABLES.
	DECLARE Var_Control	    	VARCHAR(100);
	DECLARE Var_Consecutivo		BIGINT(20);
	DECLARE Var_EstatusCli		CHAR(1);
	DECLARE Var_ClienteID		BIGINT;

# DECLARACIÓN DE CONSTANTES.
	DECLARE ClienteInactivo		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE TipoOperacionCTA	INT(11);

# ASIGNACIÓN DE CONSTANTES.
	SET	ClienteInactivo		:= 'I';
	SET Entero_Cero			:= 0;
	SET	Salida_NO       	:= 'N';
	SET Salida_SI           := 'S';
	SET TipoOperacionCTA	:= 1;		-- Tipo de operacion 1 = Abonos y cargos cuenta, 2= Pago de credito.

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CARGOABONOCUENTAPRO');
				SET Var_Control = 'sqlException';
			END;

		SET Var_ClienteID	:= Entero_Cero;
		SET Par_ClienteID	:= IFNULL(Par_ClienteID, Entero_Cero);

		SELECT Cli.ClienteID, Cli.Estatus	INTO	Var_ClienteID, Var_EstatusCli
			FROM CLIENTES Cli
				INNER JOIN CUENTASAHO Cue ON Cue.ClienteID=Cli.ClienteID
			WHERE Cue.CuentaAhoID	= Par_CuentaAhoID;

		IF (Var_EstatusCli = ClienteInactivo) THEN
			SET Par_NumErr	:= 	001;
			SET Par_ErrMen	:=	'El Cliente Indicado se Encuentra Inactivo.';
			SET Var_Control	:=  'cuentaAhoIDAb' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClienteID = Entero_Cero ) THEN
			SET Par_ClienteID := Var_ClienteID;
		END IF;

		CALL CONTAAHOPRO(
			Par_CuentaAhoID,	Par_ClienteID,		Par_NumeroMov,			Par_Fecha,				Par_FechaAplicacion,
			Par_NatMovimiento,	Par_CantidadMov,	Par_DescripcionMov,		Par_ReferenciaMov,		Par_TipoMovAhoID,
			Par_MonedaID,		Par_SucCliente,		Par_AltaEncPoliza, 		Par_ConceptoCon,		Par_Poliza,
			Par_AltaPoliza,		Par_ConceptoAho,	Par_NatConta,			Par_Consecutivo,		Salida_NO,
			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			SET Var_Control		:= 'cuentaAhoID' ;
			SET Var_Consecutivo := Par_Poliza;
			LEAVE ManejoErrores;
		END IF;

		-- EJECUTA PROCESO DE DETECCION DE OPERACIONES INUSUALES AL MOMENTO DE LA TRANSACCIÓN POR ABONOS O CARGOS A CUENTA.
		CALL PLDOPEINUSALERTTRANSPRO(
			TipoOperacionCTA,	Par_ClienteID,		Par_CuentaAhoID,	Par_TipoMovAhoID,	Par_NatMovimiento,
			Entero_Cero,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			CALL BITAERRORPLDDETOPETRANALT(
				'PLDOPEINUSALERTTRANSPRO',	Par_NumErr,			Par_ErrMen,			TipoOperacionCTA,	Par_ClienteID,
				Entero_Cero,				Par_NatMovimiento,	Par_CantidadMov,	Salida_NO,			Par_NumErr,
				Par_ErrMen,					Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= 'Transaccion Realizada';
		SET Var_Control		:= 'cuentaAhoID';
		SET Var_Consecutivo := Par_Poliza;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$