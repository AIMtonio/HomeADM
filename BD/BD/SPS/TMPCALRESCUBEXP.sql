-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALRESCUBEXP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCALRESCUBEXP`;DELIMITER $$

CREATE PROCEDURE `TMPCALRESCUBEXP`(
    Par_Fecha           DATETIME
)
TerminaStore: BEGIN


DECLARE var_LimiteExpuesto  INT;
DECLARE var_TipoInstitucion CHAR(2);
DECLARE Var_Poliza          BIGINT;
DECLARE Var_FecApl          DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE Var_NomBalance      VARCHAR(50);
DECLARE Var_NomResult       VARCHAR(50);
DECLARE Var_CueMayRes       VARCHAR(15);
DECLARE Var_CueMayBal       VARCHAR(15);

DECLARE Var_NomBalIntere	VARCHAR(50);
DECLARE Var_CueMayBalInt	VARCHAR(15);
DECLARE Var_CRBalIntere		VARCHAR(10);

DECLARE Var_NomResIntere	VARCHAR(50);
DECLARE Var_CueMayResInt	VARCHAR(15);
DECLARE Var_CRResIntere		VARCHAR(10);

DECLARE Var_NomPtePrinci	VARCHAR(50);
DECLARE Var_CueMayPtePri	VARCHAR(15);
DECLARE Var_CRPtePrinci		VARCHAR(10);

DECLARE Var_NomPteIntere	VARCHAR(50);
DECLARE Var_CueMayPteInt	VARCHAR(15);
DECLARE Var_CRPteIntere		VARCHAR(10);

DECLARE	Var_CuentaEPRC	VARCHAR(50);
DECLARE	Var_CenCosEPRC	VARCHAR(10);
DECLARE	Var_ConcepConta	INT;

DECLARE Var_FecAntRes       DATE;
DECLARE Var_NumRegCal       INT;

DECLARE Var_MonCubCapita    DECIMAL(14,2);
DECLARE Var_MonCubIntere    DECIMAL(14,2);
DECLARE Var_MonCobTotal     DECIMAL(14,2);
DECLARE Var_SaldoCobert     DECIMAL(14,2);
DECLARE Var_ResCapitaCub    DECIMAL(14,2);
DECLARE Var_ResIntereCub    DECIMAL(14,2);
DECLARE Var_InvGarantia		DECIMAL(14,2);
DECLARE Var_InvGarantiaHis	DECIMAL(14,2);

DECLARE Var_PorcReserva     DECIMAL(12,4);
DECLARE Var_SaldoInteres    DECIMAL(14,2);
DECLARE Var_SaldoCapital    DECIMAL(14,2);
DECLARE Var_CreditoID       BIGINT(12);
DECLARE Var_Clasifica       CHAR(1);
DECLARE Var_CuentaID        BIGINT;
DECLARE Var_ClienteID		BIGINT;

DECLARE Var_PorVivienda     DECIMAL(12,6);
DECLARE Var_PorConsumo      DECIMAL(12,6);
DECLARE Var_PorComercial    DECIMAL(12,6);
DECLARE	Var_PorResComercial	DECIMAL(12,6);
DECLARE	Var_PorResConsumo	DECIMAL(12,6);
DECLARE	Var_PorResVivienda	DECIMAL(12,6);

DECLARE Var_PorCeroDias     DECIMAL(12,6);

DECLARE Var_CRResul			VARCHAR(10);
DECLARE Var_CRBalance		VARCHAR(10);

DECLARE Var_RegContaEPRC	CHAR(1);
DECLARE Var_DivideEPRC	  	CHAR(1);
DECLARE Var_EPRCIntMorato	CHAR(1);
DECLARE Var_ResOrigen		CHAR(1);
DECLARE Var_EsReestruc		CHAR(1);



DECLARE Decimal_Cien    DECIMAL(12,2);
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE MetParametrico  CHAR(1);
DECLARE TipoExpuesta    CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE Con_GenReserva  INT;
DECLARE Ref_GenReserva  VARCHAR(50);
DECLARE Ref_CanReserva  VARCHAR(50);
DECLARE Par_SalidaNO    CHAR(1);
DECLARE Con_Balance     INT;
DECLARE Con_Resultados  INT;
DECLARE Con_BalIntere	INT;
DECLARE Con_ResIntere  	INT;
DECLARE Con_PtePrinci	INT;
DECLARE Con_PteIntere  	INT;
DECLARE Procedimiento   VARCHAR(20);
DECLARE For_CueMayor    CHAR(3);
DECLARE For_TipProduc   CHAR(3);
DECLARE For_TipCartera  CHAR(3);
DECLARE For_Clasifica   CHAR(3);
DECLARE	For_SubClasif	CHAR(3);
DECLARE For_Moneda      CHAR(3);
DECLARE Cla_Comercial   CHAR(1);
DECLARE Cla_Consumo     CHAR(1);
DECLARE Cla_Vivienda    CHAR(1);
DECLARE Si_AplicaConta  CHAR(1);
DECLARE NOPagaIVA       CHAR(1);
DECLARE Esta_Activa     CHAR(1);
DECLARE Gar_Liquida     INT;
DECLARE Clas_DepInstit  INT;
DECLARE Clas_InvInstit  INT;
DECLARE Estatus_Vigente CHAR(1);
DECLARE Estatus_Pagado  CHAR(1);
DECLARE Estatus_Vencida CHAR(1);
DECLARE Cec_SucOrigen  	VARCHAR(10);
DECLARE Cec_SucCliente	VARCHAR(10);
DECLARE Tip_InsCredito	INT;
DECLARE EPRC_Resultados	CHAR(1);
DECLARE SI_DivideEPRC	CHAR(1);
DECLARE NO_DivideEPRC	CHAR(1);
DECLARE SI_ReservaMora		CHAR(1);
DECLARE NO_ReservaMora		CHAR(1);
DECLARE No_EsReestruc       CHAR(1);
DECLARE Si_EsReestruc       CHAR(1);
DECLARE Tipo_Renovacion		CHAR(1);



DECLARE CURSORRESERVA CURSOR FOR
    SELECT  Cal.CreditoID,	Cal.Capital, 	Cal.Interes, Cal.PorcReservaExp,   Cal.Clasificacion,
            Cre.CuentaID,	Cre.ClienteID,	Res.Origen
        FROM CALRESCREDITOS Cal,
             CREDITOS Cre
		LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID

        WHERE Cal.Fecha = Par_Fecha
          AND Cre.CreditoID = Cal.CreditoID;


SET Decimal_Cien    := 100.00;
SET Decimal_Cero    := 0.00;
SET MetParametrico  := 'P';
SET TipoExpuesta    := 'E';
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Pol_Automatica  := 'A';
SET Con_GenReserva  := 56;
SET Par_SalidaNO    := 'N';
SET Con_Balance     := 17;
SET Con_Resultados  := 18;
SET Con_BalIntere	:= 36;
SET Con_ResIntere  	:= 37;
SET Con_PtePrinci	:= 38;
SET Con_PteIntere  	:= 39;
SET For_CueMayor    := '&CM';
SET For_TipProduc   := '&TP';
SET For_Clasifica   := '&CL';
SET For_SubClasif   := '&SC';
SET For_Moneda      := '&TM';

SET Cla_Comercial   := 'C';
SET Cla_Consumo     := 'O';
SET Cla_Vivienda    := 'H';
SET Si_AplicaConta  := 'S';
SET NOPagaIVA       := 'N';
SET Estatus_Vigente := 'V';
SET Estatus_Vencida := 'B';
SET Estatus_Pagado  := 'P';
SET Esta_Activa     := 'A';
SET Gar_Liquida     := 1;
SET Clas_DepInstit  := 1;
SET Clas_InvInstit  := 2;
SET Cec_SucOrigen  	:= '&SO';
SET Cec_SucCliente	:= '&SC';
SET	Tip_InsCredito	:= 11;
SET EPRC_Resultados	:= 'R';
SET SI_DivideEPRC	:= 'S';
SET NO_DivideEPRC	:= 'N';
SET SI_ReservaMora	:= 'S';
SET NO_ReservaMora	:= 'N';
SET No_EsReestruc	:= 'N';
SET Si_EsReestruc	:= 'S';
SET	Tipo_Renovacion	:= 'O';

SET Ref_GenReserva  := 'GENERACION DE RESERVAS';
SET Ref_CanReserva  := 'ACT.RESERVAS. ';
SET Procedimiento   := 'POLIZACREDITOPRO';

SELECT  TipoInstitucion,    LimiteExpuesto
    INTO var_TipoInstitucion, var_LimiteExpuesto
    FROM PARAMSCALIFICA;

SELECT RegContaEPRC, DivideEPRCCapitaInteres, EPRCIntMorato INTO Var_RegContaEPRC, Var_DivideEPRC, Var_EPRCIntMorato
	FROM PARAMSRESERVCASTIG;

SET	Var_RegContaEPRC := IFNULL(Var_RegContaEPRC, EPRC_Resultados);
SET	Var_DivideEPRC	:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
SET	Var_EPRCIntMorato	:= IFNULL(Var_EPRCIntMorato, NO_ReservaMora);


SET Var_FecAntRes := IFNULL(Var_FecAntRes, Fecha_Vacia);



SELECT PorResCarSReest, PorResCarReest INTO Var_PorComercial, Var_PorResComercial
    FROM PORCRESPERIODO
    WHERE LimInferior <= Entero_Cero
      AND TipoInstitucion = TipoInstitucion
      AND Estatus = Esta_Activa
      AND Clasificacion = Cla_Comercial;

SELECT PorResCarSReest, PorResCarReest INTO Var_PorConsumo, Var_PorResConsumo
    FROM PORCRESPERIODO
    WHERE LimInferior <= Entero_Cero
      AND TipoInstitucion = TipoInstitucion
      AND Estatus = Esta_Activa
      AND Clasificacion = Cla_Consumo;

SELECT PorResCarSReest, PorResCarReest INTO Var_PorVivienda, Var_PorResVivienda
    FROM PORCRESPERIODO
    WHERE LimInferior <= Entero_Cero
      AND TipoInstitucion = TipoInstitucion
      AND Estatus = Esta_Activa
      AND Clasificacion = Cla_Vivienda;

SET Var_PorVivienda := IFNULL(Var_PorVivienda, Entero_Cero) / 100;
SET Var_PorConsumo := IFNULL(Var_PorConsumo, Entero_Cero) / 100;
SET Var_PorComercial := IFNULL(Var_PorComercial, Entero_Cero) / 100;

SET Var_PorResComercial := IFNULL(Var_PorResComercial, Entero_Cero) / 100;
SET Var_PorResConsumo := IFNULL(Var_PorResConsumo, Entero_Cero) / 100;
SET Var_PorResVivienda := IFNULL(Var_PorResVivienda, Entero_Cero) / 100;



OPEN CURSORRESERVA;
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP

    FETCH CURSORRESERVA INTO
        Var_CreditoID,	Var_SaldoCapital,	Var_SaldoInteres,   Var_PorcReserva,    Var_Clasifica,
        Var_CuentaID,	Var_ClienteID,		Var_ResOrigen;


        SET Var_MonCobTotal := Entero_Cero;
        SET Var_PorCeroDias := Entero_Cero;
		SET	Var_InvGarantia	:= Entero_Cero;
		SET Var_InvGarantiaHis	:= Entero_Cero;
        SET Var_SaldoCapital := IFNULL(Var_SaldoCapital, Entero_Cero);
        SET Var_SaldoInteres := IFNULL(Var_SaldoInteres, Entero_Cero);
        SET Var_PorcReserva := IFNULL(Var_PorcReserva, Entero_Cero);
        SET Var_CuentaID := IFNULL(Var_CuentaID, Entero_Cero);
		SET	Var_ResOrigen := IFNULL(Var_ResOrigen, Cadena_Vacia);

        IF(Var_ResOrigen = Cadena_Vacia OR Var_ResOrigen = Tipo_Renovacion) THEN

            SET Var_EsReestruc  := No_EsReestruc;

			IF(Var_Clasifica = Cla_Vivienda) THEN
				SET Var_PorCeroDias := Var_PorVivienda;
			ELSEIF (Var_Clasifica = Cla_Consumo) THEN
				SET Var_PorCeroDias := Var_PorConsumo;
			ELSE
				SET Var_PorCeroDias := Var_PorComercial;
			END IF;

		ELSE
			SET Var_EsReestruc  := Si_EsReestruc;

			IF(Var_Clasifica = Cla_Vivienda) THEN
				SET Var_PorCeroDias := Var_PorResVivienda;
			ELSEIF (Var_Clasifica = Cla_Consumo) THEN
				SET Var_PorCeroDias := Var_PorResConsumo;
			ELSE
				SET Var_PorCeroDias := Var_PorResComercial;
			END IF;

        END IF;





		 SET Var_MonCobTotal  := (SELECT SUM(CASE WHEN NatMovimiento = 'B' THEN  MontoBloq ELSE MontoBloq *-1 END)
                                    FROM BLOQUEOS Blo,
                                         CUENTASAHO Cue
                                    WHERE Blo.CuentaAhoID = Cue.CuentaAhoID
									  AND DATE(FechaMov) <= Par_Fecha
                                      AND Blo.Referencia = Var_CreditoID
									  AND Cue.ClienteID = Var_ClienteID
                                      AND Blo.TiposBloqID = 8);



        SET Var_MonCobTotal := IFNULL(Var_MonCobTotal, Entero_Cero);




		SET Var_InvGarantia 	:= 0.0;
		SET Var_InvGarantiaHis	:= 0.0;

		SET Var_InvGarantia := (SELECT SUM(Gar.MontoEnGar)
									FROM CREDITOINVGAR Gar
									WHERE Gar.FechaAsignaGar <= Par_Fecha
									  AND Gar.CreditoID = Var_CreditoID);

		SET Var_InvGarantia := IFNULL(Var_InvGarantia, 0.0);

		SET Var_InvGarantiaHis := (	SELECT SUM(Gar.MontoEnGar)
									FROM HISCREDITOINVGAR Gar
									WHERE Gar.Fecha > Par_Fecha
									  AND Gar.FechaAsignaGar <= Par_Fecha
									  AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
									  AND Gar.CreditoID = Var_CreditoID  );

		SET	Var_InvGarantiaHis	:= IFNULL(Var_InvGarantiaHis, 0.0);

		SET Var_InvGarantia		:= (Var_InvGarantia + Var_InvGarantiaHis);





		SET	Var_InvGarantia	:= IFNULL(Var_InvGarantia, Entero_Cero);
		SET Var_MonCobTotal	:= Var_MonCobTotal + Var_InvGarantia;

        SET Var_SaldoCobert := Var_MonCobTotal;
        SET Var_MonCubCapita := Entero_Cero;
        SET Var_MonCubIntere := Entero_Cero;
        SET Var_ResCapitaCub := Entero_Cero;
        SET Var_ResIntereCub := Entero_Cero;


        IF(Var_MonCobTotal >= (Var_SaldoCapital + Var_SaldoInteres)) THEN
            SET Var_ResCapitaCub := ROUND(Var_SaldoCapital * Var_PorCeroDias, 2);
            SET Var_ResIntereCub := ROUND(Var_SaldoInteres * Var_PorCeroDias, 2);
            SET Var_MonCubCapita := Var_SaldoCapital;
            SET Var_MonCubIntere := Var_SaldoInteres;
            SET Var_SaldoCobert := Var_SaldoCobert - ( Var_SaldoCapital + Var_SaldoInteres);
        END IF;


        IF(Var_MonCobTotal > Entero_Cero AND Var_MonCobTotal < (Var_SaldoCapital + Var_SaldoInteres)) THEN

            IF(Var_MonCobTotal >= Var_SaldoCapital) THEN
                SET Var_ResCapitaCub := ROUND(Var_SaldoCapital * Var_PorCeroDias,2);
                SET Var_MonCubCapita := Var_SaldoCapital;
                SET Var_SaldoCobert := Var_SaldoCobert - Var_SaldoCapital;
            ELSE
                SET Var_ResCapitaCub := ROUND(Var_MonCobTotal * Var_PorCeroDias,2);
                SET Var_MonCubCapita := Var_MonCobTotal;
                SET Var_SaldoCobert := Entero_Cero;
            END IF;

            IF(Var_SaldoCobert > Entero_Cero) THEN
                SET Var_ResIntereCub := ROUND(Var_SaldoCobert * Var_PorCeroDias,2);
                SET Var_MonCubIntere := Var_SaldoCobert;
                SET Var_SaldoCobert := Entero_Cero;
            END IF;

        END IF;

        UPDATE CALRESCREDITOS SET

            ReservaTotCubierto  = Var_ResIntereCub + Var_ResCapitaCub,
            ReservaTotExpuesto  = ROUND((ROUND((Interes - Var_MonCubIntere) * PorcReservaExp, 2) +
										ROUND((Capital - Var_MonCubCapita) * PorcReservaExp, 2))/100,2),

            MontoGarantia = Var_MonCobTotal

            WHERE Fecha   = Par_Fecha
              AND CreditoID = Var_CreditoID;

    END LOOP;
END;
CLOSE CURSORRESERVA;

SELECT  000 AS NumErr,
	CONCAT("Estimacion Generada") AS ErrMen,
	'fechaCorte' AS control;


END TerminaStore$$