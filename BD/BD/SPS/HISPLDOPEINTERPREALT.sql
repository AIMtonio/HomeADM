
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLDOPEINTERPREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPLDOPEINTERPREALT`;

DELIMITER $$
CREATE PROCEDURE `HISPLDOPEINTERPREALT`(
/* ALTA EN EL HISTORICO DE LAS OPERACIONES INTERNAS PREOCUPANTES. */
	Par_PeriodoInicio			DATE,			-- Fecha de Inicio del Periodo a Reportar.
	Par_PeriodoFin				DATE,			-- Fecha Final del Periodo a Reportar.
	Par_EstatusSITI				CHAR(1),		-- Indica si el reporte generado es el enviado al SITI.
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
DECLARE	Var_NumOper			INT(11);
DECLARE	Var_RegBitID		BIGINT(20);

-- Declaracion de Constantes
DECLARE Cadena_Vacia		VARCHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT(11);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);
DECLARE Estatus_Rep			INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';				-- Cadena vacia.
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero				:= 0;				-- Entero Cero.
SET	Str_SI					:= 'S';				-- Salida Si.
SET	Str_NO					:= 'N'; 			-- Salida No.
SET Estatus_Rep				:= 3;				-- Estatus de la operación: Reportado.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISPLDOPEINTERPREALT[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		END;

	SET Var_NumOper			:= (SELECT COUNT(*) FROM PLDOPEINTERPREO WHERE Fecha <= Par_PeriodoFin);
	SET Var_RegBitID		:= (SELECT MAX(RegistroID) FROM BITPLDOPEINTPREO);
	SET Var_RegBitID		:= IFNULL(Var_RegBitID, Entero_Cero);
	SET Par_PeriodoInicio	:= (SELECT FechaGeneracion FROM BITPLDOPEINTPREO WHERE RegistroID = Var_RegBitID);
	SET Par_PeriodoInicio	:= IFNULL(Par_PeriodoInicio, Fecha_Vacia);
	SET Aud_FechaActual		:= NOW();

	# SI EXISTEN OPERACIONES EN EL PERIODO.
	IF(Var_NumOper > Entero_Cero) THEN
		INSERT INTO HISPLDOPEINTERPREO(
			Fecha,				OpeInterPreoID,		ClaveRegistra,	NombreReg,		CatProcedIntID,
			CatMotivPreoID,		FechaDeteccion,		CategoriaID,	SucursalID,		ClavePersonaInv,
			NomPersonaInv,		CteInvolucrado,		Frecuencia,		DesFrecuencia,	DesOperacion,
			Estatus,			ComentarioOC,		FechaCierre,	EstatusSITI,	EmpresaID,
			Usuario,			FechaActual,		DireccionIP,	ProgramaID,		Sucursal,
			NumTransaccion)
		SELECT
			Fecha,				OpeInterPreoID,		ClaveRegistra,	NombreReg,		CatProcedIntID,
			CatMotivPreoID,		FechaDeteccion,		CategoriaID,	SucursalID,		ClavePersonaInv,
			NomPersonaInv,		CteInvolucrado,		Frecuencia,		DesFrecuencia,	DesOperacion,
			Estatus,			ComentarioOC,		FechaCierre,	Str_NO,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion
		FROM PLDOPEINTERPREO
		WHERE Estatus = Estatus_Rep
			AND Fecha BETWEEN Par_PeriodoInicio AND Par_PeriodoFin;

		# SE ELIMINAN LOS REGISTROS DE LA TABLA DE OPERACIONES INTERNAS PREOCUPANTES.
		CALL PLDOPEINTERPREOBAJ(
			Par_PeriodoInicio,	Par_PeriodoFin,		Str_NO,				Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	/** SI EL ESTATUS INDICA QUE SE ESTA GENERANDO EL REPORTE EN EXCEL (VALOR NO),
	 ** SE DEBE ESTAR LIMPIANDO Y REGISTRANDO LAS OPERACIONES EN LA TABLA DEL
	 ** REPORTE CNBV.*/
	IF(Par_EstatusSITI = Str_NO)THEN
		# SE ELIMINAN LOS REGISTROS DE LA TABLA CNBV DE OPERACIONES INTERNAS PREOCUPANTES.
		CALL PLDCNBVOPEINTPREOBAJ(
			Par_PeriodoInicio,	Par_PeriodoFin,		Str_NO,				Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		# SE GUARDAN LOS DATOS EN LA TABLA DE LA QUE SE TOMAN LOS DATOS PARA GENERAR EL REPORTE A LA CNBV.
		CALL PLDCNBVOPEINTPREOALT(
			Par_PeriodoInicio,	Par_PeriodoFin,		Str_NO,				Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Archivo generado con exito.';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			'opeInterPreoID' AS Control,
			Aud_NumTransaccion AS Consecutivo;
END IF;

END TerminaStore$$

