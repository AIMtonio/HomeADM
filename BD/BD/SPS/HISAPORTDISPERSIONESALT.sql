

-- HISAPORTDISPERSIONESALT --

DELIMITER ;
DROP PROCEDURE IF EXISTS `HISAPORTDISPERSIONESALT`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `HISAPORTDISPERSIONESALT`(
/* SP DE ALTA DE DISPERSIONES PROCESADAS EN APORTACIONES */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_AmortizacionID			INT(11),		-- Id de la Amortizacion.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);
DECLARE	Var_FechaSistema	CHAR(15);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Cons_SI			CHAR(1);
DECLARE	Cons_NO			CHAR(1);
DECLARE	EstatusDisp		CHAR(1);
DECLARE Var_CuentaAho   BIGINT(20);
-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET	EstatusDisp			:= 'D'; 			-- Estatus Procesada de Dispersión (Dispersada).
SET Aud_FechaActual 	:= NOW();
SET Var_CuentaAho 		:= (SELECT CuentaAhoID FROM APORTACIONES WHERE  AportacionID = Par_AportacionID);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISAPORTDISPERSIONESALT');
			SET Var_Control:= 'sqlException' ;
		END;

	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET Var_FechaSistema := IFNULL(Var_FechaSistema, Fecha_Vacia);

	INSERT INTO HISAPORTDISPERSIONES(
		AportacionID,		AmortizacionID,		ClienteID,			CuentaAhoID,		Capital,
		Interes,			InteresRetener,		Total,				Estatus,			FechaVencimiento,
		FechaDispersion,	EmpresaID,			UsuarioID,			FechaActual,		DireccionIP,
		ProgramaID,			Sucursal,			NumTransaccion)
	SELECT
		AportacionID,		AmortizacionID,		ClienteID,			CuentaAhoID,		Capital,
		Interes,			InteresRetener,		Total,				EstatusDisp,		FechaVencimiento,
		Var_FechaSistema,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
	FROM APORTDISPERSIONES
	WHERE CuentaAhoID = Var_CuentaAho;

	CALL APORTDISPERSIONESBAJ(
		Par_AportacionID,	Par_AmortizacionID,		Cons_NO,			Par_NumErr,			Par_ErrMen,
		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Dispersiones Procesadas Exitosamente.';
	SET Var_Control:= 'aportacionID' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_AportacionID AS Consecutivo;
END IF;

END TerminaStore$$