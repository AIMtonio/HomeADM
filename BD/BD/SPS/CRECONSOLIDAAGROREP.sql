-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROREP`;
DELIMITER $$

CREATE PROCEDURE `CRECONSOLIDAAGROREP`(
	-- =========================================================================
	-- ----------SP PARA GENERAR EL REPORTE DE  CREDITOS CONSOLIDADOS-----------
	-- =========================================================================
    Par_FechaInicio		    DATE,			-- Fecha de Incio de corte
	Par_FechaFin		    DATE,			-- Fecha Final de corte
    Par_ProductoCreditoID   INT(11),		-- Id del Prodcucto de Crédito
    Par_Estatus 			CHAR(1),		-- Estatus del Credito
	Par_Sucursal		    INT(11),		-- Numero de Sucursal
    Par_FolioConsolidaID    BIGINT(12),     -- Folio de Consolidacion Agro

	Par_NumList			TINYINT UNSIGNED,
	/*Auditoria*/
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia 			TEXT(6000);
	DECLARE Var_Contador			INT(11);
	DECLARE Var_MaxRegistro			INT(11);
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE Var_EstatusCredito		CHAR(1);
	DECLARE Var_FechaCorte			DATE;
	DECLARE Var_FechaPago			DATE;

	 -- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT(11);
	DECLARE Decimal_Cero    		DECIMAL(14,4);
    DECLARE Lis_Encabezado			INT;
    DECLARE Lis_Detalle 			INT;
	DECLARE EstatusAtras			CHAR(1);
	DECLARE EstatusPagado			CHAR(1);
	DECLARE EstatusVencido			CHAR(1);
	DECLARE EstatusVigente			CHAR(1);
	DECLARE FechaSist				DATE;
	DECLARE EstTodos				CHAR(1);
	DECLARE Entero_Uno     			INT(11);


	-- Asignacion de constantes
	SET Cadena_Vacia    := '';              	-- Cadena Vacia
	SET Fecha_Vacia     := '1900-01-01';    	-- Fecha Vacia
	SET Entero_Cero		:= 0;					-- Entero en Cero
	SET Decimal_Cero    := 0.00;            	-- Decimal en Cero

	SET Lis_Encabezado				:= 1;
    SET Lis_Detalle                 := 2;
    SET EstatusAtras				:= 'A';
	SET EstatusPagado				:= 'P';
	SET EstatusVencido				:= 'B';
	SET EstatusVigente				:= 'V';
	SET EstTodos					:= 'T';
	SET Entero_Uno					:= 1;
	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);


	IF(Par_NumList = Lis_Encabezado) THEN


        SET Var_Sentencia :=  'SELECT CRE.CreditoID, CONCAT(PRO.ProducCreditoID, "-", PRO.Descripcion) AS ProductoCredito, ';
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,'        CONCAT(CLI.ClienteID, "-", CLI.NombreCompleto) AS NombreCliente, CRE.FechaInicio, ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,'        SUC.SucursalID, SUC.NombreSucurs,');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,'        CASE CRE.Estatus WHEN "I" THEN "INACTIVO"
                                                                WHEN "A" THEN "AUTORIZADO"
                                                                WHEN "V" THEN "VIGENTE"
                                                                WHEN "P" THEN "PAGADO"
                                                                WHEN "C" THEN "CANCELADO"
                                                                WHEN "B" THEN "VENCIDO"
                                                                WHEN "K" THEN "CASTIGADO"
                                                                END AS Estatus, ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,'        CRE.MontoCredito,  CON.MontoConsolidado, CON.FolioConsolida');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CRECONSOLIDAAGROENC CON ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,'     INNER JOIN CREDITOS CRE ON CON.CreditoID = CRE.CreditoID ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,'     INNER JOIN PRODUCTOSCREDITO PRO ON CRE.ProductoCreditoID = PRO.ProducCreditoID ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,'     INNER JOIN CLIENTES CLI ON CRE.ClienteID = CLI.ClienteID ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,'     INNER JOIN SUCURSALES SUC ON CLI.SucursalOrigen = SUC.SucursalID ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE CRE.FechaInicio >= "',(Par_FechaInicio),'" AND CRE.FechaInicio <= "',(Par_FechaFin),'" ');

        IF(IFNULL(Par_Sucursal,Entero_Cero) > Entero_Cero)THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND CLI.SucursalOrigen = "',Par_Sucursal,'"');
		END IF;

        IF(IFNULL(Par_ProductoCreditoID,Entero_Cero) > Entero_Cero)THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND PRO.ProducCreditoID = "',Par_ProductoCreditoID,'"');
		END IF;

        IF(IFNULL(Par_Estatus, EstTodos) != EstTodos)THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND CRE.Estatus = "',Par_Estatus,'"');
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,'ORDER BY SUC.SucursalID;');


        SET @Sentencia	= (Var_Sentencia);
		SET @FechaIni	= Par_FechaInicio;
		SET @FechaFin	= Par_FechaFin;
		PREPARE CREDCONSOLIDAREP FROM @Sentencia;
		EXECUTE CREDCONSOLIDAREP;

		DEALLOCATE PREPARE CREDCONSOLIDAREP;

    END IF;

    IF (Par_NumList = Lis_Detalle) THEN

    	DROP TABLE IF EXISTS TMP_CRECONSOLIDAAGROREP;
    	CREATE TEMPORARY TABLE TMP_CRECONSOLIDAAGROREP(
    		RegistroID			INT(11),
    		CreditoID 			BIGINT(12),
    		NombreCliente 		VARCHAR(215),
    		SaldoConsolida 		DECIMAL(16,2),
    		DetEstatus			VARCHAR(20),
    		PRIMARY KEY (RegistroID)
    	);

		SET @RegistroID := Entero_Cero;
    	INSERT INTO TMP_CRECONSOLIDAAGROREP(
    		RegistroID,		CreditoID,		NombreCliente,		SaldoConsolida,		DetEstatus)
    	SELECT 
    		@RegistroID:=(@RegistroID+Entero_Uno),
    		DET.CreditoID, CONCAT(CLI.ClienteID, "-", CLI.NombreCompleto) AS NombreCliente,
			(DET.MontoCredito + DET.MontoProyeccion) AS SaldoConsolida,
			Cadena_Vacia
        FROM CRECONSOLIDAAGROENC AS ENC
            INNER JOIN CRECONSOLIDAAGRODET AS DET ON ENC.FolioConsolida = DET.FolioConsolida
            INNER JOIN CREDITOS AS CRE ON DET.CreditoID = CRE.CreditoID
            INNER JOIN CLIENTES AS CLI ON CRE.ClienteID = CLI.ClienteID
            WHERE DET.FolioConsolida = Par_FolioConsolidaID;

        SELECT IFNULL(COUNT(RegistroID), Entero_Cero)
        INTO Var_MaxRegistro
        FROM TMP_CRECONSOLIDAAGROREP;

        SET Var_Contador := Entero_Cero;
        WHILE ( Var_Contador <= Var_MaxRegistro ) DO

        	SELECT CreditoID
        	INTO Var_CreditoID
        	FROM TMP_CRECONSOLIDAAGROREP
        	WHERE RegistroID = Var_Contador;

        	SELECT MAX(FechaCorte)
        	INTO Var_FechaCorte
        	FROM SALDOSCREDITOS
        	WHERE CreditoID = Var_CreditoID;

        	SET Var_FechaPago := DATE_SUB(Var_FechaCorte, INTERVAL Entero_Uno DAY);

        	SELECT EstatusCredito
        	INTO Var_EstatusCredito
        	FROM SALDOSCREDITOS
        	WHERE FechaCorte = Var_FechaPago
        	  AND CreditoID = Var_CreditoID;

        	UPDATE TMP_CRECONSOLIDAAGROREP SET 
        		DetEstatus = CASE WHEN Var_EstatusCredito = 'V' THEN 'VIGENTE'
        						  WHEN Var_EstatusCredito = 'B' THEN 'VENCIDO'
        						  WHEN Var_EstatusCredito = 'K' THEN 'CASTIGADO'
        						  WHEN Var_EstatusCredito = 'P' THEN 'PAGADO'
        						  ELSE 'VIGENTE'
        					 END
        	WHERE RegistroID = Var_Contador;

        	SET Var_Contador := Var_Contador + Entero_Uno;

        END WHILE;

        SELECT RegistroID,		CreditoID,		NombreCliente,		SaldoConsolida,		DetEstatus
        FROM TMP_CRECONSOLIDAAGROREP;

        DROP TABLE IF EXISTS TMP_CRECONSOLIDAAGROREP;
    END IF;


END TerminaStore$$
