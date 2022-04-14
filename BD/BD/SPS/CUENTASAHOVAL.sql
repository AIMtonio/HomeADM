-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOVAL`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOVAL`(
	/* VALIDACIÓN DE CUENTAS DE AHORRO. */
	Par_CuentaAhoID				BIGINT(12),			-- Número de la cuenta de ahorro.
	Par_TipoVal					TINYINT UNSIGNED,	-- Tipo de validación.
	Par_Salida					CHAR(1),			-- Tipo Salida
	INOUT Par_NumErr			INT(11),			-- Número de Error.
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error.

	/* Parámetros de Auditoría */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Estatus				CHAR(1);

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE TipoCuentaActiva		INT(1);
	DECLARE EstatusActiva			CHAR(1);
	DECLARE EstatusBloqueada		CHAR(1);
	DECLARE EstatusCancelada		CHAR(1);
	DECLARE EstatusInactiva			CHAR(1);
	DECLARE EstatusRegistrada		CHAR(1);
	DECLARE Salida_SI				CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero					:= 0;		-- Entero en Cero.
	SET Cadena_Vacia    			:='';		-- Cadena o String Vacío.
	SET TipoCuentaActiva			:= 01;		-- Validación de cuenta activa y existente.
	SET EstatusActiva				:= 'A';		-- Estatus de la cuenta: Activa
	SET EstatusBloqueada			:= 'B';		-- Estatus de la cuenta: Bloqueada
	SET EstatusCancelada			:= 'C';		-- Estatus de la cuenta: Cancelada
	SET EstatusInactiva 			:= 'I';		-- Estatus de la cuenta: Inactiva
	SET EstatusRegistrada			:= 'R';		-- Estatus de la cuenta: Registrada
	SET Salida_SI					:='S';		-- Salida del Mensaje.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASAHOVAL');
		END;

	IF(IFNULL(Par_TipoVal, Entero_Cero) = TipoCuentaActiva)THEN
		IF(IFNULL(Par_CuentaAhoID, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Cuenta esta vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT CuentaAhoID FROM CUENTASAHO
			WHERE CuentaAhoID=Par_CuentaAhoID)THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= CONCAT('El Numero de Cuenta no Existe.');
			LEAVE ManejoErrores;
		END IF;

		SET Var_Estatus := (SELECT Estatus FROM CUENTASAHO WHERE CuentaAhoID=Par_CuentaAhoID);
		SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);
		IF(Var_Estatus NOT IN(EstatusActiva, EstatusBloqueada))THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= CONCAT('La Cuenta No se Encuentra Activa. ');
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:=	0;
		SET Par_ErrMen	:=	'Validacion Exitosa.';
		LEAVE ManejoErrores;
	END IF;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$