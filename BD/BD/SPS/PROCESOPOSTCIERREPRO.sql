DELIMITER ;
DROP PROCEDURE IF EXISTS PROCESOPOSTCIERREPRO;
DELIMITER $$

CREATE PROCEDURE PROCESOPOSTCIERREPRO(

	Par_FecActual			DATETIME,				-- Optenemos la fecha del  Actual del sistema

    Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,					-- PARAMETROS DE SALIDA
	INOUT Par_ErrMen		VARCHAR(400),			-- PARAMETROS DE SALIDA

	Aud_EmpresaID			INT(11),				-- Parametros de auditoria
	Aud_Usuario				INT(11),				-- Parametros de auditoria
	Aud_FechaActual			DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal			INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(1);				-- Entero cero
	DECLARE Cadena_Vacia        	CHAR(1);			-- Cadena Vaca
	DECLARE Entero_Uno				INT(11);			-- Entero uno
	DECLARE Entero_Dos				INT(11);			-- Entero dos
	DECLARE Fecha_Vacia				DATE;				-- Fecha Vacia
	DECLARE Str_Si					CHAR(1);			-- constante para s
	DECLARE Str_No					CHAR(1);			-- Constantes para N
	DECLARE SalidaSI				CHAR(1);			-- Constante de salida SI

	-- Declaracion de variables


	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;					-- Entero cero
	SET Cadena_Vacia        	:= '';					-- cCadena Vacia
	SET Entero_Uno				:= 1;					-- Entero uno
	SET Entero_Dos				:= 2;					-- Entero dos
	SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET Str_Si					:= 'S';					-- constanteE Para S
	SET Str_No					:= 'N';					-- Constantes para N
	SET SalidaSI				:= 'S';					-- Constante para la salida si


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen	=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										   'esto le ocasiona. Ref: PROCESOPOSTCIERREPRO');
			END;

		INSERT INTO TC_TARJETASLIMITESHIS (
				TarjetaID, NoDisposiDia, Fecha)
		SELECT	TarjetaID, NoDisposiDia, Par_FecActual
			FROM TC_TARJETASLIMITES;

		DELETE FROM TC_TARJETASLIMITES;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Registros pasados al historico con exito';

    END ManejoErrores;  -- END del Handler de Errores.

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$
