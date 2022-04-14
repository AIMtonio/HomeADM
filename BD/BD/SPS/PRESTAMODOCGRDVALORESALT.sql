-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESTAMODOCGRDVALORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS PRESTAMODOCGRDVALORESALT;

DELIMITER $$
CREATE PROCEDURE `PRESTAMODOCGRDVALORESALT`(
	-- Store Procedure: De Alta  de Prestamo de Documentos de Guarda Valores
	-- Modulo Guarda Valores
	Par_CatMovimientoID				INT(11),		-- ID de Tabla CATMOVDOCGRDVALORES
	Par_DocumentoID					BIGINT(20),		-- ID de Tabla DOCUMENTOSGRDVALORES
	Par_UsuarioRegistroID			INT(11),		-- Usuario que Registra el Documento a Prestamo
	Par_UsuarioPrestamoID			INT(11),		-- Usuario que Solicita el Documento a Prestamo
	Par_ClaveUsuario				VARCHAR(45),	-- Usuario que Autoriza el Documento a Custodia

	Par_Observaciones				VARCHAR(500),	-- Comentarios del Prestamo
	Par_SucursalID					INT(11),		-- Sucursal Origen del Prestamo

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
	DECLARE Var_ControlValidacion	VARCHAR(100);	-- Variable de Retorno en Pantalla del SP Validacion
	DECLARE Var_CatMovimientoID		INT(11);		-- Variable Numero de Movimiento
	DECLARE Var_DocumentoID			BIGINT(20);		-- Variable Numero de Documento

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO

	DECLARE Est_Vigente				CHAR(1);		-- Estatus Vigente
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno				INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Declaracion de Parametros
	DECLARE Par_PrestamoDocGrdValoresID		BIGINT(20);		-- ID de tabla
	DECLARE Par_UsuarioAutorizaID 			INT(11);		-- Usuario que Autoriza el Prestamo
	DECLARE Par_HoraRegistro				TIME;			-- Hora de Registro del Prestamo Documento
	DECLARE Par_FechaRegistro				DATE;			-- Fecha de Registro de la Solicitud de Prestamo del Documento

	-- Declaracion de Constantes para Validacion
	DECLARE Val_AltaPrestamo	TINYINT UNSIGNED;			-- Numero de Validacion 1.- Guarda Valores --> Registro --> Pantalla Solicitud Prestamo Documentos

	-- Asignacion  de constantes
	SET Hora_Vacia		:= '00:00:00';
	SET Fecha_Vacia		:= '1900-01-01';
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET Salida_NO		:= 'N';
	SET Est_Vigente 	:= 'V';

	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;

	SELECT IFNULL(FechaSistema, Fecha_Vacia)
	INTO Par_FechaRegistro
	FROM PARAMETROSSIS LIMIT 1;

	-- Asignacion de Constantes para Validacion
	SET Val_AltaPrestamo	:= 1;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PRESTAMODOCGRDVALORESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SELECT UsuarioID
		INTO Par_UsuarioAutorizaID
		FROM USUARIOS
		WHERE Clave = Par_ClaveUsuario;

		-- Validaciones Generales
		CALL PRESTAMODOCGRDVALORESVAL(
			Entero_Cero,			Par_CatMovimientoID,	Par_DocumentoID,	Par_UsuarioRegistroID,	Par_UsuarioPrestamoID,
			Par_UsuarioAutorizaID,	Entero_Cero,			Par_Observaciones,	Par_SucursalID,			Var_ControlValidacion,
			Val_AltaPrestamo,		Salida_NO,				Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		-- Verifico si hay error en las Validaciones Generales
		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Var_Control	:= Var_ControlValidacion;
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(MAX(PrestamoDocGrdValoresID), Entero_Cero) + Entero_Uno
		INTO Par_PrestamoDocGrdValoresID
		FROM PRESTAMODOCGRDVALORES;

		SET Par_HoraRegistro := IFNULL(TIME(NOW()), Hora_Vacia);
		SET Aud_FechaActual  := NOW();

		INSERT INTO PRESTAMODOCGRDVALORES (
			PrestamoDocGrdValoresID,		CatMovimientoID,		DocumentoID,			HoraRegistro,			FechaRegistro,
			UsuarioRegistroID,				UsuarioPrestamoID,		UsuarioAutorizaID,		UsuarioDevolucionID,	FechaDevolucion,
			HoraDevolucion,					Observaciones,			SucursalID,				Estatus,
			EmpresaID,						Usuario,				FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,						NumTransaccion)
		VALUES(
			Par_PrestamoDocGrdValoresID,	Par_CatMovimientoID,	Par_DocumentoID,		Par_HoraRegistro,		Par_FechaRegistro,
			Par_UsuarioRegistroID,			Par_UsuarioPrestamoID,	Par_UsuarioAutorizaID,	Entero_Cero,			Fecha_Vacia,
			Hora_Vacia,						Par_Observaciones,		Par_SucursalID,			Est_Vigente,
			Aud_EmpresaID,					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,					Aud_NumTransaccion);

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= CONCAT('El Prestamo: ', Par_PrestamoDocGrdValoresID,' se ha Registrado Correctamente.');
		SET Var_Control	:= 'prestamoDocGrdValoresID';

	END ManejoErrores;
	-- fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_PrestamoDocGrdValoresID AS Consecutivo;
	END IF;

END TerminaStore$$