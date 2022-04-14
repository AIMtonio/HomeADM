-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDARCHIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDARCHIVOSCON`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDARCHIVOSCON`(
	/* SP QUE CONSULTA CUANTOS DOCUMENTOS DIGITALIZADOS TIENE EL CLIENTE */
	Par_SolicitudCreditoID		BIGINT(20),
	Par_NumCon					TINYINT UNSIGNED,

    -- Parametros de Auditoria --
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
		)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	ConsulCantDoc	INT;

	-- Asignacion de valores a constantes
	SET	Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET ConsulCantDoc	 	:= 1;


	/* Consulta para Contar Cuantos Documentos Digitalizados tiene un Credito */
	IF(Par_NumCon = ConsulCantDoc) THEN
		SELECT COUNT(TipoDocumentoID)
		FROM SOLICITUDARCHIVOS
		WHERE SolicitudCreditoID	= Par_SolicitudCreditoID
		ORDER BY TipoDocumentoID ASC, DigSolID DESC;

	END IF;

END TerminaStore$$