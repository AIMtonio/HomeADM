-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_FNNUMCONSULTAS
DELIMITER ;
DROP FUNCTION IF EXISTS `TC_FNNUMCONSULTAS`;

DELIMITER $$
CREATE FUNCTION `TC_FNNUMCONSULTAS`(
	-- -----------------------------------------------------------
	--  Obtiene el Numero de Consultas y Disposiciones de Saldo de la Tarjeta  de Credito
	-- -----------------------------------------------------------
	Par_TarjetaCredito		CHAR(16),	-- Numero de tarjeta
	Par_ClienteID			INT(11),	-- Cliente ID
	Par_TipoTarjeta			INT(11),	-- Tipo de tarjeta
	Par_NumConsulta			INT(11)		-- Numero de consulta
) RETURNS INT(11)
    DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_NumeroConsultas	INT(11);	-- numero de Consultas
	DECLARE Var_FechaSistema	DATE;		-- Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Cero
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia

	-- Declaracion de Operaciones
	DECLARE Con_OpeConsulta		INT(11);	-- Consulta para obtener Numero de Consultas de Saldo al Mes
	DECLARE Con_OpeDisposicion	INT(11);	-- Consulta para obtener Numero de Disposiciones al Dia

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';

	-- Asignacion de Operaciones
	SET Con_OpeConsulta			:= 1;
	SET Con_OpeDisposicion		:= 2;

	SET Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_NumeroConsultas		:= Entero_Cero;

	-- Consultas de Saldo
	IF( Par_NumConsulta = Con_OpeConsulta ) THEN
		SELECT NumConsultaMes
		INTO Var_NumeroConsultas
		FROM TARCRELIMITES
		WHERE TarjetaCredID = Par_TarjetaCredito
		  AND Vigencia > Var_FechaSistema;

		IF( IFNULL(Var_NumeroConsultas, Entero_Cero) =  Entero_Cero ) THEN
			BEGIN
				SELECT NumConsultaMes
				INTO Var_NumeroConsultas
				FROM TARDEBLIMITXCONTRA LCON
				WHERE ClienteID = Par_ClienteID
				  AND TipoTarjetaDebID = Par_TipoTarjeta ;

				IF( IFNULL(Var_NumeroConsultas, Entero_Cero) = Entero_Cero ) THEN
					BEGIN
						SELECT NumConsultaMes
						INTO Var_NumeroConsultas
						FROM TARDEBLIMITESXTIPO LTIP
						WHERE TipoTarjetaDebID = Par_TipoTarjeta ;
						RETURN IFNULL(Var_NumeroConsultas, Entero_Cero);
					END;
				ELSE
					RETURN IFNULL(Var_NumeroConsultas, Entero_Cero);
				END IF;
			END;
		ELSE
			RETURN IFNULL(Var_NumeroConsultas, Entero_Cero);
		END IF;
	END IF;

	-- Consultas de Disposiciones al D??a
	IF( Par_NumConsulta = Con_OpeDisposicion ) THEN
		SELECT NoDisposiDia
		INTO Var_NumeroConsultas
		FROM TARCRELIMITES
		WHERE TarjetaCredID = Par_TarjetaCredito
		  AND Vigencia > Var_FechaSistema;

		IF( IFNULL(Var_NumeroConsultas, Entero_Cero) =  Entero_Cero ) THEN
			BEGIN
				SELECT NoDisposiDia
				INTO Var_NumeroConsultas
				FROM TARDEBLIMITXCONTRA LCON
				WHERE ClienteID = Par_ClienteID
				  AND TipoTarjetaDebID = Par_TipoTarjeta ;

				IF( IFNULL(Var_NumeroConsultas, Entero_Cero) = Entero_Cero ) THEN
					BEGIN
						SELECT NoDisposiDia
						INTO Var_NumeroConsultas
						FROM TARDEBLIMITESXTIPO LTIP
						WHERE TipoTarjetaDebID = Par_TipoTarjeta ;
						RETURN IFNULL(Var_NumeroConsultas, Entero_Cero);
					END;
				ELSE
					RETURN IFNULL(Var_NumeroConsultas, Entero_Cero);
				END IF;
			END;
		ELSE
			RETURN IFNULL(Var_NumeroConsultas, Entero_Cero);
		END IF;
	END IF;

END$$