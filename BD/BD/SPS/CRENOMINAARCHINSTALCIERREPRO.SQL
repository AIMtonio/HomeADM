-- SP CRENOMINAARCHINSTALCIERREPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CRENOMINAARCHINSTALCIERREPRO;

DELIMITER $$

CREATE PROCEDURE `CRENOMINAARCHINSTALCIERREPRO`(
	-- SP para dar por autorizados los creditos de nomina en archivos de instalacion que no reportaron incidencia
	Par_Fecha							DATE,				-- Parmatro de entrada Fecha

	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de control
	DECLARE Par_Salida					CHAR(1);
	DECLARE Par_NumErr					INT(11);
	DECLARE Par_ErrMen					VARCHAR(400);

	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);			-- Entero cero
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;				-- Fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);			-- Salida si
	DECLARE Var_Actualizado				CHAR(1);			-- A : Actualizado
	DECLARE Var_Enviado					CHAR(1);			-- E : Enviado
	DECLARE Var_NoEnviado				CHAR(1);			-- N : No Enviado

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;				-- Asignacion de entero cero
	SET Cadena_Vacia					:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Var_SalidaSI					:= 'S';				-- Salida si
	SET Var_Actualizado					:= 'A';				-- A : Actualizado
	SET Var_Enviado						:= 'E';				-- E : Enviado
	SET Var_NoEnviado					:= 'N';				-- N : No Enviado
	SET Par_Salida						:= 'N';

	-- Valores por default
	SET Par_EmpresaID					:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= NOW();
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN

		DROP TEMPORARY TABLE IF EXISTS TMPACTUALIZAESTATUSNOMINA;

		CREATE TEMPORARY TABLE TMPACTUALIZAESTATUSNOMINA (
			DetalleArchivoID	INT(11),
			CreditoID			BIGINT(20),
			FechaLimite			DATE,
			Estatus				CHAR(1),
			PRIMARY KEY (CreditoID)
		);

		INSERT INTO TMPACTUALIZAESTATUSNOMINA (	DetalleArchivoID,		CreditoID,	FechaLimite,	Estatus	)
									SELECT		MAX(DetalleArchivoID),	CreditoID,	Fecha_Vacia,	Cadena_Vacia
										FROM	DETALLEARCHIVOINSTAL
										GROUP BY CreditoID;

		UPDATE TMPACTUALIZAESTATUSNOMINA TMP
			INNER JOIN DETALLEARCHIVOINSTAL ARC ON TMP.DetalleArchivoID = ARC.DetalleArchivoID
		SET TMP.FechaLimite	= ARC.FechaLimiteRecep,
			TMP.Estatus		= ARC.Estatus;

		DELETE FROM TMPACTUALIZAESTATUSNOMINA WHERE Estatus = Var_Actualizado OR FechaLimite > Par_Fecha;


		UPDATE TMPACTUALIZAESTATUSNOMINA TMP
			INNER JOIN CREDITOS CRE ON TMP.CreditoID = CRE.CreditoID
		SET	CRE.EstatusNomina	= Var_Actualizado,

			CRE.EmpresaID		= Par_EmpresaID,
			CRE.Usuario			= Aud_Usuario,
			CRE.FechaActual		= Aud_FechaActual,
			CRE.DireccionIP		= Aud_DireccionIP,
			CRE.ProgramaID		= Aud_ProgramaID,
			CRE.Sucursal		= Aud_Sucursal,
			CRE.NumTransaccion	= Aud_NumTransaccion;

		UPDATE DETALLEARCHIVOINSTAL DET
			INNER JOIN TMPACTUALIZAESTATUSNOMINA TMP ON TMP.DetalleArchivoID = DET.DetalleArchivoID
		SET DET.Estatus			= Var_Actualizado,

			DET.EmpresaID		= Par_EmpresaID,
			DET.Usuario			= Aud_Usuario,
			DET.FechaActual		= Aud_FechaActual,
			DET.DireccionIP		= Aud_DireccionIP,
			DET.ProgramaID		= Aud_ProgramaID,
			DET.Sucursal		= Aud_Sucursal,
			DET.NumTransaccion	= Aud_NumTransaccion;

		SET Par_NumErr			:= Entero_Cero;
		SET Par_ErrMen			:= 'Proceso de Actualizacion ejecutado Exitosamente';
		SET Var_Control			:= 'usuarioID';
	END ManejoErrores;

	DROP TEMPORARY TABLE IF EXISTS TMPACTUALIZAESTATUSNOMINA;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Par_NumErr		AS consecutivo;
	END IF;

END TerminaStore$$