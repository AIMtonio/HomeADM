
-- SP MONEDASWSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS MONEDASWSACT;

DELIMITER $$
CREATE PROCEDURE `MONEDASWSACT`(
# ACTUALIZACION DE MONEDAS SE UTILIZA EN LA TAREA ACT-TIPOCAMBIO-BANXICOWS
	Par_IDSerieBMX		VARCHAR(10),		-- ID de la Serie BANXICO.
	Par_TipCamDof		DECIMAL(14,6),		-- Monto Tipo de Cambio en Dof(Diario oficial de la Federacion)
	Par_FechaBmx		VARCHAR(15),		-- Fecha regresa el WS banxico del valor de la moneda
	Par_NumAct			TINYINT UNSIGNED,	-- Numero de actualizacion
	Par_Salida			CHAR(1),   	 		-- Parametro de salida S= si, N= no

	INOUT Par_NumErr	INT(11),    		-- Parametro de salida numero de error
	INOUT Par_ErrMen	VARCHAR(400), 		-- Parametro de salida mensaje de error
	/*Parámetros de Auditoría.*/
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
DECLARE Var_MonedaID		INT(11);			-- Varible para el id de moneda
DECLARE Var_FechaSis		DATE;

-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT(1);
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Str_SI				CHAR(1);

DECLARE Str_NO				CHAR(1);
DECLARE Entero_Uno      	INT(11);
DECLARE Act_TipCamDof	 	INT(11);
DECLARE TipoAlerta_Exito	INT(11);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia        	:= '';			-- Constante cadena vacia.
SET Fecha_Vacia         	:= '1900-01-01';-- Constante Fecha vacia.
SET Entero_Cero         	:= 0;			-- Constante Entero cero.
SET Decimal_Cero			:= 0.0;			-- Decimal cero.
SET Str_SI					:= 'S';			-- Constante SI.

SET Str_NO					:= 'N';			-- Constante NO.
SET Entero_Uno          	:= 1;			-- Entero Uno.
SET Act_TipCamDof			:= 1;			-- Actualizacion Tipo de cambio DoF.
SET TipoAlerta_Exito		:= 1;			-- Tipo de Alerta Exito.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-MONEDASWSACT[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		SET Var_Control := 'sqlException';
	END;

	IF(IFNULL(Par_IDSerieBMX, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El identificador de la Serie Banxico esta vacio.';
		SET Var_Control := 'iDSerieBMX' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipCamDof, Decimal_Cero) = Decimal_Cero) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Tipo de Cambio DOF esta vacio.';
		SET Var_Control := 'tipCamDof' ;
		LEAVE ManejoErrores;
	END IF;

	SET Var_MonedaID := (SELECT MonedaId FROM MONEDAS WHERE IDSerieBanxico = Par_IDSerieBMX LIMIT 1);
	SET Var_MonedaID := IFNULL(Var_MonedaID,Entero_Cero);

	IF(Var_MonedaID != Entero_Cero)THEN
		CALL HISMONEDASALT(
			Var_MonedaID,		Str_NO,				Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Par_FechaBmx := IFNULL(Par_FechaBmx,Var_FechaSis);

		UPDATE MONEDAS SET
			TipCamDof		= Par_TipCamDof,
			FechaRegistro	= Var_FechaSis,
			FechaActBanxico	= Par_FechaBmx,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,

			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE MonedaId = Var_MonedaID;

		CALL MONEDASENVALERTASPRO(
			Var_MonedaID,		TipoAlerta_Exito,	Str_NO,				Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);
	END IF;

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Divisa Actualizada Exitosamente: ',Var_MonedaID,'.');
	SET Var_Control := 'monedaID';

 END ManejoErrores;

	IF (Par_Salida = Str_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_MonedaID AS Consecutivo;
	END IF;

END TerminaStore$$

