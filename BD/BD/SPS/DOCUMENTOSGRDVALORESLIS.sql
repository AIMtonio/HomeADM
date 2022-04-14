-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCUMENTOSGRDVALORESLIS;

DELIMITER $$
CREATE PROCEDURE `DOCUMENTOSGRDVALORESLIS`(
	-- Store Procedure: De Lista los Documento de Guarda Valores
	-- Modulo Guarda Valores
	Par_DocumentoID				BIGINT(20),		-- ID de Tabla
	Par_NumeroExpedienteID		BIGINT(20),		-- ID de Tabla EXPEDIENTEGRDVALORES
	Par_TipoInstrumento			INT(11),		-- Tipo de Intrumento \n1.- Cliente \n2.- Cuenta Ahorro \n3.- CEDE \n 4.- INVERSION
												-- \n5.- Solicitud Credito \n6.- Credito \n7. Prospecto \n8.- Aportaciones
	Par_NumeroInstrumento		BIGINT(20),		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, CreditoID, SolicitudCreditoID, ProspectoID, AportacionID
	Par_SucursalID				INT(11),		-- ID de Sucursal

	Par_Estatus					CHAR(1),		-- Estatus del Documento
	Par_AlmacenID				INT(11),		-- ID de Tabla ALMACENES
	Par_CatMovimientoID			INT(11),		-- ID de Tabla CATMOVDOCGRDVALORES
	Par_NombreParticipante		VARCHAR(200),	-- Nombre del Titular del Documento
	Par_NumeroLista				TINYINT UNSIGNED,-- Numero de Lista

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
	DECLARE Tip_Cliente				CHAR(1);		-- Tipo Cliente
	DECLARE Tip_Prospecto			CHAR(1);		-- Tipo Prospecto
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Lista_Principal			TINYINT UNSIGNED;-- Lista Num. 1.- Lista Principal
	DECLARE Lista_Asignacion		TINYINT UNSIGNED;-- Lista Num. 2.- Lista Asignacion de Ubicacion
	DECLARE Lista_MovDocumento		TINYINT UNSIGNED;-- Lista Num. 3.- Lista Movimiento de Documentos

	-- Catalogo de Instrumentos
	DECLARE Inst_SolicitudCredito	INT(11);			-- Instrumento Solicitud de Credito
	DECLARE Inst_Credito			INT(11);			-- Instrumento Credito

	-- Asignacion  de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET Est_Registrado		:= 'R';
	SET Est_Custodia		:= 'C';
	SET Tip_Cliente			:= 'C';
	SET Tip_Prospecto		:= 'P';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Lista_Principal		:= 1;
	SET Lista_Asignacion	:= 2;
	SET Lista_MovDocumento	:= 3;

	-- Catalogo de Instrumentos
	SET Inst_SolicitudCredito	:= 5;
	SET Inst_Credito			:= 6;

	-- Lista Num. 1.- Lista Principal
	IF( Par_NumeroLista = Lista_Principal ) THEN

		(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, Exp.ParticipanteID, Exp.SucursalID,
				UPPER(Cli.NombreCompleto) AS NombreCompleto
		FROM DOCUMENTOSGRDVALORES Exp
		INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento
		INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
		WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
		  AND Exp.TipoPersona = Tip_Cliente)
		UNION
		(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, Exp.ParticipanteID, Exp.SucursalID,
				UPPER(Pro.NombreCompleto) AS NombreCompleto
		FROM DOCUMENTOSGRDVALORES Exp
		INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento
		INNER JOIN PROSPECTOS Pro ON Pro.ProspectoID = Exp.ParticipanteID
		WHERE Pro.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
		  AND Exp.TipoPersona = Tip_Prospecto)
		ORDER BY DocumentoID, NombreInstrumento, ParticipanteID
		LIMIT 0,15;

	END IF;

	-- Lista Num. 2.- Lista Asignacion de Ubicacion
	IF( Par_NumeroLista = Lista_Asignacion ) THEN

		IF(Par_TipoInstrumento = Inst_SolicitudCredito OR Par_TipoInstrumento = Inst_Credito) THEN
			(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, UPPER(Cli.NombreCompleto) AS NombreCompleto,
					Exp.NumeroInstrumento,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.ClasificaDesc
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
			  AND Exp.TipoPersona = Tip_Cliente
			  AND Exp.Estatus = Est_Registrado
			  AND Exp.SucursalID = Par_SucursalID)
			UNION
			(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, UPPER(Pro.NombreCompleto) AS NombreCompleto,
					Exp.NumeroInstrumento,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.ClasificaDesc
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN PROSPECTOS Pro ON Pro.ProspectoID = Exp.ParticipanteID
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Pro.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
			  AND Exp.TipoPersona = Tip_Prospecto
			  AND Exp.Estatus = Est_Registrado
			  AND Exp.SucursalID = Par_SucursalID)
			ORDER BY DocumentoID, NombreInstrumento, NombreCompleto
			LIMIT 0,15;

		ELSE

			(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, UPPER(Cli.NombreCompleto) AS NombreCompleto,
					Exp.NumeroInstrumento,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.Descripcion
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
			  AND Exp.TipoPersona = Tip_Cliente
			  AND Exp.Estatus = Est_Registrado
			  AND Exp.SucursalID = Par_SucursalID)
			UNION
			(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, UPPER(Pro.NombreCompleto) AS NombreCompleto,
					Exp.NumeroInstrumento,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.Descripcion
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN PROSPECTOS Pro ON Pro.ProspectoID = Exp.ParticipanteID
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Pro.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
			  AND Exp.TipoPersona = Tip_Prospecto
			  AND Exp.Estatus = Est_Registrado
			  AND Exp.SucursalID = Par_SucursalID)
			ORDER BY DocumentoID, NombreInstrumento, NombreCompleto
			LIMIT 0,15;
		END IF;

	END IF;

	-- Lista Num. 3.- Lista de Movimientos de Documentos
	IF( Par_NumeroLista = Lista_MovDocumento ) THEN

		IF(Par_TipoInstrumento = Inst_SolicitudCredito OR Par_TipoInstrumento = Inst_Credito) THEN

			(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, UPPER(Cli.NombreCompleto) AS NombreCompleto,
					Exp.NumeroInstrumento,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.ClasificaDesc
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN CATMOVDOCGRDVALORES Mov ON Mov.CatMovimientoID = Par_CatMovimientoID AND Exp.Estatus = Mov.EstatusRelacion
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
			  AND Exp.TipoPersona = Tip_Cliente
			  AND Exp.SucursalID = Par_SucursalID)
			UNION
			(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, UPPER(Pro.NombreCompleto) AS NombreCompleto,
					Exp.NumeroInstrumento,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.ClasificaDesc
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN CATMOVDOCGRDVALORES Mov ON Mov.CatMovimientoID = Par_CatMovimientoID AND Exp.Estatus = Mov.EstatusRelacion
			INNER JOIN PROSPECTOS Pro ON Pro.ProspectoID = Exp.ParticipanteID
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Pro.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
			  AND Exp.TipoPersona = Tip_Prospecto
			  AND Exp.SucursalID = Par_SucursalID)
			ORDER BY DocumentoID, NombreInstrumento, NombreCompleto
			LIMIT 0,15;
		ELSE
			(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, UPPER(Cli.NombreCompleto) AS NombreCompleto,
					Exp.NumeroInstrumento,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.Descripcion
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN CATMOVDOCGRDVALORES Mov ON Mov.CatMovimientoID = Par_CatMovimientoID AND Exp.Estatus = Mov.EstatusRelacion
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
			  AND Exp.TipoPersona = Tip_Cliente
			  AND Exp.SucursalID = Par_SucursalID)
			UNION
			(SELECT Exp.DocumentoID, Cat.NombreInstrumento AS NombreInstrumento, UPPER(Pro.NombreCompleto) AS NombreCompleto,
					Exp.NumeroInstrumento,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.Descripcion
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			INNER JOIN CATMOVDOCGRDVALORES Mov ON Mov.CatMovimientoID = Par_CatMovimientoID AND Exp.Estatus = Mov.EstatusRelacion
			INNER JOIN PROSPECTOS Pro ON Pro.ProspectoID = Exp.ParticipanteID
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Pro.NombreCompleto LIKE CONCAT('%',Par_NombreParticipante,'%')
			  AND Exp.TipoPersona = Tip_Prospecto
			  AND Exp.SucursalID = Par_SucursalID)
			ORDER BY DocumentoID, NombreInstrumento, NombreCompleto
			LIMIT 0,15;
		END IF;
	END IF;

END TerminaStore$$