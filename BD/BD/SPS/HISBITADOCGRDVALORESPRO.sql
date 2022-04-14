-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISBITADOCGRDVALORESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS HISBITADOCGRDVALORESPRO;

DELIMITER $$
CREATE PROCEDURE `HISBITADOCGRDVALORESPRO`(
	-- Store Procedure: De Alta del historico de la Bitacora de los Documentos de Guarda Valores
	-- al cierre de mes
	-- Modulo Guarda Valores
	Par_FechaCorte					DATE,			-- Fecha de Pase a Historico

	Par_Salida						CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr				INT(11),		-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID					INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario						INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual					DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP					VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal					INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion				BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE Hora_Vacia				TIME;			-- Constante de Hora Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET Hora_Vacia			:= '00:00:00';
	SET	Cadena_Vacia		:= '';
	SET	Salida_SI			:= 'S';
	SET	Salida_NO			:= 'N';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Var_Control			:= Cadena_Vacia;
	SET Aud_FechaActual 	:= NOW();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISBITADOCGRDVALORESPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para la Fecha de corte
		IF( IFNULL(Par_FechaCorte, Fecha_Vacia) = Fecha_Vacia ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La fecha de Pase a historico esta Vacia.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO HISBITADOCGRDVALORES(
			FechaCorte,			BitacoraDocGrdValoresID,	DocumentoID,		FechaRegistro,		HoraRegistro,
			UsuarioRegistroID,	UsuarioPrestamoID,			EstatusPrevio,		EstatusActual,		Observaciones,
			EmpresaID,			Usuario,					FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		SELECT
			Par_FechaCorte,		BitacoraDocGrdValoresID,	DocumentoID,		FechaRegistro,		HoraRegistro,
			UsuarioRegistroID,	UsuarioPrestamoID,			EstatusPrevio,		EstatusActual,		Observaciones,
			EmpresaID,			Usuario,					FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion
		FROM BITACORADOCGRDVALORES
		WHERE FechaRegistro <= Par_FechaCorte;

		CALL BITACORADOCGRDVALORESBAJ(
			Par_FechaCorte,		Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Pase a Historico Registrado Correctamente.';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;
	-- fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$