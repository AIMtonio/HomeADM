-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCUMENTOSGRDVALORESREP;

DELIMITER $$
CREATE PROCEDURE `DOCUMENTOSGRDVALORESREP`(
	-- Store Procedure: De Reporte del modulo de guarda valores para las pantallas:
	-- Guarda Valores --> Reportes --> Ingreso de Documentos
	-- Guarda Valores --> Reportes --> Documentos por Estatus
	-- Modulo Guarda Valores
	Par_FechaInicio				DATE,				-- Fecha Inicio del Reporte
	Par_FechaFin				DATE,				-- Fecha Fin del Reporte
	Par_SucursalID				INT(11),			-- ID de Sucursal
	Par_AlmacenID				INT(11),			-- ID de Almancen
	Par_Estatus					CHAR(1),			-- Estatus del Reporte

	Par_NumReporte				TINYINT UNSIGNED,	-- Numero de Reporte

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia		VARCHAR(5000);		-- Sentencia de Ejecucion
	DECLARE Var_NombreSucursal	VARCHAR(200);		-- Nombre de Sucursal
	DECLARE Var_NombreAlmacen	VARCHAR(200);		-- Nombre de Almacen

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Est_Activo			CHAR(1);			-- Estatus Activo
	DECLARE Con_Prospecto 		CHAR(1);			-- Constante de Prospecto
	DECLARE Con_Cliente			CHAR(1);			-- Constante de Cliente

	DECLARE Rep_IngresoDocumentos	TINYINT UNSIGNED;	-- Reporte de Ingreso de Documento
	DECLARE Rep_EstatusDocumentos	TINYINT UNSIGNED;	-- Reporte de Estatus Documento
	DECLARE Parametros				TINYINT UNSIGNED;	-- Parametros del Reporte

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Est_Activo				:= 'A';
	SET Con_Prospecto 			:= 'P';
	SET Con_Cliente				:= 'C';

	SET Rep_IngresoDocumentos	:= 1;
	SET Rep_EstatusDocumentos	:= 2;
	SET Parametros 				:= 3;

	DROP TABLE IF EXISTS TEMP_DOCUMENTOSGRDVALORESREP;
	CREATE TEMPORARY TABLE TEMP_DOCUMENTOSGRDVALORESREP(
		DocumentoID 			BIGINT(20),
		NombreParticipante 		VARCHAR(200),
		NombreInstrumento 		VARCHAR(50),
		NumeroInstrumento 		BIGINT(20),
		TipoDocumentoID 		INT(11),

		NombreDocumento			VARCHAR(60),
		NombreAlmacen			VARCHAR(50),
		Ubicacion				VARCHAR(1100),
		UsuarioRegistroID 		INT(11),
		UsuarioRegistro 		VARCHAR(200),

		Observaciones			VARCHAR(500),
		TipoPersona 			CHAR(1),
		Estatus					VARCHAR(20),
		AlmacenID 				INT(11),
		ParticipanteID 			INT(11),

		KEY `IDX_TEMP_DOCUMENTOSGRDVALORESREP_1` (`DocumentoID`),
		KEY `IDX_TEMP_DOCUMENTOSGRDVALORESREP_2` (`TipoDocumentoID`,`NombreDocumento`),
		KEY `IDX_TEMP_DOCUMENTOSGRDVALORESREP_3` (`UsuarioRegistroID`),
		KEY `IDX_TEMP_DOCUMENTOSGRDVALORESREP_4` (`NumeroInstrumento`,`TipoPersona`),
		KEY `IDX_TEMP_DOCUMENTOSGRDVALORESREP_5` (`AlmacenID`),
		KEY `IDX_TEMP_DOCUMENTOSGRDVALORESREP_6` (`ParticipanteID`));

	-- Se realiza la Lista principal
	IF( Par_NumReporte = Rep_IngresoDocumentos ) THEN
		SET Var_Sentencia := CONCAT('
			INSERT INTO TEMP_DOCUMENTOSGRDVALORESREP(
				DocumentoID,		NombreParticipante,	NombreInstrumento,	NumeroInstrumento,	TipoDocumentoID,
				NombreDocumento,	NombreAlmacen,		Ubicacion,			UsuarioRegistroID,	UsuarioRegistro,
				Observaciones,		TipoPersona,		Estatus,			AlmacenID,			ParticipanteID)
			SELECT 	Doc.DocumentoID, 		"" AS NombreParticipante, Cat.NombreInstrumento, Doc.NumeroInstrumento,
					Doc.TipoDocumentoID, Doc.NombreDocumento, Alm.NombreAlmacen,
					CONCAT(Doc.Ubicacion, " " , Doc.Seccion) AS Ubicacion, 				Doc.UsuarioRegistroID,
					"" AS UsuarioRegistro,	"" AS Observaciones, 			Doc.TipoPersona,
					"" AS Estatus, Doc.AlmacenID,		ParticipanteID
			FROM DOCUMENTOSGRDVALORES Doc
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Doc.TipoInstrumento
			INNER JOIN ALMACENES Alm ON Alm.AlmacenID = Doc.AlmacenID ');

		IF( Par_AlmacenID <> Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			AND Doc.AlmacenID = ',Par_AlmacenID,' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Doc.SucursalID ');

		IF( Par_SucursalID <> Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			AND Doc.SucursalID = ',Par_SucursalID,' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			WHERE Doc.FechaRegistro BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			ORDER BY  Alm.AlmacenID,Cat.CatInsGrdValoresID, Doc.DocumentoID, Doc.NumeroInstrumento;');

		SET @Sentencia    = (Var_Sentencia);
		PREPARE STMDOCUMENTOSGRDVALORESREP FROM @Sentencia;
		EXECUTE STMDOCUMENTOSGRDVALORESREP;
		DEALLOCATE PREPARE STMDOCUMENTOSGRDVALORESREP;

		IF( Par_AlmacenID = Entero_Cero ) THEN
			SET Var_Sentencia := Cadena_Vacia;
			SET Var_Sentencia := CONCAT('
				INSERT INTO TEMP_DOCUMENTOSGRDVALORESREP(
					DocumentoID,		NombreParticipante,	NombreInstrumento,	NumeroInstrumento,	TipoDocumentoID,
					NombreDocumento,	NombreAlmacen,		Ubicacion,			UsuarioRegistroID,	UsuarioRegistro,
					Observaciones,		TipoPersona,		Estatus,			AlmacenID,			ParticipanteID)
				SELECT 	Doc.DocumentoID, 		"" AS NombreParticipante, Cat.NombreInstrumento, Doc.NumeroInstrumento,
						Doc.TipoDocumentoID, Doc.NombreDocumento, "" AS NombreAlmacen,
						CONCAT(Doc.Ubicacion, " " , Doc.Seccion) AS Ubicacion, 				Doc.UsuarioRegistroID,
						"" AS UsuarioRegistro,	"" AS Observaciones, 			Doc.TipoPersona,
						"" AS Estatus,	0,	Doc.ParticipanteID
				FROM DOCUMENTOSGRDVALORES Doc
				INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Doc.TipoInstrumento ');

			SET Var_Sentencia := CONCAT(Var_Sentencia,'
				INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Doc.SucursalID ');

			IF( Par_SucursalID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'
				AND Doc.SucursalID = ',Par_SucursalID,' ');
			END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia,'
				WHERE Doc.FechaRegistro BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'"
				  AND AlmacenID = 0 ');

			SET Var_Sentencia := CONCAT(Var_Sentencia,'
				ORDER BY Cat.CatInsGrdValoresID, Doc.DocumentoID, Doc.NumeroInstrumento;');

			SET @Sentencia    = (Var_Sentencia);
			PREPARE STMDOCUMENTOSGRDVALORESREP FROM @Sentencia;
			EXECUTE STMDOCUMENTOSGRDVALORESREP;
			DEALLOCATE PREPARE STMDOCUMENTOSGRDVALORESREP;

		END IF;

		UPDATE TEMP_DOCUMENTOSGRDVALORESREP Tmp, USUARIOS Usr SET
			Tmp.UsuarioRegistro = UPPER(IFNULL(Usr.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.UsuarioRegistroID = Usr.UsuarioID;

		UPDATE TEMP_DOCUMENTOSGRDVALORESREP Tmp, CLIENTES Cli SET
			Tmp.NombreParticipante = UPPER(IFNULL(Cli.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.ParticipanteID = Cli.ClienteID
		  AND Tmp.TipoPersona = Con_Cliente;

		UPDATE TEMP_DOCUMENTOSGRDVALORESREP Tmp, PROSPECTOS Pro SET
			Tmp.NombreParticipante = UPPER(IFNULL(Pro.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.ParticipanteID = Pro.ProspectoID
		  AND Tmp.TipoPersona = Con_Prospecto;

		UPDATE TEMP_DOCUMENTOSGRDVALORESREP Tmp, TIPOSDOCUMENTOS Tip SET
			Tmp.NombreDocumento = UPPER(IFNULL(Tip.Descripcion, Cadena_Vacia))
		WHERE Tmp.TipoDocumentoID = Tip.TipoDocumentoID
		  AND Tmp.NombreDocumento = Cadena_Vacia;

		SELECT  DocumentoID, 	NombreParticipante, NombreInstrumento,	NumeroInstrumento,	NombreDocumento,
				NombreAlmacen,	Ubicacion,			UsuarioRegistro
		FROM TEMP_DOCUMENTOSGRDVALORESREP
		ORDER BY  AlmacenID, NumeroInstrumento, DocumentoID;

	END IF;

	-- Se realiza la Lista de Instrumentos Activos
	IF( Par_NumReporte = Rep_EstatusDocumentos ) THEN
		SET Var_Sentencia := CONCAT('
			INSERT INTO TEMP_DOCUMENTOSGRDVALORESREP(
				DocumentoID,		NombreParticipante,	NombreInstrumento,	NumeroInstrumento,	TipoDocumentoID,
				NombreDocumento,	NombreAlmacen,		Ubicacion,			UsuarioRegistroID,	UsuarioRegistro,
				Observaciones,		TipoPersona,		Estatus,			AlmacenID,			ParticipanteID)
			SELECT 	Doc.DocumentoID, 		"" AS NombreParticipante, Cat.NombreInstrumento, Doc.NumeroInstrumento,
					Doc.TipoDocumentoID, Doc.NombreDocumento, Alm.NombreAlmacen,
					CONCAT(Doc.Ubicacion, " " , Doc.Seccion) AS Ubicacion, 				Doc.UsuarioRegistroID,
					"" AS UsuarioRegistro,	Doc.Observaciones, 			Doc.TipoPersona,
					CASE WHEN Doc.Estatus = "R" THEN "REGISTRADO"
						 WHEN Doc.Estatus = "C" THEN "EN ALMACÉN"
						 WHEN Doc.Estatus = "P" THEN "PRÉSTAMO"
						 WHEN Doc.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus,	Alm.AlmacenID,		ParticipanteID
			FROM DOCUMENTOSGRDVALORES Doc
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Doc.TipoInstrumento
			INNER JOIN ALMACENES Alm ON Alm.AlmacenID = Doc.AlmacenID ');

		IF( Par_AlmacenID <> Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			AND Doc.AlmacenID = ',Par_AlmacenID,' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Doc.SucursalID ');

		IF( Par_SucursalID <> Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			AND Doc.SucursalID = ',Par_SucursalID,' ');
		END IF;

		IF( Par_Estatus <> Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			WHERE Doc.Estatus = "',Par_Estatus,'" ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			ORDER BY  Alm.AlmacenID,Cat.CatInsGrdValoresID, Doc.DocumentoID, Doc.NumeroInstrumento;');

		SET @Sentencia    = (Var_Sentencia);
		PREPARE STMDOCUMENTOSGRDVALORESREP FROM @Sentencia;
		EXECUTE STMDOCUMENTOSGRDVALORESREP;
		DEALLOCATE PREPARE STMDOCUMENTOSGRDVALORESREP;

		IF( Par_AlmacenID = Entero_Cero ) THEN
			SET Var_Sentencia := Cadena_Vacia;
			SET Var_Sentencia := CONCAT('
				INSERT INTO TEMP_DOCUMENTOSGRDVALORESREP(
					DocumentoID,		NombreParticipante,	NombreInstrumento,	NumeroInstrumento,	TipoDocumentoID,
					NombreDocumento,	NombreAlmacen,		Ubicacion,			UsuarioRegistroID,	UsuarioRegistro,
					Observaciones,		TipoPersona,		Estatus,			AlmacenID,			ParticipanteID)
				SELECT 	Doc.DocumentoID, 		"" AS NombreParticipante, Cat.NombreInstrumento, Doc.NumeroInstrumento,
						Doc.TipoDocumentoID, Doc.NombreDocumento, "" AS NombreAlmacen,
					CONCAT(Doc.Ubicacion, " " , Doc.Seccion) AS Ubicacion, 				Doc.UsuarioRegistroID,
					"" AS UsuarioRegistro,	Doc.Observaciones, 			Doc.TipoPersona,
					CASE WHEN Doc.Estatus = "R" THEN "REGISTRADO"
						 WHEN Doc.Estatus = "C" THEN "EN ALMACÉN"
						 WHEN Doc.Estatus = "P" THEN "PRÉSTAMO"
						 WHEN Doc.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus,	0,	ParticipanteID
				FROM DOCUMENTOSGRDVALORES Doc
				INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Doc.TipoInstrumento ');

			SET Var_Sentencia := CONCAT(Var_Sentencia,'
			INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Doc.SucursalID ');

			IF( Par_SucursalID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'
				AND Doc.SucursalID = ',Par_SucursalID,' ');
			END IF;
			SET Var_Sentencia := CONCAT(Var_Sentencia,'
				WHERE Doc.AlmacenID = 0 ');

			IF( Par_Estatus <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'
				  AND Doc.Estatus = "',Par_Estatus,'" ');
			END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia,'
				ORDER BY Cat.CatInsGrdValoresID, Doc.DocumentoID, Doc.NumeroInstrumento;');

			SET @Sentencia    = (Var_Sentencia);
			PREPARE STMDOCUMENTOSGRDVALORESREP FROM @Sentencia;
			EXECUTE STMDOCUMENTOSGRDVALORESREP;
			DEALLOCATE PREPARE STMDOCUMENTOSGRDVALORESREP;

		END IF;

		UPDATE TEMP_DOCUMENTOSGRDVALORESREP Tmp, USUARIOS Usr SET
			Tmp.UsuarioRegistro = UPPER(IFNULL(Usr.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.UsuarioRegistroID = Usr.UsuarioID;

		UPDATE TEMP_DOCUMENTOSGRDVALORESREP Tmp, CLIENTES Cli SET
			Tmp.NombreParticipante = UPPER(IFNULL(Cli.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.ParticipanteID = Cli.ClienteID
		  AND Tmp.TipoPersona = Con_Cliente;

		UPDATE TEMP_DOCUMENTOSGRDVALORESREP Tmp, PROSPECTOS Pro SET
			Tmp.NombreParticipante = UPPER(IFNULL(Pro.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.ParticipanteID = Pro.ProspectoID
		  AND Tmp.TipoPersona = Con_Prospecto;

		UPDATE TEMP_DOCUMENTOSGRDVALORESREP Tmp, TIPOSDOCUMENTOS Tip SET
			Tmp.NombreDocumento = UPPER(IFNULL(Tip.Descripcion, Cadena_Vacia))
		WHERE Tmp.TipoDocumentoID = Tip.TipoDocumentoID
		  AND Tmp.NombreDocumento = Cadena_Vacia;

		SELECT  DocumentoID, 	NombreParticipante, NombreInstrumento,	NumeroInstrumento,	NombreDocumento,
				NombreAlmacen,	Ubicacion,			UsuarioRegistro,	Estatus,			Observaciones
		FROM TEMP_DOCUMENTOSGRDVALORESREP
		ORDER BY  AlmacenID, NumeroInstrumento, DocumentoID;

	END IF;

	-- Parametros del Reporte
	IF( Par_NumReporte = Parametros ) THEN

		SELECT	NombreSucurs
		INTO	Var_NombreSucursal
		FROM SUCURSALES WHERE SucursalID = Par_SucursalID;

		SELECT	NombreAlmacen
		INTO	Var_NombreAlmacen
		FROM ALMACENES WHERE AlmacenID = Par_AlmacenID;

		SET Var_NombreSucursal := IFNULL(Var_NombreSucursal, Cadena_Vacia);
		SET Var_NombreAlmacen := IFNULL(Var_NombreAlmacen, Cadena_Vacia);

		SELECT	CASE WHEN Par_SucursalID = Entero_Cero THEN "TODAS"
					 WHEN Par_SucursalID <> Entero_Cero THEN CONCAT(Par_SucursalID,' - ',Var_NombreSucursal)
				END AS Var_NombreSucursal,
				CASE WHEN Par_AlmacenID = Entero_Cero THEN "TODOS"
					 WHEN Par_AlmacenID <> Entero_Cero THEN CONCAT(Par_AlmacenID,' - ',Var_NombreAlmacen)
				END AS Var_NombreAlmacen,
				CASE WHEN Par_Estatus = 'R' THEN 'REGISTRADO'
					 WHEN Par_Estatus = 'R' THEN 'CUSTODIA'
					 WHEN Par_Estatus = 'R' THEN 'PRÉSTAMO'
					 WHEN Par_Estatus = 'R' THEN 'BAJA'
					 ELSE 'TODOS'
				END AS Var_DescripcionEstatus;
	END IF;

	DROP TABLE IF EXISTS TEMP_DOCUMENTOSGRDVALORESREP;

END TerminaStore$$