-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQUEOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQUEOSCON`;DELIMITER $$

CREATE PROCEDURE `BLOQUEOSCON`(
	Par_BloqueoID			INT(11),
	Par_Referencia			BIGINT,				-- Referencia del bloqueo, ejemplo num de credito
	Par_CuentaAhoID			BIGINT(12),
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Mes_Consulta 			INT;
DECLARE Ano_Consulta 			INT;
DECLARE Var_EsBloqAuto      CHAR(1);
DECLARE Var_BloquearSaldo   CHAR(1);
DECLARE Var_NumCreditos     INT;

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Con_Principal   INT;
DECLARE Con_DevGarLiq   INT;
DECLARE Con_AplBloqAuto INT;
DECLARE Tipo_Bloqueo    CHAR(1);
DECLARE Var_Si          CHAR(1);
DECLARE Var_No          CHAR(1);

DECLARE TipoBloqueoDevGL    INT;
DECLARE Nat_Bloqueo         CHAR(1);
DECLARE Nat_Desbloqueo      CHAR(1);
DECLARE Con_BloqueoAutomatico	INT;
DECLARE TipoBloqueoTipoCta		INT;

-- Asignacion de Constantes
SET Cadena_Vacia        := '';			-- Cadena Vacia
SET Fecha_Vacia         := '1900-01-01';-- Fecha Vacia
SET Entero_Cero         := 0;			-- Entero Cero
SET Con_Principal       := 1;			-- Consulta Principal
SET Con_DevGarLiq       := 2; 			-- Consulta Para la Devolucion de Garantia Liquida
SET Con_DevGarLiq       := 2; 			-- Consulta Para la Devolucion de Garantia Liquida
SET Con_AplBloqAuto     := 3;        -- Consulta para Decidir si Aplica un Bloqueo Automatico de Saldo o No
SET Var_Si              := 'S';      -- Valor: SI
SET Var_No              := 'N';      -- Valor: NO

SET Tipo_Bloqueo        := 'B';         -- Tipo de Movimiento de Bloqueo

SET TipoBloqueoDevGL		:= 8;			   -- Bloqueo por deposito de GL
SET Nat_Bloqueo				:='B';	      -- Bloqueo
SET Nat_Desbloqueo			:='D';	      -- DEsbloqueo
SET Con_BloqueoAutomatico	:=4;		-- Consulta por Bloqueo Automatico
SET TipoBloqueoTipoCta		:=13;		-- Tipo bloqueo Automatico por ticpo de Cuenta

SELECT MONTH(FechaSistema) , YEAR(FechaSistema)INTO Mes_Consulta , Ano_Consulta FROM PARAMETROSSIS;

IF(Par_NumCon = Con_Principal) THEN

	SELECT CONCAT(FORMAT(IFNULL(MontoBloqueado-MontoDesbloqueado,0),2)) AS Monto
	FROM
		(SELECT IFNULL(SUM(MontoBloq),0) AS MontoBloqueado
		FROM BLOQUEOS
		WHERE CuentaAhoID= Par_CuentaAhoID AND NatMovimiento= 'B'
		AND MONTH(fechaMov)<> Mes_consulta
		OR YEAR(fechaMov)<>Ano_Consulta  )AS bloqueado,

		(SELECT IFNULL(SUM(MontoBloq),0) AS MontoDesbloqueado
		FROM BLOQUEOS
		WHERE CuentaAhoID=Par_CuentaAhoID AND NatMovimiento= 'D'
		AND MONTH(fechaMov)<> Mes_consulta
		OR YEAR(fechaMov)<>Ano_Consulta ) AS desbloqueado;

END IF;


IF(Par_NumCon = Con_DevGarLiq) THEN
	SELECT BloqueoID,FORMAT(SUM(MontoBloq),2) AS MontoBloq
			FROM BLOQUEOS
			WHERE Referencia=Par_Referencia
			AND CuentaAhoID=Par_CuentaAhoID
			AND TiposBloqID=TipoBloqueoDevGL
			AND NatMovimiento=Nat_Bloqueo
			 AND FolioBloq > Entero_Cero
			GROUP BY BloqueoID;

END IF;


-- Verifica si la Cuenta Debe Aplicar un Bloqueo Automatico o NO
IF(Par_NumCon = Con_AplBloqAuto) THEN

    SELECT Tip.EsBloqueoAuto INTO Var_EsBloqAuto
        FROM CUENTASAHO Cue,
             TIPOSCUENTAS Tip
        WHERE Cue.CuentaAhoID = Par_CuentaAhoID
          AND Cue.TipoCuentaID = Tip.TipoCuentaID;

    SET Var_EsBloqAuto  := IFNULL(Var_EsBloqAuto, Var_No);

    SELECT Var_EsBloqAuto AS BloquearSaldo;

END IF;
-- 4 consulta Bloqueo por Bloqueo Automatico por tipo de Cuenta
IF(Par_NumCon = Con_BloqueoAutomatico) THEN
	SELECT BloqueoID,FORMAT(SUM(MontoBloq),2) AS MontoBloq
			FROM BLOQUEOS
			WHERE Referencia=Par_Referencia
			AND CuentaAhoID=Par_CuentaAhoID
			AND TiposBloqID=TipoBloqueoTipoCta
			AND NatMovimiento=Nat_Bloqueo
			GROUP BY BloqueoID;

END IF;

END TerminaStore$$