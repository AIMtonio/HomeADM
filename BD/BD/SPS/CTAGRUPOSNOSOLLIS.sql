-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTAGRUPOSNOSOLLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CTAGRUPOSNOSOLLIS`;DELIMITER $$

CREATE PROCEDURE `CTAGRUPOSNOSOLLIS`(




	Par_GrupoID				INT(10),
	Par_NumLis				TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN




	DECLARE Lis_Principal		INT;

	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(4);


	SET Lis_Principal			:=1;

	SET Estatus_Activo			:='A';
	SET Cadena_Vacia			:='';
	SET Decimal_Cero			:= 0.00;



		IF(Par_NumLis = Lis_Principal) THEN
			IF EXISTS (
						SELECT Cue.CuentaAhoID
						FROM CUENTASAHO Cue,
							 CLIENTES Cli,
							 INTEGRAGRUPONOSOL Inte,
							 GRUPOSNOSOLIDARIOS Gru
						WHERE Cue.ClienteID = Cli.ClienteID
							AND Cli.ClienteID = Inte.ClienteID
							AND Inte.GrupoID = Gru.GrupoID
							AND Cue.Estatus = Estatus_Activo
							AND Cli.Estatus = Estatus_Activo
							AND Gru.Estatus = Estatus_Activo
							AND Gru.GrupoID = Par_GrupoID
						LIMIT 1)THEN
							SELECT DISTINCT(Cue.CuentaAhoID)				AS Num_Cta,
								   Cue.ClienteID							AS Num_Socio,
								   Cue.TipoCuentaID							AS Id_Cuenta,
								   IFNULL(Cue.Saldo,Decimal_Cero)			AS SaldoTot,
								   IFNULL(Cue.SaldoDispon,Decimal_Cero)		AS SaldoDisp,
								   Cadena_Vacia								AS Parametros
							FROM CUENTASAHO Cue,
								 CLIENTES Cli,
								 INTEGRAGRUPONOSOL Inte,
								 GRUPOSNOSOLIDARIOS Gru
							WHERE Cue.ClienteID = Cli.ClienteID
								AND Cli.ClienteID = Inte.ClienteID
								AND Inte.GrupoID = Gru.GrupoID
								AND Cue.Estatus = Estatus_Activo
								AND Cli.Estatus = Estatus_Activo
								AND Gru.Estatus = Estatus_Activo
								AND Gru.GrupoID = Par_GrupoID;
			ELSE
				SELECT ''			AS Num_Cta,
					    ''			AS Num_Socio,
						''			AS Id_Cuenta,
						''		AS SaldoTot,
						''		AS SaldoDisp,
						''			AS Parametros;
			END IF;
		END IF;

	END TerminaStore$$