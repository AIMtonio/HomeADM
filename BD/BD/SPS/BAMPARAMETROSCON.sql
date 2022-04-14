-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPARAMETROSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPARAMETROSCON`;DELIMITER $$

CREATE PROCEDURE `BAMPARAMETROSCON`(
-- SP que consulta los parametros para algunas acciones que realiza la banca electronica, envio de correos etc.
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
	Par_EmpresaID       	INT(11),			-- Auditoria

    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria

    Aud_NumTransaccion  	BIGINT(20)			-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Con_Principal				INT; -- Consulta pricipal
    DECLARE Con_MensajeActivacionSMS	INT; -- Consulta texto sms activacion
    DECLARE Con_rutaKtr					INT; -- Consulta ruta ktr SMS
	-- Asignacion de Constantes
	SET	Con_Principal					:= 1;
	SET	Con_MensajeActivacionSMS		:= 2;
    SET Con_RutaKtr						:= 3;

	IF (Par_NumCon=Con_Principal) THEN
	SELECT
		EmpresaID, 					MensajeCodigoActSMS, 	 	PasswordCorreoBancaMovil, 	PuertoCorreoBancaMovil,   RutaArchivos,
        RutaCorreosBancaMovil, 		ServidorCorreoBancaMovil, 	SubjectAltaBancaMovil,    	SubjectCambiosBancaMovil, SubjectPagosBancaMovil,
        SubjectSessionBancaMovil,	SubjectTransferBancaMovil, TiempoValidezSMS, 			UsuarioCorreoBancaMovil,  RemitenteCorreo,
        TipoPagoCapital, 			PermiteGrupal, 				NombreInstitucion
	FROM BAMPARAMETROS;

    ELSEIF (Par_NumCon=Con_MensajeActivacionSMS) THEN
	SELECT MensajeCodigoActSMS
	FROM BAMPARAMETROS;

    ELSEIF (Par_NumCon=Con_RutaKtr) THEN
	SELECT RutaCorreosBancaMovil
	FROM BAMPARAMETROS;

	END IF;


END TerminaStore$$