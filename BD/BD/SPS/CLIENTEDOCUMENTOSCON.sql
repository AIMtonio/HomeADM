-- CLIENTEDOCUMENTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEDOCUMENTOSCON`;
DELIMITER $$

CREATE PROCEDURE `CLIENTEDOCUMENTOSCON`(
	Par_ClienteID			INT(11),			-- ID del Cliente
	Par_TipoDocumen 		INT(11), 			-- Tipo de documento a consultar
	Par_NumCon				TINYINT UNSIGNED, 	-- Numero de consulta

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
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE Con_Documentos   	INT;

-- Asignacion de constantes
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;
SET Con_Documentos		:= 1;			-- Consulta por tipo de documento.

-- Consultar Por tipo de documento
IF(Par_NumCon = Con_Documentos) THEN

    SELECT  MAX(ClienteArchivosID) INTO Var_CliArchID
        FROM CLIENTEARCHIVOS
        WHERE
        	IF(Par_ClienteID <> Entero_Cero , ClienteID = Par_ClienteID, true)
        	AND IF(Par_TipoDocumen <> Entero_Cero , TipoDocumento = Par_TipoDocumen, true);

    SET Var_CliArchID   := IFNULL(Var_CliArchID, Entero_Cero);

    SELECT  ClienteID,  Recurso, ClienteArchivosID, TipoDocumento
        FROM CLIENTEARCHIVOS
        WHERE ClienteArchivosID = Var_CliArchID;
END IF;

END TerminaStore$$
