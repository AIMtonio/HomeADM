-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMATASACALLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMATASACALLIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMATASACALLIS`(
# =====================================================================================
# ------- STORED PARA LISTAR TASAS DE NIVELES CREDITO AL DAR UNA SOLICITUD---------
# =====================================================================================
    Par_SucursalID      INT(11),
    Par_ProdCreID       INT(11),
    Par_NumCreditos     INT(11),
    Par_Monto           DECIMAL(12,2),
    Par_Califi          VARCHAR(45),

	Par_PlazoID			VARCHAR(200),
    Par_EmpresaNomina	INT(11),
   	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema DATETIME;
	DECLARE Var_FecFinMesAnt DATE;
	DECLARE Var_FecIniMesAnt DATE;
	DECLARE Var_CalcInteres	 INT;
	DECLARE Var_EsNomina	CHAR(1);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT;
	DECLARE SalidaSI        CHAR(1);
	DECLARE SalidaNO        CHAR(1);
	DECLARE Decimal_Cero	DECIMAL;
	DECLARE PlazoTodos		VARCHAR(20);
	DECLARE TasaFijaID				INT(11);
	DECLARE TodasInstituciones		INT(11);
	DECLARE Lis_Principal	INT(11);

	-- Asinacion de Constantes
	SET Cadena_Vacia    := '';				-- Cadena Vacia
	SET Fecha_Vacia     := '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero     := 0;				-- Entero Cero
	SET SalidaSI        := 'S';				-- Salida SI
	SET SalidaNO        := 'N';				-- Salida NO
	SET Decimal_Cero	:= 0.00;			-- DECIMAL Cero
	SET PlazoTodos		:= 'T';				-- Todos los plazos
	SET TasaFijaID				:= 1; 				-- ID de la formula para tasa fija (FORMTIPOCALINT)
	SET TodasInstituciones		:= 0; 				-- Todas las Empresas de Nomina
	SET Lis_Principal	:= 3;

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT CalcInteres, ProductoNomina
			INTO Var_CalcInteres, Var_EsNomina
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = IFNULL(Par_ProdCreID, Entero_Cero);

		-- Calculo de Interes por Tasa Fija
		SET Var_EsNomina := IFNULL(Var_EsNomina, 'N');

		IF(IFNULL(Var_CalcInteres,Entero_Cero) = TasaFijaID)THEN
			IF(Var_EsNomina = 'N') THEN
				SELECT TasaFija AS TasaNivel, CONCAT(TasaFija,' - ',NIV.Descripcion) AS Descripcion
				FROM ESQUEMATASAS Est
					INNER JOIN NIVELCREDITO NIV
						ON Est.NivelID = NIV.NivelID
				WHERE  	   Est.SucursalID 			 = Par_SucursalID
					AND	   Est.ProductoCreditoID 	 = Par_ProdCreID
					AND    Est.MinCredito			<= Par_NumCreditos
					AND    Est.MaxCredito			>= Par_NumCreditos
					AND    Est.MontoInferior		<= Par_Monto
					AND    Est.MontoSuperior		>= Par_Monto
					AND    Est.Calificacion			 = Par_Califi
					AND	   (Est.PlazoID				 IN (Par_PlazoID) OR Est.PlazoID=PlazoTodos)
				ORDER BY TasaFija DESC;
			ELSE
				SELECT TasaFija AS TasaNivel,CONCAT(TasaFija,' - ',NIV.Descripcion) AS Descripcion
				FROM ESQUEMATASAS Est
					INNER JOIN NIVELCREDITO NIV
						ON Est.NivelID = NIV.NivelID
				WHERE  	   Est.SucursalID 			 = Par_SucursalID
					AND	   Est.ProductoCreditoID 	 = Par_ProdCreID
					AND    Est.MinCredito			<= Par_NumCreditos
					AND    Est.MaxCredito			>= Par_NumCreditos
					AND    Est.MontoInferior		<= Par_Monto
					AND    Est.MontoSuperior		>= Par_Monto
					AND    Est.Calificacion			 = Par_Califi
					AND	   (Est.PlazoID				 IN (Par_PlazoID) OR Est.PlazoID=PlazoTodos)
					AND		(Est.InstitNominaID IN(Par_EmpresaNomina) OR Est.InstitNominaID = TodasInstituciones)
				ORDER BY TasaFija DESC;

			END IF;

		ELSEIF(IFNULL(Var_CalcInteres,Entero_Cero)!=TasaFijaID AND IFNULL(Var_CalcInteres,Entero_Cero)!=Entero_Cero)THEN
			--  Validacion Existencia de una tasabase de el mes anterior para creditos con calculo de interes variable
			SELECT FechaSistema INTO Var_FechaSistema
			FROM PARAMETROSSIS
			LIMIT 1;

			SET	Var_FecFinMesAnt := LAST_DAY(DATE_SUB(Var_FechaSistema, INTERVAL 1 MONTH));
			SET Var_FecIniMesAnt := DATE_SUB(Var_FecFinMesAnt, INTERVAL DAYOFMONTH(Var_FecFinMesAnt)-1 DAY);

			SELECT H.Valor AS TasaNivel, CONCAT(H.Valor,' - ') AS Descripcion
			FROM `HIS-TASASBASE` H
			WHERE H.Fecha BETWEEN Var_FecIniMesAnt AND Var_FecFinMesAnt
            ORDER BY H.Valor DESC;

		END IF;
	END IF;

END TerminaStore$$