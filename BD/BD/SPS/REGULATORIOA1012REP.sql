-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOA1012REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOA1012REP`;
DELIMITER $$

CREATE PROCEDURE `REGULATORIOA1012REP`(
	/* Genera el regulatorio A1012 para Sofipo */
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
	DECLARE Var_Periodo 		VARCHAR(8);		-- Periodo del Reporte
	DECLARE Var_ClaveEntidad 	VARCHAR(10);	-- Clave de la entidad
	DECLARE Var_NumCliente 		INT;			-- Numero de Cliente
	DECLARE Var_NumConceptos	INT;
	DECLARE Var_Fecha			DATE;
	DECLARE Var_FechaHistorica	DATE;
	DECLARE Var_MaxConceptoID	INT;
	DECLARE Var_MinConceptoID	INT;
	DECLARE Var_Contador		INT;
	DECLARE Var_CuentaContable 	VARCHAR(500);
	DECLARE Var_Saldo			DECIMAL(18,2);
	-- Constantes
	DECLARE Rep_Excel		INT;			-- Reporte en Excel
	DECLARE Rep_Csv			INT;			-- Reporte en Csv
	DECLARE NumReporte		VARCHAR(4);		-- Numero de Reporte
	DECLARE CveTipoSaldo62	VARCHAR(4);		-- Numero de clave del tipo de saldo
	DECLARE CveTipoSaldo130	VARCHAR(4);		-- Numero de clave del tipo de saldo
	DECLARE Entero_Uno 		INT;
	DECLARE Entero_Cero		INT;
	DECLARE Catalogo_Minimo	INT;
	DECLARE Cadena_Vacia 	VARCHAR(2);
	DECLARE Espacio_Vacio	VARCHAR(10);
	DECLARE Decimal_Cero	DECIMAL(16,2);
	DECLARE Var_Reporte 	VARCHAR(5);
	DECLARE Con_UbiActual 			CHAR(1);
	DECLARE Con_UbiHistorica		CHAR(1);
	DECLARE Con_UbicaSaldoContable	CHAR(1);
	DECLARE Con_Fecha				CHAR(1);

	SET NumReporte			:= '1012';		-- Clave del reporte
	SET CveTipoSaldo62		:= '62';		-- Numero de clave del tipo de saldo
	SET CveTipoSaldo130		:= '130';		-- Numero de clave del tipo de saldo
	SET Rep_Excel 			:= 1 ;
	SET Rep_Csv	  			:= 2;
	SET Entero_Uno 			:= 1;
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia 		:= '';
	SET Espacio_Vacio 		:= '    ';
	SET Catalogo_Minimo		:= 3;			-- Reporte de Catalogo minimo
    SET Decimal_Cero		:= 0.0;
	SET Var_Reporte			:='A1012';
	SET Con_UbiActual 		:= 'A';
	SET Con_UbiHistorica 	:= 'H';
	SET Con_Fecha 			:= 'F';

	SET Var_Periodo	:= CONCAT(Par_Anio,CASE WHEN Par_Mes < 10 THEN CONCAT(Entero_Cero,Par_Mes) ELSE Par_Mes END);

	SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

	SELECT IFNULL(ValorParametro, Entero_Cero) INTO Var_NumCliente
		FROM PARAMGENERALES
		WHERE  LlaveParametro = 'CliProcEspecifico';

	DROP TABLE IF EXISTS TMPREGULATORIOA1012;
	DROP TABLE IF EXISTS TMPREGULATORIO;

	CREATE TEMPORARY TABLE TMPREGULATORIOA1012(
		ClaveEntidad		 	VARCHAR(15),
		Subreporte				VARCHAR(10),
		Concepto				VARCHAR(300),
		EstadoFinanciero		VARCHAR(10),
		BalanceSubsidiaria1		DECIMAL(18,2),
		BalanceSubsidiariaN 	DECIMAL(18,2),
		SumEstFinanSubsidiaria 	DECIMAL(18,2),
		SumEstFinanSofipo		VARCHAR(10),
		EliminacionesDebe		VARCHAR(10),
		EliminacionesHaber		VARCHAR(10),
		EstFinanSofipoConsol	DECIMAL(18,2)
	);

	DROP TABLE IF EXISTS TEMPCONCEPESTADOSFINCATMINIMO;

	CREATE TEMPORARY TABLE TEMPCONCEPESTADOSFINCATMINIMO(
		ClaveEntidad		 	VARCHAR(15),
		Concepto				VARCHAR(300),
		EstadoFinanciero		VARCHAR(10),
		CuentaContable			VARCHAR(500),
		BalanceSubsidiaria1		DECIMAL(18,2)
	);

	INSERT INTO  TMPREGULATORIOA1012
    SELECT  Concepto.CuentaFija,	Cadena_Vacia,
							CONCAT(CASE	Concepto.Espacios
											WHEN 1 THEN Espacio_Vacio
											WHEN 2 THEN CONCAT(Espacio_Vacio,Espacio_Vacio)
											WHEN 3 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
											WHEN 4 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
											WHEN 5 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
											WHEN 6 THEN CONCAT(Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio,Espacio_Vacio)
									ELSE Cadena_Vacia END
						,Concepto.Desplegado),		Catalogo.ConceptoFinanID,
			Catalogo.Monto,	Catalogo.MonedaExt,	Decimal_Cero,		Cadena_Vacia,
            Cadena_Vacia,	Cadena_Vacia,		Catalogo.MonedaExt
	FROM `HIS-CATALOGOMINIMO` Catalogo
	INNER JOIN CONCEPESTADOSFIN Concepto ON Concepto.CuentaFija = Catalogo.CuentaContable
	WHERE Concepto.NumClien = Var_NumCliente
		AND EstadoFinanID = Catalogo_Minimo AND Catalogo.Anio = Par_Anio AND Catalogo.Mes = Par_Mes
		AND (Concepto.CuentaFija LIKE ('5%') OR Concepto.CuentaFija LIKE('6%'));

	SELECT COUNT(ConceptoFinanID) INTO Var_NumConceptos FROM CONCEPESTADOSFINCATMINIMO WHERE Reporte = Var_Reporte;

	IF(Var_NumConceptos > Entero_Cero) THEN

		INSERT INTO TEMPCONCEPESTADOSFINCATMINIMO
		SELECT CuentaFija, Descripcion, ConceptoFinanID, CuentaContable, Entero_Cero
		FROM CONCEPESTADOSFINCATMINIMO WHERE Reporte = Var_Reporte;

		SELECT MAX(ConceptoFinanID), MIN(ConceptoFinanID) INTO Var_MaxConceptoID, Var_MinConceptoID FROM CONCEPESTADOSFINCATMINIMO WHERE Reporte = Var_Reporte;
		SELECT LAST_DAY(CONCAT(Par_Anio,'-',CASE WHEN Par_Mes < 10 THEN CONCAT(Entero_Cero,Par_Mes) ELSE Par_Mes END,'-01')) INTO Var_Fecha;
		SELECT MAX(FechaCorte) INTO Var_FechaHistorica FROM SALDOSCONTABLES;

		SET Var_Contador := Var_MinConceptoID;

		IF(Var_Fecha <= Var_FechaHistorica) THEN
			SET Con_UbicaSaldoContable := Con_UbiHistorica;
		ELSE
			SET Con_UbicaSaldoContable := Con_UbiActual;
		END IF;

		WHILE (Var_Contador <= Var_MaxConceptoID) DO

			SELECT CuentaContable INTO Var_CuentaContable FROM TEMPCONCEPESTADOSFINCATMINIMO WHERE EstadoFinanciero = Var_Contador;

			SET Var_CuentaContable := IFNULL(Var_CuentaContable,Cadena_Vacia);

			IF( Var_CuentaContable <> Cadena_Vacia )THEN

				CALL EVALFORMULAREGPRO(Var_Saldo, Var_CuentaContable, Con_UbicaSaldoContable, Con_Fecha, Var_Fecha);

				INSERT INTO TMPREGULATORIOA1012
				SELECT 	ClaveEntidad,	Cadena_Vacia, 	Concepto,		EstadoFinanciero,
						ROUND(Var_Saldo,Entero_Cero),	Decimal_Cero,	Decimal_Cero,	Cadena_Vacia,
						Cadena_Vacia,	Cadena_Vacia,	Decimal_Cero
				FROM TEMPCONCEPESTADOSFINCATMINIMO WHERE EstadoFinanciero = Var_Contador;

			ELSE

				INSERT INTO TMPREGULATORIOA1012
				SELECT 	ClaveEntidad,	Cadena_Vacia, 	Concepto,		EstadoFinanciero,
						Decimal_Cero,	Decimal_Cero,	Decimal_Cero,	Cadena_Vacia,
						Cadena_Vacia,	Cadena_Vacia,	Decimal_Cero
				FROM TEMPCONCEPESTADOSFINCATMINIMO WHERE EstadoFinanciero = Var_Contador;

			END IF;

			SET Var_Contador := Var_Contador + 1;
			SET Var_CuentaContable := Cadena_Vacia;

		END WHILE;

	END IF;

    CREATE TEMPORARY TABLE TMPREGULATORIO SELECT * FROM TMPREGULATORIOA1012;

    IF Par_NumRep = Rep_Excel THEN

		SELECT ClaveEntidad,		Subreporte,				Concepto,					EstadoFinanciero,
			   BalanceSubsidiaria1,	BalanceSubsidiariaN,	SumEstFinanSubsidiaria,		SumEstFinanSofipo,
			   EliminacionesDebe,	EliminacionesHaber,		EstFinanSofipoConsol
		FROM TMPREGULATORIOA1012 ORDER BY ClaveEntidad;

	END IF;

	IF Par_NumRep = Rep_Csv THEN

        (SELECT CONCAT(ClaveEntidad,';',NumReporte,';',CveTipoSaldo62,';',Entero_Cero,';',BalanceSubsidiaria1) AS Valor
        FROM TMPREGULATORIOA1012 ORDER BY ClaveEntidad)
        UNION
		(SELECT CONCAT(ClaveEntidad,';',NumReporte,';',CveTipoSaldo130,';',Entero_Cero,';',BalanceSubsidiaria1) AS Valor
        FROM TMPREGULATORIO ORDER BY ClaveEntidad);

	END IF;
	DROP TABLE IF EXISTS TMPREGULATORIOA1012;
	DROP TABLE IF EXISTS TMPREGULATORIO;
	DROP TABLE IF EXISTS TEMPCONCEPESTADOSFINCATMINIMO;

END TerminaStore$$