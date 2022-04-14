-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPODOCUMENTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPODOCUMENTOSLIS`;
DELIMITER $$


CREATE PROCEDURE `GRUPODOCUMENTOSLIS`(
	-- Store Procedure: Que Lista los Grupos de Documentos en SAFI
	-- Modulo Administracion
	Par_NumList				TINYINT UNSIGNED,	-- Numero de Lista
	Par_Instrumento			INT(11),			-- Tipo de instrumento
	Par_TipoInstrumentoID	INT(11),			-- Tipo de Documento
	Par_GrupoDocumentoID	VARCHAR(60),		-- Grupo de Documento

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Par_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Par_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Par_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Par_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Par_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Par_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)

TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Cero
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE ListaPrincipalGrid	INT(11);	-- Lista Principal de Grid
	DECLARE Lista_Principal		INT(11);	-- Lista Principal
	DECLARE ListaForaneaGrid	INT(11);	-- Lista Foranea en Grid

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET ListaPrincipalGrid		:= 1;
	SET Lista_Principal			:= 2;
	SET ListaForaneaGrid		:= 3;

	-- Lista Principal de Grid
	IF( ListaPrincipalGrid = Par_NumList ) THEN
		SELECT Grp.GrupoDocumentoID, Grp.Descripcion, Che.Comentario, Che.Aceptado, Che.TipoDocumentoID
		FROM GRUPODOCUMENTOS Grp
		INNER JOIN CHECLIST Che ON Che.GrupoDocumentoID = Grp.GrupoDocumentoID
		WHERE Che.Instrumento = Par_Instrumento
		  AND TipoInstrumentoID = Par_TipoInstrumentoID;
	END IF;

	-- Lista Principal
	IF( Lista_Principal = Par_NumList ) THEN
		SELECT GrupoDocumentoID, Descripcion
		FROM GRUPODOCUMENTOS
		WHERE Descripcion LIKE CONCAT( "%" , Par_GrupoDocumentoID, "%" );
	END IF;

	-- Lista Foranea en Grid
	IF( ListaForaneaGrid =Par_NumList ) THEN
		SELECT GrupoDocumentoID, Descripcion
		FROM GRUPODOCUMENTOS;
	END IF;
END$$