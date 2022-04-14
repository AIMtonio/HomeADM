-- SP CONVENIOSNOMINAREP

DELIMITER ;

DROP PROCEDURE IF EXISTS HISCONVENIOSNOMINAREP;

DELIMITER $$

CREATE PROCEDURE HISCONVENIOSNOMINAREP (
	-- Stored procedure para reportes de la tabla HISCONVENIOSNOMINA
	Par_HisConvenioNomID			INT(11),			-- Identificador del historico de convenio
	Par_InstitNominaID				INT(11),			-- Empresa de nomina a la cual pertenece el convenio
	Par_ConvenioNominaID			INT(11),			-- Identificador del convenio
	Par_FechaInicio					DATE,				-- Fecha de inicio del intervalo
	Par_FechaFIn					DATE,				-- Fecha final del intervalo

	Par_NumRep						TINYINT,			-- Numero de reporte

	Par_EmpresaID 					INT(11), 			-- Parametros de auditoria
	Aud_Usuario						INT(11),			-- Parametros de auditoria
	Aud_FechaActual					DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal					INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Var_ConstanteS			CHAR(1);			-- Constante Si
	DECLARE Var_ConstanteN			CHAR(1);			-- Constante No
	DECLARE Var_TextoSi				CHAR(2);			-- Constante Texto Si
	DECLARE Var_TextoNo				CHAR(2);			-- Constante Texto No
	DECLARE Est_Activo				CHAR(1);			-- Estatus Activo
	DECLARE Est_Suspendido			CHAR(1);			-- Estatus Suspendido
	DECLARE Est_Vencido				CHAR(1);			-- Estatus Vencido
	DECLARE Est_Inactivo			CHAR(1);			-- Estatus Inactivo
	DECLARE Var_TextoActivo			VARCHAR(6);			-- Constante para el texto Activo
	DECLARE Var_TextoSuspendido		VARCHAR(10);		-- Constante para el texto Suspendido
	DECLARE Var_TextoVencido		VARCHAR(7);			-- Constante para el texto Vencido
	DECLARE Var_TextoInactivo		VARCHAR(8);			-- Constante para el texto Inactivo
	DECLARE Var_RepTodos			TINYINT UNSIGNED;	-- Reporte de todos los cambios en convenios de nomina
	DECLARE Var_RepIndiv			TINYINT UNSIGNED;	-- Reporte de los convenios de nomina segun la institucion
	DECLARE Var_NoCuotasCobr		INT(11);			-- Variable para almacenar el valor que se tenia previemente en el campo NoCuotasCobrar

	-- Declaracion de variables

	DECLARE Var_Hora 						TIME;					-- Variable para almacenar el valor que se tenia previamente en el campo Hora
	DECLARE	Var_ConvenioNominaID			BIGINT UNSIGNED;		-- Variable para almacenar el valor que se tenia previamente en el campo ConvenioNominaID
	DECLARE Var_Descripcion					VARCHAR(150);			-- Variable para almacenar el valor que se tenia previamente en el campo Descripcion
	DECLARE Var_FechaRegistro				DATE;					-- Variable para almacenar el valor que se tenia previamente en el campo FechaRegistro
	DECLARE Var_ManejaVencimiento 			CHAR(1);				-- Variable para almacenar el valor que se tenia previamente en el campo ManejaVencimiento
	DECLARE Var_FechaVencimiento			DATE;					-- Variable para almacenar el valor que se tenia previamente en el campo FechaVencimiento
	DECLARE	Var_DomiciliacionPagos			CHAR(1);				-- Variable para almacenar el valor que se tenia previamente en el campo DomiciliacionPagos
	DECLARE Var_ClaveConvenio				VARCHAR(20);			-- Variable para almacenar el valor que se tenia previamente en el campo ClaveConvenio
	DECLARE Var_Estatus 					CHAR(1);				-- Variable para almacenar el valor que se tenia previamente en el campo Estatus
	DECLARE Var_Resguardo					DECIMAL(12,2);			-- Variable para almacenar el valor que se tenia previamente en el campo Resguardo
	DECLARE Var_RequiereFolio				CHAR(1);				-- Variable para almacenar el valor que se tenia previamente en el campo RequiereFolio
	DECLARE Var_ManejaQuinquenios			CHAR(1);				-- Variable para almacenar el valor que se tenia previamente en el campo ManejaQuinquenios
	DECLARE Var_NumActualizaciones			INT(11);				-- Variable para almacenar el valor que se tenia previamente en el campo NumActualizaciones
	DECLARE Var_UsuarioID 					INT(11);				-- Variable para almacenar el valor que se tenia previamente en el campo UsuarioID
	DECLARE Var_CorreoEjecutivo				TEXT;					-- Variable para almacenar el valor que se tenia previamente en el campo CorreoEjecutivo
	DECLARE Var_Comentario 					TEXT(150);				-- Variable para almacenar el valor que se tenia previamente en el campo Comentario
	DECLARE Var_ManejaCapPago				CHAR(1);				-- Variable para almacenar el valor que se tenia previamente en el campo ManejaCapPago
	DECLARE Var_FormCapPago 				TEXT(500);				-- Variable para almacenar el valor que se tenia previamente en el campo FormCapPago
	DECLARE Var_FormCapPagoRes				TEXT(500);				-- Variable para almacenar el valor que se tenia previamente en el campo FormCapPagoRes
	DECLARE Var_ManejaCalendario			CHAR(1);				-- Variable para almacenar el valor que se tenia previamente en el campo ManejaCalendario
	DECLARE Var_ManejaFechaIniCal			CHAR(1);				-- Variable para almacenar el valor que se tenia previamente en el campo ManejaFechaIniCal

	DECLARE Var_Cambios				TEXT;				-- Variable para almacenar los datos de modificacion de registro en tabla HISCONVENIOSNOMINA
	DECLARE Var_DescripAnt			VARCHAR(105);		-- Variable para almacenar el valor que se tenia previamente en el campo Descripcion
	DECLARE Var_ManejaVencAnt		CHAR(1);			-- Variable para almacenar el valor que se tenia previamente en el campo ManejaVencimiento
	DECLARE Var_FechaVencAnt		DATE;				-- Variable para almacenar el valor que se tenia previamente en el campo FechaVencimiento
	DECLARE Var_FechaProgramAnt		DATE;				-- Variable para almacenar el valor que se tenia previamente en el campo FechaProgramada
	DECLARE Var_DomiciPagosAnt		CHAR(1);			-- Variable para almacenar el valor que se tenia previamente en el campo DomiciliacionPagos
	DECLARE Var_LimitPlazCredAnt	CHAR(1);			-- Variable para almacenar el valor que se tenia previamente en el campo LimitaPlazoCredito
	DECLARE Var_EstatusAnt			CHAR(1);			-- Variable para almacenar el valor que se tenia previamente en el campo Estatus
	DECLARE Var_UsuarioIDAnt		INT(11);			-- Variable para almacenar el valor que se tenia previamente en el campo UsuarioID
	DECLARE Var_ExtEjecutivoAnt		VARCHAR(10);		-- Variable para almacenar el valor que se tenia previamente en el campo ExtEjecutivo
	DECLARE Var_ComentariosAnt		TEXT;				-- Variable para almacenar el valor que se tenia previamente en el campo Comentarios

	DECLARE Var_FechaSistema		DATE;				-- Variable para almacenar la fecha del sistema en tabla PARAMETROSSIS
	DECLARE Var_TmpHisID			BIGINT(20);			-- Variable para almacenar el identificador de tabla temporal
	DECLARE Var_EsProgramacion		CHAR(1);			-- Variable para almacenar identificador si registro viene de tabla de programaciones o de historico
--	DECLARE Var_ConvenioNominaID	INT(11);			-- Variable para almacenar identificador de convenio de nomina
	DECLARE Var_NoAplica			CHAR(5);

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';				-- Constante Cadena Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Var_ConstanteS				:= 'S';				-- Constante Si
	SET Var_ConstanteN				:= 'N';				-- Constante No
	SET Var_TextoSi					:= 'SI';			-- Constante Texto Si
	SET Var_TextoNo					:= 'NO';			-- Constante Texto No
	SET Est_Activo					:= 'A';
	SET Est_Suspendido				:= 'S';
	SET Est_Vencido					:= 'V';
	SET Est_Inactivo				:= 'I';
	SET Var_TextoActivo				:= 'ACTIVO';
	SET Var_TextoSuspendido			:= 'SUSPENDIDO';
	SET Var_TextoVencido			:= 'VENCIDO';
	SET Var_TextoInactivo			:= 'INACTIVO';
	SET Var_RepTodos				:= 1;				-- Reporte de todos los cambios en convenios de nomina
	SET Var_RepIndiv				:= 2;				-- Reporte de los convenios de nomina segun la institucion
	SET Var_NoAplica				:= 'N/A';

	-- Reporte Todos para la pantalla de bitacora de cambios en convenios de nomina
	IF (Par_NumRep = Var_RepTodos) THEN
		DROP TEMPORARY TABLE IF EXISTS `TMPHIS`;
		CREATE TEMPORARY TABLE `TMPHIS` (
			FechaCambio				DATE,
			HoraCambio				VARCHAR(12),
			NombreInstitNomina		VARCHAR(200),
			ConvenioNominaID		INT(11),
			NoActualizaciones		INT(11),
			NombreCompleto			VARCHAR(150),
			NombreSucurs			VARCHAR(50),
			HisConvenioNomID		BIGINT(20),
			InstitNominaID			INT(11),
			EsProgramacion			CHAR(1)
		);

		INSERT INTO TMPHIS	(	FechaCambio,			HoraCambio,				NombreInstitNomina,		ConvenioNominaID,		NoActualizaciones,
								NombreCompleto,			NombreSucurs,			HisConvenioNomID,		InstitNominaID,			EsProgramacion)
			SELECT	CAST(His.FechaSistema AS DATE),		CAST(His.Hora AS TIME) AS HoraCambio,	Ins.NombreInstit,		His.ConvenioNominaID,	His.NumActualizaciones,
					Usu.NombreCompleto,					Suc.NombreSucurs,						His.HisConvenioNomID,	His.InstitNominaID,		Var_ConstanteN
				FROM HISCONVENIOSNOMINA His
				INNER JOIN INSTITNOMINA Ins ON His.InstitNominaID = Ins.InstitNominaID
				LEFT JOIN USUARIOS Usu ON Usu.UsuarioID = His.UsuarioID
				INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Usu.SucursalUsuario
				WHERE His.InstitNominaID = CASE WHEN Par_InstitNominaID <> Entero_Cero THEN Par_InstitNominaID ELSE His.InstitNominaID END
				  AND (His.ConvenioNominaID = CASE WHEN Par_ConvenioNominaID <> Entero_Cero THEN Par_ConvenioNominaID ELSE His.ConvenioNominaID END)
				  AND (CAST(His.FechaSistema AS DATE) BETWEEN Par_FechaInicio AND Par_FechaFin);

		SELECT	FechaCambio,		HoraCambio,				NombreInstitNomina,		ConvenioNominaID,			NoActualizaciones AS NumActualizaciones,
				NombreCompleto,		NombreSucurs,			HisConvenioNomID,			InstitNominaID,			EsProgramacion
			FROM TMPHIS
			ORDER BY FechaCambio ASC;
	END IF;

	-- Reporte Individual para la pantalla de bitacora de cambios en convenios de nomina
	IF (Par_NumRep = Var_RepIndiv) THEN
			SELECT		Hora, 				ConvenioNominaID,  		Descripcion, 			FechaRegistro, 			ManejaVencimiento,
						FechaVencimiento, 	DomiciliacionPagos, 	ClaveConvenio, 			Estatus, 				Resguardo,
						RequiereFolio, 		ManejaQuinquenios, 		NumActualizaciones, 	UsuarioID, 				CorreoEjecutivo,
						Comentario, 		ManejaCapPago, 			FormCapPago, 			FormCapPagoRes, 		ManejaCalendario,
						ManejaFechaIniCal,	NoCuotasCobrar
					INTO	Var_Hora, 				Var_ConvenioNominaID,  		Var_Descripcion, 			Var_FechaRegistro, 			Var_ManejaVencimiento,
							Var_FechaVencimiento, 	Var_DomiciliacionPagos, 	Var_ClaveConvenio, 			Var_Estatus, 				Var_Resguardo,
							Var_RequiereFolio, 		Var_ManejaQuinquenios, 		Var_NumActualizaciones, 	Var_UsuarioID, 				Var_CorreoEjecutivo,
							Var_Comentario, 		Var_ManejaCapPago, 			Var_FormCapPago, 			Var_FormCapPagoRes, 		Var_ManejaCalendario,
							Var_ManejaFechaIniCal,	Var_NoCuotasCobr
						FROM HISCONVENIOSNOMINA
						WHERE HisConvenioNomID = Par_HisConvenioNomID;

					SET Var_Cambios	:=
								CONCAT('1.- Maneja Vencimiento: ',
									 CASE Var_ManejaVencimiento
										WHEN Var_ConstanteS THEN Var_TextoSi
                                        WHEN Var_ConstanteN THEN Var_TextoNo
									 ELSE Cadena_Vacia END, '\n');
					SET Var_Cambios	:=CONCAT(Var_Cambios,
									 CASE Var_ManejaVencimiento
										WHEN Var_ConstanteS THEN CONCAT('2.- Fecha Vencimiento: ', IFNULL(Var_FechaVencimiento, Cadena_Vacia), '\n')
									 ELSE CONCAT('2.- Fecha Vencimiento: ', Var_NoAplica, '\n') END,
								CONCAT('3.- Domiciliación Pagos: ', (CASE Var_DomiciliacionPagos
																						WHEN Var_ConstanteS THEN Var_TextoSi
																						WHEN Var_ConstanteN THEN Var_TextoNo
																						ELSE Cadena_Vacia END)), '\n',
								CONCAT('4.- Clave Convenio: ', IFNULL(Var_ClaveConvenio, Cadena_Vacia)),  '\n',

								CONCAT('5.- Estatus: ', (CASE Var_Estatus
																			WHEN Est_Activo THEN Var_TextoActivo
																			WHEN Est_Suspendido THEN Var_TextoSuspendido
																			WHEN Est_Vencido THEN Var_TextoVencido
																			WHEN Est_Inactivo THEN Var_TextoInactivo
																			ELSE Cadena_Vacia END)), '\n',

								CONCAT('6.- Resguardo: ', IFNULL(Var_Resguardo, Cadena_Vacia)),  '\n',

								CONCAT('7.- Requiere Folio: ',
										CASE Var_RequiereFolio WHEN Var_ConstanteS THEN Var_TextoSi
															   WHEN Var_ConstanteN THEN Var_TextoNo
										ELSE Cadena_Vacia END), '\n',

								CONCAT('8.- Maneja Quinquenios: ',
										CASE Var_ManejaQuinquenios WHEN Var_ConstanteS THEN Var_TextoSi
																   WHEN Var_ConstanteN THEN Var_TextoNo
										ELSE Cadena_Vacia END), '\n',

								CONCAT('9.- Num. Actualizaciones: ', IFNULL(Var_NumActualizaciones, Entero_Cero)),  '\n',

								CONCAT('10.- Usuario Encargado: ', IFNULL(Var_UsuarioID, Cadena_Vacia)),  '\n',

								CONCAT('11.- Correo Encargado: ', IFNULL(Var_CorreoEjecutivo, Cadena_Vacia)),  '\n',

								CONCAT('12.- Comentario: ', IFNULL(Var_Comentario, Cadena_Vacia)),  '\n',

								CONCAT('13.- Maneja Capacidad de Pago: ',
										CASE Var_ManejaCapPago WHEN Var_ConstanteS THEN Var_TextoSi
															   WHEN Var_ConstanteN THEN Var_TextoNo
										ELSE Cadena_Vacia END), '\n',

								CONCAT('14.- Formula Capacidad de Pago: ', IFNULL(Var_FormCapPago, Cadena_Vacia)),  '\n',

								CONCAT('15.- Formula Capacidad de Pago Res: ', IFNULL(Var_FormCapPagoRes, Cadena_Vacia)),  '\n',

								CONCAT('16.- Maneja Calendario: ',
										CASE Var_ManejaCalendario WHEN Var_ConstanteS THEN Var_TextoSi
																  WHEN Var_ConstanteN THEN Var_TextoNo
										ELSE Cadena_Vacia END), '\n',

										CASE Var_ManejaCalendario WHEN Var_ConstanteS THEN CONCAT('17.-Maneja Fecha de Inicio Calendario: ', Var_TextoSi, '\n')
										ELSE CONCAT('17.-Maneja Fecha de Inicio Calendario: ', Var_NoAplica, '\n') END
								);

						SET Var_Cambios	:=CONCAT(Var_Cambios,
											CONCAT('18.- No Cuotas Cobrar: ', CONCAT(Var_NoCuotasCobr, Cadena_Vacia)), '\n');

			SELECT CAST(His.FechaSistema AS DATE) AS FechaCambio,		His.Hora AS HoraCambio,			Ins.NombreInstit As NombreInstitNomina,
			His.ConvenioNominaID,		His.NumActualizaciones ,		Var_Cambios AS Cambios,			Usu.NombreCompleto,			Suc.NombreSucurs
				FROM HISCONVENIOSNOMINA His
				INNER JOIN INSTITNOMINA Ins ON Ins.InstitNominaID = His.InstitNominaID
				INNER JOIN USUARIOS Usu ON Usu.UsuarioID = His.UsuarioID
				INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Usu.SucursalUsuario
				  AND (His.ConvenioNominaID = Par_ConvenioNominaID)
				  AND (His.HisConvenioNomID = Par_HisConvenioNomID)
				  AND (CAST(His.FechaSistema AS DATE) BETWEEN Par_FechaInicio AND Par_FechaFin);
	END IF;
END TerminaStore$$