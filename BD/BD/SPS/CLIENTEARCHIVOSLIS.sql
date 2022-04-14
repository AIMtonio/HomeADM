-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEARCHIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEARCHIVOSLIS`;
DELIMITER $$


CREATE PROCEDURE `CLIENTEARCHIVOSLIS`(
	Par_ClienteID		INT(11),		-- ID del Cliente
	Par_ProspectoID		INT(11),		-- ID del prospecto
	Par_TipoDocumen		VARCHAR(45), 	-- Tipo de Documento a Listar
	Par_Instrumento		INT(11), 		-- Tipo de Instrumento
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(11)
		)

TerminaStore: BEGIN

-- Declaracion de Constantes,
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero			INT;
DECLARE Lis_Principal       INT;
DECLARE Lis_PorInstrumento	INT;
DECLARE Lis_reportePDFC		INT;
DECLARE Lis_reportePDFp		INT;
DECLARE Lis_PLD				INT;
DECLARE RequeridoEnPLD		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';              -- Cadena Vacia
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET Entero_Cero			:= 0;               -- Entero Cero
SET Lis_Principal		:= 1;               -- Tipo de Lista Principal
SET Lis_PorInstrumento	:= 2;				-- Lista archivos de un cliente, tomando en cuenta el instrumento
SET Lis_reportePDFC		:= 3;				-- Lista de archivos de un cliente
SET Lis_reportePDFP		:= 4;				-- Lista de archivos de un PROSPECTO
SET Lis_PLD				:= 5;				-- Lista de archivos de PLD
SET RequeridoEnPLD		:= 'P';				-- Tipo de documento requerido en el modulo de PLD


IF(Par_NumLis = Lis_Principal) THEN
	SELECT CliA.TipoDocumento,	CliA.Consecutivo,	CliA.Recurso,	CliA.ClienteArchivosID, CliA.Observacion,
		   CliA.Instrumento, CliA.FechaRegistro,	Tip.Descripcion
		FROM CLIENTEARCHIVOS CliA
		INNER JOIN TIPOSDOCUMENTOS Tip ON CliA.TipoDocumento = Tip.TipoDocumentoID
		WHERE  CliA.ClienteID = IFNULL(Par_ClienteID,Entero_Cero )
		AND CliA.ProspectoID = IFNULL(Par_ProspectoID ,Entero_Cero )
		AND CliA.TipoDocumento = Par_TipoDocumen
		LIMIT 0, 20;
END IF;

IF(Par_NumLis = Lis_PorInstrumento) THEN
	SELECT  TipoDocumento,	Consecutivo,	Recurso,	ClienteArchivosID,	Observacion,
			Instrumento,	FechaRegistro
		FROM CLIENTEARCHIVOS
		WHERE  ClienteID = IFNULL(Par_ClienteID,Entero_Cero )
		AND  ProspectoID = IFNULL(Par_ProspectoID ,Entero_Cero )
		AND Instrumento = Par_Instrumento;
END IF;

-- CONSULTA POR CLIENTE
IF(Par_NumLis = Lis_reportePDFC) THEN
	SELECT	TipoDocumento,	Recurso,			Observacion,	ClienteID,		ProspectoID,
		Consecutivo,		ClienteArchivosID,	Instrumento,	FechaRegistro, 	TIME(NOW()) AS Hora,
		Descripcion AS DescTipDoc
	FROM CLIENTEARCHIVOS	CliA
		INNER JOIN TIPOSDOCUMENTOS Tip ON CliA.TipoDocumento = Tip.TipoDocumentoID
		WHERE CliA.ClienteID = Par_ClienteID;
END IF;

-- CONSULTA POR PROSPECTO
IF(Par_NumLis = Lis_reportePDFP) THEN
	SELECT	TipoDocumento,	Recurso,			Observacion,	ClienteID,		ProspectoID,
		Consecutivo,		ClienteArchivosID,	Instrumento,	FechaRegistro, 	TIME(NOW()) AS Hora,
		Descripcion AS DescTipDoc
	FROM CLIENTEARCHIVOS	CliA
		INNER JOIN TIPOSDOCUMENTOS Tip ON CliA.TipoDocumento = Tip.TipoDocumentoID
		WHERE CliA.ProspectoID =Par_ProspectoID ;
END IF;

-- LISTA ARCHIVOS SUBIDOS PARA PLD
IF(Par_NumLis = Lis_PLD) THEN
	SELECT TipoDocumento,	Consecutivo,	Recurso,	ClienteArchivosID, Observacion,
			Instrumento, FechaRegistro
		FROM CLIENTEARCHIVOS INNER JOIN TIPOSDOCUMENTOS ON TipoDocumento=TipoDocumentoID
		WHERE ClienteID = IFNULL(Par_ClienteID,Entero_Cero)
		AND RequeridoEn LIKE CONCAT('%',RequeridoEnPLD,'%')
		LIMIT 0, 15;
END IF;

END TerminaStore$$