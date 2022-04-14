-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXPEDIENTEGRDVALORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS EXPEDIENTEGRDVALORESLIS;

DELIMITER $$
CREATE PROCEDURE `EXPEDIENTEGRDVALORESLIS`(
	-- Store Procedure: De Lista los Expediente de Guarda Valores
	-- Modulo Guarda Valores
	Par_NumeroExpedienteID		BIGINT(20),		-- ID de Tabla
	Par_TipoInstrumento			INT(11),		-- Tipo de Intrumento \n1.- Cliente \n2.- Cuenta Ahorro \n3.- CEDE \n 4.- INVERSION
												-- \n5.- Solicitud Credito \n6.- Credito \n7. Prospecto \n8.- Aportaciones
	Par_NumeroInstrumento		BIGINT(20),		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, CreditoID, SolicitudCreditoID, ProspectoID, AportacionID
	Par_SucursalID				INT(11),		-- ID de Sucursal
	Par_UsuarioAdministrador 	INT(11),		-- 0.- Usuario Sucursal 1 Usuario Admin

	Par_NombreInstrumento		VARCHAR(200),	-- Nombre del Titular del Expediente
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
	DECLARE Est_Activo				CHAR(1);		-- Estatus Activo
	DECLARE Tip_Cliente				CHAR(1);		-- Tipo Cliente
	DECLARE Tip_Prospecto			CHAR(1);		-- Tipo Prospecto
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE UsuarioAdmin 			INT(11);		-- Constante Usuario Administrador

	-- Catalogo de Instrumentos
	DECLARE Inst_Cliente			INT(11);			-- Instrumento cliente
	DECLARE Inst_SolicitudCredito	INT(11);			-- Instrumento Solicitud de Credito
	DECLARE Inst_Credito			INT(11);			-- Instrumento Credito
	DECLARE Inst_Prospecto			INT(11);			-- Instrumento Prospecto

	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Lista_Principal			TINYINT UNSIGNED;-- Lista Num. 1.- Lista Principal
	DECLARE Lista_Foranea			TINYINT UNSIGNED;-- Lista Num. 2.- Lista de Ayuda de Expediente
	DECLARE Lista_Registro			TINYINT UNSIGNED;-- Lista Num. 3.- Lista de Ayuda de Expediente
	DECLARE Lista_Expediente		TINYINT UNSIGNED;-- Lista Num. 4.- Lista de Expediente por Instrumento

	-- Asignacion  de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET	Cadena_Vacia			:= '';
	SET Est_Activo				:= 'A';
	SET Tip_Cliente				:= 'C';
	SET Tip_Prospecto			:= 'P';
	SET	Entero_Cero				:= 0;
	SET	Decimal_Cero			:= 0.0;
	SET Lista_Principal			:= 1;
	SET Lista_Foranea			:= 2;
	SET Lista_Registro 			:= 3; -- Aun no utilizada
	SET Lista_Expediente		:= 4;
	SET UsuarioAdmin			:= 1;

	-- Catalogo de Instrumentos
	SET Inst_Cliente			:= 1;
	SET Inst_SolicitudCredito	:= 5;
	SET Inst_Credito			:= 6;
	SET Inst_Prospecto			:= 7;

	-- Lista Num. 1.- Lista Principal
	IF( Par_NumeroLista = Lista_Principal ) THEN

		IF(Par_UsuarioAdministrador <> UsuarioAdmin) THEN
			(SELECT Exp.NumeroExpedienteID, Cat.NombreInstrumento AS NombreInstrumento, Exp.NumeroInstrumento AS NumeroInstrumento, Exp.SucursalID,
					UPPER(Cli.NombreCompleto) AS NombreCompleto
			FROM EXPEDIENTEGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
			WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_NombreInstrumento,'%')
			  AND Exp.SucursalID = Par_SucursalID)
			UNION
			(SELECT Exp.NumeroExpedienteID, Cat.NombreInstrumento AS NombreInstrumento, Exp.NumeroInstrumento AS NumeroInstrumento, Exp.SucursalID,
					Pro.NombreCompleto AS NombreCompleto
			FROM EXPEDIENTEGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento
			INNER JOIN PROSPECTOS Pro ON Pro.ProspectoID = Exp.ParticipanteID
			WHERE Pro.NombreCompleto LIKE CONCAT('%',Par_NombreInstrumento,'%')
			  AND Exp.SucursalID = Par_SucursalID)
			ORDER BY NumeroExpedienteID, NombreInstrumento,NumeroInstrumento
			LIMIT 0,15;
		ELSE
			(SELECT Exp.NumeroExpedienteID, Cat.NombreInstrumento AS NombreInstrumento, Exp.NumeroInstrumento AS NumeroInstrumento, Exp.SucursalID,
					UPPER(Cli.NombreCompleto) AS NombreCompleto
			FROM EXPEDIENTEGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
			WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_NombreInstrumento,'%'))
			UNION
			(SELECT Exp.NumeroExpedienteID, Cat.NombreInstrumento AS NombreInstrumento, Exp.NumeroInstrumento AS NumeroInstrumento, Exp.SucursalID,
					Pro.NombreCompleto AS NombreCompleto
			FROM EXPEDIENTEGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento
			INNER JOIN PROSPECTOS Pro ON Pro.ProspectoID = Exp.ParticipanteID
			WHERE Pro.NombreCompleto LIKE CONCAT('%',Par_NombreInstrumento,'%'))
			ORDER BY NumeroExpedienteID, NombreInstrumento,NumeroInstrumento
			LIMIT 0,15;

		END IF;
	END IF;

	-- Lista Num. 2.- Lista de Ayuda de Expediente por Instrumento
	IF( Par_NumeroLista = Lista_Foranea ) THEN

		IF(Par_UsuarioAdministrador <> UsuarioAdmin) THEN

			IF( Par_TipoInstrumento = Inst_Cliente) THEN

				SELECT 	Exp.ParticipanteID AS NumeroInstrumento, UPPER(MAX(Cli.NombreCompleto)) AS NombreCompleto,
						'CLIENTE' AS TipoPersona, Entero_Cero AS NumeroExpedienteID
				FROM EXPEDIENTEGRDVALORES Exp
				INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
				WHERE Cli.NombreCompleto LIKE CONCAT('%', Par_NombreInstrumento ,'%')
				  AND Exp.TipoPersona = Tip_Cliente
				  AND Exp.SucursalID = Par_SucursalID
				GROUP BY Exp.ParticipanteID
				LIMIT 0,15;

			END IF;

			IF( Par_TipoInstrumento = Inst_Prospecto) THEN

				SELECT 	Exp.ParticipanteID AS NumeroInstrumento, UPPER(MAX(Cli.NombreCompleto)) AS NombreCompleto,
						'PROSPECTOS' AS TipoPersona, Entero_Cero AS NumeroExpedienteID
				FROM EXPEDIENTEGRDVALORES Exp
				INNER JOIN PROSPECTOS Cli ON Cli.ProspectoID = Exp.ParticipanteID
				WHERE Cli.NombreCompleto LIKE CONCAT('%', Par_NombreInstrumento ,'%')
				  AND Exp.TipoPersona = Tip_Prospecto
				  AND Exp.SucursalID = Par_SucursalID
				GROUP BY Exp.ParticipanteID
				LIMIT 0,15;
			END IF;

		ELSE

			IF( Par_TipoInstrumento = Inst_Cliente) THEN

				SELECT 	Exp.ParticipanteID AS NumeroInstrumento, UPPER(MAX(Cli.NombreCompleto)) AS NombreCompleto,
						'CLIENTE' AS TipoPersona, Entero_Cero AS NumeroExpedienteID
				FROM EXPEDIENTEGRDVALORES Exp
				INNER JOIN CLIENTES Cli ON Cli.ClienteID = Exp.ParticipanteID
				WHERE Cli.NombreCompleto LIKE CONCAT('%', Par_NombreInstrumento ,'%')
				  AND Exp.TipoPersona = Tip_Cliente
				GROUP BY Exp.ParticipanteID
				LIMIT 0,15;

			END IF;

			IF( Par_TipoInstrumento = Inst_Prospecto) THEN

				SELECT 	Exp.ParticipanteID AS NumeroInstrumento, UPPER(MAX(Cli.NombreCompleto)) AS NombreCompleto,
						'PROSPECTOS' AS TipoPersona, Entero_Cero AS NumeroExpedienteID
				FROM EXPEDIENTEGRDVALORES Exp
				INNER JOIN PROSPECTOS Cli ON Cli.ProspectoID = Exp.ParticipanteID
				WHERE Cli.NombreCompleto LIKE CONCAT('%', Par_NombreInstrumento ,'%')
				  AND Exp.TipoPersona = Tip_Prospecto
				GROUP BY Exp.ParticipanteID
				LIMIT 0,15;
			END IF;
		END IF;
	END IF;

	-- Lista Num. 3..- Lista de Expediente por Instrumento
	IF( Par_NumeroLista = Lista_Registro ) THEN

		IF(Par_UsuarioAdministrador <> UsuarioAdmin) THEN
			(SELECT Exp.DocumentoID, 	Exp.TipoInstrumento,	Exp.ParticipanteID AS NumeroInstrumento, Exp.TipoDocumentoID,
					CASE WHEN Exp.TipoDocumentoID =  0 THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> 0 THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Exp.Estatus = "R" THEN "REGISTRADO"
						 WHEN Exp.Estatus = "C" THEN "EN ALMACEN"
						 WHEN Exp.Estatus = "P" THEN "PRESTAMO"
						 WHEN Exp.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus,
					CONCAT(Exp.Ubicacion, " " , Exp.Seccion) AS Ubicacion
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Exp.SucursalID = Par_SucursalID
			  AND Exp.ParticipanteID = Par_NumeroInstrumento
			  AND Exp.TipoPersona = Par_NombreInstrumento
			  AND Exp.TipoInstrumento NOT IN (Inst_SolicitudCredito,Inst_Credito))
			UNION
			(SELECT Exp.DocumentoID, 	Exp.TipoInstrumento,	Exp.ParticipanteID AS NumeroInstrumento, Exp.TipoDocumentoID,
					CASE WHEN Exp.TipoDocumentoID =  0 THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> 0 THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Exp.Estatus = "R" THEN "REGISTRADO"
						 WHEN Exp.Estatus = "C" THEN "EN ALMACEN"
						 WHEN Exp.Estatus = "P" THEN "PRESTAMO"
						 WHEN Exp.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus,
					CONCAT(Exp.Ubicacion, " " , Exp.Seccion) AS Ubicacion
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Exp.SucursalID = Par_SucursalID
			  AND Exp.ParticipanteID = Par_NumeroInstrumento
			  AND Exp.TipoPersona = Par_NombreInstrumento
			  AND Exp.TipoInstrumento IN (Inst_SolicitudCredito,Inst_Credito));

		ELSE

			(SELECT Exp.DocumentoID, 	Exp.TipoInstrumento,	Exp.ParticipanteID AS NumeroInstrumento, Exp.TipoDocumentoID,
					CASE WHEN Exp.TipoDocumentoID =  0 THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> 0 THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Exp.Estatus = "R" THEN "REGISTRADO"
						 WHEN Exp.Estatus = "C" THEN "EN ALMACEN"
						 WHEN Exp.Estatus = "P" THEN "PRESTAMO"
						 WHEN Exp.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus,
					CONCAT(Exp.Ubicacion, " " , Exp.Seccion) AS Ubicacion
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Exp.ParticipanteID = Par_NumeroInstrumento
			  AND Exp.TipoPersona = Par_NombreInstrumento
			  AND Exp.TipoInstrumento NOT IN (Inst_SolicitudCredito,Inst_Credito))
			UNION
			(SELECT Exp.DocumentoID, 	Exp.TipoInstrumento,	Exp.ParticipanteID AS NumeroInstrumento, Exp.TipoDocumentoID,
					CASE WHEN Exp.TipoDocumentoID =  0 THEN Exp.NombreDocumento
						 WHEN Exp.TipoDocumentoID <> 0 THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Exp.Estatus = "R" THEN "REGISTRADO"
						 WHEN Exp.Estatus = "C" THEN "EN ALMACEN"
						 WHEN Exp.Estatus = "P" THEN "PRESTAMO"
						 WHEN Exp.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus,
					CONCAT(Exp.Ubicacion, " " , Exp.Seccion) AS Ubicacion
			FROM DOCUMENTOSGRDVALORES Exp
			INNER JOIN CATINSTGRDVALORES Cat ON Cat.CatInsGrdValoresID = Exp.TipoInstrumento AND Exp.TipoInstrumento = Par_TipoInstrumento
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Exp.ParticipanteID = Par_NumeroInstrumento
			  AND Exp.TipoPersona = Par_NombreInstrumento
			  AND Exp.TipoInstrumento IN (Inst_SolicitudCredito,Inst_Credito));
		END IF;
	END IF;

	-- Lista Num. 4..- Lista de Registro de Expediente por Instrumento
	IF( Par_NumeroLista = Lista_Expediente ) THEN

		IF(Par_UsuarioAdministrador <> UsuarioAdmin) THEN
			(SELECT 	Exp.DocumentoID, Cat.NombreOrigen AS NombreInstrumento,
					Exp.TipoDocumentoID,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.Descripcion
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
					 	 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Exp.Estatus = "R" THEN "REGISTRADO"
						 WHEN Exp.Estatus = "C" THEN "EN ALMACEN"
						 WHEN Exp.Estatus = "P" THEN "PRESTAMO"
						 WHEN Exp.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus
			FROM EXPEDIENTEGRDVALORES Doc
			INNER JOIN DOCUMENTOSGRDVALORES Exp ON Exp.NumeroExpedienteID = Doc.NumeroExpedienteID
			INNER JOIN CATORIGENESDOCUMENTOS Cat ON Cat.CatOrigenDocumentoID = Exp.OrigenDocumento
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Exp.NumeroExpedienteID = Par_NumeroExpedienteID
			  AND Doc.TipoInstrumento = Par_TipoInstrumento
			  AND Exp.SucursalID = Par_SucursalID
			  AND Exp.TipoInstrumento NOT IN (Inst_SolicitudCredito,Inst_Credito))
			UNION
			(SELECT 	Exp.DocumentoID, Cat.NombreOrigen AS NombreInstrumento,
					Exp.TipoDocumentoID,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.ClasificaDesc
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
					 	 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Exp.Estatus = "R" THEN "REGISTRADO"
						 WHEN Exp.Estatus = "C" THEN "EN ALMACEN"
						 WHEN Exp.Estatus = "P" THEN "PRESTAMO"
						 WHEN Exp.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus
			FROM EXPEDIENTEGRDVALORES Doc
			INNER JOIN DOCUMENTOSGRDVALORES Exp ON Exp.NumeroExpedienteID = Doc.NumeroExpedienteID
			INNER JOIN CATORIGENESDOCUMENTOS Cat ON Cat.CatOrigenDocumentoID = Exp.OrigenDocumento
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Exp.NumeroExpedienteID = Par_NumeroExpedienteID
			  AND Doc.TipoInstrumento = Par_TipoInstrumento
			  AND Exp.SucursalID = Par_SucursalID
			  AND Exp.TipoInstrumento IN (Inst_SolicitudCredito,Inst_Credito));

		ELSE

			(SELECT Exp.DocumentoID, Cat.NombreOrigen AS NombreInstrumento,
					Exp.TipoDocumentoID,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.Descripcion
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
					 	 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Exp.Estatus = "R" THEN "REGISTRADO"
						 WHEN Exp.Estatus = "C" THEN "EN ALMACEN"
						 WHEN Exp.Estatus = "P" THEN "PRESTAMO"
						 WHEN Exp.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus
			FROM EXPEDIENTEGRDVALORES Doc
			INNER JOIN DOCUMENTOSGRDVALORES Exp ON Exp.NumeroExpedienteID = Doc.NumeroExpedienteID
			INNER JOIN CATORIGENESDOCUMENTOS Cat ON Cat.CatOrigenDocumentoID = Exp.OrigenDocumento
			LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Exp.NumeroExpedienteID = Par_NumeroExpedienteID
			  AND Doc.TipoInstrumento = Par_TipoInstrumento
			  AND Exp.TipoInstrumento NOT IN (Inst_SolicitudCredito,Inst_Credito))
			UNION
			(SELECT 	Exp.DocumentoID, Cat.NombreOrigen AS NombreInstrumento,
					Exp.TipoDocumentoID,
					CASE WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID =  Entero_Cero THEN 'NO APLICA'
						 WHEN Exp.GrupoDocumentoID =  Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN 'DIGITALIZACION'
						 WHEN Exp.GrupoDocumentoID <> Entero_Cero AND Exp.TipoDocumentoID <> Entero_Cero THEN Gpo.ClasificaDesc
						 ELSE 'NO APLICA'
					END AS GrupoDocumento,
					CASE WHEN Exp.TipoDocumentoID =  Entero_Cero THEN Exp.NombreDocumento
					 	 WHEN Exp.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
					END AS NombreDocumento,
					CASE WHEN Exp.Estatus = "R" THEN "REGISTRADO"
						 WHEN Exp.Estatus = "C" THEN "EN ALMACEN"
						 WHEN Exp.Estatus = "P" THEN "PRESTAMO"
						 WHEN Exp.Estatus = "B" THEN "BAJA"
						 ELSE "INDEFINIDO"
					END AS Estatus
			FROM EXPEDIENTEGRDVALORES Doc
			INNER JOIN DOCUMENTOSGRDVALORES Exp ON Exp.NumeroExpedienteID = Doc.NumeroExpedienteID
			INNER JOIN CATORIGENESDOCUMENTOS Cat ON Cat.CatOrigenDocumentoID = Exp.OrigenDocumento
			LEFT JOIN CLASIFICATIPDOC Gpo ON Gpo.ClasificaTipDocID = Exp.GrupoDocumentoID
			LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Exp.TipoDocumentoID
			WHERE Exp.NumeroExpedienteID = Par_NumeroExpedienteID
			  AND Doc.TipoInstrumento = Par_TipoInstrumento
			  AND Exp.TipoInstrumento IN (Inst_SolicitudCredito,Inst_Credito));
		END IF;
	END IF;

END TerminaStore$$