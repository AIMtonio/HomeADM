-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMESQUEMATASACREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMESQUEMATASACREDPRO`;
DELIMITER $$


CREATE PROCEDURE `NOMESQUEMATASACREDPRO`(
/*SP que Obtiene la TASA Fija del Cliente al dar una solicitud de credito*/
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
DECLARE Var_EsNomina	 CHAR(1);
DECLARE Val_TipoTasa    VARCHAR(20);



-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE SalidaSI        CHAR(1);
DECLARE SalidaNO        CHAR(1);
DECLARE Decimal_Cero	DECIMAL;
DECLARE PlazoTodos		INT(11);
DECLARE TasaFijaID				INT(11);
DECLARE TodasInstituciones		INT(11);
DECLARE Cons_Fija		CHAR(1);

DECLARE Cons_Esquema	CHAR(1);
DECLARE SucursalTodos   INT(11);

-- Asinacion de Constantes
SET Cadena_Vacia    := '';				-- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';	-- Fecha Vacia
SET Entero_Cero     := 0;				-- Entero Cero
SET SalidaSI        := 'S';				-- Salida SI
SET SalidaNO        := 'N';				-- Salida NO
SET Decimal_Cero	:= 0.00;			-- Decimal Cero
SET PlazoTodos		:= 0;				-- Todos los Plazos
SET TasaFijaID				:= 1; 				-- ID de la formula para tasa fija (FORMTIPOCALINT)
SET TodasInstituciones		:= 0; 				-- Todas las Empresas de Nomina
SET Cons_Fija			:= 'F';         -- Tipo Tasa: Fija

SET Cons_Esquema		:= 'E';         -- Tipo Tasa: Por Esquema
SET SucursalTodos       := 0;           -- Todos las Sucursales

-- Inicializacion
SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;

SELECT CalcInteres, ProductoNomina INTO
	Var_CalcInteres, Var_EsNomina
	FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID=IFNULL(Par_ProdCreID, Entero_Cero);

-- Calculo de Interes por Tasa Fija
 SELECT TipoTasa INTO Val_TipoTasa
 FROM NOMCONDICIONCRED WHERE InstitNominaID = Par_EmpresaNomina
 AND ConvenioNominaID = Par_ConvenioNominaID
 AND  ProducCreditoID = Par_ProdCreID;


IF(Val_TipoTasa = Cons_Fija) THEN
	SELECT ValorTasa AS ValorTasa INTO Par_TasaFija
		FROM NOMCONDICIONCRED
		WHERE ProducCreditoID = Par_ProdCreID AND InstitNominaID = Par_EmpresaNomina
		AND ConvenioNominaID = Par_ConvenioNominaID LIMIT 1;
ELSE

	SELECT NEC.Tasa AS ValorTasa INTO Par_TasaFija
			FROM NOMESQUEMATASACRED NEC
			INNER JOIN NOMCONDICIONCRED NCC ON NCC.CondicionCredID=NEC.CondicionCredID
			WHERE NCC.ProducCreditoID = Par_ProdCreID
			AND NCC.InstitNominaID = Par_EmpresaNomina
			AND NCC.ConvenioNominaID = Par_ConvenioNominaID
			AND (FIND_IN_SET(Par_SucursalID, NEC.SucursalID) OR NEC.SucursalID = SucursalTodos)
			AND NEC.MontoMin <= Par_Monto
			AND NEC.MontoMax >= Par_Monto
			AND (FIND_IN_SET(Par_PlazoID, NEC.PlazoID) OR NEC.PlazoID = PlazoTodos)
			LIMIT 1;

END IF;



SET Par_TasaFija	:=IFNULL(Par_TasaFija,Decimal_Cero);

IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Par_TasaFija AS ValorTasa,
            Cadena_Vacia AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$
