-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTAARCHIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTAARCHIVOSLIS`;
DELIMITER $$

CREATE PROCEDURE `CUENTAARCHIVOSLIS`(
	Par_CuentaAhoID		BIGINT(12),
	Par_TipoDocumen		VARCHAR(45),
	Par_NumLis			TINYINT UNSIGNED,
	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)

TerminaStore: BEGIN

DECLARE		Cadena_Vacia	CHAR(1);
DECLARE		Fecha_Vacia		DATE;
DECLARE		Entero_Cero		INT;
DECLARE		Lis_Principal	INT;
DECLARE		Lis_CtaArchivo  INT;
DECLARE		Lis_Todas		INT;

SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Lis_Principal	:= 3;
SET	Lis_CtaArchivo	:= 4;
SET Lis_Todas		:= 6;

IF(Par_NumLis = Lis_Principal) THEN
	SELECT ArchivoCtaID,	TipoDocumento,	Consecutivo,	Recurso
	FROM CUENTAARCHIVOS
	WHERE  CuentaAhoID = Par_CuentaAhoID
	AND TipoDocumento = Par_TipoDocumen
	LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_CtaArchivo) THEN
	SELECT ca.ArchivoCtaID,	ca.Observacion,	ca.Recurso, ca.TipoDocumento,	ca.Consecutivo,
	       td.Descripcion
	FROM CUENTAARCHIVOS AS ca
	INNER JOIN TIPOSDOCUMENTOS AS td ON td.TipoDocumentoID=ca.TipoDocumento
	WHERE  CuentaAhoID = Par_CuentaAhoID
	AND ca.TipoDocumento = Par_TipoDocumen
	LIMIT 0, 15;
END IF;
-- lista para todos los documentos de la cuenta
IF(Par_NumLis = Lis_Todas) THEN
	SELECT ca.ArchivoCtaID,	ca.Observacion,	ca.Recurso, td.Descripcion AS TipoDocumento,	ca.Consecutivo, td.Descripcion
	FROM CUENTAARCHIVOS AS ca
    INNER JOIN TIPOSDOCUMENTOS AS td ON td.TipoDocumentoID=ca.TipoDocumento
	WHERE  ca.CuentaAhoID = Par_CuentaAhoID;
END IF;

END$$