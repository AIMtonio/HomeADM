-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODOCENTLIST
DELIMITER ;
DROP PROCEDURE IF EXISTS CREDITODOCENTLIST;

DELIMITER $$
CREATE PROCEDURE `CREDITODOCENTLIST`(
	-- Store Procedure de tipo lista para los documentos relacionados a un credito
	Par_Credito     		BIGINT(12),			-- Numero de Credito
	Par_ClasificaTipDocID	INT(11),			-- Clasificacion de Tipo de Documento
	Par_Descripcion			VARCHAR(100),		-- Descripcion
	Par_NumLis      		TINYINT UNSIGNED	-- Numero de Lista
)
TerminaStore: BEGIN

	/* Declaracion de Constantes */
	DECLARE Con_Cadena_Vacia        CHAR(1);
	DECLARE Con_Fecha_Vacia         DATE;
	DECLARE Con_Entero_Cero         INT(11);
	DECLARE Con_Str_SI              CHAR(1);
	DECLARE Con_Str_NO              CHAR(1);
	DECLARE Lis_Principal           CHAR(1);
	DECLARE	Lis_Combo				TINYINT UNSIGNED;-- Numero de Lista 3 Combo
	DECLARE	Lis_GuardaValores		TINYINT UNSIGNED;-- Numero de Lista 2 Guarda Valores

	/* Asignacion de Constantes */
	SET	Con_Cadena_Vacia    := '';
	SET	Con_Fecha_Vacia     := '1900-01-01';
	SET	Con_Entero_Cero     := 0;
	SET	Con_Str_SI          := 'S';
	SET	Con_Str_NO          := 'N';
	SET	Lis_Principal       := 1;
	SET	Lis_Combo   		:= 2;
	SET	Lis_GuardaValores	:= 3;


	/* 1.- Consulta Principal por Credito de Documentos Requeridos */
	IF(Par_NumLis = Lis_Principal) THEN

	SELECT   Cre.CreditoID,          Cre.ProducCreditoID,    Cre.ClasificaTipDocID,     Cla.ClasificaDesc,  Cre.DocAceptado,
			Cre.TipoDocumentoID,    Doc.Descripcion,        Cre.Comentarios
	FROM CREDITODOCENT Cre,
		CLASIFICATIPDOC Cla,
		TIPOSDOCUMENTOS Doc
	WHERE CreditoID = Par_Credito
	  AND Cre.ClasificaTipDocID = Cla.ClasificaTipDocID
	  AND Cre.TipoDocumentoID = Doc.TipoDocumentoID;

	END IF;

	-- Lista Combo de Grupo de Documento
	IF(Par_NumLis = Lis_Combo) THEN

		SELECT  Cre.ClasificaTipDocID, Cre.TipoDocumentoID, Cat.ClasificaDesc AS Descripcion
		FROM CREDITODOCENT Cre
		INNER JOIN CLASIFICATIPDOC Cat ON Cre.ClasificaTipDocID = Cat.ClasificaTipDocID
		WHERE Cre.CreditoID = Par_Credito;
	END IF;


	IF(Par_NumLis = Lis_GuardaValores) THEN
		-- Lista de Tipo de Documento
		SELECT Cre.TipoDocumentoID,    Doc.Descripcion
		FROM CREDITODOCENT Cre
		INNER JOIN CLASIFICATIPDOC Cat ON Cre.ClasificaTipDocID = Cat.ClasificaTipDocID
		INNER JOIN TIPOSDOCUMENTOS Doc ON Cre.TipoDocumentoID = Doc.TipoDocumentoID
		WHERE CreditoID = Par_Credito
		 AND Cre.ClasificaTipDocID = Par_ClasificaTipDocID
		 AND Doc.Descripcion LIKE CONCAT('%', Par_Descripcion ,'%');
	END IF;


END TerminaStore$$