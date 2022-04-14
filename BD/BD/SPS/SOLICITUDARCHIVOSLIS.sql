-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDARCHIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDARCHIVOSLIS`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDARCHIVOSLIS`(
	-- Proceso para el listado de archivos
	Par_SolicitudCreditoID	BIGINT(20),			-- ID de la solicitud de credito
	Par_TipoDocumento		INT(11),			-- ID del tipo documento
	Par_Comentario			VARCHAR(200),		-- Comentario del documento
	Par_Recurso				VARCHAR(200),		-- Recurso del documento
	Par_Fecha       		DATE,				-- Parametro de la fecha

	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista
	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	PrincipalSolLis	INT(11);
	DECLARE	LisPorTipoDoc   INT(11);
	DECLARE Cons_No         CHAR(1);

	-- Asignacion de valores a constantes

	SET     Cadena_Vacia        := '';
	SET     Fecha_Vacia         := '1900-01-01';
	SET     Entero_Cero         := 0;
	SET     PrincipalSolLis 	:= 1;
	SET     LisPorTipoDoc       := 2;
	SET     Cons_No             := 'N';


	/* Lista Principal para Todos los Documentos Digitalizados de una Solicitud de Credito */
	IF(Par_NumLis = PrincipalSolLis) THEN
		SELECT  Arch.DigSolID,	Arch.SolicitudCreditoID,	Arch.TipoDocumentoID,	Clas.ClasificaDesc AS Descripcion,	Arch.Comentario,
				Arch.Recurso,	SCred.GrupoID, 				SCred.CicloGrupo, 		GCred.NombreGrupo
		FROM SOLICITUDARCHIVOS AS Arch
			LEFT JOIN CLASIFICATIPDOC AS Clas
				ON Arch.TipoDocumentoID  = Clas.ClasificaTipDocID
			LEFT JOIN SOLICITUDCREDITO AS SCred
				ON SCred.SolicitudCreditoID  = Arch.SolicitudCreditoID
			LEFT JOIN GRUPOSCREDITO AS GCred
				ON GCred.GrupoID = SCred.GrupoID
		WHERE Arch.SolicitudCreditoID = Par_SolicitudCreditoID
		ORDER BY Arch.TipoDocumentoID ASC,
				 Arch.DigSolID DESC;

	END IF;


	/* Lista Principal para Todos los Documentos Digitalizados de una Solicitud de Credito de un Tipo de Documento Particular*/
	IF(Par_NumLis = LisPorTipoDoc) THEN
		IF (Par_TipoDocumento != 9999)THEN
			SELECT  Arch.DigSolID,  Arch.SolicitudCreditoID,	Arch.TipoDocumentoID, 	Clas.ClasificaDesc AS Descripcion,    Arch.Comentario,
				Arch.Recurso,	IFNULL(Arch.VoBoAnalista,Cons_No) AS VoBoAnalista ,	Arch.ComentarioAnalista
			FROM SOLICITUDARCHIVOS Arch,
				 CLASIFICATIPDOC Clas
			WHERE Arch.SolicitudCreditoID	= Par_SolicitudCreditoID
			  AND Arch.TipoDocumentoID  = Par_TipoDocumento
			  AND Arch.TipoDocumentoID  = Clas.ClasificaTipDocID
			ORDER BY  Arch.DigSolID DESC;
        ELSE
			SELECT  Arch.DigSolID,  Arch.SolicitudCreditoID,	Arch.TipoDocumentoID, 	Clas.ClasificaDesc AS Descripcion,    Arch.Comentario,
				Arch.Recurso,	IFNULL(Arch.VoBoAnalista,Cons_No) AS VoBoAnalista ,	Arch.ComentarioAnalista
			FROM SOLICITUDARCHIVOS Arch,
				 CLASIFICATIPDOC Clas
			WHERE Arch.SolicitudCreditoID	= Par_SolicitudCreditoID
			  AND Arch.TipoDocumentoID  = Clas.ClasificaTipDocID
			ORDER BY  Arch.DigSolID ASC;
        END IF;


	END IF;

END TerminaStore$$