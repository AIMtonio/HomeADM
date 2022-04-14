DELIMITER ;
DROP PROCEDURE IF EXISTS BITACORADOCGRDVALORESREP;

DELIMITER $$
CREATE PROCEDURE `BITACORADOCGRDVALORESREP`(
	-- Store Procedure: De Reporte de la Bitacora los cambios de Estatus de los Documentos de Guarda Valores
	-- Modulo Guarda Valores
	Par_DocumentoID				BIGINT(20),			-- ID de tabla DOCUMENTOSGRDVALORES
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
	DECLARE Var_ParticipanteID		BIGINT(20);			-- Numero de Participante
	DECLARE Var_TipoPersona			CHAR(1);			-- Tipo de Persona
	DECLARE Var_NombreDocumento 	VARCHAR(200);		-- Nombre de Documento
	DECLARE Var_NombreCompleto	 	VARCHAR(200);		-- Nombre de Cliente o Prospecto

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia

	DECLARE Est_Registrado			CHAR(1);			-- Estatus Registrado
	DECLARE Est_Custodia			CHAR(1);			-- Estatus Custodia
	DECLARE Est_Prestamo			CHAR(1);			-- Estatus Prestamo
	DECLARE Est_Baja				CHAR(1);			-- Estatus Baja

	DECLARE Con_Cliente				CHAR(1);			-- Tipo Cliente
	DECLARE Con_Prospecto			CHAR(1);			-- Tipo Prospecto

	DECLARE Desc_Registrado			VARCHAR(20);		-- Estatus Registrado
	DECLARE Desc_Custodia			VARCHAR(20);		-- Estatus Custodia
	DECLARE Desc_Prestamo			VARCHAR(20);		-- Estatus Prestamo
	DECLARE Desc_Baja				VARCHAR(20);		-- Estatus Baja
	DECLARE Desc_Desconocido		VARCHAR(20);		-- Estatus Desconocido
	DECLARE	Entero_Cero				INT(11);			-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);		-- Constante de Decimal Cero
	DECLARE Rep_Bitacora			TINYINT UNSIGNED;	-- Numero de Reporte Excel

	-- Asignacion  de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';

	SET Est_Registrado		:= 'R';
	SET Est_Prestamo		:= 'P';
	SET Est_Custodia		:= 'C';
	SET Est_Baja			:= 'B';
	SET Con_Cliente 		:= 'C';
	SET Con_Prospecto		:= 'P';

	SET Desc_Registrado		:= 'REGISTRADO';
	SET Desc_Custodia		:= 'CUSTODIA';
	SET Desc_Prestamo		:= 'PRESTAMO';
	SET Desc_Baja			:= 'BAJA';
	SET Desc_Desconocido	:= 'DESCONOCIDO';

	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Rep_Bitacora		:= 1;

	SELECT 	Doc.TipoPersona,   Doc.NumeroInstrumento,
			CASE WHEN Doc.GrupoDocumentoID =  Entero_Cero AND Doc.TipoDocumentoID =  Entero_Cero THEN Doc.NombreDocumento
				 WHEN Doc.GrupoDocumentoID =  Entero_Cero AND Doc.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
				 WHEN Doc.GrupoDocumentoID <> Entero_Cero AND Doc.TipoDocumentoID <> Entero_Cero THEN Tip.Descripcion
				 ELSE ''
			END AS NombreDocumento
	INTO Var_TipoPersona, Var_ParticipanteID, Var_NombreDocumento
	FROM DOCUMENTOSGRDVALORES Doc
	LEFT JOIN GRUPODOCUMENTOS Gpo ON Gpo.GrupoDocumentoID = Doc.GrupoDocumentoID
	LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID =  Doc.TipoDocumentoID
	WHERE DocumentoID = Par_DocumentoID;

	IF( Var_TipoPersona = Con_Cliente ) THEN
		SELECT NombreCompleto
		INTO Var_NombreCompleto
		FROM CLIENTES
		WHERE ClienteID = Var_ParticipanteID;
	END IF;

	IF( Var_TipoPersona = Con_Prospecto ) THEN
		SELECT NombreCompleto
		INTO Var_NombreCompleto
		FROM PROSPECTOS
		WHERE ProspectoID = Var_ParticipanteID;
	END IF;

	SET Var_NombreCompleto := IFNULL(Var_NombreCompleto, Cadena_Vacia);

	DROP TABLE IF EXISTS TMP_BITACORADOCGRDVALORESREP;
	CREATE TEMPORARY TABLE TMP_BITACORADOCGRDVALORESREP(
		BitacoraDocGrdValoresID		BIGINT(20),
		TipoInstrumento				VARCHAR(50),
		NumeroInstrumento			BIGINT(20),
		NombreParticipante			VARCHAR(200),
		NombreDocumento				VARCHAR(100),

		EstatusPrevio 				VARCHAR(20),
		EstatusActual 				VARCHAR(20),
		UsuarioRegistroID			VARCHAR(200),
		FechaRegistro				VARCHAR(20),
		Observaciones 				VARCHAR(500));

	IF( Par_NumeroReporte = Rep_Bitacora ) THEN

		SET @Consecutivo := 0;
		INSERT INTO TMP_BITACORADOCGRDVALORESREP(
			BitacoraDocGrdValoresID,			TipoInstrumento,		NumeroInstrumento,
			NombreParticipante,					NombreDocumento,
			EstatusPrevio,						EstatusActual,			UsuarioRegistroID,
			FechaRegistro,						Observaciones)
		SELECT @Consecutivo:=(@Consecutivo+1),	Cat.NombreInstrumento,	Var_ParticipanteID AS NumeroInstrumento,
			   Var_NombreCompleto AS NombreParticipante,				Var_NombreDocumento AS NombreDocumento,
			   CASE WHEN His.EstatusPrevio = Est_Registrado  THEN Desc_Registrado
					WHEN His.EstatusPrevio = Est_Custodia    THEN Desc_Custodia
					WHEN His.EstatusPrevio = Est_Prestamo    THEN Desc_Prestamo
					WHEN His.EstatusPrevio = Est_Baja        THEN Desc_Baja
					ELSE Desc_Desconocido
			   END,
			   CASE WHEN His.EstatusActual = Est_Registrado  THEN Desc_Registrado
					WHEN His.EstatusActual = Est_Custodia    THEN Desc_Custodia
					WHEN His.EstatusActual = Est_Prestamo    THEN Desc_Prestamo
					WHEN His.EstatusActual = Est_Baja        THEN Desc_Baja
					ELSE Desc_Desconocido
			   END,
			   Usr.NombreCompleto,		CONCAT(His.FechaRegistro,' ',His.HoraRegistro),
			   His.Observaciones
		FROM HISBITADOCGRDVALORES His
		INNER JOIN USUARIOS Usr ON His.UsuarioRegistroID = Usr.UsuarioID
		INNER JOIN DOCUMENTOSGRDVALORES Doc ON Doc.DocumentoID = His.DocumentoID
		INNER JOIN CATINSTGRDVALORES Cat ON Doc.TipoInstrumento = Cat.CatInsGrdValoresID
		WHERE His.DocumentoID = Par_DocumentoID;

		INSERT INTO TMP_BITACORADOCGRDVALORESREP(
			BitacoraDocGrdValoresID,			TipoInstrumento,		NumeroInstrumento,
			NombreParticipante,					NombreDocumento,
			EstatusPrevio,						EstatusActual,			UsuarioRegistroID,
			FechaRegistro,						Observaciones)
		SELECT @Consecutivo:=(@Consecutivo+1),  Cat.NombreInstrumento,	Var_ParticipanteID AS NumeroInstrumento,
			   Var_NombreCompleto AS NombreParticipante,				Var_NombreDocumento AS NombreDocumento,
			   CASE WHEN Bita.EstatusPrevio = Est_Registrado  THEN Desc_Registrado
					WHEN Bita.EstatusPrevio = Est_Custodia    THEN Desc_Custodia
					WHEN Bita.EstatusPrevio = Est_Prestamo    THEN Desc_Prestamo
					WHEN Bita.EstatusPrevio = Est_Baja        THEN Desc_Baja
					ELSE Desc_Desconocido
			   END,
			   CASE WHEN Bita.EstatusActual = Est_Registrado  THEN Desc_Registrado
					WHEN Bita.EstatusActual = Est_Custodia    THEN Desc_Custodia
					WHEN Bita.EstatusActual = Est_Prestamo    THEN Desc_Prestamo
					WHEN Bita.EstatusActual = Est_Baja        THEN Desc_Baja
					ELSE Desc_Desconocido
			   END,
			   Usr.NombreCompleto,		CONCAT(Bita.FechaRegistro,' ',Bita.HoraRegistro),
			   Bita.Observaciones
		FROM BITACORADOCGRDVALORES Bita
		INNER JOIN USUARIOS Usr ON Bita.UsuarioRegistroID = Usr.UsuarioID
		INNER JOIN DOCUMENTOSGRDVALORES Doc ON Doc.DocumentoID = Bita.DocumentoID
		INNER JOIN CATINSTGRDVALORES Cat ON Doc.TipoInstrumento = Cat.CatInsGrdValoresID
		WHERE Bita.DocumentoID = Par_DocumentoID;

		SELECT	BitacoraDocGrdValoresID AS Consecutivo,		TipoInstrumento,	NumeroInstrumento,
				NombreParticipante,		NombreDocumento,	EstatusPrevio,		EstatusActual,
				UsuarioRegistroID,		FechaRegistro,		Observaciones
		FROM TMP_BITACORADOCGRDVALORESREP;
	END IF;

	DROP TABLE IF EXISTS TMP_BITACORADOCGRDVALORESREP;
END TerminaStore$$