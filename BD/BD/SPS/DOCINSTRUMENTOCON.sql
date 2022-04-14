-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCINSTRUMENTOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCINSTRUMENTOCON;

DELIMITER $$
CREATE PROCEDURE `DOCINSTRUMENTOCON`(
	-- Store Procedure: Que Consulta Los Instrumentos por grupo de documento y tipo de documento
	-- Modulo Guarda Valores
	Par_OrigenDocumentoID 		INT(11),			-- Origen del Documento
	Par_GrupoDocumentoID		INT(11),			-- ID de Grupo de Documento
	Par_TipoDocumentoID			INT(11),			-- ID de Documento
	Par_TipoInstrumento			BIGINT(20),			-- ID de Tipo de Instrumento
	Par_NumeroInstrumento 		BIGINT(20),			-- ID de Instrumento

	Par_ArchivoID  				BIGINT(20),			-- ID de Archivo
	Par_NombreDocumento			VARCHAR(50),		-- Nombre del Instrumentos
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Lista

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

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Est_Activo			CHAR(1);			-- Estatus Activo
	DECLARE Con_Prospecto 		CHAR(1);			-- Constante de Prospecto
	DECLARE Con_Cliente			CHAR(1);			-- Constante de Cliente
	DECLARE Var_TipoParticipante CHAR(1);			-- Tipo Participante

	DECLARE Con_Ayuda			TINYINT UNSIGNED;	-- Consulta de ayuda
	DECLARE Con_ValidaCheck 	TINYINT UNSIGNED;	-- Consulta de validacion

	DECLARE InstrumentoCliente	INT(11);			-- Tipo de Instrumento Cliente
	DECLARE Cliente 			INT(11);			-- Tipo de Instrumento Cliente
	DECLARE CuentaAhorro 		INT(11);			-- Tipo de Instrumento Cuenta de Ahorro
	DECLARE SolicitudCredito	INT(11);			-- Tipo de Instrumento Solicitud Credito
	DECLARE Credito				INT(11);			-- Tipo de Instrumento Credito

	DECLARE Check_List 			INT(11);			-- Origen Check List
	DECLARE Digitalizacion		INT(11);			-- Origen Digitalizacion

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_Prospecto 			:= 'P';
	SET Con_Cliente				:= 'C';

	SET Con_Ayuda				:= 1;
	SET Con_ValidaCheck			:= 2;


	SET InstrumentoCliente		:= 4;
	SET Cliente 				:= 1;
	SET CuentaAhorro 			:= 2;
	SET SolicitudCredito 		:= 5;
	SET Credito 				:= 6;

	SET Check_List 				:= 1;
	SET Digitalizacion			:= 2;

	-- Se realiza la Lista de Instrumentos Activos
	IF( Par_NumConsulta = Con_Ayuda ) THEN

		-- Lista de Ayuda para Check List
		IF( Par_OrigenDocumentoID = Check_List ) THEN

			-- Instrumento Cliente
			IF( Par_TipoInstrumento = Cliente ) THEN
				SELECT Che.CheckListCteID AS ClasificaTipDocID, Tip.TipoDocumentoID,	Tip.Descripcion
				FROM CHECLIST Che
				INNER JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID = Che.TipoDocumentoID
				WHERE Che.Instrumento = Par_NumeroInstrumento
				  AND Che.TipoInstrumentoID = InstrumentoCliente
				  AND Tip.TipoDocumentoID = Par_TipoDocumentoID;
			END IF;

			-- Instrumento Solicitud de Credito
			IF( Par_TipoInstrumento = SolicitudCredito ) THEN
				SELECT Sol.ClasificaTipDocID AS ClasificaTipDocID, Tip.TipoDocumentoID, Tip.Descripcion
				FROM SOLICIDOCENT Sol
				INNER JOIN CLASIFICAGRPDOC Cla ON Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID = Sol.TipoDocumentoID
				WHERE Sol.ClasificaTipDocID = Par_GrupoDocumentoID
				  AND Sol.SolicitudCreditoID = Par_NumeroInstrumento
				  AND Sol.TipoDocumentoID = Par_TipoDocumentoID
				LIMIT 1;
			END IF;

			-- Instrumento Solicitud de Credito
			IF( Par_TipoInstrumento = Credito ) THEN
				SELECT Cre.ClasificaTipDocID AS ClasificaTipDocID, Cre.TipoDocumentoID,    Doc.Descripcion
				FROM CREDITODOCENT Cre
				INNER JOIN CLASIFICATIPDOC Cat ON Cre.ClasificaTipDocID = Cat.ClasificaTipDocID
				INNER JOIN TIPOSDOCUMENTOS Doc ON Cre.ClasificaTipDocID = Doc.TipoDocumentoID
				WHERE CreditoID = Par_NumeroInstrumento
				 AND Cre.ClasificaTipDocID = Par_GrupoDocumentoID
				 AND Cre.TipoDocumentoID = Par_TipoDocumentoID;
			END IF;

		END IF;

		-- Lista de Ayuda para Digitalizacion
		IF( Par_OrigenDocumentoID = Digitalizacion ) THEN

			-- Instrumento Cliente
			IF( Par_TipoInstrumento = Cliente ) THEN
				SELECT  Cli.ClienteArchivosID AS ClasificaTipDocID, Tip.TipoDocumentoID,	Tip.Descripcion
				FROM TIPOSDOCUMENTOS Tip
				INNER JOIN CLIENTEARCHIVOS Cli ON Cli.TipoDocumento = Tip.TipoDocumentoID
				  AND Cli.ClienteID = Par_NumeroInstrumento
				WHERE Cli.ClienteArchivosID = Par_ArchivoID
				  AND Tip.TipoDocumentoID = Par_TipoDocumentoID;
			END IF;

			-- Instrumento Cuenta de Ahorro
			IF( Par_TipoInstrumento = CuentaAhorro ) THEN
				SELECT  Cue.ArchivoCtaID AS ClasificaTipDocID, Tip.TipoDocumentoID,	Tip.Descripcion
				FROM TIPOSDOCUMENTOS Tip
				INNER JOIN CUENTAARCHIVOS Cue ON Cue.TipoDocumento = Tip.TipoDocumentoID
				  AND Cue.CuentaAhoID = Par_NumeroInstrumento
				WHERE Cue.ArchivoCtaID = Par_ArchivoID
				  AND Tip.TipoDocumentoID = Par_TipoDocumentoID;
			END IF;

			-- Instrumento Solicitud de Credito
			IF( Par_TipoInstrumento = SolicitudCredito ) THEN
				SELECT  Arch.DigSolID AS ClasificaTipDocID,  Arch.TipoDocumentoID, 	Clas.ClasificaDesc AS Descripcion
				FROM SOLICITUDARCHIVOS Arch,
					 CLASIFICATIPDOC Clas
				WHERE Arch.SolicitudCreditoID = Par_NumeroInstrumento
				  AND Arch.TipoDocumentoID  = Clas.ClasificaTipDocID
				  AND Arch.DigSolID = Par_ArchivoID
				  AND Arch.TipoDocumentoID = Par_TipoDocumentoID;
			END IF;

			-- Instrumento Credito
			IF( Par_TipoInstrumento = Credito ) THEN
				SELECT  Cre.DigCreaID AS ClasificaTipDocID, Tip.TipoDocumentoID,	Tip.Descripcion
				FROM TIPOSDOCUMENTOS Tip
				INNER JOIN CREDITOARCHIVOS Cre ON Cre.TipoDocumentoID = Tip.TipoDocumentoID
				  AND Cre.CreditoID = Par_NumeroInstrumento
				WHERE Cre.DigCreaID = Par_ArchivoID
				  AND Cre.TipoDocumentoID = Par_TipoDocumentoID;
			END IF;
		END IF;

	END IF;


	-- Se realiza la Lista de Instrumentos Activos
	IF( Par_NumConsulta = Con_ValidaCheck ) THEN
		-- Lista de Ayuda para Check List
		IF( Par_OrigenDocumentoID = Check_List ) THEN

			-- Instrumento Cliente
			IF( Par_TipoInstrumento = Cliente ) THEN

				SELECT 	Cadena_Vacia AS ClasificaTipDocID, IFNULL(COUNT(Arch.CheckListCteID), Entero_Cero) AS TipoDocumentoID,
						Cadena_Vacia AS Descripcion
				FROM CHECLIST Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.Instrumento = Doc.ParticipanteID AND Doc.TipoPersona = Con_Cliente
														 AND Doc.OrigenDocumento = Par_OrigenDocumentoID
														 AND Arch.GrupoDocumentoID  = Doc.GrupoDocumentoID
														 AND Arch.TipoDocumentoID = Doc.TipoDocumentoID AND TipoInstrumento = Par_TipoInstrumento
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumentoID = Tip.TipoDocumentoID
				WHERE Arch.Instrumento = Par_NumeroInstrumento
				  AND TipoInstrumentoID = InstrumentoCliente
				  AND Doc.TipoDocumentoID IS NULL;
			END IF;

			-- Instrumento Solicitud de Credito
			IF( Par_TipoInstrumento = SolicitudCredito ) THEN
				SET Var_TipoParticipante = FNTIPOPARTICIPANTEGRDVALORES(SolicitudCredito,Par_NumeroInstrumento);

				SELECT Cadena_Vacia AS ClasificaTipDocID, IFNULL(COUNT(Sol.SolicitudCreditoID), Entero_Cero) AS TipoDocumentoID,
					   Cadena_Vacia AS Descripcion
				FROM SOLICIDOCENT Sol
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Sol.SolicitudCreditoID = Doc.NumeroInstrumento AND Doc.TipoPersona = Var_TipoParticipante
				  AND Doc.TipoInstrumento = Par_TipoInstrumento AND Doc.OrigenDocumento = Par_OrigenDocumentoID
				  AND Sol.ClasificaTipDocID = Doc.GrupoDocumentoID AND Doc.TipoDocumentoID = Sol.TipoDocumentoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID = Sol.TipoDocumentoID
				WHERE Sol.SolicitudCreditoID = Par_NumeroInstrumento
				  AND Doc.NumeroInstrumento IS NULL;
			END IF;

			-- Instrumento Credito
			IF( Par_TipoInstrumento = Credito ) THEN
				SELECT Cadena_Vacia AS ClasificaTipDocID,IFNULL(COUNT(Arch.TipoDocumentoID) , 0) AS TipoDocumentoID,
					   Cadena_Vacia AS Descripcion
				FROM CREDITODOCENT Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.CreditoID = Doc.NumeroInstrumento AND Doc.TipoPersona = Con_Cliente
				  AND Doc.TipoInstrumento = Par_TipoInstrumento AND Doc.OrigenDocumento = Par_OrigenDocumentoID
				  AND Doc.GrupoDocumentoID = Arch.ClasificaTipDocID AND Arch.TipoDocumentoID = Doc.TipoDocumentoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumentoID = Tip.TipoDocumentoID
				WHERE Arch.CreditoID = Par_NumeroInstrumento
				  AND Doc.TipoDocumentoID IS NULL;
			END IF;

		END IF;

		-- Lista de Ayuda para Digitalizacion
		IF( Par_OrigenDocumentoID = Digitalizacion ) THEN

			-- Instrumento Cliente
			IF( Par_TipoInstrumento = Cliente ) THEN

				SELECT 	Cadena_Vacia AS ClasificaTipDocID, IFNULL(COUNT(Arch.ClienteArchivosID), Entero_Cero)  AS TipoDocumentoID,
						Cadena_Vacia AS Descripcion
				FROM CLIENTEARCHIVOS Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.ClienteID = Doc.ParticipanteID AND Doc.TipoPersona = Con_Cliente
														 AND Doc.OrigenDocumento = Digitalizacion AND Arch.ClienteArchivosID  = Doc.ArchivoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumento = Tip.TipoDocumentoID
				WHERE Arch.ClienteID = Par_NumeroInstrumento
				  AND Doc.ArchivoID IS NULL;
			END IF;

			-- Instrumento Cuenta de Ahorro
			IF( Par_TipoInstrumento = CuentaAhorro ) THEN
				SELECT Cadena_Vacia AS ClasificaTipDocID, IFNULL(COUNT(Arch.ArchivoCtaID), Entero_Cero) AS TipoDocumentoID, Cadena_Vacia AS Descripcion
				FROM CUENTAARCHIVOS Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.CuentaAhoID = Doc.NumeroInstrumento AND Doc.TipoPersona = Con_Cliente
				  AND Doc.TipoInstrumento = Par_TipoInstrumento AND Doc.OrigenDocumento = Digitalizacion AND Arch.ArchivoCtaID  = Doc.ArchivoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumento = Tip.TipoDocumentoID
				WHERE Arch.CuentaAhoID = Par_NumeroInstrumento
				  AND Doc.ArchivoID IS NULL;
			END IF;

			-- Instrumento Solicitud de Credito
			IF( Par_TipoInstrumento = SolicitudCredito ) THEN
				SET Var_TipoParticipante = FNTIPOPARTICIPANTEGRDVALORES(SolicitudCredito,Par_NumeroInstrumento);

				SELECT Cadena_Vacia AS ClasificaTipDocID, IFNULL(COUNT(Arch.DigSolID) , Entero_Cero) AS TipoDocumentoID,
					   Cadena_Vacia AS Descripcion
				FROM SOLICITUDARCHIVOS Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.SolicitudCreditoID = Doc.NumeroInstrumento AND Doc.TipoPersona = Var_TipoParticipante
				  AND Doc.TipoInstrumento = Par_TipoInstrumento AND Doc.OrigenDocumento = Digitalizacion AND Arch.DigSolID  = Doc.ArchivoID
				INNER JOIN CLASIFICATIPDOC Tip ON Arch.TipoDocumentoID = Tip.ClasificaTipDocID
				WHERE Arch.SolicitudCreditoID = Par_NumeroInstrumento
				  AND Doc.ArchivoID IS NULL;
			END IF;

			-- Instrumento Credito
			IF( Par_TipoInstrumento = Credito ) THEN
				SELECT Cadena_Vacia AS ClasificaTipDocID,IFNULL(COUNT(Arch.DigCreaID) , Entero_Cero) AS TipoDocumentoID,
					   Cadena_Vacia AS Descripcion
				FROM CREDITOARCHIVOS Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.CreditoID = Doc.NumeroInstrumento AND Doc.TipoPersona = Con_Cliente
				  AND Doc.TipoInstrumento = Par_TipoInstrumento AND Doc.OrigenDocumento = Digitalizacion AND Arch.DigCreaID  = Doc.ArchivoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumentoID = Tip.TipoDocumentoID
				WHERE Arch.CreditoID = Par_NumeroInstrumento
				  AND Doc.ArchivoID IS NULL;
			END IF;
		END IF;
	END IF;
END TerminaStore$$