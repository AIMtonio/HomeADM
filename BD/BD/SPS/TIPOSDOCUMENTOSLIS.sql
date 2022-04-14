-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSDOCUMENTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSDOCUMENTOSLIS`;
DELIMITER $$


CREATE PROCEDURE `TIPOSDOCUMENTOSLIS`(
# ===================================================================
#				SP PARA LISTAR LOS TIPOS DE DOCUMENTOS
# ===================================================================
	Par_Descripcion		VARCHAR(60),		-- Parametro descripcion
	Par_RequeridoEn		CHAR(1),			-- Parametro Requerido en
	Par_NumLis			TINYINT UNSIGNED,	-- Parametro Numero de lista

	-- Parametros de auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)

TerminaStore: BEGIN


	-- declaracion de constantes
	DECLARE	Lis_Combo 				INT(11);
	DECLARE	Lis_Combok				INT(11);
	DECLARE	Var_RequeridoEn  		CHAR(1);
	DECLARE	List_Principal			INT(11);
	DECLARE	Lis_TiposDocumento		INT(11);
	DECLARE	Lis_DocumentosCTEEXP	INT(11);
	DECLARE	Lis_WSMilagro			INT(11);
	DECLARE	RequeridoEn_Estatus		CHAR(1);

	-- asignacion de constantes
	SET		Lis_Combo				:= 1;	-- Lista combo
	SET 	Lis_Combok       		:= 2;	-- Lista combok
	SET 	List_Principal			:= 3;	-- Constante lista principal
	SET 	Var_RequeridoEn  		:= 'K'; -- Parametro Requerido en
	SET		Lis_TiposDocumento		:= 4;	-- Tipo de lista para mostrar los tipos de documentos
	SET		Lis_DocumentosCTEEXP	:= 5;	-- Tipo de lista para mostrar los tipos de documentos Requeridos en el Expediente del CTE
	SET		Lis_WSMilagro			:= 6;	-- Tipo de lista para mostrar los tipos de documentos en el ws de confiadora
	SET		RequeridoEn_Estatus		:= 'Q';	-- Estatus para mostrar el Documento

	IF(Par_NumLis = Lis_Combo) THEN
		SELECT	TipoDocumentoID,	Descripcion
			FROM	TIPOSDOCUMENTOS
				WHERE 	RequeridoEn  LIKE CONCAT("%", Par_RequeridoEn, "%");
	END IF;

	IF(Par_NumLis = Lis_Combok) THEN
		SELECT	TipoDocumentoID,Descripcion
			FROM	TIPOSDOCUMENTOS
				WHERE	RequeridoEn  LIKE CONCAT("%", Var_RequeridoEn, "%");
	END IF;

	IF Par_NumLis=List_Principal THEN
		SELECT	TipoDocumentoID,	Descripcion
			FROM	TIPOSDOCUMENTOS
				WHERE	Descripcion  LIKE CONCAT("%", Par_Descripcion, "%")
				AND 	Estatus	= "A" LIMIT 0,15;

	END IF;

	-- Consulta Lista Documentos con RequeridoEn=Q
	IF(Par_NumLis = Lis_TiposDocumento)THEN
		SELECT	td.TipoDocumentoID,	td.Descripcion
			FROM	TIPOSDOCUMENTOS	td
				WHERE	RequeridoEn	LIKE CONCAT("%", RequeridoEn_Estatus, "%")
				AND 	td.Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
				LIMIT	0, 15;
	END IF;

		-- Consulta Lista Documentos requeridos en el expediente del cte
	IF(Par_NumLis = Lis_DocumentosCTEEXP)THEN
		SELECT	td.TipoDocumentoID,	td.Descripcion
			FROM	TIPOSDOCUMENTOS	td
				WHERE	RequeridoEn	LIKE CONCAT("%C%")
				AND 	td.Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
				LIMIT	0, 15;
	END IF;

	IF(Par_NumLis = Lis_WSMilagro) THEN
			SELECT	TipoDocumentoID, Descripcion, RequeridoEn, Estatus
			FROM	TIPOSDOCUMENTOS
				WHERE 	RequeridoEn  LIKE CONCAT("%", Par_RequeridoEn, "%");
	END IF;

END TerminaStore$$