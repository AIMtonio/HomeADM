-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSRECEPMENSAJELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSRECEPMENSAJELIS`;DELIMITER $$

CREATE PROCEDURE `SMSRECEPMENSAJELIS`(
# ===============================================
# ----- SP PARA LISTAR MENSAJES POR RECIBIDOS----
# ===============================================
	Par_FechaCon		DATE,
	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

	DECLARE Lis_MensajesRec	INT(11);
	DECLARE	Lis_MenEnv		INT(11);
    DECLARE	Lis_PorEnv		INT(11);
    DECLARE	Lis_MenCan  	INT(11);
	DECLARE Est_Recibido	CHAR(1);
	DECLARE Est_Procesado 	CHAR(1);
    DECLARE Est_Cancelado	CHAR(1);

	SET Lis_MensajesRec		:= 1;
	SET	Lis_MenEnv			:= 2;
    SET Lis_PorEnv			:= 3;
    SET Lis_MenCan  		:= 4;
	SET Est_Recibido		:= 'R';
	SET Est_Procesado		:= 'P';
    SET Est_Cancelado		:= 'C';

	IF (Par_NumLis = Lis_MensajesRec) THEN
		SELECT	RecepMensajeID,	Estatus,	Remitente,	Mensaje,	FechaRealEnvio,
				FechaRecepcion
			FROM 	SMSRECEPMENSAJE
			WHERE	Estatus	= Est_Recibido
			LIMIT 	0, 200;
	END IF;

	IF(Par_NumLis = Lis_MenEnv)THEN
    	SET @row=0;
		SELECT 		(@row:=@row+1) AS Consecutivo,	Remitente,	Mensaje, CAST(FechaRealEnvio AS DATE) AS FechaRealEnvio
			FROM	SMSRECEPMENSAJE
			WHERE	Estatus = Est_Procesado
			AND 	CAST(FechaRealEnvio AS DATE) = Par_FechaCon;
    END IF;


	IF(Par_NumLis = Lis_PorEnv)THEN
		SET @row=0;
		SELECT 		(@row:=@row+1) AS Consecutivo,	Remitente,	Mensaje, CAST(FechaRealEnvio AS DATE)AS FechaRealEnvio
			FROM	SMSRECEPMENSAJE
			WHERE	Estatus = Est_Recibido
			AND 	CAST(FechaRealEnvio AS DATE) = Par_FechaCon;
    END IF;

	IF(Par_NumLis = Lis_MenCan)THEN
		SET @row=0;
		SELECT 		(@row:=@row+1) AS Consecutivo,	Remitente,	Mensaje, CAST(FechaRealEnvio AS DATE)AS FechaRealEnvio
			FROM	SMSRECEPMENSAJE
			WHERE	Estatus = Est_Cancelado
			AND 	CAST(FechaRealEnvio AS DATE) = Par_FechaCon;
    END IF;

END TerminaStore$$