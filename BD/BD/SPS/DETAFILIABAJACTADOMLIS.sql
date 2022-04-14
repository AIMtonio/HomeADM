DELIMITER ;
DROP PROCEDURE IF EXISTS `DETAFILIABAJACTADOMLIS`;

DELIMITER $$
CREATE PROCEDURE `DETAFILIABAJACTADOMLIS`(
	Par_FolioAfiliacion BIGINT(20),			-- Folio con la que se guardo la afiliacion
    Par_NumConsulta		INT(1),				-- Numero de consulta a realizar

    Par_EmpresaID		INT(11),			-- Parametro de auditoria
	Aud_Usuario			INT(11),			-- Parametro de auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal		INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN

	DECLARE Entero_Cero		INT(11);		-- Entero cero
    DECLARE Cadena_Vacia	CHAR(1);		-- Cadena vacia
	DECLARE Con_Afiliacion	INT(11);		-- Consulta para los detalles de un folio de afiliacion;
    DECLARE Emp_NomVacia	CHAR(1);

    SET Entero_Cero := 0;
    SET Cadena_Vacia := '';
    SET Emp_NomVacia := '.';
	SET Con_Afiliacion	:=5;


    IF Par_NumConsulta = Con_Afiliacion THEN
		SELECT 	FolioAfiliacion, 											Referencia, 								ClienteID, 		NombreCompleto, 	EsNomina,
		IFNULL(InstitNominaID,Entero_Cero) AS InstitNominaID, IFNULL(NombreEmpNomina,Emp_NomVacia) AS NombreEmpNomina, InstitBancaria, 	NombreBanco,		Clabe,
                Convenio, Comentario, EstatusDomicilia
		FROM DETAFILIABAJACTADOM
        WHERE FolioAfiliacion =Par_FolioAfiliacion;
    END IF;

END TerminaStore$$