-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEARCHIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEARCHIVOSCON`;
DELIMITER $$

CREATE PROCEDURE `CLIENTEARCHIVOSCON`(
	Par_ClienteID			INT(11),		-- ID del Cliente
	Par_ProspectoID			INT, 		-- ID del Prospecto
	Par_TipoDocumen 		INT, 		-- Tipo de documento a consultar
	Par_NumCon				TINYINT UNSIGNED, -- Numero de consulta

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN

-- Declaracion e Variables
DECLARE Var_CliArchID			INT;

-- Declaracion de constantes
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Var_PLD             CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE Con_NumeroDoc		INT;
DECLARE Con_ExistePLD       INT;
DECLARE Con_ImagenPerfil    INT;
DECLARE Con_TipoDocumento   INT;
DECLARE TipoDocumentoImg    INT;

-- Asignacion de constantes
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;
SET Con_NumeroDoc		:= 3;           -- Consulta para obtener el numero de documentos por cliente
SET Con_ExistePLD		:= 9;           -- Consulta para PLD
SET Con_ImagenPerfil	:= 13;          -- Consulta de la Imagen o Foto del Cliente.
SET Con_TipoDocumento	:= 13;			-- Consulta por tipo de documento.
SET TipoDocumentoImg	:= 1;           -- Tipo Documento Imagen o Foto del Cliente-Prospecto
SET Var_PLD				:= 'P';

-- se utiliza para saber si ya existen documentos pld
IF(Par_NumCon = Con_ExistePLD) THEN
	SELECT	ClienteID
		FROM CLIENTEARCHIVOS,
			TIPOSDOCUMENTOS
		WHERE  RequeridoEn LIKE CONCAT('%',Var_PLD,'%')
		AND TipoDocumento = tipoDocumentoID
		AND ClienteID = Par_ClienteID
		LIMIT 1;
END IF;

-- Consultar Imagen de Perfil del Cliente
IF(Par_NumCon = Con_ImagenPerfil) THEN

    SELECT  MAX(ClienteArchivosID) INTO Var_CliArchID
        FROM CLIENTEARCHIVOS
        WHERE ClienteID     = Par_ClienteID
          AND TipoDocumento = TipoDocumentoImg;

    SET Var_CliArchID   := IFNULL(Var_CliArchID, Entero_Cero);

    SELECT  ClienteID,  Recurso, ClienteArchivosID
        FROM CLIENTEARCHIVOS
        WHERE ClienteArchivosID = Var_CliArchID;
END IF;

-- Consulta el numero de documentos que existen por cliente o prospecto
IF(Par_NumCon = Con_NumeroDoc) THEN
	IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
		SELECT	IFNULL(COUNT(ClienteArchivosID),Entero_Cero)
			FROM 	CLIENTEARCHIVOS
			WHERE	ProspectoID = Par_ProspectoID;
	ELSE
		SELECT	IFNULL(COUNT(ClienteArchivosID),Entero_Cero)
			FROM 	CLIENTEARCHIVOS
			WHERE	ClienteID = Par_ClienteID;
	END IF;
END IF;

-- Consultar Por tipo de documento
IF(Par_NumCon = Con_TipoDocumento) THEN

    SELECT  MAX(ClienteArchivosID) INTO Var_CliArchID
        FROM CLIENTEARCHIVOS
        WHERE ClienteID     = Par_ClienteID
          AND TipoDocumento = Par_TipoDocumen;

    SET Var_CliArchID   := IFNULL(Var_CliArchID, Entero_Cero);

    SELECT  ClienteID,  Recurso, ClienteArchivosID
        FROM CLIENTEARCHIVOS
        WHERE ClienteArchivosID = Var_CliArchID;
END IF;

END TerminaStore$$