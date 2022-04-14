-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCUMENTOSGRDVALORESCON;

DELIMITER $$
CREATE PROCEDURE `DOCUMENTOSGRDVALORESCON`(
	-- Store Procedure: De Consulta los Documentos de Guarda Valores
	-- Modulo Guarda Valores
	Par_DocumentoID				BIGINT(20),		-- ID de tabla
	Par_NumeroExpedienteID		BIGINT(20),		-- ID de Tabla EXPEDIENTEGRDVALORES
	Par_TipoInstrumento			INT(11),		-- Tipo de Intrumento \n1.- Cliente \n2.- Cuenta Ahorro \n3.- CEDE \n 4.- INVERSION
												-- \n5.- Solicitud Credito \n6.- Credito \n7. Prospecto \n8.- Aportaciones
	Par_NumeroInstrumento		BIGINT(20),		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, CreditoID, SolicitudCreditoID, ProspectoID, AportacionID
	Par_SucursalID				INT(11),		-- ID de Sucursal

	Par_Estatus					CHAR(1),		-- Estatus del Documento
	Par_AlmacenID				INT(11),		-- ID de Tabla ALMACENES
	Par_CatMovimientoID			INT(11),		-- ID de Tabla CATMOVDOCGRDVALORES
	Par_NumeroConsulta			TINYINT UNSIGNED,-- Numero de Consulta

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE Est_Registrado			CHAR(1);		-- Estatus Registrado
	DECLARE Est_Custodia			CHAR(1);		-- Estatus Custodia
	DECLARE Est_Prestamo 			CHAR(1);		-- Estatus Prestamo
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Consulta_Principal		TINYINT UNSIGNED;-- Consulta Num. 1.- Consulta Principal
	DECLARE Consulta_Asignacion		TINYINT UNSIGNED;-- Consulta Num. 2.- Consulta Asignacion de Ubicacion
	DECLARE Consulta_MovDocumento	TINYINT UNSIGNED;-- Consulta Num. 3.- Consulta Movimientos de Documentos

	-- Catalogo de Instrumentos
	DECLARE Inst_SolicitudCredito	INT(11);			-- Instrumento Solicitud de Credito
	DECLARE Inst_Credito			INT(11);			-- Instrumento Credito

	-- Asignacion  de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET Est_Registrado		:= 'R';
	SET Est_Custodia		:= 'C';
	SET Est_Prestamo		:= 'P';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Consulta_Principal	:= 1;
	SET Consulta_Asignacion	:= 2;
	SET Consulta_MovDocumento := 3;

	-- Catalogo de Instrumentos
	SET Inst_SolicitudCredito	:= 5;
	SET Inst_Credito			:= 6;


	-- Consulta Num. 1.- Consulta Principal
	IF( Par_NumeroConsulta = Consulta_Principal ) THEN

		SELECT 	DocumentoID,		NumeroExpedienteID,	  TipoInstrumento,	 NumeroInstrumento,	OrigenDocumento,
				GrupoDocumentoID,	TipoDocumentoID,	  NombreDocumento,	 ParticipanteID,	TipoPersona,
				AlmacenID,			Ubicacion,			  Seccion,			 Observaciones,		Estatus,
				UsuarioRegistroID,	UsuarioProcesaID,	  SucursalID,		 FechaRegistro,		HoraRegistro,
				FechaCustodia,		UsuarioBajaID,		  SucursalBajaID,	 FechaBaja,			PrestamoDocGrdValoresID,
				DocSustitucionID,	NombreDocSustitucion
		FROM DOCUMENTOSGRDVALORES
		WHERE DocumentoID = Par_DocumentoID;

	END IF;

	-- Consulta Num. 2.- Consulta Asignacion de Ubicacion
	IF( Par_NumeroConsulta = Consulta_Asignacion ) THEN

		IF(Par_TipoInstrumento = Inst_SolicitudCredito OR Par_TipoInstrumento = Inst_Credito) THEN
			SELECT 	Doc.DocumentoID,		Doc.FechaRegistro,		Doc.ParticipanteID,		Doc.NumeroInstrumento,	Doc.TipoInstrumento,
					Cat.NombreOrigen AS OrigenDocumento,
					CASE WHEN Doc.GrupoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Doc.GrupoDocumentoID <> Entero_Cero THEN Gpo.ClasificaDesc
					END AS GrupoDocumento,
					CASE WHEN Doc.TipoDocumentoID =  Entero_Cero THEN Doc.NombreDocumento
						 WHEN Doc.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento,
					'REGISTRADO' AS Estatus,			Doc.SucursalID,						Doc.TipoPersona,		Doc.PrestamoDocGrdValoresID
			FROM DOCUMENTOSGRDVALORES Doc
			INNER JOIN CATORIGENESDOCUMENTOS Cat ON Cat.CatOrigenDocumentoID = Doc.OrigenDocumento AND Doc.TipoInstrumento = Par_TipoInstrumento
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Doc.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Doc.TipoDocumentoID
			WHERE Doc.DocumentoID = Par_DocumentoID
			  AND Doc.Estatus = Est_Registrado
			  AND Doc.SucursalID = Par_SucursalID;
		ELSE
			SELECT 	Doc.DocumentoID,		Doc.FechaRegistro,		Doc.ParticipanteID,		Doc.NumeroInstrumento,	Doc.TipoInstrumento,
					Cat.NombreOrigen AS OrigenDocumento,
					CASE WHEN Doc.GrupoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Doc.GrupoDocumentoID <> Entero_Cero THEN Gpo.Descripcion
					END AS GrupoDocumento,
					CASE WHEN Doc.TipoDocumentoID =  Entero_Cero THEN Doc.NombreDocumento
						 WHEN Doc.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento,
					'REGISTRADO' AS Estatus,			Doc.SucursalID,						Doc.TipoPersona,		Doc.PrestamoDocGrdValoresID
			FROM DOCUMENTOSGRDVALORES Doc
			INNER JOIN CATORIGENESDOCUMENTOS Cat ON Cat.CatOrigenDocumentoID = Doc.OrigenDocumento AND Doc.TipoInstrumento = Par_TipoInstrumento
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Doc.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Doc.TipoDocumentoID
			WHERE Doc.DocumentoID = Par_DocumentoID
			  AND Doc.Estatus = Est_Registrado
			  AND Doc.SucursalID = Par_SucursalID;
		END IF;
	END IF;

	-- Consulta Num. 3.- Consulta Movimiento de Documentos
	IF( Par_NumeroConsulta = Consulta_MovDocumento ) THEN

		IF(Par_TipoInstrumento = Inst_SolicitudCredito OR Par_TipoInstrumento = Inst_Credito) THEN
			SELECT 	Doc.DocumentoID,		Doc.FechaRegistro,		Doc.ParticipanteID,		Doc.NumeroInstrumento,	Doc.TipoInstrumento,
					Cat.NombreOrigen AS OrigenDocumento,
					CASE WHEN Doc.GrupoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Doc.GrupoDocumentoID <> Entero_Cero THEN Gpo.ClasificaDesc
					END AS GrupoDocumento,
					CASE WHEN Doc.TipoDocumentoID =  Entero_Cero THEN Doc.NombreDocumento
						 WHEN Doc.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Mov.EstatusRelacion = Est_Custodia THEN 'CUSTODIA'
						 WHEN Mov.EstatusRelacion = Est_Prestamo THEN 'PRESTAMO'
						 ELSE 'INDEFINIDO'
					END AS Estatus,			Doc.SucursalID,			Doc.TipoPersona,		Doc.PrestamoDocGrdValoresID
			FROM DOCUMENTOSGRDVALORES Doc
			INNER JOIN CATORIGENESDOCUMENTOS Cat ON Cat.CatOrigenDocumentoID = Doc.OrigenDocumento AND Doc.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN CATMOVDOCGRDVALORES Mov ON Mov.CatMovimientoID = Par_CatMovimientoID AND Doc.Estatus = Mov.EstatusRelacion
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Doc.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Doc.TipoDocumentoID
			WHERE Doc.DocumentoID = Par_DocumentoID
			  AND Doc.SucursalID = Par_SucursalID;
		ELSE
			SELECT 	Doc.DocumentoID,		Doc.FechaRegistro,		Doc.ParticipanteID,		Doc.NumeroInstrumento,	Doc.TipoInstrumento,
					Cat.NombreOrigen AS OrigenDocumento,
					CASE WHEN Doc.GrupoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Doc.GrupoDocumentoID <> Entero_Cero THEN Gpo.Descripcion
					END AS GrupoDocumento,
					CASE WHEN Doc.TipoDocumentoID =  Entero_Cero THEN Doc.NombreDocumento
						 WHEN Doc.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Mov.EstatusRelacion = Est_Custodia THEN 'CUSTODIA'
						 WHEN Mov.EstatusRelacion = Est_Prestamo THEN 'PRESTAMO'
						 ELSE 'INDEFINIDO'
					END AS Estatus,			Doc.SucursalID,			Doc.TipoPersona,		Doc.PrestamoDocGrdValoresID
			FROM DOCUMENTOSGRDVALORES Doc
			INNER JOIN CATORIGENESDOCUMENTOS Cat ON Cat.CatOrigenDocumentoID = Doc.OrigenDocumento AND Doc.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN CATMOVDOCGRDVALORES Mov ON Mov.CatMovimientoID = Par_CatMovimientoID AND Doc.Estatus = Mov.EstatusRelacion
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Doc.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Doc.TipoDocumentoID
			WHERE Doc.DocumentoID = Par_DocumentoID
			  AND Doc.SucursalID = Par_SucursalID;
		END IF;
	END IF;

END TerminaStore$$