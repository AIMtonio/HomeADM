-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOSCON`;
DELIMITER $$

CREATE PROCEDURE `CRECASTIGOSCON`(
	Par_CreditoID			BIGINT(12),
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_AplicaIVA	CHAR(1);
DECLARE Var_TasaIVA		DECIMAL(12,2);
DECLARE Var_GarantiaID  INT(11);
DECLARE Var_Estatus     CHAR(1);
DECLARE Var_EstGaran	CHAR(1);
DECLARE Var_EstatusCreR	CHAR(1);
DECLARE Var_EstatusCreCR CHAR(1);
DECLARE Var_CredRes		CHAR(1);
DECLARE Var_CredCont	CHAR(1);
DECLARE Var_AfectaGaran	CHAR(1);


-- Declaracion de Constantes
DECLARE Entero_Cero		INT;
DECLARE ConPincipal		INT;
DECLARE SI_AplicaIVA	CHAR(1);
DECLARE ConCredCastigar	INT(11);
DECLARE Con_Autoriza    CHAR(1);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Var_GaranPagada CHAR(1);
DECLARE Var_CredPagado 	CHAR(1);
DECLARE Var_CredCast 	CHAR(1);
DECLARE Cons_SI			CHAR(1);
DECLARE Cons_NO			CHAR(1);


-- Asignacion de Constantes
SET	Entero_Cero		:= 0;				-- Entero en Cero
SET ConPincipal 	:= 1;				-- Consulta principal
SET	SI_AplicaIVA	:= 'S';				-- Si aplica IVA en la Recuperacion de Cartera Castigada.
SET	ConCredCastigar	:= 2;				-- Consulta para mostrar el credito que se puede Castigar.
SET Con_Autoriza    := 'U';             -- Constante Autorizacion de una Garantia
SET Cadena_Vacia	:= '';				-- Constante de Cadena Vacia ''
SET Var_GaranPagada := 'P';				-- Constante de Garantia Pagada en tabla CREDITOS
SET Var_CredPagado 	:= 'P';				-- Constante de Estatus Pagado para Creditos
SET Var_CredCast 	:= 'K';				-- Constante de Estatus Pagado para Creditos
SET Cons_SI			:= 'S';				-- Constante SI
SET Cons_NO			:= 'N';				-- Constante NO



-- Inicializacion
SET	Var_TasaIVA := Entero_Cero;

SELECT IVARecuperacion INTO Var_AplicaIVA
	FROM PARAMSRESERVCASTIG;

SET	Var_AplicaIVA	:= IFNULL(Var_AplicaIVA, SI_AplicaIVA);


IF(Var_AplicaIVA = SI_AplicaIVA) THEN
	SELECT Suc.IVA INTO Var_TasaIVA
		FROM CREDITOS Cre,
			 SUCURSALES Suc
		WHERE CreditoID = Par_CreditoID
		  AND Cre.SucursalID = Suc.SucursalID;
END IF;

SET	Var_TasaIVA 	:= IFNULL(Var_TasaIVA, Entero_Cero);


IF (Par_NumCon = ConPincipal)THEN
            SELECT 	CreditoID,		Fecha,		FORMAT(CapitalCastigado,2) AS CapitalCastigado,
			FORMAT(InteresCastigado,2) AS InteresCastigado,
            ROUND(CapitalCastigado * (1 + Var_TasaIVA),2) +  ROUND(InteresCastigado * (1 + Var_TasaIVA),2) +
			ROUND(IntMoraCastigado * (1 + Var_TasaIVA),2) + ROUND(AccesorioCastigado * (1 + Var_TasaIVA),2) AS TotalCastigo,

			ROUND(MonRecuperado,2) AS MonRecuperado,
			EstatusCredito, MotivoCastigoID,Observaciones,
			FORMAT(IntMoraCastigado,2) AS IntMoraCastigado,
			FORMAT(AccesorioCastigado,2) AS AccesorioCastigado,
			FORMAT(InteresCastigado,2) AS InteresCastigado,
             ROUND(CapitalCastigado * Var_TasaIVA,2) +  ROUND(InteresCastigado * Var_TasaIVA,2) +
			ROUND(IntMoraCastigado *  Var_TasaIVA,2) + ROUND(AccesorioCastigado * Var_TasaIVA,2) AS IVA,

			ROUND(SaldoCapital * (1 + Var_TasaIVA),2) + ROUND(SaldoInteres * ( 1 + Var_TasaIVA),2) +
			ROUND(SaldoMoratorio * (1 + Var_TasaIVA),2) + ROUND(SaldoAccesorios * (1 + Var_TasaIVA),2) AS PorRecuperar
		FROM CRECASTIGOS
			WHERE CreditoID = Par_CreditoID;

END IF;

IF (Par_NumCon = ConCredCastigar)THEN
	-- Identificamos si el Crédito tiene Garantias Asignadas
    SELECT  TipoGarantiaFIRAID, EstatusGarantiaFIRA  INTO  Var_GarantiaID, Var_EstGaran
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

	SET Var_GarantiaID := IFNULL(Var_GarantiaID, Entero_Cero);
	SET Var_EstGaran := IFNULL(Var_EstGaran, Cadena_Vacia);

    IF(Var_GarantiaID <> Entero_Cero)THEN
	-- Si hay garantias Asignadas Identificamos el Estatus de la Garantia en CREDITOS

		IF(Var_EstGaran = Var_GaranPagada) THEN
		-- Si se aplico la Garantia al Credito
			SET Var_AfectaGaran	:= Cons_SI;

			SELECT Estatus INTO Var_EstatusCreR
			FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;
			IF (Var_EstatusCreR = Var_CredPagado OR Var_EstatusCreR = Var_CredCast) THEN
				SET Var_CredRes := Cons_SI;
			ELSE
				SET Var_CredRes := Cons_NO;
			END IF;

			SELECT Estatus INTO Var_EstatusCreCR
			FROM CREDITOSCONT
				WHERE CreditoID = Par_CreditoID;

			IF (Var_EstatusCreCR = Var_CredPagado OR Var_EstatusCreCR = Var_CredCast) THEN
				SET Var_CredCont := Cons_SI;
			ELSE
				SET Var_CredCont := Cons_NO;
			END IF;

		ELSE
		-- Si no se aplicaron las garantias
			SET Var_AfectaGaran	:= Cons_NO;

			SELECT Estatus INTO Var_EstatusCreR
			FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;

			IF (Var_EstatusCreR = Var_CredPagado OR Var_EstatusCreR = Var_CredCast) THEN
				SET Var_CredRes := Cons_SI;
			ELSE
				SET Var_CredRes := Cons_NO;
			END IF;

			SET Var_CredCont := Cons_SI;

		END IF;
	ELSE
		SET Var_AfectaGaran	:= Cons_NO;
		SELECT Estatus INTO Var_EstatusCreR
			FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;

			IF (Var_EstatusCreR = Var_CredPagado OR Var_EstatusCreR = Var_CredCast) THEN
				SET Var_CredRes := Cons_SI;
			ELSE
				SET Var_CredRes := Cons_NO;
			END IF;
		SET Var_CredCont := Cons_SI;
    END IF;

	SELECT Var_AfectaGaran AS AfectaGaran , Var_CredRes AS CredResPag, Var_CredCont AS CredContPag;

END IF;

END TerminaStore$$