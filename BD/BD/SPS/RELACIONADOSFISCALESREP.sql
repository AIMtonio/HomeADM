-- SP RELACIONADOSFISCALESREP

DELIMITER ;

DROP PROCEDURE IF EXISTS RELACIONADOSFISCALESREP;

DELIMITER $$

CREATE PROCEDURE `RELACIONADOSFISCALESREP`(
# ====================================================================================
# ------ STORED REPORTE DE PREELACIONADOS FISCALES------------------------------------
# ====================================================================================
	Par_Ejercicio			INT(11),		-- Anio del Ejercicio
	Par_ClienteID			INT(11), 		-- ID de cliente

	Par_EmpresaID       	INT(11),		-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),		-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore:begin

	-- Declaracion de Variable
	DECLARE	Var_Sentencia	VARCHAR(10000);
    DECLARE Var_FechaSistema	DATE;

	-- Declaracion de Contantes
	DECLARE Entero_Cero		INT(1);			-- Entero Cero
	DECLARE Entero_Uno		INT(1);			-- Entero Uno
    DECLARE Cadena_Vacia	CHAR(1);		-- Cadena Vacia
	DECLARE Decimal_Cero	DECIMAL(14,2);	-- Decimal Cero
	DECLARE Fecha_Vacia		DATE;			-- Fecha Vacia


	-- Asignacion de Constantes
	SET Entero_Cero	  	:= 0;
	SET Entero_Uno	  	:= 1;
    SET Cadena_Vacia	:= '';
	SET Decimal_Cero   	:= 0.0;
	SET Fecha_Vacia	  	:= '1900-01-01';

	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT Entero_Uno);

    SELECT 	CASE CON.Tipo WHEN "A" THEN "APORTANTE" ELSE "RELACIONADO" END AS Tipo,
			CASE CON.Tipo WHEN "A" THEN CON.ClienteID ELSE CON.CteRelacionadoID END AS Numero,
			CON.NombreCompleto AS Nombre,
            CASE CON.TipoPersona WHEN "F" THEN "FISICA"
								WHEN "A" THEN "FISICA CON ACTIVIDAD EMP."
                                ELSE "" END AS TipoPersona,
			CASE CON.Nacion WHEN "N" THEN "NACIONAL"
							WHEN "E" THEN "EXTRANJERO" END AS Nacion,
			CONCAT(CON.PaisResidencia,"-",PAI.Nombre) AS PaisResidencia,
            CASE CON.RegHacienda WHEN "S" THEN "SI"
								WHEN "N" THEN "NO" END AS registroHacienda,
			CON.RFC AS RFC,		CON.CURP AS CURP,			CON.DireccionCompleta AS DomicilioFiscal,
			CON.ParticipaFiscal AS ParticipacionFiscal,	CON.MontoCapital AS Capital,
            IF(CON.MontoIntReal > Entero_Cero, CON.MontoIntReal,Entero_Cero) AS InteresRealPeriodo,
            (CON.MontoTotGrav + CON.MontoTotExent) AS InteresNominalPeriodo,
            MontoTotRet AS ISRRetenido,
			IF(CON.MontoIntReal < Entero_Cero, (CON.MontoIntReal*-1),Entero_Cero) AS PerdidaReal
	FROM CONSTANCIARETCTEREL CON
		LEFT JOIN PAISES PAI
			ON CON.PaisResidencia = PAI.PaisID
    WHERE CON.Anio = Par_Ejercicio
		AND IF(Par_ClienteID > Entero_Cero,
				(CON.ClienteID	= Par_ClienteID),
				(CON.ClienteID	> Entero_Cero)
			)
	ORDER BY CON.ClienteID, CON.Tipo ASC;

END TerminaStore$$