DELIMITER ;
DROP FUNCTION IF EXISTS FNFECHASAMORTIZACIONES;
DELIMITER $$
CREATE FUNCTION FNFECHASAMORTIZACIONES(
	-- Descripcion: Funcion para obtener el minimo y maximo exigilidad de la fecha de amortizacion de un credito
	-- Modulo: Creditos
	Par_CreditoID		BIGINT(12),		-- Numero del credito
	Par_TipoConsulta	CHAR(1)			-- Tipo de consulta I.- Inicio del credito, F.- Fin del Credito

) RETURNS DATE
	DETERMINISTIC
BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_FechaCredito		DATE;		-- Fecha a retornar

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				INT(11);	-- Constante de entero cero
	DECLARE Cadena_Vacia			CHAR(1);	-- Constante de cadena vacia
	DECLARE Fecha_Vacia				DATE;		-- Constante de fecha vacia

	-- DECLARACION DE TIPO DE CONSULLAS
	DECLARE Tipo_InicioCredito		CHAR(1);	-- Inicio del Credito
	DECLARE Tipo_FinCredito			CHAR(1);	-- Fin del credito

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Tipo_InicioCredito			:= 'I';
	SET Tipo_FinCredito				:= 'F';

	-- VALIDACION DE DATOS NULOS
	SET Par_CreditoID				:= IFNULL(Par_CreditoID, Entero_Cero);
	SET Par_TipoConsulta			:= IFNULL(Par_TipoConsulta,Cadena_Vacia);

	-- SE VALIDA QUE LOS DATOS VENGAN CON VALORES
	IF(Par_CreditoID = Entero_Cero OR Par_TipoConsulta = Cadena_Vacia)THEN
		RETURN Fecha_Vacia;
	END IF;

	-- CONSULTA POR LA PRIMERA FECHA EXIGIBILE DEL CREDITO
	IF(Par_TipoConsulta = Tipo_InicioCredito)THEN
		SELECT	FechaInicio
		INTO	Var_FechaCredito
		FROM CREDITOS
		WHERE CreditoID	= Par_CreditoID;

		-- VALIDACION DE DATOS NULOS
		SET Var_FechaCredito := IFNULL(Var_FechaCredito, Fecha_Vacia);

	END IF;

	-- CONSULTA POR LA ULTIMA FECHA EXIGIBILE DEL CREDITO
	IF(Par_TipoConsulta = Tipo_FinCredito)THEN
		SELECT	MAX(FechaExigible)
		INTO	Var_FechaCredito
		FROM AMORTICREDITO
		WHERE CreditoID	= Par_CreditoID;

		-- VALIDACION DE DATOS NULOS
		SET Var_FechaCredito := IFNULL(Var_FechaCredito, Fecha_Vacia);

	END IF;
-- SE RETORNA EL DATO
RETURN Var_FechaCredito;
END$$