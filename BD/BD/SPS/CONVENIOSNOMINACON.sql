-- SP CONVENIOSNOMINACON

DELIMITER ;

DROP PROCEDURE IF EXISTS CONVENIOSNOMINACON;

DELIMITER $$

CREATE PROCEDURE CONVENIOSNOMINACON (
	-- Stored procedure para consulta de la tabla CONVENIOSNOMINA
	Par_ConvenioNominaID	BIGINT UNSIGNED,	-- Identificador del convenio

	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Par_EmpresaID 			INT(11), 			-- Parametros de auditoria
	Aud_Usuario				INT(11),			-- Parametros de auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal			INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_FechaProgramada			DATE;				-- Fecha programada de la tabla CONVENIOSNOMINA
	DECLARE Var_FechaRegistro			DATE;				-- Fecha de registro de la tabla CONVENIOSNOMINA
	DECLARE Var_Descripcion 			VARCHAR(150);		-- Valor para el campo Descripcion de CONVENIOSNOMINA
	DECLARE Var_DomiciliacionPagos		CHAR(1);			-- Valor para el campo DomiciliacionPagos de CONVENIOSNOMINA
	DECLARE Var_LimitaPlazoCredito		CHAR(1);			-- Valor para el campo LimitaPlazoCredito de CONVENIOSNOMINA
	DECLARE Var_Estatus					CHAR(1);			-- Valor para el campo Estatus de CONVENIOSNOMINA
	DECLARE Var_ExtEjecutivo			VARCHAR(10);		-- Valor para el campo ExtEjecutivo de CONVENIOSNOMINA
	DECLARE Var_Comentarios				TEXT;				-- Valor para el campo Comentarios de CONVENIOSNOMINA
	DECLARE Var_NoCuotasCobrar			INT(11);			-- Valor para el campo NoCuotasCobrar de CONVENIOSNOMINA
	DECLARE Var_MotivosEstatus			VARCHAR(6000);		-- Valor para el campo MotivosEstatus de CONVENIOSNOMINA
	DECLARE Var_FechaMinima				DATE;				-- Variable para almacenar la fecha mas proxima de programacion
	DECLARE Var_FechaSistema			DATETIME;			-- Variable para almacenar la fecha del sistema
	DECLARE Var_NoActualizac			INT(11);			-- Variable para almacenar el numero de actualizaciones del convenio
	-- Declaracion de constantes
	DECLARE Fecha_Vacia					DATE;				-- Fecha vacia
	DECLARE Entero_Cero					INT(1);				-- Entero cero
	DECLARE Var_ConPrincipal			TINYINT UNSIGNED;	-- Consulta principal de la tabla CONVENIOSNOMINA
	DECLARE Var_ConPantPrincipal		TINYINT UNSIGNED;	-- Consulta para la pantalla de alta de CONVENIOSNOMINA
	DECLARE Var_ConvenioInstitucion		TINYINT UNSIGNED;	-- Consulta para el modulo de guarda valores
	DECLARE	Var_ConReportaIncidencia	TINYINT	UNSIGNED;	-- Consulta para conocer si el convenio reporta incidencia.

	-- Asignacion de constantes
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Entero_Cero						:= 0;				-- Entero cero
	SET Var_ConPrincipal				:= 1;				-- Consulta principal de la tabla CONVENIOSNOMINA
	SET Var_ConPantPrincipal			:= 2;				-- Consulta para la pantalla de alta de CONVENIOSNOMINA
	SET Var_ConvenioInstitucion			:= 3;
	SET Var_ConReportaIncidencia		:= 4;

	-- Consulta principal de la tabla CONVENIOSNOMINA
	IF (Par_NumCon = Var_ConPrincipal) THEN
		SELECT	con.ConvenioNominaID, 				con.InstitNominaID, 		con.Descripcion,  			con.FechaRegistro, 			con.ManejaVencimiento,
				con.FechaVencimiento, 				con.DomiciliacionPagos, 	con.ClaveConvenio, 			con.Estatus, 				con.Resguardo,
				con.RequiereFolio, 					con.ManejaQuinquenios, 		con.NumActualizaciones, 	con.UsuarioID, 				con.CorreoEjecutivo,
				con.Comentario, 					con.ManejaCapPago, 			con.FormCapPago, 			con.FormCapPagoRes, 		con.ManejaCalendario,
				con.ManejaFechaIniCal,              con.CobraComisionApert,     con.CobraMora, 				usu.NombreCompleto,			con.DesFormCapPago,
				con.DesFormCapPagoRes,		        con.NoCuotasCobrar,			con.Referencia,				con.ReportaIncidencia
			FROM CONVENIOSNOMINA AS con
			INNER JOIN USUARIOS AS usu ON con.UsuarioID = usu.UsuarioID
			WHERE	con.ConvenioNominaID	= Par_ConvenioNominaID;
	END IF;

	-- Consulta Reporta Incidencia
	IF (Par_NumCon = Var_ConReportaIncidencia) THEN
		SELECT con.ConvenioNominaID,	con.ReportaIncidencia
			FROM CONVENIOSNOMINA AS con
			WHERE	con.ConvenioNominaID	= Par_ConvenioNominaID;
	END IF;


END TerminaStore$$
