-- SP BANSOLICIDOCREQLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS BANSOLICIDOCREQLIS;

DELIMITER $$

CREATE PROCEDURE BANSOLICIDOCREQLIS(
	Par_ProducCreID  		INT(11),			-- Producto de Credito
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista
	
	Par_EmpresaID			INT(11),				-- Parametro de auditoria
	Aud_Usuario				INT(11),				-- Parametro de auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Fecha_Vacia					DATETIME;
	DECLARE Entero_Cero					INT(11);
	DECLARE Si_Asignado					CHAR(1);
	DECLARE No_Asignado					CHAR(1);
	DECLARE Cla_RevisionMesaControl		INT(11);

	DECLARE Lis_DocProducto				INT(11);
	DECLARE Lis_DocSolPro				INT(11);
	
	-- Asignacion de constantes
	SET Cadena_Vacia					:= '';				-- Cadena o String Vacio
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero en Cero
	SET Si_Asignado						:= 'S';				-- El Documento SI esta Asignado
	SET No_Asignado						:= 'N';				-- El Documento NO esta Asignado
	SET Cla_RevisionMesaControl			:= 9998;			-- Clasificacion de Documentos que es comentario para el de Mesa de control y que esta por default en el sistema (no se parametriza)

	SET Lis_DocProducto					:= 1;				-- Lista de documentacion por producto de credito
	SET Lis_DocSolPro					:= 2;				-- Lista Documentos por producto credito
		
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
END TerminaStore$$
