-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCSOCMENORAUTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCSOCMENORAUTREP`;DELIMITER $$

CREATE PROCEDURE `CANCSOCMENORAUTREP`(
	Par_FechaInicial		DATE,
	Par_FechaFinal			DATE,
	Par_SucursalInicial		INT(11),
	Par_SucursalFinal		INT(11),
	Par_ClienteID		 	INT(11),

	Par_EmpresaID			INT(11),
    Aud_Usuario		    	INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID		    VARCHAR(50),
	Aud_Sucursal		    INT(11),
	Aud_NumTransaccion		BIGINT(20)



		)
TERMINASTORE: BEGIN
 /* Declaracion de variables*/
DECLARE	Var_Sentencia		VARCHAR(8000);

/* Declaracion de Constantes*/
DECLARE Entero_Cero     	INT;
DECLARE EstatusVigente   	CHAR(1);
DECLARE EstatusVencido   	CHAR(1);
DECLARE EstatusActivas   	CHAR(1);
DECLARE EstatusBloqueadas   CHAR(1);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE NombreTabla			VARCHAR(300);
DECLARE Con_TablaPrincipal  INT(11);
DECLARE Con_CtaAhorro		INT(11);
DECLARE Con_CtaInver		INT(11);
DECLARE Si_Elimina			CHAR(1);
DECLARE No_Elimina			CHAR(1);
DECLARE Fecha_Vacia			VARCHAR(30);
/* Asignacion de Constantes*/
SET Entero_Cero      		:= 0;
SET EstatusVigente   		:='V';
SET EstatusVencido   		:='B';
SET EstatusActivas   		:='A';
SET EstatusBloqueadas   	:='B';
SET Cadena_Vacia			:='';
SET Con_TablaPrincipal		:=1;
SET Con_CtaAhorro			:=2;
SET Con_CtaInver			:=3;
SET Si_Elimina				:="S";
SET No_Elimina				:="N";
SET Fecha_Vacia				:='1900-01-01 00:00:00';

SET Var_Sentencia :='';

	SET Var_Sentencia:=CONCAT(Var_Sentencia,' SELECT Cta.ClienteID, Cli.NombreCompleto,sum(Cta.SaldoAhorro) as Monto,case Cta.Aplicado
																														when "N" then "PENDIENTE"
																														when "R" then "ENTREGADO" end as Estatus,
												   Cta.FechaCancela, cast(ifnull(Cta.FechaRetiro,"1900-01-01") as date) as FechaRetiro ,
													Cli.SucursalOrigen,Suc.NombreSucurs, time(now()) as HoraEmision
													from CANCSOCMENORCTA Cta
														inner join CLIENTES Cli on Cli.ClienteID=Cta.ClienteID
														inner join SUCURSALES Suc on Suc.SucursalID=Cli.SucursalOrigen
														where Cta.FechaCancela >= "',Par_FechaInicial,'"
														and   Cta.FechaCancela <= "',Par_FechaFinal,'"');

	IF Par_SucursalInicial != Entero_Cero THEN
				SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  and Cli.SucursalOrigen >=  ',Par_SucursalInicial);
		END IF;

	IF Par_SucursalFinal != Entero_Cero THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '   and  Cli.SucursalOrigen <=  ',Par_SucursalFinal);
	END IF;

	IF Par_ClienteID != Entero_Cero THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  and  Cta.ClienteID =  ',Par_ClienteID);
	END IF;


	SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  group by Cli.SucursalOrigen, Cta.ClienteID, Cli.NombreCompleto, Cta.Aplicado, Cta.FechaCancela, Cta.FechaRetiro, Suc.NombreSucurs; ');

	SET @Sentencia	= (Var_Sentencia);
	PREPARE STCANSOCMENOR FROM @Sentencia;
	EXECUTE STCANSOCMENOR ;
	DEALLOCATE PREPARE STCANSOCMENOR;


END TERMINASTORE$$