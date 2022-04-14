DELIMITER ;
DROP FUNCTION IF EXISTS FNMONTOBONIFICACION;

DELIMITER $$
CREATE FUNCTION `FNMONTOBONIFICACION`(
	-- Descripcion	= Funcion retorna el Monto Amortizado y Por Amortizar de una Bonificacion.
	-- Modulo		= Web Services
	Par_BonificacionID		BIGINT(20),	-- ID de Bonificacion
	Par_Fecha				DATE,		-- Fecha de Consulta
	Par_TipoConsulta 		TINYINT UNSIGNED-- Tipo de Consulta:
								--  1.-Monto que lleva amortizado la bonificacion a la fecha de consulta
								--  2.-Monto pendiente por amortizar de la bonificacion a la fecha de consulta
) RETURNS DECIMAL(14,2)
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_AmortizacionID 		INT(11);		-- Numero de Amortizacion de Bonificacion
	DECLARE Var_MontoAmortizacion	DECIMAL(14,2);	-- Monto Consultado

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);		-- Constante de entero cero
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Fecha_Vacia				DATE;			-- Constante de fecha vacia

	-- Declaracion de Consultas
	DECLARE Con_MontoAmortizado		TINYINT UNSIGNED;-- Monto que lleva amortizado la bonificacion a la fecha de consulta
	DECLARE Con_MontoPorAmortizar	TINYINT UNSIGNED;-- Monto pendiente por amortizar de la bonificacion a la fecha de consulta

	-- Asignacion  de Constantes
	SET Entero_Cero		:=0;
	SET	Cadena_Vacia	:= '';
	SET	Decimal_Cero	:= 0.0;
	SET Fecha_Vacia 	:='1900-01-01';

	-- Asignacion de Consulta
	SET Con_MontoAmortizado			:= 1;
	SET Con_MontoPorAmortizar		:= 2;

	SELECT IFNULL(FechaSistema, Fecha_Vacia)
	INTO Var_FechaSistema
	FROM PARAMETROSSIS LIMIT 1;

	-- Valores por default
	SET Par_BonificacionID 	:= IFNULL(Par_BonificacionID , Entero_Cero);
	SET Par_Fecha			:= IFNULL(Par_Fecha , Var_FechaSistema);
	SET Par_TipoConsulta 	:= IFNULL(Par_TipoConsulta , Con_MontoAmortizado);

	-- Se obtiene la fecha de consulta de la bonificacion
	SELECT IFNULL( MAX(AmortizacionID), Entero_Cero)
	INTO Var_AmortizacionID
	FROM AMORTIZABONICACIONES
	WHERE BonificacionID = Par_BonificacionID
	  AND Fecha <= Par_Fecha;

	-- Consulta 1.- Monto que lleva amortizado la bonificacion a la fecha de consulta
	IF( Par_TipoConsulta = Con_MontoAmortizado ) THEN

		SELECT MontoAcomulado
		INTO Var_MontoAmortizacion
		FROM AMORTIZABONICACIONES
		WHERE BonificacionID = Par_BonificacionID
		  AND AmortizacionID = Var_AmortizacionID;
	END IF;

	-- Consulta 2.- Monto pendiente por amortizar de la bonificacion a la fecha de consulta
	IF( Par_TipoConsulta = Con_MontoPorAmortizar ) THEN

		SELECT MontoPendiente
		INTO Var_MontoAmortizacion
		FROM AMORTIZABONICACIONES
		WHERE BonificacionID = Par_BonificacionID
		  AND AmortizacionID = Var_AmortizacionID;
	END IF;

	SET Var_MontoAmortizacion := IFNULL(Var_MontoAmortizacion, Decimal_Cero);
	RETURN Var_MontoAmortizacion;

END$$