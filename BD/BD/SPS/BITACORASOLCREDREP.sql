-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORASOLCREDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORASOLCREDREP`;DELIMITER $$

CREATE PROCEDURE `BITACORASOLCREDREP`(
/*SP PARA GENERAR EL REPORTE BITACORA DE SOLICITUDES DE CREDITOS */
	Par_FechaInicio		DATE,
	Par_FechaFin		DATE,
	Par_SucursalID		INT(11),
	Par_PromotorID		INT(11),
    Par_ProducCreditoID	INT(11),

    Par_EsAgropecuario	CHAR(1),
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia   		VARCHAR(5000);
	DECLARE Var_FechaInicial		DATE;
	DECLARE Var_FechaFinal			DATE;
	DECLARE Var_FechaSolRegistro 	DATE;
	DECLARE Var_FechaSolActualiza	DATE;
	DECLARE Var_FechaSolLibera 		DATE;
	DECLARE Var_FechaSolAutoriza	DATE;
	DECLARE Var_FechaSolRechazo		DATE;
	DECLARE Var_FechaCreRegistro	DATE;
	DECLARE Var_FechaCreCondiciona	DATE;
	DECLARE Var_FechaCreAutoriza	DATE;
	DECLARE Var_FechaCreDesembolsa	DATE;
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_SolCredID			BIGINT(20);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE Todas					CHAR(1);
    DECLARE InactivaS				CHAR(1);
    DECLARE LiberadaS				CHAR(1);
    DECLARE	RechazadasS				CHAR(1);
    DECLARE CanceladaS				CHAR(1);
    DECLARE AutorizadaS				CHAR(1);
    DECLARE DesembolsadaS			CHAR(1);
	DECLARE AutorizadoC				CHAR(1);
    DECLARE VencidoC				CHAR(1);
    DECLARE CanceladoC				CHAR(1);
    DECLARE DesembolsadoC			CHAR(1);
    DECLARE InactivoC				CHAR(1);
    DECLARE CastigadoC				CHAR(1);
    DECLARE PagadoC					CHAR(1);
    DECLARE VigenteC				CHAR(1);
	DECLARE InactivaT				VARCHAR(30);
    DECLARE LiberadaT				VARCHAR(30);
    DECLARE	RechazadasT				VARCHAR(30);
    DECLARE CanceladaT				VARCHAR(30);
    DECLARE AutorizadaT				VARCHAR(30);
    DECLARE DesembolsadaT			VARCHAR(30);
    DECLARE AutorizadoTxt			VARCHAR(30);
    DECLARE DesembolsadoTxt			VARCHAR(30);
    DECLARE CanceladoTxt			VARCHAR(30);
    DECLARE InactivoTxt				VARCHAR(30);
    DECLARE AltaSolicitudSI			CHAR(1);
    DECLARE AltaSolicitudNO			CHAR(1);
    DECLARE Est_SolInactiva			CHAR(2);
    DECLARE Est_SolLiberada 		CHAR(2);
    DECLARE Est_SolActualizacion 	CHAR(2);
    DECLARE Est_SolRechazada 		CHAR(2);
    DECLARE Est_SolAutorizada 		CHAR(2);
    DECLARE Est_CredInactivo 		CHAR(2);
	DECLARE Est_CredCondicionado 	CHAR(2);
    DECLARE Est_CredAutorizado 		CHAR(2);
    DECLARE Est_CredDesembolsado 	CHAR(2);
	DECLARE No_EsAgro				CHAR(1);

	# Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET Todas						:= 'T';

    SET AutorizadoC					:= 'A';
    SET VencidoC					:= 'B';
    SET CanceladoC					:= 'C';
    SET DesembolsadoC				:= 'D';
    SET InactivoC					:= 'I';
    SET CastigadoC					:= 'K';
    SET PagadoC						:= 'P';
    SET VigenteC					:= 'V';
    SET InactivaS					:= 'I';
    SET LiberadaS					:= 'L';
    SET	RechazadasS					:= 'R';
    SET CanceladaS					:= 'C';
    SET AutorizadaS					:= 'A';
    SET DesembolsadaS				:= 'D';
	SET InactivaT					:= 'SOLICITUD INACTIVA';
    SET LiberadaT					:= 'SOLICITUD LIBERADA';
    SET	RechazadasT					:= 'SOLICITUD RECHAZADA';
    SET CanceladaT					:= 'SOLICITUD CANCELADA';
    SET AutorizadaT					:= 'SOLICITUD AUTORIZADA';
    SET DesembolsadaT				:= 'SOLICITUD DESEMBOLSADA';
    SET AutorizadoTxt				:= 'CREDITO AUTORIZADO';
    SET DesembolsadoTxt				:= 'CREDITO DESEMBOLSADO';
    SET CanceladoTxt				:= 'CREDITO CANCELADO';
    SET InactivoTxt					:= 'CREDITO INACTIVO';
    SET AltaSolicitudSI				:= 'S';
    SET AltaSolicitudNO				:= 'N';

    SET Est_SolInactiva				:= 'SI';
    SET Est_SolLiberada				:= 'SL';
    SET Est_SolActualizacion		:= 'SM';
    SET Est_SolRechazada			:= 'SR';
    SET Est_SolAutorizada			:= 'SA';
    SET Est_CredInactivo 			:= 'CI';
	SET Est_CredCondicionado 		:= 'CC';
    SET Est_CredAutorizado 			:= 'CA';
    SET Est_CredDesembolsado 		:= 'CD';
	SET No_EsAgro					:= 'N';

	SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);

	DROP TABLE IF EXISTS TMPBITACORASOLCREDREP;

	CREATE TEMPORARY TABLE TMPBITACORASOLCREDREP (
		`SolicitudCreditoID`		BIGINT(20),
		`CreditoID`					BIGINT(12),
		`ClienteID`					INT(11),
		`ProspectoID`				BIGINT(20),
		`NombreCompleto`			VARCHAR(200),
		`PromotorID`				INT(11),
		`NombrePromotor`			VARCHAR(100),
		`Estatus`					VARCHAR(30),

		`FechaSolRegistro`			DATETIME,
		`UsuSolRegistro`			INT(11),
		`NomUsuSolRegistro`			VARCHAR(160),
		`ComSolRegistro`			VARCHAR(2600),
		`TiempoEstRegistro`			INT(11),

		`FechaSolLiberacion`		DATETIME,
		`UsuSolLiberacion`			INT(11),
		`NomUsuSolLiberacion`		VARCHAR(160),
		`ComSolLiberacion`			VARCHAR(2600),
		`TiempoEstLiberacion`		INT(11),

		`FechaSolActualizacion`		DATETIME,
		`UsuSolActualizacion`		INT(11),
		`NomUsuSolActualizacion`	VARCHAR(160),
		`ComSolActualizacion`		VARCHAR(2600),
		`TiempoEstActualizacion`	INT(11),

		`FechaSolRechazo`			DATETIME,
		`UsuSolRechazo`				INT(11),
		`NomUsuSolRechazo`			VARCHAR(160),
		`ComSolRechazo`				VARCHAR(2600),

		`FechaSolAutorizacion`		DATETIME,
		`UsuSolAutorizacion`		INT(11),
		`NomUsuSolAutorizacion`		VARCHAR(160),
		`ComSolAutorizacion`		VARCHAR(2600),
		`TiempoEstAutorizacion`		INT(11),

		`FechaCreRegistro`			DATETIME,
		`UsuCreRegistro`			INT(11),
		`NomUsuCreRegistro`			VARCHAR(160),
		`ComCreRegistro`			VARCHAR(2600),
		`TiempoEstCreRegistro`		INT(11),

		`FechaCreCondiciona`		DATETIME,
		`UsuCreCondiciona`			INT(11),
		`NomUsuCreCondiciona`		VARCHAR(160),
		`ComCreCondiciona`			VARCHAR(2600),
		`TiempoEstCreCondiciona`	INT(11),

		`FechaCreAutoriza`			DATETIME,
		`UsuCreAutoriza`			INT(11),
		`NomUsuCreAutoriza`			VARCHAR(160),
		`ComCreAutoriza`			VARCHAR(2600),
		`TiempoEstCreAutoriza`		INT(11),

		`FechaCreDesembolsa`		DATETIME,
		`UsuCreDesembolsa`			INT(11),
		`NomUsuCreDesembolsa`		VARCHAR(160),
		`ComCreDesembolsa`			VARCHAR(2600),

		`FechaCreCancela`			DATETIME,
		`UsuCreCancela`				INT(11),
		`NomUsuCreCancela`			VARCHAR(160),
		`ComCreCancela`				VARCHAR(2600),
		`AltaSolicitud`				CHAR(1),
		Dias						INT(11),
		INDEX TMPBITACORASOLCREDREP_idx1(SolicitudCreditoID),
		INDEX TMPBITACORASOLCREDREP_idx2(ClienteID),
		INDEX TMPBITACORASOLCREDREP_idx3(ProspectoID),
		INDEX TMPBITACORASOLCREDREP_idx4(PromotorID) );

	SET Var_Sentencia := '
		 INSERT	INTO TMPBITACORASOLCREDREP(
			SolicitudCreditoID, CreditoID,	ClienteID,	ProspectoID,	PromotorID,	Estatus, AltaSolicitud,FechaCreCancela )';

	SET Var_Sentencia := 	CONCAT(Var_Sentencia, '
		SELECT
	S.SolicitudCreditoID,	S.CreditoID,	S.ClienteID,			S.ProspectoID,        S.PromotorID,
	CASE Estatus
		WHEN "', InactivaS, '" THEN "' ,InactivaT, '"
		WHEN "', LiberadaS, '" THEN "',	LiberadaT, '"
		WHEN "', RechazadasS, '" THEN "', RechazadasT, '"
		WHEN "', CanceladaS, '" THEN "', CanceladaT, '"
		WHEN "', AutorizadaS, '" THEN "', AutorizadaT, '"
		WHEN "', DesembolsadaS, '" THEN "', DesembolsadaT, '"
	END AS Estatus, "',AltaSolicitudSI,'",S.FechaCancela
	FROM SOLICITUDCREDITO S
	WHERE  FechaRegistro <="',Var_FechaSistema,'"');

    -- Filtro Agropecuarios
	SET Par_EsAgropecuario:=IFNULL(Par_EsAgropecuario,No_EsAgro);

	SET Var_Sentencia :=  CONCAT( Var_Sentencia,' AND S.EsAgropecuario= "',Par_EsAgropecuario,'"');

	IF  (IFNULL(Par_SucursalID, Entero_Cero) != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	S.SucursalID = ', Par_SucursalID );
	END IF;

	IF  (IFNULL(Par_PromotorID, Entero_Cero) != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	S.PromotorID = ', Par_PromotorID );
	END IF;

	IF  (IFNULL(Par_ProducCreditoID, Entero_Cero) != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	S.ProductoCreditoID = ', Par_ProducCreditoID );
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,';');

	SET @Sentencia	:= (Var_Sentencia);

	PREPARE STBITACORASOLCREDREP FROM @Sentencia;
	EXECUTE STBITACORASOLCREDREP;
	DEALLOCATE PREPARE STBITACORASOLCREDREP;

	# Inserta creditos sin solicitud
	SET Var_Sentencia := '
		 INSERT	INTO TMPBITACORASOLCREDREP(
			SolicitudCreditoID,	CreditoID,	ClienteID,	Estatus, AltaSolicitud )';

	SET Var_Sentencia := 	CONCAT(Var_Sentencia, '
		SELECT
		0,	S.CreditoID,	C.ClienteID,	CASE C.Estatus
		WHEN "', InactivoC, '" THEN "' ,InactivoTxt, '"
		WHEN "', AutorizadoC, '" THEN "',	AutorizadoTxt, '"
		WHEN "', CanceladoC, '" THEN "', CanceladoTxt, '"
		WHEN "', DesembolsadoC, '" THEN "', DesembolsadoTxt, '"
		WHEN "', CastigadoC, '" THEN "', DesembolsadoTxt, '"
		WHEN "', VencidoC, '" THEN "', DesembolsadoTxt, '"
		WHEN "', PagadoC, '" THEN "', DesembolsadoTxt, '"
		WHEN "', VigenteC, '" THEN "', DesembolsadoTxt, '"
	END AS Estatus,"',AltaSolicitudNO,'"
	FROM SOLICITUDESCERO S
	INNER JOIN CREDITOS C
	ON S.CreditoID = C.CreditoID
	WHERE  FechaRegistro <="',Var_FechaSistema,'"');

    SET Var_Sentencia :=  CONCAT( Var_Sentencia,' AND C.EsAgropecuario= "',Par_EsAgropecuario,'"');

	IF  (IFNULL(Par_SucursalID, Entero_Cero) != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	C.SucursalID = ', Par_SucursalID );
	END IF;

	IF  (IFNULL(Par_ProducCreditoID, Entero_Cero) != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	C.ProductoCreditoID = ', Par_ProducCreditoID );
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,';');

	SET @Sentencia	:= (Var_Sentencia);

	PREPARE STBITACORACREDSINSOL FROM @Sentencia;
	EXECUTE STBITACORACREDSINSOL;
	DEALLOCATE PREPARE STBITACORACREDSINSOL;

	# Termina de insertar creditos sin solicitud

	DROP TABLE IF EXISTS TMPCOMENTARIOSSOL ;

	CREATE TEMPORARY TABLE TMPCOMENTARIOSSOL (
		ComentarioID			BIGINT(12),
		`SolicitudCreditoID`	BIGINT(11),
		`Estatus`				CHAR(2),
		`Fecha`					DATETIME,
		`Comentario`			VARCHAR(2500),
		`UsuarioOperacion`		INT(11),
		`TiempoEstatus`			INT(11),
		INDEX TMPCOMENTARIOSSOL_idx1(SolicitudCreditoID));

	INSERT	INTO TMPCOMENTARIOSSOL(
		ComentarioID,	SolicitudCreditoID,	Estatus,	Fecha,	Comentario,
		UsuarioOperacion, TiempoEstatus)

	SELECT
		C.ComentarioID,	C.SolicitudCreditoID,		C.Estatus,C.Fecha,
		C.Comentario, 	C.UsuarioOperacion, 	C.TiempoEstatus
		FROM	COMENTARIOSSOL C, TMPBITACORASOLCREDREP T
		WHERE	C.SolicitudCreditoID = T.SolicitudCreditoID
		GROUP BY C.SolicitudCreditoID,	C.Estatus,			C.ComentarioID,	C.Fecha,
				 C.Comentario, 			C.UsuarioOperacion, C.TiempoEstatus
		ORDER BY C.Fecha DESC;

	UPDATE TMPBITACORASOLCREDREP T, CLIENTES C
	SET T.NombreCompleto = C.NombreCompleto
	WHERE T.ClienteID = C.ClienteID;

	UPDATE TMPBITACORASOLCREDREP T, PROSPECTOS P
	SET T.NombreCompleto = P.NombreCompleto
	WHERE T.ProspectoID = P.ProspectoID;

	UPDATE TMPBITACORASOLCREDREP T, PROMOTORES P
	SET T.NombrePromotor = P.NombrePromotor
	WHERE T.PromotorID = P.PromotorID;


	-- Comentarios Registro de Solicitud
	UPDATE TMPBITACORASOLCREDREP T, TMPCOMENTARIOSSOL C
	SET T.FechaSolRegistro = C.Fecha,
		T.UsuSolRegistro = C.UsuarioOperacion,
		T.ComSolRegistro = C.Comentario,
		T.TiempoEstRegistro = C.TiempoEstatus
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
	AND C.Estatus = Est_SolInactiva;


	UPDATE TMPBITACORASOLCREDREP T, TMPCOMENTARIOSSOL C
	SET T.FechaSolLiberacion = C.Fecha,
		T.UsuSolLiberacion = C.UsuarioOperacion,
		T.ComSolLiberacion = C.Comentario,
		T.TiempoEstLiberacion = C.TiempoEstatus
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
		AND C.Estatus = Est_SolLiberada;


	UPDATE TMPBITACORASOLCREDREP T, TMPCOMENTARIOSSOL C
	SET T.FechaSolActualizacion = C.Fecha,
		T.UsuSolActualizacion = C.UsuarioOperacion,
		T.ComSolActualizacion = C.Comentario,
		T.TiempoEstActualizacion = C.TiempoEstatus
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
	AND C.Estatus = Est_SolActualizacion;

	UPDATE TMPBITACORASOLCREDREP T, TMPCOMENTARIOSSOL C
	SET T.FechaSolRechazo = C.Fecha,
		T.UsuSolRechazo = C.UsuarioOperacion,
		T.ComSolRechazo = C.Comentario
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
	AND C.Estatus = Est_SolRechazada;

	UPDATE TMPBITACORASOLCREDREP T, TMPCOMENTARIOSSOL C
	SET T.FechaSolAutorizacion = C.Fecha,
		T.UsuSolAutorizacion = C.UsuarioOperacion,
		T.ComSolAutorizacion = C.Comentario,
		T.TiempoEstAutorizacion = C.TiempoEstatus
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
	AND C.Estatus = Est_SolAutorizada;

	UPDATE TMPBITACORASOLCREDREP T, COMENTARIOSSOL C
	SET T.FechaCreRegistro = C.Fecha,
		T.UsuCreRegistro = C.UsuarioOperacion,
		T.ComCreRegistro = C.Comentario,
		T.TiempoEstCreRegistro = C.TiempoEstatus
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
	AND C.Estatus = Est_CredInactivo;

	UPDATE TMPBITACORASOLCREDREP T, TMPCOMENTARIOSSOL C
	SET T.FechaCreCondiciona = C.Fecha,
		T.UsuCreCondiciona = C.UsuarioOperacion,
		T.ComCreCondiciona = C.Comentario,
		T.TiempoEstCreCondiciona = C.TiempoEstatus
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
	AND C.Estatus = Est_CredCondicionado;

	UPDATE TMPBITACORASOLCREDREP T, TMPCOMENTARIOSSOL C
	SET T.FechaCreAutoriza = C.Fecha,
		T.UsuCreAutoriza = C.UsuarioOperacion,
		T.ComCreAutoriza = C.Comentario,
		T.TiempoEstCreAutoriza = C.TiempoEstatus
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
	AND C.Estatus = Est_CredAutorizado;

	UPDATE TMPBITACORASOLCREDREP T, TMPCOMENTARIOSSOL C
	SET T.FechaCreDesembolsa = C.Fecha,
		T.UsuCreDesembolsa = C.UsuarioOperacion,
		T.ComCreDesembolsa = C.Comentario
	WHERE T.SolicitudCreditoID = C.SolicitudCreditoID
	AND C.Estatus = Est_CredDesembolsado;


	-- USUARIO ALTA DE SOLICITUD
	UPDATE  TMPBITACORASOLCREDREP T,USUARIOS U
	SET 	T.NomUsuSolRegistro	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuSolRegistro	 = U.UsuarioID;

	-- USUARIO QUE LIBERO LA SOLICITUD
	UPDATE  TMPBITACORASOLCREDREP T,USUARIOS U
	SET 	T.NomUsuSolLiberacion	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuSolLiberacion	 = U.UsuarioID;

	-- USUARIO QUE REGRESO LA SOLICITUD AL EJECUTIVO
	UPDATE  TMPBITACORASOLCREDREP T, USUARIOS U
	SET 	T.NomUsuSolActualizacion	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuSolActualizacion	 = U.UsuarioID;

	-- USUARIO QUE RECHAZO LA SOLICITUD
	UPDATE  TMPBITACORASOLCREDREP T, USUARIOS U
	SET 	T.NomUsuSolRechazo	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuSolRechazo	 = U.UsuarioID;

	-- USUARIO QUE AUTORIZO LA SOLICITUD
	UPDATE  TMPBITACORASOLCREDREP T, USUARIOS U
	SET 	T.NomUsuSolAutorizacion	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	 T.UsuSolAutorizacion	 = U.UsuarioID;

	-- USUARIO QUE REGISTRO EL CREDITO
	UPDATE  TMPBITACORASOLCREDREP T, USUARIOS U
	SET 	T.NomUsuCreRegistro	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuCreRegistro	 = U.UsuarioID;

	-- USUARIO QUE CONDICIONO EL CREDITO
	UPDATE  TMPBITACORASOLCREDREP T, USUARIOS U
	SET 	T.NomUsuCreCondiciona	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuCreCondiciona	 = U.UsuarioID;

	-- USUARIO QUE AUTORIZO EL CREDITO
	UPDATE  TMPBITACORASOLCREDREP T,  USUARIOS U
	SET 	T.NomUsuCreAutoriza = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuCreAutoriza	 = U.UsuarioID;

	-- USUARIO QUE DESEMBOLSA EL CREDITO
	UPDATE  TMPBITACORASOLCREDREP T,  USUARIOS U
	SET 	T.NomUsuCreDesembolsa	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuCreDesembolsa	 = U.UsuarioID;

	-- USUARIO QUE REGISTRO EL CREDITO
	UPDATE  TMPBITACORASOLCREDREP T,  USUARIOS U
	SET 	T.NomUsuCreCancela	 = IFNULL(U.NombreCompleto,Cadena_Vacia)
	WHERE	T.UsuCreCancela	 = U.UsuarioID;


	UPDATE TMPBITACORASOLCREDREP T,
			CREDITOS C
	SET T.Estatus = (CASE C.Estatus
						WHEN AutorizadoC THEN AutorizadoTxt
						WHEN VencidoC THEN DesembolsadoTxt
						WHEN CanceladoC THEN CanceladoTxt
						WHEN DesembolsadoC THEN DesembolsadoTxt
						WHEN InactivoC THEN InactivoTxt
						WHEN CastigadoC THEN DesembolsadoTxt
						WHEN PagadoC THEN DesembolsadoTxt
						WHEN VigenteC THEN DesembolsadoTxt
						END)

		WHERE T.SolicitudCreditoID = C.SolicitudCreditoID;


	UPDATE TMPBITACORASOLCREDREP AS Tmp
		LEFT JOIN SOLICITUDCREDITO AS Sol ON Tmp.SolicitudCreditoID = Sol.SolicitudCreditoID
		LEFT JOIN CREDITOS AS Cred ON Tmp.CreditoID = Cred.CreditoID
	SET
		Dias =
			DATEDIFF(COALESCE(DATE(IF(Cred.FechaMinistrado = Fecha_Vacia, NULL,Cred.FechaMinistrado)),Par_FechaFin),
			COALESCE(IF(Sol.FechaRegistro = Fecha_Vacia, NULL,Sol.FechaRegistro),Cred.FechaInicio));

	SELECT
		CASE T.AltaSolicitud
			WHEN AltaSolicitudSI THEN IFNULL(T.SolicitudCreditoID, Cadena_Vacia)
			WHEN AltaSolicitudNO THEN Cadena_Vacia
		END AS SolicitudCreditoID,
		IFNULL(T.CreditoID,Cadena_Vacia) AS CreditoID,
		IFNULL(T.ClienteID, Cadena_Vacia) AS ClienteID,
		IFNULL(T.ProspectoID, Cadena_Vacia) AS ProspectoID,
		IFNULL(T.NombreCompleto,Cadena_Vacia) AS NombreCompleto,
		IFNULL(T.PromotorID, Cadena_Vacia) AS PromotorID,
		IFNULL(T.NombrePromotor,Cadena_Vacia) AS NombrePromotor,
		IFNULL(T.Estatus, Cadena_Vacia) AS Estatus ,
		(IFNULL(T.FechaSolRegistro, Cadena_Vacia)) AS FechaSolRegistro,
		(IFNULL(T.UsuSolRegistro, Cadena_Vacia)) AS	UsuSolRegistro,
		(IFNULL(T.NomUsuSolRegistro, Cadena_Vacia)) AS	NomUsuSolRegistro,
		(IFNULL(T.ComSolRegistro, Cadena_Vacia)) AS ComSolRegistro,
		(IFNULL(T.TiempoEstRegistro, Cadena_Vacia)) AS TiempoEstRegistro ,
		(IFNULL(T.FechaSolLiberacion, Cadena_Vacia)) AS FechaSolLiberacion,
		(IFNULL(T.UsuSolLiberacion,	Cadena_Vacia))	AS UsuSolLiberacion,
		(IFNULL(T.NomUsuSolLiberacion, 	Cadena_Vacia))	AS NomUsuSolLiberacion,
		(IFNULL(T.ComSolLiberacion, Cadena_Vacia)) AS ComSolLiberacion,
		(IFNULL(T.TiempoEstLiberacion,	Cadena_Vacia)) AS TiempoEstLiberacion,
		(IFNULL(T.FechaSolActualizacion, Cadena_Vacia)) AS FechaSolActualizacion,
		(IFNULL(T.UsuSolActualizacion, Cadena_Vacia))AS UsuSolActualizacion,
		(IFNULL(T.NomUsuSolActualizacion,Cadena_Vacia))	AS NomUsuSolActualizacion,
		(IFNULL(T.ComSolActualizacion, 	Cadena_Vacia))AS ComSolActualizacion,
		(IFNULL(T.TiempoEstActualizacion,Cadena_Vacia))AS TiempoEstActualizacion,
		(IFNULL(T.FechaSolRechazo,Cadena_Vacia)) AS FechaSolRechazo,
		(IFNULL(T.UsuSolRechazo, Cadena_Vacia)) AS UsuSolRechazo,
		(IFNULL(T.NomUsuSolRechazo, Cadena_Vacia)) AS NomUsuSolRechazo,
		(IFNULL(T.ComSolRechazo, Cadena_Vacia)) AS ComSolRechazo,
		(IFNULL(T.FechaSolAutorizacion,Cadena_Vacia)) AS FechaSolAutorizacion,
		(IFNULL(T.UsuSolAutorizacion, 	Cadena_Vacia)) AS UsuSolAutorizacion,
		(IFNULL(T.NomUsuSolAutorizacion,Cadena_Vacia)) AS NomUsuSolAutorizacion,
		(IFNULL(T.ComSolAutorizacion, 	Cadena_Vacia)) AS ComSolAutorizacion,
		(IFNULL(T.TiempoEstAutorizacion,Cadena_Vacia)) AS TiempoEstAutorizacion,
		(IFNULL(T.FechaCreRegistro,Cadena_Vacia)) AS FechaCreRegistro,
		(IFNULL(T.UsuCreRegistro, 	Cadena_Vacia)) AS UsuCreRegistro,
		(IFNULL(T.NomUsuCreRegistro, Cadena_Vacia)) AS NomUsuCreRegistro,
		(IFNULL(T.ComCreRegistro, 	Cadena_Vacia)) AS ComCreRegistro,
		(IFNULL(T.TiempoEstCreRegistro, Cadena_Vacia)) AS TiempoEstCreRegistro,
		(IFNULL(T.FechaCreCondiciona,Cadena_Vacia)) AS FechaCreCondiciona,
		(IFNULL(T.UsuCreCondiciona,	Cadena_Vacia)) AS UsuCreCondiciona,
		(IFNULL(T.NomUsuCreCondiciona, Cadena_Vacia)) AS NomUsuCreCondiciona,
		(IFNULL(T.ComCreCondiciona, Cadena_Vacia)) AS ComCreCondiciona,
		(IFNULL(T.TiempoEstCreCondiciona,Cadena_Vacia)) AS TiempoEstCreCondiciona,
		(IFNULL(T.FechaCreAutoriza,Cadena_Vacia)) AS FechaCreAutoriza,
		(IFNULL(T.UsuCreAutoriza, 	Cadena_Vacia)) AS UsuCreAutoriza,
		(IFNULL(T.NomUsuCreAutoriza,Cadena_Vacia)) AS NomUsuCreAutoriza,
		(IFNULL(T.ComCreAutoriza, 	Cadena_Vacia)) AS ComCreAutoriza,
		(IFNULL(T.TiempoEstCreAutoriza,Cadena_Vacia)) AS TiempoEstCreAutoriza,
		(IFNULL(T.FechaCreDesembolsa, Cadena_Vacia)) AS FechaCreDesembolsa,
		(IFNULL(T.UsuCreDesembolsa, Cadena_Vacia)) AS UsuCreDesembolsa,
		(IFNULL(T.NomUsuCreDesembolsa,Cadena_Vacia)) AS NomUsuCreDesembolsa,
		(IFNULL(T.ComCreDesembolsa,	Cadena_Vacia)) AS ComCreDesembolsa,
		CASE WHEN T.FechaCreCancela  = Fecha_Vacia THEN ''
			ELSE IFNULL(T.FechaCreCancela,Cadena_Vacia)
			END AS FechaCreCancela,
		(IFNULL(T.UsuCreCancela,Cadena_Vacia)) AS UsuCreCancela,
		(IFNULL(T.NomUsuCreCancela,	Cadena_Vacia)) AS NomUsuCreCancela,
		(IFNULL(T.ComCreCancela,Cadena_Vacia)) AS ComCreCancela,
		CURRENT_TIME AS HoraEmision,
		Dias
		FROM TMPBITACORASOLCREDREP T
		WHERE (
		(DATE(T.FechaSolRegistro) BETWEEN Par_FechaInicio AND Par_FechaFin) OR
		(DATE(T.FechaSolLiberacion) BETWEEN Par_FechaInicio AND Par_FechaFin) OR
		(DATE(T.FechaSolActualizacion) BETWEEN Par_FechaInicio AND Par_FechaFin) OR
		(DATE(T.FechaSolAutorizacion) BETWEEN Par_FechaInicio AND Par_FechaFin) OR
		(DATE(T.FechaCreRegistro) BETWEEN Par_FechaInicio AND Par_FechaFin) OR
		(DATE(T.FechaCreAutoriza) BETWEEN Par_FechaInicio AND Par_FechaFin) OR
		(DATE(T.FechaCreDesembolsa) BETWEEN Par_FechaInicio AND Par_FechaFin) OR
		(DATE(T.FechaCreCondiciona) BETWEEN Par_FechaInicio AND Par_FechaFin) OR
		(DATE(T.FechaCreCancela) BETWEEN Par_FechaInicio AND Par_FechaFin));

	DROP TABLE IF EXISTS TMPBITACORASOLCREDREP;
END TerminaStore$$