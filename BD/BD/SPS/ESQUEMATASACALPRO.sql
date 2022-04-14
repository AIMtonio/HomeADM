-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMATASACALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMATASACALPRO`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMATASACALPRO`(
/*SP que Obtiene la TASA Fija del Cliente al dar una solicitud de crédito*/
    Par_SucursalID      INT(11),
    Par_ProdCreID       INT(11),
    Par_NumCreditos     INT(11),
    Par_Monto           DECIMAL(12,2),
    Par_Califi          VARCHAR(45),

	OUT Par_TasaFija	DECIMAL(12,4),
	Par_PlazoID			VARCHAR(200),
    Par_EmpresaNomina	INT(11),
    Par_ConvenioNominaID BIGINT UNSIGNED,
    OUT Par_NivelID		INT(11),
    
    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
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
DECLARE Var_ManejaConv	CHAR(1); 		-- Para Clientes que utilicen convenios de nomina

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
DECLARE Cons_NominaNO   CHAR(1);		-- Constante No Nomina
DECLARE Cons_NominaSI 	CHAR(1);		-- Constante Si Nomina
DECLARE Cons_MConvSI   	CHAR(1);		-- Constante No Maneja Convenio
DECLARE Cons_MConvNO 	CHAR(1);		-- Constante Si Maneja Convenio
DECLARE Cons_LlaveConv 	VARCHAR(60);	-- Constante llave Parametro Maneja Convenio



-- Asinacion de Constantes
SET Cadena_Vacia    := '';				-- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';	-- Fecha Vacia
SET Entero_Cero     := 0;				-- Entero Cero
SET SalidaSI        := 'S';				-- Salida SI
SET SalidaNO        := 'N';				-- Salida NO
SET Decimal_Cero	:= 0.00;			-- Decimal Cero
SET PlazoTodos		:= 'T';				-- Todos los plazos
SET TasaFijaID				:= 1; 				-- ID de la formula para tasa fija (FORMTIPOCALINT)
SET TodasInstituciones		:= 0; 				-- Todas las Empresas de Nomina
SET Cons_NominaNO	:= 'N';
SET Cons_NominaSI   := 'S';
SET Cons_MConvNO	:= 'N';
SET Cons_MConvSI	:= 'S';
SET	Cons_LlaveConv  := 'ManejaCovenioNomina';
SET Var_ManejaConv	:= (SELECT IFNULL(ValorParametro,Cons_NominaNO) from PARAMGENERALES WHERE LlaveParametro = Cons_LlaveConv) ;

-- Inicializacion
SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;

SET Par_ConvenioNominaID = IFNULL(Par_ConvenioNominaID,Entero_Cero);

SELECT CalcInteres, ProductoNomina INTO
	Var_CalcInteres, Var_EsNomina
	FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID=IFNULL(Par_ProdCreID, Entero_Cero);
        
-- Calculo de Interes por Tasa Fija
SET Var_EsNomina := IFNULL(Var_EsNomina, Cons_NominaNO);

	IF(Var_EsNomina = Cons_NominaNO ) THEN

		SET Par_TasaFija := (SELECT TasaFija
								FROM ESQUEMATASAS Est
									WHERE  	   Est.SucursalID 			 = Par_SucursalID
										AND	   Est.ProductoCreditoID 	 = Par_ProdCreID
										AND    Est.MinCredito			<= Par_NumCreditos
										AND    Est.MaxCredito			>= Par_NumCreditos
										AND    Est.MontoInferior		<= Par_Monto
										AND    Est.MontoSuperior		>= Par_Monto
										AND    Est.Calificacion			 = Par_Califi
										AND	   (Est.PlazoID				 IN (Par_PlazoID) OR Est.PlazoID=PlazoTodos)
										LIMIT 1);
		SET Par_NivelID := (SELECT NivelID
								FROM ESQUEMATASAS Est
									WHERE  	   Est.SucursalID 			 = Par_SucursalID
										AND	   Est.ProductoCreditoID 	 = Par_ProdCreID
										AND    Est.MinCredito			<= Par_NumCreditos
										AND    Est.MaxCredito			>= Par_NumCreditos
										AND    Est.MontoInferior		<= Par_Monto
										AND    Est.MontoSuperior		>= Par_Monto
										AND    Est.Calificacion			 = Par_Califi
										AND	   (Est.PlazoID				 IN (Par_PlazoID) OR Est.PlazoID=PlazoTodos)
										LIMIT 1);
	
		ELSEIF(Var_EsNomina = Cons_NominaSI AND Var_ManejaConv = Cons_MConvNO ) THEN

			SET Par_TasaFija := (SELECT TasaFija
									FROM ESQUEMATASAS Est
										WHERE  	   Est.SucursalID 			 = Par_SucursalID
											AND	   Est.ProductoCreditoID 	 = Par_ProdCreID
											AND    Est.MinCredito			<= Par_NumCreditos
											AND    Est.MaxCredito			>= Par_NumCreditos
											AND    Est.MontoInferior		<= Par_Monto
											AND    Est.MontoSuperior		>= Par_Monto
											AND    Est.Calificacion			 = Par_Califi
											AND	   (Est.PlazoID				 IN (Par_PlazoID) OR Est.PlazoID=PlazoTodos)
                                            AND		(Est.InstitNominaID IN(Par_EmpresaNomina) OR Est.InstitNominaID = TodasInstituciones)
											LIMIT 1);
			SET Par_NivelID := (SELECT NivelID
									FROM ESQUEMATASAS Est
										WHERE  	   Est.SucursalID 			 = Par_SucursalID
											AND	   Est.ProductoCreditoID 	 = Par_ProdCreID
											AND    Est.MinCredito			<= Par_NumCreditos
											AND    Est.MaxCredito			>= Par_NumCreditos
											AND    Est.MontoInferior		<= Par_Monto
											AND    Est.MontoSuperior		>= Par_Monto
											AND    Est.Calificacion			 = Par_Califi
											AND	   (Est.PlazoID				 IN (Par_PlazoID) OR Est.PlazoID=PlazoTodos)
                                            AND		(Est.InstitNominaID IN(Par_EmpresaNomina) OR Est.InstitNominaID = TodasInstituciones)
											LIMIT 1);
	
		ELSEIF(Var_EsNomina = Cons_NominaSI AND Var_ManejaConv = Cons_MConvSI ) THEN
      
          CALL  NOMESQUEMATASACREDPRO(Par_SucursalID,	Par_ProdCreID,	Par_NumCreditos,	Par_Monto,	Par_Califi,
									Par_TasaFija,	Par_PlazoID,	Par_EmpresaNomina,		Par_ConvenioNominaID, Par_NivelID,
                                    SalidaNO,	Par_NumErr,		Par_ErrMen, Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
                                    Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );
	
	END IF;

SET Par_TasaFija	:=IFNULL(Par_TasaFija,Decimal_Cero);
SET Par_NivelID		:=IFNULL(Par_NivelID,Entero_Cero);

IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Par_TasaFija AS ValorTasa,
            Cadena_Vacia AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$