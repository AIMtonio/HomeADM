-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXPEDIENTEGRDVALORESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS EXPEDIENTEGRDVALORESREP;

DELIMITER $$
CREATE PROCEDURE `EXPEDIENTEGRDVALORESREP`(
	-- Store Procedure: De Reporte del Expediente del Participante de Guarda Valores
	-- Modulo Guarda Valores
	Par_ExpedienteID			BIGINT(20),			-- ID de tabla DOCUMENTOSGRDVALORES
	Par_SucursalID 				INT(11),			-- Sucursal ID
	Par_TipoPersona 			CHAR(1),			-- Tipo de Persona
	Par_NumeroReporte			TINYINT UNSIGNED,	-- Numero de Reporte

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
	DECLARE Var_NombreCompleto	VARCHAR(200);		-- Nombre de Almacen

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Con_Prospecto 			CHAR(1);			-- Constante de Prospecto
	DECLARE Con_Cliente				CHAR(1);			-- Constante de Cliente

	DECLARE	Entero_Cero				INT(11);			-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);		-- Constante de Decimal Cero
	DECLARE Rep_Expediente			TINYINT UNSIGNED;	-- Numero de Reporte Excel
	DECLARE Parametros				TINYINT UNSIGNED;	-- Parametros del Reporte

	-- Catalogo de Instrumentos
	DECLARE Inst_SolicitudCredito	INT(11);			-- Instrumento Solicitud de Credito
	DECLARE Inst_Credito			INT(11);			-- Instrumento Credito

	-- Asignacion  de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET Con_Prospecto 		:= 'P';
	SET Con_Cliente			:= 'C';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Rep_Expediente		:= 1;
	SET Parametros			:= 2;

	-- Catalogo de Instrumentos
	SET Inst_SolicitudCredito	:= 5;
	SET Inst_Credito			:= 6;

	DROP TABLE IF EXISTS TMP_EXPEDIENTEGRDVALORESREP;
	CREATE TEMPORARY TABLE TMP_EXPEDIENTEGRDVALORESREP(
		DocumentoID 		BIGINT(20),
		NombreInstrumento 	VARCHAR(100),
		NumeroInstrumento 	BIGINT(20),
		NombreOrigen 	  	VARCHAR(100),
		GrupoDocumentoID 	VARCHAR(100),
		NombreDocumento   	VARCHAR(200),
		NombreSucursal 	  	VARCHAR(200),
		AlmacenID 		  	INT(11),
		NombreAlmacen     	VARCHAR(200),
		FechaRegistro 	  	VARCHAR(25),
		Estatus 		  	VARCHAR(25),
		TipoInstrumento 	INT(11),
		GrupoDocumento 		INT(11),
		KEY `IDX_TMP_EXPEDIENTEGRDVALORESREP_1` (`AlmacenID`),
		KEY `IDX_TMP_EXPEDIENTEGRDVALORESREP_2` (`TipoInstrumento`),
		KEY `IDX_TMP_EXPEDIENTEGRDVALORESREP_3` (`GrupoDocumento`));


	IF( Par_NumeroReporte = Rep_Expediente ) THEN

		SET Var_Sentencia := CONCAT('
			INSERT INTO TMP_EXPEDIENTEGRDVALORESREP(
					DocumentoID,		NombreInstrumento,		NumeroInstrumento,		NombreOrigen,
					GrupoDocumentoID,	NombreDocumento,		NombreSucursal,			AlmacenID,
					NombreAlmacen,		FechaRegistro,			Estatus,				TipoInstrumento,
					GrupoDocumento)
			SELECT	Doc.DocumentoID,	Cat.NombreInstrumento,	Doc.NumeroInstrumento,	Ori.NombreOrigen,
				CASE WHEN Doc.GrupoDocumentoID =  0 AND Doc.TipoDocumentoID =  0 THEN "NO APLICA"
					 WHEN Doc.GrupoDocumentoID =  0 AND Doc.TipoDocumentoID <> 0 THEN "DIGITALIZACION"
					 WHEN Doc.GrupoDocumentoID <> 0 AND Doc.TipoDocumentoID <> 0 THEN Gpo.Descripcion
					 ELSE "NO APLICA"
				END AS GrupoDocumentoID,
				CASE WHEN Doc.TipoDocumentoID =  0 THEN Doc.NombreDocumento
					 WHEN Doc.TipoDocumentoID <> 0 THEN Tip.Descripcion
				END AS NombreDocumento,
				Suc.NombreSucurs AS NombreSucursal,		Doc.AlmacenID,	"" AS NombreAlmacen,
				CONCAT(Doc.FechaRegistro, " " ,Doc.HoraRegistro) AS FechaRegistro,
				CASE WHEN Doc.Estatus = "R" THEN "REGISTRADO"
					 WHEN Doc.Estatus = "C" THEN "EN ALMACÉN"
					 WHEN Doc.Estatus = "P" THEN "PRÉSTAMO"
					 WHEN Doc.Estatus = "B" THEN "BAJA"
					 ELSE "INDEFINIDO"
				END AS Estatus,	Doc.TipoInstrumento,	Doc.GrupoDocumentoID
			FROM DOCUMENTOSGRDVALORES Doc
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Doc.TipoInstrumento
			INNER JOIN CATORIGENESDOCUMENTOS Ori ON Ori.CatOrigenDocumentoID = Doc.OrigenDocumento
			INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Doc.SucursalID
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Doc.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Doc.TipoDocumentoID');

		SET Var_Sentencia := CONCAT(Var_Sentencia, '
			WHERE Doc.ParticipanteID = ',Par_ExpedienteID);

		SET Var_Sentencia := CONCAT(Var_Sentencia, '
			  AND Doc.TipoPersona = "',Par_TipoPersona,'"');

		IF( Par_SucursalID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, '
			  AND Doc.SucursalID = ', Par_SucursalID);
		END IF;
		SET Var_Sentencia := CONCAT(Var_Sentencia, '
			ORDER BY Doc.TipoInstrumento, Doc.OrigenDocumento, Doc.SucursalID, Doc.AlmacenID;');

		SET @Sentencia    = (Var_Sentencia);
		PREPARE STMEXPEDIENTEGRDVALORESREP FROM @Sentencia;
		EXECUTE STMEXPEDIENTEGRDVALORESREP;
		DEALLOCATE PREPARE STMEXPEDIENTEGRDVALORESREP;

		UPDATE TMP_EXPEDIENTEGRDVALORESREP Tmp, CLASIFICATIPDOC Cla SET
			Tmp.GrupoDocumentoID = Cla.ClasificaDesc
		WHERE Tmp.TipoInstrumento IN (Inst_SolicitudCredito,Inst_Credito)
		  AND Tmp.GrupoDocumento = Cla.ClasificaTipDocID;

		UPDATE TMP_EXPEDIENTEGRDVALORESREP Tmp, ALMACENES Alm SET
			Tmp.NombreAlmacen = Alm.NombreAlmacen
		WHERE Tmp.AlmacenID = Alm.AlmacenID;

		SELECT	DocumentoID,		NombreInstrumento,		NumeroInstrumento,		NombreOrigen,
				GrupoDocumentoID,	NombreDocumento,		NombreSucursal,			NombreAlmacen,
				FechaRegistro,		Estatus
		FROM TMP_EXPEDIENTEGRDVALORESREP;
	END IF;

	-- Parametros del Reporte
	IF( Par_NumeroReporte = Parametros ) THEN

		IF( Par_TipoPersona = Con_Cliente ) THEN
			SELECT NombreCompleto
			INTO Var_NombreCompleto
			FROM CLIENTES
			WHERE ClienteID = Par_ExpedienteID;
		END IF;

		IF( Par_TipoPersona = Con_Prospecto ) THEN
			SELECT NombreCompleto
			INTO Var_NombreCompleto
			FROM PROSPECTOS
			WHERE ProspectoID = Par_ExpedienteID;
		END IF;

		SELECT	NombreSucurs
		INTO	Var_NombreSucursal
		FROM SUCURSALES WHERE SucursalID = Par_SucursalID;


		SET Var_NombreSucursal := IFNULL(Var_NombreSucursal, Cadena_Vacia);
		SET Var_NombreCompleto := IFNULL(Var_NombreCompleto, Cadena_Vacia);

		SELECT	CASE WHEN Par_SucursalID = Entero_Cero THEN "TODAS"
					 WHEN Par_SucursalID <> Entero_Cero THEN CONCAT(Par_SucursalID,' - ',Var_NombreSucursal)
				END AS Var_NombreSucursal,
				Var_NombreCompleto;
	END IF;

	DROP TABLE IF EXISTS TMP_EXPEDIENTEGRDVALORESREP;
END TerminaStore$$