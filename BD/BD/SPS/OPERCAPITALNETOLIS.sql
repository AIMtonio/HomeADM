-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERCAPITALNETOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERCAPITALNETOLIS`;
DELIMITER $$


CREATE PROCEDURE `OPERCAPITALNETOLIS`(
# =========================================================================================
# -------SP PARA LISTAR LAS OPERACIONES QUE SUPERAN EL PORCENTAJE DEL CAPITAL NETO --------
# =========================================================================================
	Par_PantallaOrigen		VARCHAR(3),             -- PANTALLA DE LA OPERACION\n AS.-Autorizacion Solicitud Cred.\n AI.-Autorizacion Inversion\n AC.-Autorizacion CEDE\n AC.-ABONO A CUENTA
	Par_Descripcion			VARCHAR(200),           -- DESCRIPCION
	Par_NumLis				TINYINT UNSIGNED,       -- NUMERO DE LISTAS

	Aud_EmpresaID			INT(11),                -- AUDITORIA
	Aud_Usuario				INT(11),                -- AUDITORIA
	Aud_FechaActual			DATETIME,               -- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),            -- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),            -- AUDITORIA
	Aud_Sucursal			INT(11),                -- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)              -- AUDITORIA
	)

TerminaStore:BEGIN

    -- DECLARACION DE CONSTANTES
	DECLARE Lis_Principal		INT(11);

    -- ASIGNACION DEC CONSTANTES
	SET Lis_Principal		:=1;


    IF(Par_NumLis = Lis_Principal) THEN
		SELECT  OperacionID,		FechaOperacion,			CLI.NombreCompleto,
				CASE EstatusOper WHEN 'I' THEN 'SIN PROCESAR' WHEN 'A' THEN 'AUTORIZADA' WHEN 'R' THEN 'RECHAZADA' ELSE '' END AS EstatusOper
			FROM	OPERCAPITALNETO OP
			INNER JOIN CLIENTES CLI ON CLI.ClienteID=OP.ClienteID
			WHERE	OP.PantallaOrigen = Par_PantallaOrigen
			AND 	OP.EstatusOper="I"
			AND     CLI.NombreCompleto LIKE CONCAT('%', Par_Descripcion, '%')
			LIMIT 15;
    END IF;

END TerminaStore$$