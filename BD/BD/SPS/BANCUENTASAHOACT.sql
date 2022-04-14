-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCUENTASAHOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCUENTASAHOACT`;
DELIMITER $$

CREATE PROCEDURE `BANCUENTASAHOACT`(
	Par_CuentaAhoID			BIGINT(12),					-- ID de la cuenta de Ahorro.
	Par_Motivo 				VARCHAR(100),				-- Motivo de registro
	Par_NumAct	 			TINYINT UNSIGNED,			-- Numero de Actualizacion

	Par_Salida				CHAR(1),					-- Parametro de Salida
	INOUT Par_NumErr		INT(11),					-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),				-- Mensaje de Error

    Par_EmpresaID			INT(11),					-- Parametro de Auditoria
	Aud_Usuario         	INT(11),					-- Parametro de Auditoria
	Aud_FechaActual     	DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP     	VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID      	VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal        	INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion  	BIGINT(20)					-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);					-- Variable de Control.
	DECLARE	Var_Fecha			DATE;            				-- Fecha Actual

	-- Declaracion de Constates
	DECLARE Cadena_Vacia		CHAR(1);						-- Cadena Vacia
	DECLARE Entero_Cero			INT(11);						-- Entero Cero
	DECLARE Fecha_Vacia			DATE;							-- Fecha Vacia
	DECLARE	Act_AperturaNivel2	INT(11);						-- Actualizacion por nivel de Cuenta
    DECLARE Salida_Si			CHAR(1);						-- Salida SI
    DECLARE Var_UsuarioID		INT(11);						-- ID del Usuario
    DECLARE Var_Motivo			VARCHAR(26);					-- Motivo de Actualizacion
    DECLARE Var_ActApertura		TINYINT UNSIGNED;				-- Apertura

    -- Asignacion de Valor a Constantes.
	SET Cadena_Vacia			:= '';								-- Cadena Vacia
	SET Fecha_Vacia			    := '1900-01-01';					-- Fecha Vacia
	SET Entero_Cero			    := 0;								-- Entero Cero
	SET Act_AperturaNivel2		:= '1';								-- Actualizacion por nivel de Cuenta
	SET Salida_Si				:= 'S';             				-- Salida SI
	SET Var_UsuarioID			:= 1;								-- ID del Usuario
	SET Var_Motivo				:= 'Registro en la Banca Movil';	-- Motivo de Actualizacion
	SET Var_ActApertura			:= 1;								-- Apertura

	SET Par_CuentaAhoID			:= IFNULL(Par_CuentaAhoID,Entero_Cero);
	SET Par_Motivo 			    := IFNULL(Par_Motivo,Cadena_Vacia);
	SET Par_NumAct 		    	:= IFNULL(Par_NumAct,Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-BANCUENTASAHOACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual	:= NOW();

		SELECT FechaSistema INTO Var_Fecha
			FROM PARAMETROSSIS;

		IF(Par_NumAct = Act_AperturaNivel2) THEN
			CALL CUENTASAHOACT (Par_CuentaAhoID,	Var_UsuarioID,		Var_Fecha,		Var_Motivo,		Var_ActApertura,
								Salida_Si,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
		END IF;

	END ManejoErrores;


	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_CuentaAhoID as consecutivo,
				Var_Control AS control;
	END IF;


END TerminaStore$$
