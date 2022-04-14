DELIMITER ;
DROP PROCEDURE IF EXISTS `AFILIABAJACTADOMLIS`;

DELIMITER $$
CREATE PROCEDURE `AFILIABAJACTADOMLIS`(
	/*SP que sirve para realizar el listado de archivos de afiliacion*/
    Par_FolioAfiliacion BIGINT(20),			-- Folio que identifca a la afiliacion
    Par_NombreArchivo	VARCHAR(50),		-- Nombre del archivo
    Par_NumLista		INT(11),			-- Numero de lista

	Par_EmpresaID		INT(11),			-- Parametro de auditoria
	Aud_Usuario			INT(11),			-- Parametro de auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal		INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria
)

TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Lis_Principal	INT(11);

    -- Sereo de constantes y variables
    SET Entero_Cero		:= 0;
    SET Cadena_Vacia	:='';
    SET Lis_Principal	:=4;


    IF Par_NumLista = Lis_Principal THEN
		SELECT FolioAfiliacion,NombreArchivo
        FROM AFILIABAJACTADOM
        WHERE NombreArchivo LIKE(CONCAT("%", Par_NombreArchivo, "%"))
        LIMIT 15;
    END IF;
END TerminaStore$$