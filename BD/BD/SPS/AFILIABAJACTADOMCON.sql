DELIMITER ;
DROP PROCEDURE IF EXISTS `AFILIABAJACTADOMCON`;

DELIMITER $$
CREATE PROCEDURE `AFILIABAJACTADOMCON`(
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

    DECLARE Var_Clabe	VARCHAR(10);
    DECLARE Var_ClabeBanco VARCHAR(3);
    DECLARE Var_ClienteID INT(11);

	DECLARE Entero_Cero		INT(11);		-- Entero cero
    DECLARE Cadena_Vacia	CHAR(1);		-- Cadena vacia
	DECLARE Con_Archivo		INT(11);		-- consulta para saber el archivo que se generara
    DECLARE Con_Afiliacion	INT(11);
    DECLARE BancoDomiciliado  VARCHAR(30);

    SET BancoDomiciliado := 'ClabeBancoDomiciliacion';
    SET Entero_Cero := 0;
    SET Cadena_Vacia := '';
    SET Con_Archivo := 2;
	SET Con_Afiliacion	:=3;

	IF Par_NumConsulta = Con_Archivo THEN
		SELECT ClabeInstitBancaria INTO Var_Clabe
		FROM PARAMETROSSIS;

        SELECT ValorParametro INTO Var_ClabeBanco
        FROM PARAMGENERALES
        WHERE LlaveParametro =BancoDomiciliado;
        
		SELECT NombreArchivo,Var_Clabe AS ClabeBancoInst,
        Var_ClabeBanco AS FolioBanco,TipoOperacion
        FROM AFILIABAJACTADOM
        WHERE FolioAfiliacion = Par_FolioAfiliacion;
    END IF;


    IF Par_NumConsulta = Con_Afiliacion THEN
		SELECT COUNT(ClienteID) INTO Var_ClienteID
        FROM DETAFILIABAJACTADOM
        WHERE FolioAfiliacion = Par_FolioAfiliacion;

		SELECT D.FolioAfiliacion,
			CASE  WHEN Var_ClienteID=1 THEN D.ClienteID WHEN  Var_ClienteID>1 THEN Entero_Cero END AS ClienteID,
            CASE WHEN Var_ClienteID=1 THEN D.NombreCompleto WHEN  Var_ClienteID>1 THEN 'TODOS' END AS NombreCompleto,
            D.EsNomina, D.InstitNominaID,
            CASE D.InstitNominaID WHEN Entero_Cero THEN 'TODOS' ELSE D.NombreEmpNomina END AS NombreEmpNomina,
            D.Convenio, A.Estatus,A.TipoOperacion
        FROM DETAFILIABAJACTADOM D
        LEFT JOIN AFILIABAJACTADOM A ON D.FolioAfiliacion = A.FolioAfiliacion
        WHERE A.FolioAfiliacion = Par_FolioAfiliacion LIMIT 1;

    END IF;
END TerminaStore$$