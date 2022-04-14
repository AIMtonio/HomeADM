-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESTAMODOCGRDVALORESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS PRESTAMODOCGRDVALORESREP;

DELIMITER $$
CREATE PROCEDURE `PRESTAMODOCGRDVALORESREP`(
	-- Store Procedure: De Reporte del modulo de guarda valores para las pantallas:
	-- Guarda Valores --> Reportes --> Prestamo de Documentos.
	-- Modulo Guarda Valores
	Par_FechaInicio				DATE,				-- Fecha Inicio del Reporte
	Par_FechaFin				DATE,				-- Fecha Fin del Reporte
	Par_SucursalID				INT(11),			-- ID de Sucursal
	Par_AlmacenID				INT(11),			-- ID de Almancen

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

	DECLARE Rep_PrestamoDocumentos	TINYINT UNSIGNED;-- Reporte de Prestamo Documento
	DECLARE Parametros				TINYINT UNSIGNED;-- Reporte de Prestamo Documento

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Est_Activo				:= 'A';

	SET Con_Prospecto 			:= 'P';
	SET Con_Cliente				:= 'C';

	-- Tipos de Reporte
	SET Rep_PrestamoDocumentos	:= 1;
	SET Parametros 				:= 2;

	DROP TABLE IF EXISTS TEMP_PRESTAMODOCGRDVALORESREP;
	CREATE TEMPORARY TABLE TEMP_PRESTAMODOCGRDVALORESREP(
		DocumentoID 			BIGINT(20),
		NombreParticipante 		VARCHAR(200),
		NombreInstrumento 		VARCHAR(50),
		NumeroInstrumento 		BIGINT(20),
		TipoDocumentoID 		INT(11),

		NombreDocumento			VARCHAR(60),
		NombreAlmacen			VARCHAR(50),
		Ubicacion				VARCHAR(1100),
		FechaPrestamo			DATE,
		HoraPrestamo			TIME,

		UsuarioRegistroID		INT(11),
		UsuarioPrestamoID		INT(11),
		UsuarioAutorizaID		INT(11),
		NombreUsuarioRegistroID	VARCHAR(200),
		NombreUsuarioPrestamoID	VARCHAR(200),

		NombreUsuarioAutorizaID	VARCHAR(200),
		FechaDevolucion 		VARCHAR(20),
		Observaciones			VARCHAR(500),
		TipoPersona 			CHAR(1),
		ParticipanteID			INT(11),

		KEY `IDX_TEMP_PRESTAMODOCGRDVALORESREP_1` (`DocumentoID`),
		KEY `IDX_TEMP_PRESTAMODOCGRDVALORESREP_2` (`TipoDocumentoID`,`NombreDocumento`),
		KEY `IDX_TEMP_PRESTAMODOCGRDVALORESREP_3` (`UsuarioRegistroID`),
		KEY `IDX_TEMP_PRESTAMODOCGRDVALORESREP_4` (`UsuarioPrestamoID`),
		KEY `IDX_TEMP_PRESTAMODOCGRDVALORESREP_5` (`UsuarioAutorizaID`),
		KEY `IDX_TEMP_PRESTAMODOCGRDVALORESREP_6` (`NumeroInstrumento`,`TipoPersona`),
        KEY `IDX_TEMP_PRESTAMODOCGRDVALORESREP_7` (`ParticipanteID`,`TipoPersona`));

	-- Reporte de Pretamo de documentos
	IF( Par_NumReporte = Rep_PrestamoDocumentos ) THEN

		SET Var_Sentencia := CONCAT('
			INSERT INTO TEMP_PRESTAMODOCGRDVALORESREP(
					DocumentoID,				NombreParticipante,	NombreInstrumento,	NumeroInstrumento,			TipoDocumentoID,
					NombreDocumento,			NombreAlmacen,		Ubicacion,			FechaPrestamo,				HoraPrestamo,
					UsuarioRegistroID,			UsuarioPrestamoID,	UsuarioAutorizaID,	NombreUsuarioRegistroID,	NombreUsuarioPrestamoID,
					NombreUsuarioAutorizaID,	FechaDevolucion,	Observaciones,		TipoPersona,				ParticipanteID)
			SELECT 	Doc.DocumentoID,	"" AS NombreParticipante,	Cat.NombreInstrumento, Doc.NumeroInstrumento, Doc.TipoDocumentoID,
					Doc.NombreDocumento, 	Alm.NombreAlmacen,		CONCAT(Doc.Ubicacion, " " , Doc.Seccion) AS Ubicacion,
					Pre.FechaRegistro AS FechaPrestamo,				Pre.HoraRegistro AS HoraPrestamo,
					Pre.UsuarioRegistroID,	Pre.UsuarioPrestamoID,	Pre.UsuarioAutorizaID, "" AS NombreUsuarioRegistroID, "" AS NombreUsuarioPrestamoID,
					"" AS NombreUsuarioAutorizaID,
					CASE WHEN Pre.FechaDevolucion = "1900-01-01" THEN "NA"
						 ELSE CONCAT(Pre.FechaDevolucion, " ",Pre.HoraDevolucion)
					END FechaDevolucion, 	Pre.Observaciones,	Doc.TipoPersona,		Doc.ParticipanteID
			FROM PRESTAMODOCGRDVALORES Pre
			INNER JOIN DOCUMENTOSGRDVALORES Doc ON Doc.DocumentoID = Pre.DocumentoID
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Doc.TipoInstrumento
			INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Doc.SucursalID
			INNER JOIN ALMACENES Alm ON Alm.SucursalID = Suc.SucursalID AND Alm.AlmacenID = Doc.AlmacenID
			WHERE Pre.FechaRegistro BETWEEN "',Par_FechaInicio,'" AND "', Par_FechaFin,'" ');

		IF( Par_SucursalID <> Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Suc.SucursalID = ',Par_SucursalID,' ');
		END IF;

		IF( Par_AlmacenID <> Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Alm.AlmacenID = ',Par_AlmacenID,' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		ORDER BY Suc.SucursalID, Alm.AlmacenID, Pre.FechaRegistro, Pre.Estatus, Doc.TipoInstrumento, Doc.NumeroInstrumento, Doc.DocumentoID;');

		SET @Sentencia    = (Var_Sentencia);
		PREPARE STMDOCUMENTOSGRDVALORESREP FROM @Sentencia;
		EXECUTE STMDOCUMENTOSGRDVALORESREP;
		DEALLOCATE PREPARE STMDOCUMENTOSGRDVALORESREP;

		UPDATE TEMP_PRESTAMODOCGRDVALORESREP Tmp, USUARIOS Usr SET
			Tmp.NombreUsuarioRegistroID = UPPER(IFNULL(Usr.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.UsuarioRegistroID = Usr.UsuarioID;

		UPDATE TEMP_PRESTAMODOCGRDVALORESREP Tmp, USUARIOS Usr SET
			Tmp.NombreUsuarioPrestamoID = UPPER(IFNULL(Usr.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.UsuarioPrestamoID = Usr.UsuarioID;

		UPDATE TEMP_PRESTAMODOCGRDVALORESREP Tmp, USUARIOS Usr SET
			Tmp.NombreUsuarioAutorizaID = UPPER(IFNULL(Usr.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.UsuarioAutorizaID = Usr.UsuarioID;

		UPDATE TEMP_PRESTAMODOCGRDVALORESREP Tmp, CLIENTES Cli SET
			Tmp.NombreParticipante = UPPER(IFNULL(Cli.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.ParticipanteID = Cli.ClienteID
		  AND Tmp.TipoPersona = Con_Cliente;

		UPDATE TEMP_PRESTAMODOCGRDVALORESREP Tmp, PROSPECTOS Pro SET
			Tmp.NombreParticipante = UPPER(IFNULL(Pro.NombreCompleto, Cadena_Vacia))
		WHERE Tmp.ParticipanteID = Pro.ProspectoID
		  AND Tmp.TipoPersona = Con_Prospecto;

		UPDATE TEMP_PRESTAMODOCGRDVALORESREP Tmp, TIPOSDOCUMENTOS Tip SET
			Tmp.NombreDocumento = UPPER(IFNULL(Tip.Descripcion, Cadena_Vacia))
		WHERE Tmp.TipoDocumentoID = Tip.TipoDocumentoID
		  AND Tmp.NombreDocumento = Cadena_Vacia;

		SELECT  DocumentoID, 	NombreParticipante, NombreInstrumento,	NumeroInstrumento,	NombreDocumento,
				NombreAlmacen,	Ubicacion,			FechaPrestamo,		HoraPrestamo,		NombreUsuarioRegistroID AS NombreUsuarioPresto,
				NombreUsuarioAutorizaID AS NombreUsuarioAutoriza,		NombreUsuarioPrestamoID  AS NombreUsuarioPrestamo,
				FechaDevolucion, Observaciones
		FROM TEMP_PRESTAMODOCGRDVALORESREP;
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
				END AS Var_NombreAlmacen;
	END IF;

END TerminaStore$$