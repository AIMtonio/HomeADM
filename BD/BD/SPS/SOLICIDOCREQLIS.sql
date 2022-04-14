-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCREQLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICIDOCREQLIS;

DELIMITER $$
CREATE PROCEDURE `SOLICIDOCREQLIS`(
	-- Store Procedure de tipo lista para los documentos relacionados a una solicitud de credito
	Par_ClasificaTipDocID	INT(11),		-- Clasificacion de Tipo de Documento
	Par_ProducCreID  		INT(11),		-- Producto de Credito
	Par_Decripcion			VARCHAR(100),	-- Descripcion del Documento
	Par_NumLis				TINYINT UNSIGNED,-- Numero de Lista

	Par_EmpresaID       	INT(11),		-- Parametro de Auditoria Empresa
	Aud_Usuario         	INT(11),		-- Parametro de Auditoria Usuario
	Aud_FechaActual     	DATETIME,		-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP    		VARCHAR(15),	-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID     		VARCHAR(50),	-- Parametro de Auditoria Programa ID
	Aud_Sucursal        	INT(11),		-- Parametro de Auditoria Sucursal
	Aud_NumTransaccion  	BIGINT(20)		-- Parametro de Auditoria Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia                CHAR(1);
	DECLARE Fecha_Vacia                 DATETIME;
	DECLARE Entero_Cero                 INT(11);
	DECLARE Con_Str_SI                  CHAR(1);
	DECLARE Con_Str_NO                  CHAR(1);
	DECLARE Si_Asignado                 CHAR(1);
	DECLARE No_Asignado                 CHAR(1);
	DECLARE Cla_RevisionMesaControl     INT(11);

	DECLARE Lis_Principal               INT(11);
	DECLARE Lis_DocProducto             INT(11);
	DECLARE Lis_DocSolPro           	INT(11);
	DECLARE Lis_GuardaValores			INT(11);

	-- Asignacion de constantes
	SET Cadena_Vacia                    := '';              -- Cadena o String Vacio
	SET Fecha_Vacia                     := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero                     := 0;               -- Entero en Cero
	SET Con_Str_SI                      := 'S';             -- String valor : SI
	SET Con_Str_NO                      := 'N';             -- String valor : NO
	SET Si_Asignado                     := 'S';             -- El Documento SI esta Asignado
	SET No_Asignado                     := 'N';             -- El Documento NO esta Asignado
	SET Cla_RevisionMesaControl         := 9998;            -- Clasificacion de Documentos que es comentario para el de Mesa de control y que esta por default en el sistema (no se parametriza)

	SET Lis_Principal                   := 1;               -- Lista principal
	SET Lis_DocProducto                 := 2;               -- Lista de documentacion por producto de credito
	SET Lis_DocSolPro					:= 3;				-- Lista Documentos por producto credito
	SET Lis_GuardaValores				:= 4;				-- Lista Documentos para Guarda Valores

	/* 1.- Consulta todos los Documentos por Clasificacion de Documentos */
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT Grp.TipoDocumentoID, Doc.Descripcion
		FROM CLASIFICAGRPDOC Grp,
			 TIPOSDOCUMENTOS Doc
		WHERE Grp.ClasificaTipDocID = Par_ClasificaTipDocID
		  AND Grp.TipoDocumentoID = Doc.TipoDocumentoID
		ORDER BY Grp.TipoDocumentoID;
	END IF;

	-- Lista de documentos solicitados por producto de credito
	IF(Par_NumLis = Lis_DocProducto) THEN

		SELECT Cla.ClasificaTipDocID,	Cla.ClasificaDesc,
				CASE WHEN IFNULL(Sol.ClasificaTipDocID, Entero_Cero) = Entero_Cero THEN No_Asignado
					ELSE Si_Asignado
					END	AS Asignado
				FROM CLASIFICATIPDOC Cla
				LEFT OUTER JOIN SOLICIDOCREQ AS Sol ON  Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
													AND Sol.ProducCreditoID = Par_ProducCreID
				WHERE Cla.ClasificaTipDocID <> Cla_RevisionMesaControl;

	END IF;

	IF(Par_NumLis = Lis_DocSolPro) THEN

		SELECT  Cla.ClasificaTipDocID,	Cla.ClasificaDesc,
				CASE WHEN IFNULL(Sol.ClasificaTipDocID, Entero_Cero) = Entero_Cero THEN No_Asignado
					ELSE Si_Asignado
					END	AS Asignado
				FROM CLASIFICATIPDOC Cla
				LEFT OUTER JOIN SOLICIDOCREQ AS Sol ON  Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
													AND Sol.ProducCreditoID = Par_ProducCreID
				WHERE Cla.ClasificaTipDocID <> Cla_RevisionMesaControl
				AND IFNULL(Sol.ClasificaTipDocID, Entero_Cero) <> Entero_Cero;

	END IF;

	-- Lista Documentos para Guarda Valores
	IF( Par_NumLis = Lis_GuardaValores ) THEN
		SELECT Grp.TipoDocumentoID, Doc.Descripcion
		FROM CLASIFICAGRPDOC Grp,
			 TIPOSDOCUMENTOS Doc
		WHERE Grp.ClasificaTipDocID = Par_ClasificaTipDocID
		  AND Grp.TipoDocumentoID = Doc.TipoDocumentoID
		  AND Doc.Descripcion LIKE CONCAT('%',Par_Decripcion,'%')
		ORDER BY Grp.TipoDocumentoID;

	END IF;

END TerminaStore$$