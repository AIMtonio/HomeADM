-- SP CONVENIOSNOMINALIS

DELIMITER ;

DROP PROCEDURE IF EXISTS CONVENIOSNOMINALIS;

DELIMITER $$

CREATE PROCEDURE CONVENIOSNOMINALIS (
	-- Stored procedure para listas de la tabla CONVENIOSNOMINA
	Par_InstitNominaID		INT(11),			-- Empresa de nomina a la cual pertenece el convenio
	Par_Descripcion			VARCHAR(150),		-- Descripcion del convenio de nomina
	Par_ClienteID			INT(11),			-- Identificador del cliente de nomina

	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

	Par_EmpresaID 			INT(11), 			-- Parametros de auditoria
	Aud_Usuario				INT(11),			-- Parametros de auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal			INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Var_LisAyuda		TINYINT UNSIGNED;	-- Lista de ayuda de la tabla CONVENIOSNOMINA
	DECLARE Var_LisCombo		TINYINT UNSIGNED;	-- Lista para cargar combo con convenios activos
	DECLARE Var_LisConvTod  	TINYINT UNSIGNED;   -- Lista para cargar combo con todos los convenios
	DECLARE Lis_InstCliente		TINYINT UNSIGNED;	-- Lista para cargar combo de convenios de un cliente por institucion de nomina
	DECLARE Est_Activo			CHAR(1);			-- Estatus activo
	DECLARE Lis_Clie			TINYINT UNSIGNED;	-- Lista para cargar UN cliente sin la condicion de institucion de nomina
	DECLARE Var_LisActInstit 	TINYINT UNSIGNED;	-- Lista ayuda de convenios activos por institucion de nomina
	DECLARE	Entero_Cero			INT(11);
	DECLARE Lis_Principal	 	TINYINT UNSIGNED;	-- Lista principal de todos los covenios
	DECLARE ListaComboComAper   TINYINT UNSIGNED;
	DECLARE ListaComboCobMora   TINYINT UNSIGNED;
	DECLARE Var_CobraApert		CHAR(1);

	-- Asignacion de constantes
	SET Var_LisAyuda		:= 1;				-- Lista de ayuda de la tabla CONVENIOSNOMINA
	SET Var_LisCombo		:= 2;				-- Lista para cargar combo con convenios activos
	SET Var_LisConvTod		:= 3;               -- Lista para cargar combo con todos los convenios
	SET Lis_InstCliente		:= 4;				-- Lista para cargar combo de convenios de un cliente por institucion de nomina
	SET Lis_Clie			:= 5;				-- Lista para cargar un cliente sin la condicion de institucion de nomina
	SET Var_LisActInstit	:= 6;				-- Lista ayuda de convenios activos por institucion de nomina
	SET Lis_Principal		:= 7;				-- Lista principal de todos los covenios
	SET ListaComboComAper	:= 9;
	SET ListaComboCobMora	:= 10;
	SET Var_CobraApert		:= 'S';
	SET Est_Activo			:= 'A';				-- Estatus activo
	SET Entero_Cero			:= 0;

	-- Lista de ayuda de la tabla CONVENIOSNOMINA
	IF (Par_NumLis = Var_LisAyuda) THEN
		IF(IFNULL(Par_InstitNominaID,Entero_Cero)=0) THEN
			SELECT	ConvenioNominaID, 			InstitNominaID, 			Descripcion,		FechaRegistro, 			ManejaVencimiento,
					FechaVencimiento, 			DomiciliacionPagos, 		ClaveConvenio, 		Estatus, 				Resguardo,
					RequiereFolio, 				ManejaQuinquenios, 			NumActualizaciones, UsuarioID, 				CorreoEjecutivo,
					Comentario, 				ManejaCapPago, 				FormCapPago, 		FormCapPagoRes, 		ManejaCalendario,
					ManejaFechaIniCal,			NoCuotasCobrar
			FROM 	CONVENIOSNOMINA
			WHERE	Estatus=Est_Activo
					AND Descripcion LIKE CONCAT('%', Par_Descripcion, '%')
			LIMIT 0, 15;
		ELSE
			SELECT	ConvenioNominaID, 			InstitNominaID, 			Descripcion,		FechaRegistro, 			ManejaVencimiento,
					FechaVencimiento, 			DomiciliacionPagos, 		ClaveConvenio, 		Estatus, 				Resguardo,
					RequiereFolio, 				ManejaQuinquenios, 			NumActualizaciones, UsuarioID, 				CorreoEjecutivo,
					Comentario, 				ManejaCapPago, 				FormCapPago, 		FormCapPagoRes, 		ManejaCalendario,
					ManejaFechaIniCal,			NoCuotasCobrar
			FROM 	CONVENIOSNOMINA
			WHERE	InstitNominaID	= Par_InstitNominaID
			  AND	Descripcion LIKE CONCAT('%', Par_Descripcion, '%')
			LIMIT 0, 15;
		END IF;
	END IF;

	-- Lista para cargar combo con convenios activos
	IF (Par_NumLis = Var_LisCombo) THEN
		SELECT	ConvenioNominaID, 			InstitNominaID, 			Descripcion,		FechaRegistro, 			ManejaVencimiento,
				FechaVencimiento, 			DomiciliacionPagos, 		ClaveConvenio, 		Estatus, 				Resguardo,
				RequiereFolio, 				ManejaQuinquenios, 			NumActualizaciones, UsuarioID, 				CorreoEjecutivo,
				Comentario, 				ManejaCapPago, 				FormCapPago, 		FormCapPagoRes, 		ManejaCalendario,
				ManejaFechaIniCal,			NoCuotasCobrar
			FROM CONVENIOSNOMINA
			WHERE	InstitNominaID	= Par_InstitNominaID
			  AND	Estatus			= Est_Activo;
	END IF;

	-- Lista para cargar combo con todos los convenios
	IF (Par_NumLis = Var_LisConvTod) THEN
	SELECT		ConvenioNominaID, 			InstitNominaID, 			Descripcion,		FechaRegistro, 			ManejaVencimiento,
				FechaVencimiento, 			DomiciliacionPagos, 		ClaveConvenio, 		Estatus, 				Resguardo,
				RequiereFolio, 				ManejaQuinquenios, 			NumActualizaciones, UsuarioID, 				CorreoEjecutivo,
				Comentario, 				ManejaCapPago, 				FormCapPago, 		FormCapPagoRes, 		ManejaCalendario,
				ManejaFechaIniCal,			NoCuotasCobrar
		FROM CONVENIOSNOMINA
			WHERE	InstitNominaID	= Par_InstitNominaID;
	END IF;

	-- 4 .- Lista de convenios de un cliente por institucion de nomina
	IF (Par_NumLis = Lis_InstCliente) THEN
		SELECT con.ConvenioNominaID,		con.InstitNominaID,			con.Descripcion
			FROM CONVENIOSNOMINA con
			INNER JOIN NOMINAEMPLEADOS emp ON con.ConvenioNominaID = emp.ConvenioNominaID
			WHERE emp.ClienteID = Par_ClienteID AND con.InstitNominaID = Par_InstitNominaID
            AND	con.Estatus			= Est_Activo;
	END IF;

	IF (Par_NumLis = Lis_Clie) THEN
		SELECT con.ConvenioNominaID,		con.InstitNominaID,			CONCAT(con.Descripcion, ' - ', ins.NombreInstit) as Descripcion
			FROM CONVENIOSNOMINA con
			INNER JOIN NOMINAEMPLEADOS emp ON con.ConvenioNominaID = emp.ConvenioNominaID
			INNER JOIN INSTITNOMINA ins ON con.InstitNominaID = ins.InstitNominaID
			WHERE emp.ClienteID = Par_ClienteID
			LIMIT 0, 15;
	END IF;

	-- 6.- Lista ayuda de convenios activos por institucion de nomina
	IF (Par_NumLis = Var_LisActInstit) THEN
		SELECT	ConvenioNominaID, 			InstitNominaID, 			Descripcion,		FechaRegistro, 			ManejaVencimiento,
				FechaVencimiento, 			DomiciliacionPagos, 		ClaveConvenio, 		Estatus, 				Resguardo,
				RequiereFolio, 				ManejaQuinquenios, 			NumActualizaciones, UsuarioID, 				CorreoEjecutivo,
				Comentario, 				ManejaCapPago, 				FormCapPago, 		FormCapPagoRes, 		ManejaCalendario,
				ManejaFechaIniCal,			NoCuotasCobrar
			FROM CONVENIOSNOMINA
			WHERE	InstitNominaID	= Par_InstitNominaID 	AND 	Estatus = Est_Activo
			  AND	Descripcion LIKE CONCAT('%', Par_Descripcion, '%')
			LIMIT 0, 15;
	END IF;

    -- 7.- Lista principal de todos los covenios
	IF (Par_NumLis = Lis_Principal) THEN
		SELECT	ConvenioNominaID, 			InstitNominaID, 			Descripcion,		FechaRegistro, 			ManejaVencimiento,
				FechaVencimiento, 			DomiciliacionPagos, 		ClaveConvenio, 		Estatus, 				Resguardo,
				RequiereFolio, 				ManejaQuinquenios, 			NumActualizaciones, UsuarioID, 				CorreoEjecutivo,
				Comentario, 				ManejaCapPago, 				FormCapPago, 		FormCapPagoRes, 		ManejaCalendario,
				ManejaFechaIniCal,			NoCuotasCobrar
			FROM CONVENIOSNOMINA
			WHERE Descripcion LIKE CONCAT('%', Par_Descripcion, '%')
			LIMIT 0, 15;
	END IF;

	-- Lista para cargar combo con convenios activos que tengan indicado que cobran comision por apertura
	IF (Par_NumLis = ListaComboComAper) THEN
		SELECT	ConvenioNominaID, 			InstitNominaID, 			Descripcion,		FechaRegistro, 			ManejaVencimiento,
				FechaVencimiento, 			DomiciliacionPagos, 		ClaveConvenio, 		Estatus, 				Resguardo,
				RequiereFolio, 				ManejaQuinquenios, 			NumActualizaciones, UsuarioID, 				CorreoEjecutivo,
				Comentario, 				ManejaCapPago, 				FormCapPago, 		FormCapPagoRes, 		ManejaCalendario,
				ManejaFechaIniCal,			NoCuotasCobrar
			FROM CONVENIOSNOMINA
			WHERE	InstitNominaID	= Par_InstitNominaID
			AND	CobraComisionApert = Var_CobraApert
			AND	Estatus			= Est_Activo;
	END IF;

		-- Lista para cargar combo con convenios activos y su campo Cobra Mora
	IF (Par_NumLis = ListaComboCobMora) THEN
		SELECT	ConvenioNominaID,			InstitNominaID, 			Descripcion,		CobraMora
			FROM CONVENIOSNOMINA
			WHERE	InstitNominaID	=	Par_InstitNominaID
			AND		Estatus			=	Est_Activo;
	END IF;


END TerminaStore$$
