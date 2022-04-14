-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTAARCHIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTAARCHIVOSCON`;DELIMITER $$

CREATE PROCEDURE `CUENTAARCHIVOSCON`(
	Par_CuentaAhoID		BIGINT(12),			-- id de cuenta ahorro
	Par_TipoDocumen 	INT(11),			-- parametro de tipo de documento
	Par_ArchivCtaID		INT(11),			-- parametro archivo cuenta id
	Par_NumCon			TINYINT UNSIGNED,	-- Parametro numero de consulta

    /* Parametros de Auditoria */
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
	DECLARE	Cadena_Vacia		CHAR(1);	-- constante cadena vacia
	DECLARE	Fecha_Vacia			DATE;		-- constante fecha vacia
	DECLARE	Entero_Cero			INT(11);	-- constante entero cero
	DECLARE	Con_Principal		INT(11);	-- constante consulta principal
	DECLARE	Con_Foranea			INT(11);	-- constante consulta foranea
	DECLARE Con_Todos			INT(11);	-- constante consulta todos los archivos de una cuenta
    DECLARE	Con_NumeroSiguien	INT(11);	-- constante numero siguiente
	DECLARE	Con_VerArchivos		INT(11);	-- constante ver archivos
	DECLARE	Con_VerFirma		INT(11);	-- constante ver firma
	-- asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Con_Principal		:= 3;
	SET	Con_Foranea			:= 4;

    SET	Con_NumeroSiguien	:= 5;
	SET	Con_VerArchivos		:= 11;
	SET	Con_VerFirma		:= 12;

    SET Con_Todos			:=14;

	IF(Par_NumCon = Con_Principal) THEN
		SELECT	CuentaAhoID,	TipoDocumento,	ArchivoCtaID,	Consecutivo,	Observacion,
				Recurso
			FROM	CUENTAARCHIVOS
				WHERE	CuentaAhoID		= Par_CuentaAhoID
				AND		TipoDocumento	= Par_TipoDocumen
				AND		ArchivoCtaID	= Par_ArchivCtaID;
	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT	CuentaAhoID,	ArchivoCtaID,	TipoDocumento
			FROM	CUENTAARCHIVOS
				WHERE	CuentaAhoID 	= Par_CuentaAhoID
				AND		TipoDocumento 	= Par_TipoDocumen
				AND		ArchivoCtaID 	= Par_ArchivCtaID;
	END IF;

	/*Consulta para obtener el siguiente numero que se insertara*/
	IF(Par_NumCon = Con_NumeroSiguien) THEN
		SELECT IFNULL(MAX(ArchivoCtaID),Entero_Cero)+1
			FROM CUENTAARCHIVOS
				WHERE CuentaAhoID = Par_CuentaAhoID;
	END IF;


	/*Consulta para ver los archivos de la cuenta*/
	IF(Par_NumCon = Con_VerArchivos) THEN
		SELECT 	CuentaAhoID,	TipoDocumento,	ArchivoCtaID,	Consecutivo,	Observacion,
				Recurso
			FROM CUENTAARCHIVOS
				WHERE	CuentaAhoID		= Par_CuentaAhoID
				AND		TipoDocumento	= Par_TipoDocumen
				AND		ArchivoCtaID	= Par_ArchivCtaID
				LIMIT 1;
	END IF;

	/*Consulta para ver las firmas*/
	IF(Par_NumCon = Con_VerFirma) THEN
		SELECT 	CuentaAhoID,	TipoDocumento,	ArchivoCtaID,	Consecutivo,	Observacion,
				Recurso
			FROM	CUENTAARCHIVOS	INNER JOIN	PARAMETROSSIS ps
				WHERE	CuentaAhoID		= Par_CuentaAhoID
				AND		TipoDocumento	= ps.TipoDocumentoFirma
				LIMIT 1;
	END IF;

	IF(Par_NumCon = Con_Todos) THEN
     SELECT COUNT(CA.CuentaAhoID) numeroDocumentos,C.ClienteID AS clienteID
     FROM CUENTAARCHIVOS CA
     INNER JOIN CUENTASAHO CAH ON CA.CuentaAhoID = CAH.CuentaAhoID
     INNER JOIN CLIENTES C ON CAH.ClienteID = C.ClienteID
     WHERE CA.CuentaAhoID	= Par_CuentaAhoID;
    END IF;
END TerminaStore$$