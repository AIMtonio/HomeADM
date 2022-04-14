-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLICADEPAMORTIZAACTIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLICADEPAMORTIZAACTIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `APLICADEPAMORTIZAACTIVOSLIS`(
# =====================================================================================
# ------- STORED PARA LISTA EN LA APLICACION DEL PROCESO DE DEPRECIACION  ---------
# =====================================================================================
	Par_Anio				INT(11),		-- Anio
	Par_Mes					INT(11),		-- Mes
   	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_FechaSistema	DATE;

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE Lis_Anios			INT(11);			-- Lista 1: de ANIOS
    DECLARE Lis_Meses			INT(11);			-- Lista 2: de MESES

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET Lis_Anios				:= 1;
    SET Lis_Meses				:= 2;

	SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

	-- Lista 1 ANIOS
	IF(Par_NumLis = Lis_Anios) THEN

		SELECT BDA.Anio
		FROM BITACORADEPREAMORTI BDA
			INNER JOIN ACTIVOS ACT
				ON ACT.ActivoID = BDA.ActivoID
		WHERE  BDA.Estatus = 'R'
			AND BDA.Anio <= YEAR(Var_FechaSistema)
			AND ACT.Estatus IN('VI','BA')
		GROUP BY BDA.Anio
        ORDER BY BDA.Anio ASC LIMIT 1;

	END IF;

	-- Lista 2 MESES
	IF(Par_NumLis = Lis_Meses) THEN

		SELECT BDA.Mes, CASE BDA.Mes
						WHEN 1 THEN 'ENERO'
						WHEN 2 THEN 'FEBRERO'
						WHEN 3 THEN 'MARZO'
						WHEN 4 THEN 'ABRIL'
						WHEN 5 THEN 'MAYO'
						WHEN 6 THEN 'JUNIO'
						WHEN 7 THEN 'JULIO'
						WHEN 8 THEN 'AGOSTO'
						WHEN 9 THEN 'SEPTIEMBRE'
						WHEN 10 THEN 'OCTUBRE'
						WHEN 11 THEN 'NOVIEMBRE'
						WHEN 12 THEN 'DICIEMBRE'
						END AS DescMes
		FROM BITACORADEPREAMORTI BDA
			INNER JOIN ACTIVOS ACT
				ON ACT.ActivoID = BDA.ActivoID
		WHERE  BDA.Estatus = 'R'
			AND BDA.Anio = Par_Anio
			 AND BDA.Mes <= MONTH(Var_FechaSistema)
			AND ACT.Estatus IN('VI','BA')
		GROUP BY BDA.Anio,BDA.Mes
        ORDER BY BDA.Mes LIMIT 1;

	END IF;

END TerminaStore$$