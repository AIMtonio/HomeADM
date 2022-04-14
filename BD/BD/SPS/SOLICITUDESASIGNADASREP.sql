DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDESASIGNADASREP;

DELIMITER $$
CREATE PROCEDURE SOLICITUDESASIGNADASREP(
	-- Descripcion	= Procedimiento para los reportes de asignacion de solicitudes
	-- Modulo		= Bandeja de Solicitudes
	Par_FechaInicio				DATE,						-- Fecha de Inicio del Reporte
	Par_FechaFin				DATE,						-- Fecha de Fin del Reporte
	Par_AnalistaID				INT(11),					-- Numero del analista de la solicitud de credito

	Par_EmpresaID				INT(11),					-- Parametros de Auditoria
	Aud_Usuario					INT(11), 					-- Parametros de Auditoria
	Aud_FechaActual				DATETIME, 					-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15), 				-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50), 				-- Parametros de Auditoria
	Aud_Sucursal				INT(11), 					-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20) 					-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Sentencia				VARCHAR(9000); 		-- Sentencia a Ejecutar
	DECLARE Var_FechaCorte				DATE;				-- Fecha corte de saldos creditos
	DECLARE Var_MotDevol                VARCHAR(500);       -- Motivos de devolucion de la sol. credito

	-- Declaracion de Constantes
	DECLARE Entero_Cero					INT(11);			-- Constante de entero cero
	DECLARE Fecha_Vacia					DATE;				-- Constante de fecha vacia
	DECLARE Hora_Vacia					TIME;				-- Constante Hora Vacia
	DECLARE	Cadena_Vacia				CHAR(1);			-- Constante cadena vacia
	DECLARE Est_Inactivo				CHAR(1);			-- Estatus inactivo
	DECLARE	Est_Liberado				CHAR(1);			-- Estatus liberado
	DECLARE	Est_EnAnalisis				CHAR(1);			-- Estatus En analisis
	DECLARE Est_Devuelta				CHAR(1);			-- Estatus devuelta
	DECLARE	Est_Rechazado				CHAR(1);			-- Estatus Rechazado
	DECLARE Est_Descondicionado			CHAR(1);			-- Estatus Descondicionado
	DECLARE Est_Desembolsado			CHAR(1);			-- Estatus desembolsado
	DECLARE Est_Autorizado				CHAR(1);			-- Estatus Autorizado
	DECLARE Est_Cancelado				CHAR(1);			-- Estatus Cancelado
	DECLARE Est_Condicionado			CHAR(1);			-- Estatus condicionado
	DECLARE Est_Dispersado				CHAR(1);			-- Estatus dispersado
	DECLARE Est_Asignado                CHAR(1);			-- Estatus asignado
	DECLARE Est_InactivoDes				VARCHAR(15);		-- Estatus inactivo descripcion
	DECLARE Est_LiberadoDes				VARCHAR(15);		-- Estatus liberado descripcion
	DECLARE Est_EnAnalisisDes			VARCHAR(15);		-- Estatus en Analisis descripcion
	DECLARE Est_DevueltaDes				VARCHAR(15);		-- Estatus devuelta descripcion
	DECLARE Est_CanceladoDes			VARCHAR(15);		-- Estatus cancelado descripcion
	DECLARE Est_RechazadoDes			VARCHAR(15);		-- Estatus rechazado descripcion
	DECLARE Est_AutorizadoDes			VARCHAR(15);		-- Estatus autorizado descripcion
	DECLARE Est_CondicionadoDes			VARCHAR(15);		-- Estatus condicionado descripcion
	DECLARE Est_DescondicionadoDes		VARCHAR(15);		-- Estatus descondiconado descripcion
	DECLARE Est_DesembolsadoDes			VARCHAR(15);		-- Estatus desembolsado descripcion
	DECLARE Est_DispersadoDes			VARCHAR(15);		-- Estatus dispersado descripcion
	DECLARE Est_AsignadoDes             VARCHAR(15);		-- Estatus asignado descripcion
	DECLARE	Decimal_Cero				DECIMAL(12,2);		-- Valor para el Decimal Cero
	DECLARE Entero_Treinta				INT(11);			-- Entero treinta
	DECLARE Con_Mensual					VARCHAR(20);		-- Constante de frecuencia mensual
	DECLARE Con_ProAutomatico			VARCHAR(20);		-- Constante de proceso automatico
	DECLARE Con_No						CHAR(1);			-- Constante no
	DECLARE Con_Si						CHAR(1);			-- Constante si
	DECLARE Con_Devolucion				CHAR(1);			-- Constante de devolucion
	DECLARE Con_NA						CHAR(2);			-- Constante no disponible

	-- Asignacion de Constantes
	SET Var_Sentencia					:= '';
	SET	Entero_Cero						:= 0;
	SET	Fecha_Vacia						:= '1900-01-01';
	SET Hora_Vacia						:= '00:00:00';
	SET	Cadena_Vacia					:= '';
	SET Est_Inactivo					:= 'I';
	SET Est_Liberado					:= 'L';
	SET Est_EnAnalisis					:= 'E';
	SET Est_Devuelta					:= 'B';
	SET Est_Cancelado					:= 'C';
	SET Est_Rechazado					:= 'R';
	SET Est_Autorizado					:= 'A';
	SET Est_Condicionado				:= 'S';
	SET Est_Descondicionado				:= 'F';
	SET Est_Desembolsado				:= 'D';
	SET Est_Dispersado					:= 'P';
	SET Est_Asignado					:= 'G';
	SET Est_InactivoDes					:= 'INACTIVO';
	SET Est_LiberadoDes					:= 'LIBERADO';
	SET Est_EnAnalisisDes				:= 'EN ANALISIS';
	SET Est_DevueltaDes					:= 'DEVUELTO';
	SET Est_CanceladoDes				:= 'CANCELADO';
	SET Est_RechazadoDes				:= 'RECHAZADO';
	SET Est_AutorizadoDes				:= 'AUTORIZADO';
	SET Est_CondicionadoDes				:= 'CONDICIONADO';
	SET Est_DescondicionadoDes			:= 'DESCONDICIONADO';
	SET Est_DesembolsadoDes				:= 'DESEMBOLSADO';
	SET Est_DispersadoDes				:= 'DISPERSADO';
	SET Est_AsignadoDes				    := 'ASIGNADO';
	SET	Decimal_Cero					:= 0.00;
	SET Entero_Treinta					:= 30;
	SET Con_Mensual						:= 'Meses';
	SET Con_ProAutomatico				:= 'PROCESO AUTOMATICO';
	SET Con_No							:= 'N';
	SET Con_Si							:= 'S';
	SET Con_Devolucion					:= 'D';
	SET Con_NA							:= 'NA';
	SET Par_AnalistaID					:= IFNULL(Par_AnalistaID, Entero_Cero);

	-- ============================= Reporte de Asignacion de Solicitudes =============================
	-- Tabla auxiliar para el reporte
	DROP TABLE IF EXISTS TMPSOLICITUDESASIGNADAS;
	CREATE TEMPORARY TABLE TMPSOLICITUDESASIGNADAS(
		ProspectoID				BIGINT(20),
		NombreAnalista			VARCHAR(150),
		SolicitudCreditoID		BIGINT(20),
		CreditoID				BIGINT(12),
		NombreEstado			VARCHAR(100),
		NombreProducto			VARCHAR(100),
		NombreConvenio			VARCHAR(150),
		ClienteID				INT(11),
		NombreCliente			VARCHAR(200),
		MontoSolicitado			DECIMAL(12,2),
		Finalidad				VARCHAR(300),
		PlazoID					VARCHAR(50),
		MontoMaximo				DECIMAL(14,2),
		FechaLiberada			DATE,
		HoraLiberada			TIME,
		FechaAutoriza			DATE,
		MotivoDevolucion		VARCHAR(1000),
		EstatusSolicitud		VARCHAR(50),
		NombreSucursal			VARCHAR(50),
		AnalistaID				INT(11),
		AsignacionAuto 			CHAR(1),
		MotivoRechazoID 		VARCHAR(50),
	INDEX INDEX_1(CreditoID),
	INDEX INDEX_2(ClienteID),
	INDEX INDEX_3(ProspectoID),
	INDEX INDEX_4(AsignacionAuto),
	INDEX INDEX_5(MotivoRechazoID),
	PRIMARY KEY(AnalistaID, SolicitudCreditoID));



		-- Tabla auxiliar para el reporte
	DROP TABLE IF EXISTS TMPHISSOLICITUDESASIGNADAS;
	CREATE TEMPORARY TABLE TMPHISSOLICITUDESASIGNADAS(
		SolicitudCreditoID		BIGINT(20),
		SolicitudAsignaID	    bigint(20),
		Estatus                 CHAR(1),
		UsuarioID               int(11),
		AsignacionAuto          char(1),
		FechaAsignacion         date);

	   -- Tabla auxiliar para el reporte sobre los estatus de actualizacion
	DROP TABLE IF EXISTS TMPESTATUS;
	CREATE TEMPORARY TABLE TMPESTATUS(
		SolicitudCreditoID		BIGINT(20),
		EstatusSolCreID         INT(11),
		Estatus                 CHAR(1));

	-- Tabla auxiliar para el reporte de las descripciones de solicitudes rechazadas
	DROP TABLE IF EXISTS TMPCATRECHAZOS;
	CREATE TEMPORARY TABLE TMPCATRECHAZOS(
		SolicitudCreditoID		BIGINT(20),
		MotivoRechaDevolucion	VARCHAR(1000));

	-- Tabla auxiliar para el reporte sobre el monto maximo de solicitud
	DROP TABLE IF EXISTS TMPSOLCAPACIDADPAGOS;
	CREATE TEMPORARY TABLE TMPSOLCAPACIDADPAGOS(
		SolicitudCreditoID		BIGINT(20),
		CapacidadPago         DECIMAL(14,2));



	SET Var_Sentencia :=('INSERT INTO TMPHISSOLICITUDESASIGNADAS (SolicitudCreditoID,        SolicitudAsignaID,         UsuarioID,               AsignacionAuto, FechaAsignacion)');
    SET Var_Sentencia:= CONCAT(Var_Sentencia,'(SELECT             S.SolicitudCreditoID,      max(S.SolicitudAsignaID),  MAX(S.UsuarioID),        MAX(S.AsignacionAuto),MAX(S.FechaAsignacion)');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' FROM  HISSOLICITUDESASIGNADAS S LEFT JOIN SOLICITUDESASIGNADAS SOL ON S.SolicitudCreditoID=SOL.SolicitudCreditoID ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' WHERE  SOL.SolicitudCreditoID IS NULL  group by S.SolicitudCreditoID)');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' UNION (SELECT Su.SolicitudCreditoID,Su.SolicitudAsignaID,Su.UsuarioID,Su.AsignacionAuto, Su.FechaAsignacion');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' FROM  SOLICITUDESASIGNADAS Su LEFT JOIN SOLICITUDCREDITO SOLu ON SOLu.SolicitudCreditoID=Su.SolicitudCreditoID)');

	-- Se ejecuta la sentencia dinamica
	SET @Sentencia	= (Var_Sentencia);
	PREPARE BSASIGNACIONREP FROM @Sentencia;
	EXECUTE BSASIGNACIONREP;
	DEALLOCATE PREPARE BSASIGNACIONREP;

    -- Se Insertan los estatus de la solicitud
	INSERT INTO TMPESTATUS(SolicitudCreditoID,EstatusSolCreID)
	SELECT EST.SolicitudCreditoID,MAX(EST.EstatusSolCreID)
	FROM ESTATUSSOLCREDITOS EST
	GROUP BY  EST.SolicitudCreditoID;

	-- Se actualiza el estatus de la solicitud
	UPDATE TMPESTATUS Tmp
	INNER JOIN ESTATUSSOLCREDITOS Est ON Tmp.EstatusSolCreID = Est.EstatusSolCreID
		SET
		Tmp.Estatus = Est.Estatus;

	SET Var_Sentencia := Cadena_Vacia;


	SET Var_Sentencia := ('INSERT INTO TMPSOLICITUDESASIGNADAS (ProspectoID,			NombreAnalista,			SolicitudCreditoID,			CreditoID,			NombreEstado, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				NombreProducto,			NombreConvenio,			ClienteID,					NombreCliente,		MontoSolicitado, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				Finalidad,				PlazoID,				MontoMaximo,				FechaLiberada,		HoraLiberada, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				FechaAutoriza,			MotivoDevolucion,		EstatusSolicitud,			NombreSucursal,		AnalistaID, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				AsignacionAuto,			MotivoRechazoID ) ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'SELECT 			Asig.UsuarioID,		"',Cadena_Vacia,'",		Sol.SolicitudCreditoID, 	Sol.CreditoID,		"',Cadena_Vacia,'",
                                                                CONCAT(Prod.Descripcion, " - ", (CASE
                                                                                                    WHEN FlujoOrigen != "C" THEN "NUEVO"
                                                                                                    ELSE "TRATAMIENTO"
                                                                                                    END)) ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				,		Nom.Descripcion,		Sol.ClienteID, 				"',Cadena_Vacia,'",	Sol.MontoSolici, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				Dest.Descripcion,		Plazo.Descripcion as Dias,	"',Decimal_Cero,'",Asig.FechaAsignacion,	"',Hora_Vacia,'", ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				Sol.FechaAutoriza,	"',Cadena_Vacia,'", ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'		CASE	WHEN (Est.Estatus = "',Est_Inactivo,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_InactivoDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Liberado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_LiberadoDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_EnAnalisis,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_EnAnalisisDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Devuelta,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_DevueltaDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Cancelado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_CanceladoDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Rechazado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_RechazadoDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Autorizado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_AutorizadoDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Condicionado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_Condicionado,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Descondicionado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_Descondicionado,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Desembolsado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_DesembolsadoDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Dispersado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_DispersadoDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				WHEN (Est.Estatus = "',Est_Asignado,'") ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'					THEN "',Est_AsignadoDes,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				END AS EstatusSolicitud, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'				Suc.NombreSucurs,	Asig.UsuarioID,			Asig.AsignacionAuto,			Sol.MotivoRechazoID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'FROM TMPHISSOLICITUDESASIGNADAS Asig ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'INNER JOIN SOLICITUDCREDITO Sol ON (Asig.SolicitudCreditoID = Sol.SolicitudCreditoID)');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'INNER JOIN SUCURSALES Suc ON (Sol.SucursalID = Suc.SucursalID)');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'INNER JOIN PRODUCTOSCREDITO Prod ON (Sol.ProductoCreditoID = Prod.ProducCreditoID)');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'INNER JOIN CREDITOSPLAZOS Plazo ON (Sol.PlazoID = Plazo.PlazoID)');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'INNER JOIN DESTINOSCREDITO Dest ON (Sol.DestinoCreID = Dest.DestinoCreID)');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'LEFT JOIN CONVENIOSNOMINA Nom ON (Sol.InstitucionNominaID = Nom.InstitNominaID AND Sol.ConvenioNominaID=Nom.ConvenioNominaID)');
    SET Var_Sentencia := CONCAT(Var_Sentencia ,'LEFT JOIN TMPESTATUS Est ON (Sol.SolicitudCreditoID = Est.SolicitudCreditoID)');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'WHERE Asig.FechaAsignacion >= "',Par_FechaInicio,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'	AND Asig.FechaAsignacion <= "',Par_FechaFin,'" ');

	-- Validacion para el Tipo de Alianza
	IF(Par_AnalistaID <> Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'	AND Asig.UsuarioID = ', Par_AnalistaID,' ');
	END IF;

	-- Se ejecuta la sentencia dinamica
	SET @Sentencia	= (Var_Sentencia);
	PREPARE BSASIGNACIONREP FROM @Sentencia;
	EXECUTE BSASIGNACIONREP;
	DEALLOCATE PREPARE BSASIGNACIONREP;

    -- Se realiza el insert a la tabla temporal de las descripciones de los estatus de devoluciones de solicitudes
	INSERT INTO TMPCATRECHAZOS(SolicitudCreditoID,MotivoRechaDevolucion)
	SELECT MAX(Tmp.SolicitudCreditoID),GROUP_CONCAT( Cat.Descripcion) FROM
	        TMPSOLICITUDESASIGNADAS Tmp  INNER JOIN
			CATALOGOMOTRECHAZO Cat
					WHERE  FIND_IN_SET(Cat.MotivoRechazoID,Tmp.MotivoRechazoID) >0
					  AND  Cat.TipoMotivo = Con_Devolucion
					  GROUP BY Tmp.SolicitudCreditoID ;

	-- Se llena la tabla temporal para capacidad de pago
	INSERT INTO TMPSOLCAPACIDADPAGOS(SolicitudCreditoID, CapacidadPago)
	SELECT Cap.SolicitudCreditoID, MAX(Cap.CapacidadPago) FROM NOMCAPACIDADPAGOSOL Cap
	GROUP BY Cap.SolicitudCreditoID;

	-- Se actualiza el nombre del analista
	UPDATE TMPSOLICITUDESASIGNADAS Tmp
	LEFT  OUTER JOIN USUARIOS Usua ON Tmp.AnalistaID = Usua.UsuarioID
		SET
			Tmp.NombreAnalista = IF(Tmp.AnalistaID = Entero_Cero, Con_ProAutomatico, Usua.NombreCompleto);
	
	-- Se actualiza el monto maximo de pago
	UPDATE TMPSOLICITUDESASIGNADAS Tmp
	INNER JOIN TMPSOLCAPACIDADPAGOS Cap ON Tmp.SolicitudCreditoID = Cap.SolicitudCreditoID
		SET
			Tmp.MontoMaximo = Cap.CapacidadPago;

	-- Se actualiza el nombre del cliente
	UPDATE TMPSOLICITUDESASIGNADAS Tmp
	LEFT JOIN CLIENTES Cli ON Tmp.ClienteID = Cli.ClienteID
	LEFT JOIN PROSPECTOS Pros ON Tmp.ProspectoID = Pros.ProspectoID
		SET
			Tmp.NombreCliente = CASE WHEN Tmp.ClienteID <> Entero_Cero THEN
										Cli.NombreCompleto
									WHEN Tmp.ProspectoID <> Entero_Cero THEN
										Pros.NombreCompleto
									ELSE Cadena_Vacia
									END;

	-- Se actualiza el nombre del estado
	UPDATE TMPSOLICITUDESASIGNADAS Tmp
	INNER JOIN DIRECCLIENTE Dir ON Tmp.ClienteID = Dir.ClienteID
	INNER JOIN ESTADOSREPUB Est ON Dir.EstadoID = Est.EstadoID
		SET
			Tmp.NombreEstado = Est.Nombre
	WHERE Dir.Oficial = Con_Si;



	-- Se actualiza el motivo de devolucion
	UPDATE TMPSOLICITUDESASIGNADAS Tmp
	INNER JOIN TMPCATRECHAZOS Tmpc ON Tmp.SolicitudCreditoID =Tmpc.SolicitudCreditoID
		SET
		    Tmp.MotivoDevolucion = Tmpc.MotivoRechaDevolucion;


	-- Se actualiza la fecha y hora de la liberacion
	UPDATE TMPSOLICITUDESASIGNADAS Tmp
	INNER JOIN ESTATUSSOLCREDITOS EstSol ON Tmp.SolicitudCreditoID = EstSol.SolicitudCreditoID  AND Tmp.FechaLiberada=EstSol.Fecha
		SET
			Tmp.FechaLiberada	= EstSol.Fecha,
			Tmp.HoraLiberada	= EstSol.HoraActualizacion
	WHERE EstSol.Estatus = Est_EnAnalisis OR EstSol.Estatus=Est_Liberado ;

	-- Se actualiza datos por defectos
	UPDATE TMPSOLICITUDESASIGNADAS Tmp
		SET
			Tmp.NombreConvenio	= Con_NA
	WHERE IFNULL(Tmp.NombreConvenio, Cadena_Vacia) = Cadena_Vacia;

	-- Se actualiza datos por defectos
	UPDATE TMPSOLICITUDESASIGNADAS Tmp
		SET
			Tmp.MotivoDevolucion	= Con_NA
	WHERE IFNULL(Tmp.MotivoDevolucion, Cadena_Vacia) = Cadena_Vacia;

	SELECT	ProspectoID,		NombreAnalista,			SolicitudCreditoID,			CreditoID,			NombreEstado,
			NombreProducto,		NombreConvenio,			ClienteID,					NombreCliente,		MontoSolicitado,
			Finalidad,			PlazoID,				MontoMaximo,				FechaLiberada,		HoraLiberada,
			FechaAutoriza,		MotivoDevolucion,		EstatusSolicitud,			NombreSucursal,		AnalistaID
	FROM TMPSOLICITUDESASIGNADAS;


END TerminaStore$$