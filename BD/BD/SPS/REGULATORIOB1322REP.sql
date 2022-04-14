-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOB1322REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOB1322REP`;
DELIMITER $$

CREATE PROCEDURE `REGULATORIOB1322REP`(
	/* Genera el regulatorio B1322 para Sofipo */
	Par_Anio           		INT,				# Año del Reporte
	Par_Mes					INT,				# Mes del Reporte
	Par_NumRep				TINYINT UNSIGNED, 	# Numero de Reporte 1 - Excel  2 - CSV

    Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50), 		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion		BIGINT(20)			-- Auditoria
)
TerminaStore:BEGIN
	-- Variables

    DECLARE Var_CuentaContable		VARCHAR(300);
    DECLARE Var_CuentaFija			VARCHAR(20);
    DECLARE Var_TMPCuentaContable	VARCHAR(300);
    DECLARE Var_TMPCuentaFija		VARCHAR(15);
	DECLARE Var_Fecha				VARCHAR(10);		-- Periodo del Reporte
    DECLARE Var_Descripcion			VARCHAR(300);

	DECLARE FechaConsulta			VARCHAR(10);		-- Periodo del Reporte
	DECLARE Var_ClaveEntidad 		VARCHAR(10);	-- Clave de la entidad
	DECLARE Var_Control 			VARCHAR(100);	-- Clave de la entidad
	DECLARE Var_PeriodoCatalogo		VARCHAR(10);	-- Clave de la entidad
	DECLARE Var_NumCliente 			INT;			-- Numero de Cliente

    DECLARE Var_ConceptoFinanIDMax	INT;
    DECLARE Var_ConceptoFinanID		INT;
    DECLARE Contador				INT;
	DECLARE Var_Espacios	 		INT;
	DECLARE Par_AcumuladoCta 		DECIMAL(18,2);
    DECLARE Var_FechaHistorica 		DATE;

    -- Constantes
	DECLARE Rep_Excel				INT;			-- Reporte en Excel
	DECLARE Rep_Csv					INT;			-- Reporte en Csv
	DECLARE Entero_Uno 				INT;
	DECLARE Entero_Cero				INT;
	DECLARE CatalogoRegulatorio		INT;

    DECLARE Tif_Regulatorio			INT;
	DECLARE Tif_Balance    			INT;
	DECLARE Decimal_Cero			DECIMAL(16,2);
    DECLARE Con_UbiActual 			CHAR(1);
	DECLARE Con_UbiHistorica		CHAR(1);

    DECLARE Con_UbicaSaldoContable	CHAR(1);
    DECLARE Con_Fecha				CHAR(1);
    DECLARE Con_Evaluado			CHAR(1);
    DECLARE NumReporte				VARCHAR(4);		-- Numero de Reporte
	DECLARE Cadena_Vacia 			VARCHAR(2);
    DECLARE Espacio_Vacio			VARCHAR(10);

	-- Seteo de constantes
	SET NumReporte				:= '1322';		-- Clave del reporte
	SET Tif_Balance 			:= 3 ;
	SET Tif_Regulatorio			:= 8 ;
	SET Rep_Excel 				:= 1 ;
	SET Rep_Csv	  				:= 2;
	SET Entero_Uno 				:= 1;
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia 			:= '';
	SET Espacio_Vacio 			:= '    ';
    SET Decimal_Cero			:= 0.0;
	SET Con_UbiActual 			:= 'A'; 				/* Ubicacion: Actual */
    SET Con_UbiHistorica 		:= 'H'; 				/* Ubicacion: Historica */
    SET Con_Fecha				:= 'F';					/* Tipo: Calculo por Fecha */
    SET Con_Evaluado			:= 'S';					/* Tipo: Calculo por Fecha */
    SET Var_Control				:= '';					/* Tipo: Calculo por Fecha */
    SET Contador 				:= 1;

	SELECT IFNULL(CONCAT(Anio,CASE WHEN Mes < 10 THEN CONCAT(0,Mes) ELSE Mes END), Cadena_Vacia) INTO Var_PeriodoCatalogo
	FROM `HIS-CATALOGOMINIMO`
	WHERE Anio = Par_Anio AND Mes = Par_Mes LIMIT 1;

	SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

	SELECT IFNULL(ValorParametro, Entero_Cero) INTO Var_NumCliente
		FROM PARAMGENERALES
		WHERE  LlaveParametro = 'CliProcEspecifico';

	SELECT MAX(Fecha) INTO Var_FechaHistorica
		FROM `HIS-DETALLEPOL`;

	DROP TABLE IF EXISTS TMPREGULATORIOB1322;
	CREATE TEMPORARY TABLE TMPREGULATORIOB1322(
		NumeroConcepto			INT,
		CuentaContable		 	VARCHAR(300),
		CuentaFija		 		VARCHAR(20),
		Concepto				VARCHAR(300),
		Evaluado				CHAR(1),
		Saldo					DECIMAL(18,2),
		FormulaRegulatorio	 	VARCHAR(300),
		FormulaCatalogoMinimo 	VARCHAR(300),
		NumeroTransaccion		BIGINT(20)
	);

	/* Se insertar los registros del reporte regulatorio a imprimir en la tabla temporal*/
	INSERT INTO  TMPREGULATORIOB1322
	SELECT Concepto.ConceptoFinanID,	Concepto.CuentaContable, Concepto.CuentaFija,
							CONCAT(CASE	Concepto.Espacios
											WHEN 1 THEN Espacio_Vacio
											WHEN 2 THEN CONCAT(Espacio_Vacio,Espacio_Vacio)
											WHEN 3 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
											WHEN 4 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
											WHEN 5 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
											WHEN 6 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
									ELSE Cadena_Vacia END ,Concepto.Desplegado),
			Cadena_Vacia,	Catalogo.Monto,		Cadena_Vacia,
			Cadena_Vacia,	Aud_NumTransaccion
	FROM CONCEPESTADOSFIN Concepto
	INNER JOIN `HIS-CATALOGOMINIMO` Catalogo ON Catalogo.CuentaContable = Concepto.CuentaFija
	WHERE Concepto.NumClien = Var_NumCliente AND
		  Concepto.EstadoFinanID = Tif_Regulatorio AND
		  Catalogo.CuentaContable = Concepto.CuentaFija AND
		  Catalogo.Anio = Par_Anio AND
		  Catalogo.Mes = Par_Mes;

	SET Var_ConceptoFinanID := Entero_Cero;

	SET Var_ConceptoFinanIDMax := (SELECT MAX(ConceptoFinanID)
		FROM CONCEPESTADOSFIN WHERE EstadoFinanID = Tif_Regulatorio
								AND NumClien = Var_NumCliente);

 	WHILE (Contador <= Var_ConceptoFinanIDMax) DO

		SELECT LAST_DAY(CONCAT(Par_Anio,'-',CASE WHEN Par_Mes < 10 THEN CONCAT(Entero_Cero,Par_Mes) ELSE Par_Mes END,'-01'))
			INTO Var_Fecha;

		IF(Var_Fecha <= Var_FechaHistorica) THEN
			SET Con_UbicaSaldoContable := Con_UbiHistorica;
		ELSE
			SET Con_UbicaSaldoContable := Con_UbiActual;
		END IF;

		SELECT CuentaFija, CuentaContable INTO Var_TMPCuentaFija, Var_TMPCuentaContable
				FROM TMPREGULATORIOB1322
		WHERE NumeroConcepto = Contador;

        SELECT CuentaFija, CuentaContable INTO Var_TMPCuentaFija, Var_TMPCuentaContable
		FROM TMPREGULATORIOB1322 WHERE NumeroConcepto = Contador;
        SET Var_TMPCuentaContable := IFNULL(Var_TMPCuentaContable,Cadena_Vacia);

		SET Var_TMPCuentaContable := IFNULL(Var_TMPCuentaContable,Cadena_Vacia);

		SELECT CuentaFija, CuentaContable, Descripcion, Espacios INTO Var_CuentaFija, Var_CuentaContable, Var_Descripcion, Var_Espacios
		FROM CONCEPESTADOSFIN
		WHERE EstadoFinanID = Tif_Regulatorio AND
			  NumClien = Var_NumCliente AND
			  ConceptoFinanID = Contador;

        IF(Var_CuentaContable = Cadena_Vacia) THEN
			SET Var_CuentaContable := Entero_Cero;
        END IF;

		IF( Var_TMPCuentaFija = Cadena_Vacia )THEN

			CALL EVALFORMULAREGPRO(Par_AcumuladoCta, Var_CuentaContable, 	Con_UbicaSaldoContable,	Con_Fecha, 	Var_Fecha);

			INSERT INTO TMPREGULATORIOB1322 VALUES (Contador,	Var_CuentaContable, Var_CuentaFija,
													CONCAT(CASE	Var_Espacios
															WHEN 1 THEN Espacio_Vacio
															WHEN 2 THEN CONCAT(Espacio_Vacio,Espacio_Vacio)
															WHEN 3 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
															WHEN 4 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
															WHEN 5 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
															WHEN 6 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
													ELSE Cadena_Vacia END ,Var_Descripcion),
													Cadena_Vacia, 		IFNULL(Par_AcumuladoCta, Decimal_Cero),
													Var_CuentaContable, Var_CuentaContable,	Aud_NumTransaccion);

        END IF;


		SET Contador := Contador + 1;
		SET Var_TMPCuentaFija := Cadena_Vacia;
		SET Var_TMPCuentaContable := Cadena_Vacia;
		SET Var_CuentaContable := Cadena_Vacia;

	END WHILE;

    IF Par_NumRep = Rep_Excel THEN
		SELECT NumeroConcepto,	CuentaFija, CuentaContable,		Concepto,
			   Evaluado, 		Saldo,		FormulaRegulatorio AS Formula ,	FormulaCatalogoMinimo AS SumEstFinanSubsidiaria
		FROM TMPREGULATORIOB1322;
		DROP TABLE IF EXISTS TMPREGULATORIOB1322;
	END IF;

	IF Par_NumRep = Rep_Csv THEN
		SELECT CONCAT(CuentaFija,';',Saldo) AS Valor
		FROM TMPREGULATORIOB1322;
		DROP TABLE IF EXISTS TMPREGULATORIOB1322;
	END IF;

END TerminaStore$$