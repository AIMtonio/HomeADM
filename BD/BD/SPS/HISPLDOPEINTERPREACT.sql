
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLDOPEINTERPREACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPLDOPEINTERPREACT`;

DELIMITER $$
CREATE PROCEDURE `HISPLDOPEINTERPREACT`(
/* ACTUALIZACIÓN DEL HISTORICO DE LAS OPERACIONES INTERNAS PREOCUPANTES. */
	Par_PeriodoInicio			DATE,			-- Fecha de Inicio del Periodo a Reportar.
	Par_PeriodoFin				DATE,			-- Fecha Final del Periodo a Reportar.
	Par_NombreReporte			VARCHAR(200),	-- Nombre del Reporte.
	Par_NumAct					INT(11),		-- Número de Actualización.
	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No

	INOUT Par_NumErr     		INT,			-- Numero de Validación.
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Validación.
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

-- Declaracion de Variables
DECLARE	Var_NumOper				INT(11);
DECLARE Var_EstatusSITI			CHAR(1);
DECLARE Var_FechaSistema		DATE;

-- Declaracion de Constantes
DECLARE Cadena_Vacia		VARCHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT(11);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);
DECLARE TipoAct_SITI		INT(11);
DECLARE TipoRep_SITI		INT(11);
DECLARE TipoRep_Excel		INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';				-- Cadena vacia.
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero				:= 0;				-- Entero Cero.
SET	Str_SI					:= 'S';				-- Salida Si.
SET	Str_NO					:= 'N'; 			-- Salida No.
SET TipoAct_SITI			:= 06;				-- Tipo de Actualización SITI.
SET TipoRep_SITI			:= 01;				-- Tipo de Reporte SITI.
SET TipoRep_Excel			:= 02;				-- Tipo de Reporte Excel.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISPLDOPEINTERPREACT[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		END;

	IF(Par_NumAct = TipoAct_SITI) THEN
		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		UPDATE HISPLDOPEINTERPREO
		SET 
			EstatusSITI = Str_SI
		WHERE EstatusSITI = Str_NO
			AND Fecha <= Par_PeriodoFin;

		INSERT INTO BITPLDOPEINTPREO(
			FechaGeneracion,	NombreReporte,		UsuarioID,		EmpresaID,		Usuario,
			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion
		) VALUES (
			Var_FechaSistema,	Par_NombreReporte,	Aud_Usuario,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
	END IF;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'Actualizacion Realizada Exitosamente.';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			'opeInterPreoID' AS Control,
			Aud_NumTransaccion AS Consecutivo;
END IF;

END TerminaStore$$

