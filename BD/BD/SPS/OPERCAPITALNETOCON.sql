-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERCAPITALNETOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERCAPITALNETOCON`;
DELIMITER $$


CREATE PROCEDURE `OPERCAPITALNETOCON`(
# ============================================================================================
# -------SP PARA CONSULTAR LAS OPERACIONES QUE SUPERAN EL PORCENTAJE DEL CAPITAL NETO --------
# ============================================================================================
    Par_PantallaOrigen		VARCHAR(3),				-- PANTALLA ORIGEN
	Par_OperacionID         INT(11),                -- OPERACION ID
	Par_InstrumentoID		BIGINT(12),             -- INSTRUMENTO ID
	Par_NumCon				TINYINT UNSIGNED,       -- NUMERO DE CONSULTA

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
	DECLARE Con_Principal		INT(11);			-- CONSULTA PRINCIPAL
	DECLARE Con_Instrumento		INT(11);			-- CONSULTA FORANEA
	DECLARE Estatus_I			CHAR(1);			-- ESTATUS SIN PROCESAR
	DECLARE Estatus_A			CHAR(1);			-- ESTATUS AUTORIZADA
	DECLARE Estatus_R			CHAR(1);			-- ESTATUS RECHAZADA


    -- ASIGNACION DE CONSTANTES
	SET Con_Principal			:=1;
	SET Con_Instrumento			:=2;
	SET Estatus_I				:='I';
	SET Estatus_A				:='A';
	SET Estatus_R				:='R';



    IF(Par_NumCon = Con_Principal) THEN
        SELECT  OperacionID,		ClienteID,			FechaOperacion,			ProductoID,				CapitalNeto,
                Porcentaje,			MontoOper,			Comentario,				OrigenOperacion,		PantallaOrigen,
				InstrumentoID,		Mensaje,			CASE EstatusOper WHEN 'I' THEN 'SIN PROCESAR' WHEN 'A' THEN 'AUTORIZADA' WHEN 'R' THEN 'RECHAZADA' ELSE '' END AS EstatusOper,
				SucursalCliID
        FROM	OPERCAPITALNETO
        WHERE	OperacionID = Par_OperacionID
		AND 	PantallaOrigen = Par_PantallaOrigen
		LIMIT 1;
    END IF;

	IF(Par_NumCon = Con_Instrumento) THEN
        SELECT  OperacionID,		ClienteID,			FechaOperacion,			ProductoID,				CapitalNeto,
                Porcentaje,			MontoOper,			Comentario,				OrigenOperacion,		PantallaOrigen,
				InstrumentoID,		Mensaje,			CASE EstatusOper WHEN 'I' THEN 'SIN PROCESAR' WHEN 'A' THEN 'AUTORIZADA' WHEN 'R' THEN 'RECHAZADA' ELSE '' END AS EstatusOper,
				SucursalCliID
        FROM	OPERCAPITALNETO
        WHERE	InstrumentoID = Par_InstrumentoID
		AND 	PantallaOrigen = Par_PantallaOrigen
		LIMIT 1;
    END IF;

END TerminaStore$$