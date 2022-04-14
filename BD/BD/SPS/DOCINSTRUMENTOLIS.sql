-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCINSTRUMENTOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCINSTRUMENTOLIS;

DELIMITER $$
CREATE PROCEDURE `DOCINSTRUMENTOLIS`(
	-- Store Procedure: Que Lista Los Instrumentos por grupo de documento y tipo de documento
	-- Modulo Guarda Valores
	Par_OrigenDocumentoID 		INT(11),			-- Origen del Documento
	Par_GrupoDocumentoID		INT(11),			-- ID de Grupo de Documento
	Par_TipoDocumentoID			INT(11),			-- ID de Grupo de Documento
	Par_TipoInstrumento			BIGINT(20),			-- ID de Tipo de Instrumento
	Par_NumeroInstrumento 		BIGINT(20),			-- ID de Instrumento
	Par_NombreDocumento			VARCHAR(50),		-- Nombre del Instrumentos

	Par_NumLista				TINYINT UNSIGNED,	-- Numero de Lista

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
	DECLARE Var_TipoParticipante CHAR(1);			-- Tipo Participante

	DECLARE Lista_Combo			TINYINT UNSIGNED;	-- Lista de Combo
	DECLARE Lista_Ayuda			TINYINT UNSIGNED;	-- Lista de Ayuda

	DECLARE InstrumentoCliente	INT(11);			-- Tipo de Instrumento Cliente
	DECLARE Cliente 			INT(11);			-- Tipo de Instrumento Cliente
	DECLARE CuentaAhorro 		INT(11);			-- Tipo de Instrumento Cuenta de Ahorro
	DECLARE SolicitudCredito	INT(11);			-- Tipo de Instrumento Solicitud Credito
	DECLARE Credito				INT(11);			-- Tipo de Instrumento Credito
	DECLARE Check_List 			INT(11);			-- Origen Check List
	DECLARE Digitalizacion		INT(11);			-- Origen Digitalizacion

	DECLARE RequeridoCliente	CHAR(1);			-- Requerido en Cliente
	DECLARE RequeridoCuenta		CHAR(1);			-- Requerido en Cuenta
	DECLARE RequeridoCredito 	CHAR(1);			-- Requerido en Credito
	DECLARE Con_Prospecto 		CHAR(1);			-- Constante de Prospecto
	DECLARE Con_Cliente			CHAR(1);			-- Constante de Cliente

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET RequeridoCliente		:= 'C';
	SET RequeridoCuenta 		:= 'Q';
	SET RequeridoCredito 		:= 'K';
	SET Con_Prospecto 			:= 'P';
	SET Con_Cliente				:= 'C';

	SET Lista_Combo				:= 1;
	SET Lista_Ayuda				:= 2;

	SET Cliente 				:= 1;
	SET CuentaAhorro 			:= 2;
	SET SolicitudCredito 		:= 5;
	SET Credito 				:= 6;

	SET Check_List 				:= 1;
	SET Digitalizacion			:= 2;
	SET InstrumentoCliente		:= 4;

	-- Se realiza la Lista Combo de check list disponible solo para cliente, solicitud y credito
	IF( Par_NumLista = Lista_Combo ) THEN

		-- Lista de Ayuda para Check List
		IF( Par_OrigenDocumentoID = Check_List ) THEN

			-- Instrumento Cliente
			IF( Par_TipoInstrumento = Cliente ) THEN
				SELECT  Grp.GrupoDocumentoID, Grp.Descripcion
					FROM GRUPODOCUMENTOS Grp
		            INNER JOIN CHECLIST Chek ON Chek.GrupoDocumentoID = Grp.GrupoDocumentoID
					WHERE Chek.Instrumento = Par_NumeroInstrumento
		              AND TipoInstrumentoID = InstrumentoCliente
					GROUP BY Grp.GrupoDocumentoID;
			END IF;
		END IF;

		-- Lista de Ayuda para Digitalizacion
		IF( Par_OrigenDocumentoID = Digitalizacion ) THEN

			-- Instrumento Cliente
			IF( Par_TipoInstrumento = Cliente ) THEN
				SELECT CONCAT(Tip.TipoDocumentoID,'-',Arch.ClienteArchivosID) AS TipoDocumentoID, CONCAT(' NO. ARCHIVO ',Arch.ClienteArchivosID, ': ', Tip.Descripcion ) AS Descripcion,
					Arch.ClienteArchivosID AS ArchivoID
				FROM CLIENTEARCHIVOS Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.ClienteID = Doc.ParticipanteID AND Doc.TipoPersona = Con_Cliente
				  										 AND Doc.OrigenDocumento = Digitalizacion AND Arch.ClienteArchivosID  = Doc.ArchivoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumento = Tip.TipoDocumentoID
				WHERE Arch.ClienteID = Par_NumeroInstrumento
				  AND Doc.ArchivoID IS NULL;
			END IF;

			-- Instrumento Cuenta de Ahorro
			IF( Par_TipoInstrumento = CuentaAhorro ) THEN
				SELECT CONCAT(Tip.TipoDocumentoID,'-',Arch.ArchivoCtaID) AS TipoDocumentoID, CONCAT(' NO. ARCHIVO ',Arch.ArchivoCtaID, ': ', Tip.Descripcion ) AS Descripcion,
					Arch.ArchivoCtaID AS ArchivoID
				FROM CUENTAARCHIVOS Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.CuentaAhoID = Doc.NumeroInstrumento AND Doc.TipoPersona = Con_Cliente
				  AND Doc.TipoInstrumento = CuentaAhorro AND Doc.OrigenDocumento = Digitalizacion AND Arch.ArchivoCtaID  = Doc.ArchivoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumento = Tip.TipoDocumentoID
				WHERE Arch.CuentaAhoID = Par_NumeroInstrumento
				  AND Doc.ArchivoID IS NULL;
			END IF;

			-- Instrumento Solicitud de Credito
			IF( Par_TipoInstrumento = SolicitudCredito ) THEN
				SET Var_TipoParticipante = FNTIPOPARTICIPANTEGRDVALORES(SolicitudCredito,Par_NumeroInstrumento);
				SELECT CONCAT(Arch.TipoDocumentoID,'-',Arch.DigSolID) AS TipoDocumentoID, CONCAT(' NO. ARCHIVO ',Arch.DigSolID, ': ', Tip.Descripcion ) AS Descripcion,
					Arch.DigSolID AS ArchivoID
				FROM SOLICITUDARCHIVOS Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.SolicitudCreditoID = Doc.NumeroInstrumento AND Doc.TipoPersona = Var_TipoParticipante
				  AND Doc.TipoInstrumento = SolicitudCredito AND Doc.OrigenDocumento = Digitalizacion AND Arch.DigSolID  = Doc.ArchivoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumentoID = Tip.TipoDocumentoID
				WHERE Arch.SolicitudCreditoID = Par_NumeroInstrumento
				  AND Doc.ArchivoID IS NULL;
			END IF;

			-- Instrumento Credito
			IF( Par_TipoInstrumento = Credito ) THEN
				SELECT CONCAT(Arch.TipoDocumentoID,'-',Arch.DigCreaID) AS TipoDocumentoID, CONCAT(' NO. ARCHIVO ',Arch.DigCreaID, ': ', Tip.Descripcion ) AS Descripcion,
					Arch.DigCreaID AS ArchivoID
				FROM CREDITOARCHIVOS Arch
				LEFT OUTER JOIN  DOCUMENTOSGRDVALORES Doc ON Arch.CreditoID = Doc.NumeroInstrumento AND Doc.TipoPersona = Con_Cliente
				  AND Doc.TipoInstrumento = Credito AND Doc.OrigenDocumento = Digitalizacion AND Arch.DigCreaID  = Doc.ArchivoID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Arch.TipoDocumentoID = Tip.TipoDocumentoID
				WHERE Arch.CreditoID = Par_NumeroInstrumento
				  AND Doc.ArchivoID IS NULL;
			END IF;
		END IF;
	END IF;

	-- Se realiza la Lista de Instrumentos Activos
	IF( Par_NumLista = Lista_Ayuda ) THEN

		-- Lista de Ayuda para Check List
		IF( Par_OrigenDocumentoID = Check_List ) THEN

			-- Instrumento Cliente
			IF( Par_TipoInstrumento = Cliente ) THEN
				SELECT Che.CheckListCteID AS ArchivoID, Tip.TipoDocumentoID,	Tip.Descripcion
				FROM CHECLIST Che
				INNER JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID = Che.TipoDocumentoID
				WHERE  Che.Instrumento = Par_NumeroInstrumento
				  AND Che.GrupoDocumentoID = Par_GrupoDocumentoID
				  AND Che.TipoInstrumentoID = InstrumentoCliente
				  AND Tip.Descripcion LIKE CONCAT("%", Par_NombreDocumento, "%")
				LIMIT 0,15;
			END IF;

			-- Instrumento Solicitud de Credito
			IF( Par_TipoInstrumento = SolicitudCredito ) THEN
				SELECT Sol.ClasificaTipDocID  AS ArchivoID, Tip.TipoDocumentoID, Tip.Descripcion
				FROM SOLICIDOCENT Sol
				INNER JOIN CLASIFICAGRPDOC Cla ON Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
				INNER JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID = Sol.TipoDocumentoID
				WHERE Sol.ClasificaTipDocID = Par_GrupoDocumentoID
				  AND Sol.SolicitudCreditoID = Par_NumeroInstrumento
				  AND Tip.Descripcion LIKE CONCAT("%", Par_NombreDocumento, "%")
				GROUP BY Sol.ClasificaTipDocID, Tip.TipoDocumentoID
				LIMIT 0,15;
			END IF;

		END IF;

		-- Lista de Ayuda para Digitalizacion
		IF( Par_OrigenDocumentoID = Digitalizacion ) THEN

			-- Instrumento Cliente
			IF( Par_TipoInstrumento = Cliente ) THEN
				SELECT  Cli.ClienteArchivosID AS ArchivoID, Tip.TipoDocumentoID,	Tip.Descripcion
				FROM TIPOSDOCUMENTOS Tip
				INNER JOIN CLIENTEARCHIVOS Cli ON Cli.TipoDocumento = Tip.TipoDocumentoID
				  AND Cli.ClienteID = Par_NumeroInstrumento
				WHERE Tip.RequeridoEn LIKE CONCAT("%", RequeridoCliente, "%")
				  AND Tip.Descripcion LIKE CONCAT("%", Par_NombreDocumento, "%")
				LIMIT 0, 15;
			END IF;

			-- Instrumento Cuenta de Ahorro
			IF( Par_TipoInstrumento = CuentaAhorro ) THEN
				SELECT  Cue.ArchivoCtaID AS ArchivoID, Tip.TipoDocumentoID,	Tip.Descripcion
				FROM TIPOSDOCUMENTOS Tip
			    INNER JOIN CUENTAARCHIVOS Cue ON Cue.TipoDocumento = Tip.TipoDocumentoID
			      AND Cue.CuentaAhoID = Par_NumeroInstrumento
				WHERE Tip.RequeridoEn LIKE CONCAT("%", RequeridoCuenta , "%")
			      AND Tip.Descripcion LIKE CONCAT("%", Par_NombreDocumento, "%")
				LIMIT 0,15;
			END IF;

			-- Instrumento Solicitud de Credito
			IF( Par_TipoInstrumento = SolicitudCredito ) THEN
				SELECT  Arch.DigSolID AS ArchivoID,  Arch.TipoDocumentoID, 	Clas.Descripcion AS Descripcion
				FROM SOLICITUDARCHIVOS Arch,
					 TIPOSDOCUMENTOS Clas
				WHERE Arch.SolicitudCreditoID = Par_NumeroInstrumento
				  AND Arch.TipoDocumentoID  = Clas.TipoDocumentoID
				  AND Clas.Descripcion LIKE CONCAT("%", Par_NombreDocumento, "%")
				LIMIT 0,15;
			END IF;

			-- Instrumento Credito
			IF( Par_TipoInstrumento = Credito ) THEN
				SELECT  Cre.DigCreaID AS ArchivoID, Tip.TipoDocumentoID,	Tip.Descripcion
				FROM TIPOSDOCUMENTOS Tip
			    INNER JOIN CREDITOARCHIVOS Cre ON Cre.TipoDocumentoID = Tip.TipoDocumentoID
			      AND Cre.CreditoID = Par_NumeroInstrumento
				WHERE Tip.RequeridoEn LIKE CONCAT("%", RequeridoCredito, "%")
			      AND Tip.Descripcion LIKE CONCAT("%", Par_NombreDocumento , "%")
			    LIMIT 0,15;
			END IF;
		END IF;

	END IF;


END TerminaStore$$