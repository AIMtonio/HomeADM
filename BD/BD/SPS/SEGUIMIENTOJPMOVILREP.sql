-- SEGUIMIENTOJPMOVILREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOJPMOVILREP`;
DELIMITER $$
CREATE PROCEDURE `SEGUIMIENTOJPMOVILREP`(
	-- SP que geenra el reporte del historial de los folios JPMovi

	Par_FechaInicio			DATE,				-- Fecha de inicio de los folios
	Par_FechaFin			DATE,				-- Fecha de fin de los folio
	Par_ClienteID			INT(11),			-- Identificador del Cliente
	Par_Estatus				CHAR(1),			-- Identificador del folio para el reporte TODOS = '' EN PROCESO = 'P' CANCELADO = 'C' RESUELTO = 'R'
	Par_IncluyeCometario	CHAR(1),			-- Indica si se incluye el historia de comentarios S = SI N = NO

	Par_TipoReporte			INT(11),			-- Indica el tipo de reporte 1 = Excel

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50), 		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_Sentencia			VARCHAR(10000);		-- Variable para la consulta

	DECLARE Var_ConsecutivoID		INT(11);			-- Variable para Consulta en el While
	DECLARE Var_ClienteID			INT(11);			-- Variable para Consulta en el While
	DECLARE Var_NombreCliente		VARCHAR(200);		-- Variable para Consulta en el While
	DECLARE Var_Telefono			VARCHAR(20);		-- Variable para Consulta en el While
	DECLARE Var_CuentaAhoID			BIGINT(12);			-- Variable para Consulta en el While
	DECLARE Var_SeguimientoID		INT(11);			-- Variable para Consulta en el While
	DECLARE Var_SucursalOrigen		INT(11);			-- Variable para Consulta en el While
	DECLARE Var_Estatus				CHAR(1);			-- Variable para Consulta en el While
	DECLARE Var_FechaRegistro		DATE;				-- Variable para Consulta en el While
	DECLARE Var_HoraRegistro		TIME;				-- Variable para Consulta en el While
	DECLARE Var_TipoSoporte			VARCHAR(200);		-- Variable para Consulta en el While
	DECLARE Var_UsuarioNombre		VARCHAR(200);		-- Variable para Consulta en el While
	DECLARE Var_UltimoComentario	VARCHAR(150);		-- Variable para Consulta en el While

	DECLARE Var_Contador			INT(11);			-- Varialbe para Consulta en el while
	DECLARE Var_Tamanio 			INT(11);			-- Variable para Consulta en el while
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante para una cadena vacia
	DECLARE Entero_Cero				INT(11);			-- Constante para el valor 0
	DECLARE Fecha_Vacia				DATE;				-- Constante para fecha vacia

	DECLARE Con_Excel				INT(11);			-- Constante para el valor Excel
	DECLARE Con_SI 					CHAR(1);			-- Constante SI
	DECLARE Con_NO 					CHAR(1);			-- Constante NO
	DECLARE Entero_Uno				INT(11);			-- Constante valor uno

	DECLARE Est_EnProceso			CHAR(1);			-- Estatus Del Folio en Proceso
	DECLARE Est_Cancelado			CHAR(1);			-- Estatus Del Folio Cancelado
	DECLARE Est_Resuleto			CHAR(1);			-- Estatus Del Folio Resuelto
	DECLARE Txt_EnProceso			VARCHAR(10);		-- Texto del estatus En Proceso
	DECLARE Txt_Cancelado			VARCHAR(9);			-- Texto del estatus Cancelado
	DECLARE Txt_Resuleto			VARCHAR(8);			-- Texto del estatus Resuleto
	-- Seteo de Valores
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia

	SET Con_Excel					:= 1;				-- Excel
	SET Con_SI 						:= 'S';				-- NO
	SET Con_NO 						:= 'N';				-- SI

	SET Var_Contador				:= 1;				-- Contador para el while

	SET Est_EnProceso	:= 'P';
	SET Est_Cancelado	:= 'C';
	SET Est_Resuleto	:= 'R';
	SET Txt_EnProceso	:= 'EN PROCESO';
	SET Txt_Cancelado	:= 'CANCELADO';
	SET Txt_Resuleto	:= 'RESUELTO';

	-- Creacion de Tabla temporal para los comentarios
	DROP TABLE IF EXISTS `TMPSEGUIMIENTOJPMOVILREP`;
	CREATE TEMPORARY TABLE `TMPSEGUIMIENTOJPMOVILREP`(
			ClienteID INT(11) NULL,
			NombreCliente VARCHAR(200) NULL,
			Telefono VARCHAR(20) NULL,
			CuentaAhoID BIGINT(12) NULL,
			SeguimientoID INT(11) NULL,
			SucursalOrigen INT(11) NULL ,
			Estatus CHAR(1) NULL ,
			FechaRegistro DATE NULL,
			HoraRegistro TIME NULL,
			TipoSoporte VARCHAR(200) NULL,
			UsuarioNombre VARCHAR(200) NULL,
			UltimoComentario VARCHAR(150) NULL,
			ComentarioCliente VARCHAR(150) NULL,
			ComentarioUsuario VARCHAR(150) NULL
		);
	DROP TABLE IF EXISTS `TMPPARAWHILEREP`;
	CREATE TEMPORARY TABLE `TMPPARAWHILEREP`(
			ConsecutivoID INT(11) PRIMARY KEY,
			ClienteID INT(11) NULL,
			NombreCliente VARCHAR(200) NULL,
			Telefono VARCHAR(20) NULL,
			CuentaAhoID BIGINT(12) NULL,
			SeguimientoID INT(11) NULL,
			SucursalOrigen INT(11) NULL ,
			Estatus CHAR(1) NULL ,
			FechaRegistro DATE NULL,
			HoraRegistro TIME NULL,
			TipoSoporte VARCHAR(200) NULL,
			UsuarioNombre VARCHAR(200) NULL,
			UltimoComentario VARCHAR(150) NULL
		);

	-- Inicia seccion de reporte en Excel
	IF Par_TipoReporte = Con_Excel THEN
	SET @Consecutivo := 0;
		SET Var_Sentencia := CONCAT('INSERT INTO TMPPARAWHILEREP(SELECT @Consecutivo := @Consecutivo+1,Cli.ClienteID,		Cli.NombreCompleto,		FNMASCARA(Cue.Telefono,"### ###-####") Telefono,		Cue.CuentaAhoID,		Seg.SeguimientoID,
									Cli.SucursalOrigen, Seg.Estatus, DATE(Seg.FechaRegistra) FechaRegistro, TIME(Seg.FechaRegistra) HoraRegistro,		Sop.Descripcion,
									Usu.NombreCompleto, ""
		FROM SEGUIMIENTOSPDM Seg
		INNER JOIN CATTIPOSOPORTE Sop ON Seg.TipoSoporteID = Sop.TipoSoporteID
		INNER JOIN USUARIOS	Usu ON Seg.UsuarioRegistra = Usu.UsuarioID
		INNER JOIN CUENTASBCAMOVIL Cue ON Seg.ClienteID = Cue.ClienteID
		INNER JOIN CLIENTES Cli ON Cue.ClienteID = Cli.ClienteID
		WHERE DATE(Seg.FechaRegistra) BETWEEN DATE("',Par_FechaInicio,'") AND DATE("',Par_FechaFin,'") ');

		IF IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Seg.ClienteID = ',Par_ClienteID);
		END IF;

		IF IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND Seg.Estatus= "',Par_Estatus,'" ');
		END IF;

		SET Var_Sentencia := CONCAT (Var_Sentencia,' GROUP BY Cli.ClienteID,		Cli.NombreCompleto,		Cue.Telefono,		Cue.CuentaAhoID,		Seg.SeguimientoID,
				Cli.SucursalOrigen, Seg.Estatus, 			Seg.FechaRegistra,	Usu.NombreCompleto)');


		SET @Sentencia	= (Var_Sentencia);

		PREPARE SEGUIMIENTOJPMOVIL FROM @Sentencia;
		EXECUTE SEGUIMIENTOJPMOVIL;
		DEALLOCATE PREPARE SEGUIMIENTOJPMOVIL;


		SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero) INTO Var_Tamanio FROM TMPPARAWHILEREP;

		-- Inicia ciclo para considerar si lleva o no historial de comentarios
		InicioCiclo:WHILE Var_Contador <= Var_Tamanio DO

			SELECT 	ClienteID, 		NombreCliente, 	Telefono,		CuentaAhoID,	SeguimientoID,
					SucursalOrigen,	Estatus,		FechaRegistro,	HoraRegistro,	TipoSoporte,
					UsuarioNombre,	UltimoComentario

			INTO 	Var_ClienteID, 		Var_NombreCliente, 	Var_Telefono,		Var_CuentaAhoID,	Var_SeguimientoID,
					Var_SucursalOrigen,	Var_Estatus,		Var_FechaRegistro,	Var_HoraRegistro,	Var_TipoSoporte,
					Var_UsuarioNombre,	Var_UltimoComentario
			FROM TMPPARAWHILEREP
			WHERE ConsecutivoID = Var_Contador;

			IF Par_IncluyeCometario = Con_SI THEN
				INSERT INTO TMPSEGUIMIENTOJPMOVILREP(ClienteID, 		NombreCliente, 	Telefono,		CuentaAhoID,	SeguimientoID,
													SucursalOrigen,		Estatus,		FechaRegistro,	HoraRegistro,	TipoSoporte,
													UsuarioNombre,		UltimoComentario)
				VALUES(Var_ClienteID, 		Var_NombreCliente, 	Var_Telefono,		Var_CuentaAhoID,	Var_SeguimientoID,
						Var_SucursalOrigen,	Var_Estatus,		Var_FechaRegistro,	Var_HoraRegistro,	Var_TipoSoporte,
						Var_UsuarioNombre,	Var_UltimoComentario);

				INSERT INTO TMPSEGUIMIENTOJPMOVILREP(ComentarioCliente,ComentarioUsuario)
				(SELECT ComentarioCliente,ComentarioUsuario FROM COMENTASEGUIMIENTOPDM
					WHERE SeguimientoID = Var_SeguimientoID ORDER BY ConsecutivoID);

				ELSE
					SELECT MAX(ConsecutivoID) INTO Var_ConsecutivoID FROM COMENTASEGUIMIENTOPDM
					WHERE SeguimientoID = Var_SeguimientoID
					AND ComentarioUsuario!=Cadena_Vacia;

					SELECT ComentarioUsuario INTO Var_UltimoComentario FROM COMENTASEGUIMIENTOPDM
					WHERE SeguimientoID = Var_SeguimientoID
					AND ConsecutivoID = Var_ConsecutivoID;

					INSERT INTO TMPSEGUIMIENTOJPMOVILREP(ClienteID, 		NombreCliente, 	Telefono,		CuentaAhoID,	SeguimientoID,
														SucursalOrigen,		Estatus,		FechaRegistro,	HoraRegistro,	TipoSoporte,
														UsuarioNombre,		UltimoComentario)
					VALUES(Var_ClienteID, 		Var_NombreCliente, 	Var_Telefono,		Var_CuentaAhoID,	Var_SeguimientoID,
							Var_SucursalOrigen,	Var_Estatus,		Var_FechaRegistro,	Var_HoraRegistro,	Var_TipoSoporte,
							Var_UsuarioNombre,	Var_UltimoComentario);
				END IF;

			SET Var_Contador := Var_Contador+1;
		END WHILE InicioCiclo;

		SELECT IFNULL(ClienteID,Cadena_Vacia) ClienteID, 		NombreCliente, 	Telefono,		CuentaAhoID,	SeguimientoID,
				SucursalOrigen,		CASE Estatus WHEN Est_EnProceso THEN
														Txt_EnProceso
													WHEN Est_Cancelado THEN
														Txt_Cancelado
													WHEN Est_Resuleto THEN
														Txt_Resuleto
														END Estatus,
				FechaRegistro,		HoraRegistro,		TipoSoporte,
				UsuarioNombre,		UltimoComentario,	ComentarioCliente,	ComentarioUsuario
		FROM TMPSEGUIMIENTOJPMOVILREP;

	END IF;

	-- Termina seccion de reporte en Excel
END TerminaStore$$