
-- SP HISMONEDASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS HISMONEDASALT;

DELIMITER $$
CREATE PROCEDURE `HISMONEDASALT`(
# ALTA PARA HISTORICO DE MONEDAS.
	Par_MonedaID        INT(11),		-- ID de la moneda
	Par_Salida          CHAR(1),   	 	-- Parametro de salida S= si, N= no
	INOUT Par_NumErr    INT(11),    	-- Parametro de salida numero de error
	INOUT Par_ErrMen    VARCHAR(400), 	-- Parametro de salida mensaje de error
	/* Parámetros de Auditoría.*/
	Par_EmpresaID		INT(11),

	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),

	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
DECLARE Var_FechaRegistro	DATE;				-- Fecha del sistema que se registra el historico
DECLARE Var_HisMonedaID		INT(11);			-- ID consecutivo historico de moneda

-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT(1);
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Str_SI				CHAR(1);

DECLARE Str_NO				CHAR(1);
DECLARE Entero_Uno      	INT(11);
DECLARE Act_PesosxDolarEUA 	INT(11);
DECLARE Act_ValorUDIS	 	INT(11);
DECLARE Cons_Pesos		 	INT(11);
DECLARE Cons_UDIS		 	INT(11);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia        	:= '';				-- Constante cadena vacia ''
SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha vacia 1900-01-01
SET Entero_Cero         	:= 0;				-- Constante Entero cero 0
SET Decimal_Cero			:= 0.0;				-- Decimal cero
SET Str_SI					:= 'S';				-- Parametro de salida SI

SET Str_NO					:= 'N';				-- Parametro de salida NO
SET Entero_Uno          	:= 1;				-- Entero Uno
SET Act_PesosxDolarEUA 		:= 1;				-- Actualizacion Tipo de cambio pesos por dolar EUA
SET Act_ValorUDIS	 		:= 2;				-- Actualizacion valor de UDIS
SET Cons_Pesos		 		:= 1;				-- Constante 1  pesos TABLA MONEDAS
SET Cons_UDIS		 		:= 4;				-- Constante 4 unidades de inversion TABLA MONEDAS

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISMONEDASALT[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		SET Var_Control := 'sqlException';
	END;

	IF(IFNULL(Par_MonedaID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr :='001';
		SET Par_ErrMen := 'El ID de la Moneda esta vacio.';
		SET Var_Control := 'monedaID' ;
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := NOW();

	INSERT INTO `HIS-MONEDAS` (
		MonedaId,			EmpresaID,			Descripcion,		DescriCorta,		Simbolo,
		TipCamComVen,		TipCamVenVen,		TipCamComInt,   	TipCamVenInt,		TipoMoneda,
		TipCamFixCom,		TipCamFixVen,		TipCamDof,			EqCNBVUIF,			EqBuroCred,
		FechaRegistro,		IDSerieBanxico,		FechaActBanxico,	Usuario,			FechaActual,
		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
	SELECT
		MonedaId,			EmpresaID,			Descripcion,		DescriCorta,		Simbolo,
		TipCamComVen,		TipCamVenVen,		TipCamComInt,   	TipCamVenInt,		TipoMoneda,
		TipCamFixCom,		TipCamFixVen,		TipCamDof,			EqCNBVUIF,			EqBuroCred,
		FechaRegistro,		IDSerieBanxico,		FechaActBanxico,	Usuario,			FechaActual,
		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion
	FROM MONEDAS
	WHERE MonedaId = Par_MonedaID;

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT("El Historico de Divisa se ha dado de Alta Exitosamente: '",Par_MonedaID);
	SET Var_Control := 'monedaID';

END ManejoErrores;

	IF (Par_Salida = Str_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_MonedaID AS Consecutivo;
	END IF;

END TerminaStore$$

