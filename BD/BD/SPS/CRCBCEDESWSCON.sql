-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCEDESWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCEDESWSCON`;DELIMITER $$

CREATE PROCEDURE `CRCBCEDESWSCON`(
	/*SP para listar las amortizaciones de credito para WS Crediclub*/
	Par_CedeID			BIGINT(12),		-- ID de la cede
    Par_NumCon			INT(11),		-- Numero de Consulta
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
	-- Declaracion de Constantes
    DECLARE Var_EstatusISR		CHAR(1);
    DECLARE Var_TasaISR			DECIMAL(14,2);
    DECLARE Var_Dias			INT(11);

	-- Declaracion de Constantes
    DECLARE Entero_Cero			CHAR(1);
    DECLARE Con_Amortizacion	INT(11);
	DECLARE Con_Cedes			INT(11);
	DECLARE Est_Vigente			CHAR(1);
    DECLARE Est_Pagada			CHAR(1);
	DECLARE Est_Regis			CHAR(1);
	DECLARE Esta_Activo			CHAR(1);
    DECLARE EstatusPag			VARCHAR(15);
	DECLARE EstatusVig			VARCHAR(15);
	DECLARE EstatusReg			VARCHAR(15);

    -- Asignacion de Constantes
    SET Entero_Cero			:= '0';
	SET Con_Amortizacion	:= 1;
    SET Con_Cedes			:= 2;
    SET Est_Vigente			:= 'N';
    SET Est_Pagada			:= 'P';
	SET Est_Regis			:= 'A';
	SET Esta_Activo			:= 'A';
    SET EstatusPag 			:= 'PAGADA';
    SET EstatusVig			:= 'VIGENTE';
    SET EstatusReg			:= 'REGISTRADA';
	SET Var_EstatusISR		:= (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
	SET Var_EstatusISR		:= IFNULL(Var_EstatusISR, '');

    IF(Par_NumCon=Con_Amortizacion)THEN
		SELECT
			TasaISR,		Plazo
		INTO
			Var_TasaISR,	Var_Dias
		FROM CEDES
			WHERE CedeID = Par_CedeID;

		SELECT  CedeID, 	AmortizacionID,	FechaInicio, 	FechaVencimiento,	FechaPago,
				Capital,	Interes,
				IF(Var_EstatusISR = Esta_Activo, FNISRINFOCAL(Capital, Var_Dias, (Var_TasaISR*100)), InteresRetener) AS InteresRetener,
            CASE WHEN Estatus = Est_Vigente THEN EstatusVig
				 WHEN Estatus = Est_Pagada	THEN EstatusPag
                 END AS Estatus
		FROM AMORTIZACEDES
			WHERE CedeID = Par_CedeID
			GROUP BY AmortizacionID
			ORDER BY AmortizacionID;

    END IF;

    IF(Par_NumCon=Con_Cedes)THEN
		SELECT
			CedeID,  			Monto,			FechaInicio, 	FechaVencimiento, 	FechaPago,
			InteresGenerado,	TasaFija, 		TasaISR, 		ValorGatReal,		Plazo,
			IF(Var_EstatusISR = Esta_Activo, FNISRINFOCAL(Monto, Plazo, (TasaISR*100)), InteresRetener) AS InteresRetener,
            CASE WHEN Estatus = Est_Vigente THEN EstatusVig
				 WHEN Estatus = Est_Regis	THEN EstatusReg
                 END AS Estatus, Entero_Cero  AS NumErr
		FROM CEDES
			WHERE CedeID = Par_CedeID;

    END IF;

END TerminaStore$$