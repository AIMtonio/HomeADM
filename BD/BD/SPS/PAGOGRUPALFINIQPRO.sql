-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOGRUPALFINIQPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOGRUPALFINIQPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGOGRUPALFINIQPRO`(
  Par_GrupoID         INT,
    Par_MontoPagar      DECIMAL(12,2),
    Par_CuentaPago      INT,
    Par_MonedaID        INT,
    Par_FormaPago       CHAR(1),
    Par_CicloGrupo      INT,

    Par_EmpresaID       INT,
    Par_AltaEncPoliza   CHAR(1),
    Par_Salida          CHAR(1),

	INOUT Var_Poliza	BIGINT,
	INOUT Var_MontoPago	DECIMAL(12,2),
  Par_OrigenPago    CHAR(1),      -- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	INOUT Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),
	INOUT	Par_Consecutivo	BIGINT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_FechaSis    DATETIME;
DECLARE Var_NumCiclo    INT;
DECLARE Var_TotalCiclo  INT;
DECLARE Var_PorcPago    DECIMAL(14,8);
DECLARE Var_PagoIndiv   DECIMAL(14,2);
DECLARE Var_AcumPagos   DECIMAL(14,2);
DECLARE Var_CreditoStr  VARCHAR(20);
DECLARE Var_MontoAplic  DECIMAL(14,2);
DECLARE Var_TotGrupo    DECIMAL(14,2);

DECLARE Var_CreditoID   BIGINT;
DECLARE Var_CuentaID    BIGINT(12);
DECLARE Var_ClienteID   BIGINT;
DECLARE Var_MonedaID    INT;
DECLARE Var_SolCredID   BIGINT;
DECLARE Var_SucCliente  INT;
DECLARE Var_TotCredito  DECIMAL(14,2);


-- Declaracion de Variables
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    INT;
DECLARE Par_SalidaNO    CHAR(1);
DECLARE Par_SalidaSI    CHAR(1);
DECLARE Si_Prorratea    CHAR(1);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaPoliza_SI   CHAR(1);
DECLARE AltaMovAho_SI   CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE Coc_PagoCred    INT;
DECLARE Con_AhoCapital  INT;

DECLARE Esta_Activo     CHAR(1);
DECLARE Esta_Vencido    CHAR(1);
DECLARE Esta_Vigente    CHAR(1);

DECLARE Esta_Pagado     CHAR(1);

DECLARE SI_EsPrePago    CHAR(1);
DECLARE NO_EsPrePago    CHAR(1);
DECLARE SI_EsFiniquito  CHAR(1);
DECLARE Pago_Ordinario  CHAR(1);
DECLARE Pago_Finiquito  CHAR(1);
DECLARE Pago_Anticipado CHAR(1);

DECLARE Forma_CargoCue  CHAR(1);
DECLARE Forma_Efectivo  CHAR(1);
DECLARE Des_DepPagCre   VARCHAR(50);
DECLARE Des_ConPagCre   VARCHAR(50);
DECLARE Aho_DepEfeVen   CHAR(4);
DECLARE Var_CicloActual     INT;
DECLARE Con_Origen		CHAR(1);
DECLARE RespaldaCredSI	CHAR(1);
DECLARE Estatus_Suspendido    CHAR(1);      -- Estatus Suspendido


DECLARE CURSORGRUPO CURSOR FOR
    SELECT  Cre.CreditoID,          Cre.CuentaID,           Cre.ClienteID,      Cre.MonedaID,
            Sol.SolicitudCreditoID, Cli.SucursalOrigen,
            FUNCIONCONFINIQCRE(Cre.CreditoID)
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre,
             CLIENTES Cli
        WHERE Ing.GrupoID               = Par_GrupoID
          AND Ing.Estatus               = Esta_Activo
          AND Ing.ProrrateaPago         = Si_Prorratea
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          AND Cre.ClienteID             = Cli.ClienteID
          AND Sol.CreditoID             = Cre.CreditoID
          AND	(   Cre.Estatus		= Esta_Vigente
               OR  Cre.Estatus		= Esta_Vencido
               OR  Cre.Estatus    = Estatus_Suspendido
          );

DECLARE CURSORGRUPOHIS CURSOR FOR
    SELECT  Cre.CreditoID,          Cre.CuentaID,           Cre.ClienteID,      Cre.MonedaID,
            Sol.SolicitudCreditoID, Cli.SucursalOrigen,
            FUNCIONCONFINIQCRE(Cre.CreditoID)
        FROM `HIS-INTEGRAGRUPOSCRE` Ing,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre,
             CLIENTES Cli
        WHERE Ing.GrupoID               = Par_GrupoID
          AND Ing.Estatus               = Esta_Activo
          AND Ing.ProrrateaPago         = Si_Prorratea
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          AND Ing.Ciclo                 = Par_CicloGrupo
          AND Cre.ClienteID             = Cli.ClienteID
          AND Sol.CreditoID             = Cre.CreditoID
          AND	(   Cre.Estatus		= Esta_Vigente
               OR  Cre.Estatus		= Esta_Vencido
               OR  Cre.Estatus    = Estatus_Suspendido
          );

-- Asignacion de Constantes
SET Entero_Cero     := 0;       -- Entero en Cero
SET Decimal_Cero    := 0.00;      -- DECIMAL en Cero
SET Par_SalidaNO    := 'N';       -- Salida: NO
SET Par_SalidaSI    := 'S';       -- Salida: SI
SET Si_Prorratea    := 'S';         -- Si prorratea el pago en el grupo
SET Nat_Cargo       := 'C';       -- Naturaleza de Cargo
SET Nat_Abono       := 'A';       -- Naturaleza de Abono
SET AltaPoliza_NO   := 'N';         -- Alta del Encabezado de la Poliza: NO
SET AltaPoliza_SI   := 'S';         -- Alta del Encabezado de la Poliza: SI
SET AltaMovAho_SI   := 'S';       -- Alta del Movimiento de Ahorro: SI
SET Con_AhoCapital  := 1;           -- Concepto de Ahorro: Capital

SET Pol_Automatica  := 'A';       -- Tipo de Poliza Automatica
SET Coc_PagoCred    := 54;          -- Concepto Contable: Pago de Credito

SET Esta_Activo     := 'A';         -- Estatus: Activo
SET Esta_Vencido    := 'B';         -- Estatus: Vencido
SET Esta_Vigente    := 'V';         -- Estatus: Vigente
SET Esta_Pagado     := 'P';         -- Estatus: Pagado

SET SI_EsPrePago    := 'S';       -- Es Prepago: SI
SET NO_EsPrePago    := 'N';         -- Es Prepago: NO
SET SI_EsFiniquito  := 'S';         -- Es Finiquito: SI

SET Pago_Ordinario  := 'O';         -- Tipo de Pago: Ordinario
SET Pago_Finiquito  := 'F';         -- Tipo de Pago: Finiquito
SET Pago_Anticipado := 'A';         -- Tipo de Pago: Anticipado

SET Forma_CargoCue  := 'C';         -- Forma de Pago: Con Cargo a Cuenta
SET Forma_Efectivo  := 'E';         -- Forma de Pago: Efectivo
SET Aho_DepEfeVen   := '10';      -- Tipo de Deposito en Efectivo

SET Des_DepPagCre   := 'DEP.PAGO DE CREDITO';       -- Descripcion Operativa
SET Des_ConPagCre   := 'PAGO DE CREDITO';	        -- Descripcion Contable
SET Aud_ProgramaID  := 'PAGOCREDITOPRO';			-- Programa ID
SET Con_Origen		:= 'S';				-- Constante Origen donde se llama el SP (S= safy, W=WS)
SET RespaldaCredSI	:= 'S';
SET Estatus_Suspendido := 'S';  -- Estatus Suspendido

ManejoErrores: BEGIN

SELECT CicloActual INTO Var_CicloActual
    FROM  GRUPOSCREDITO
    WHERE GrupoID = Par_GrupoID;

SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);


IF(Par_CicloGrupo = Var_CicloActual) THEN
    SELECT  COUNT(MontoCredito),
            SUM(FUNCIONCONFINIQCRE(Cre.CreditoID)) INTO
            Var_TotalCiclo, Var_TotGrupo
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre
        WHERE Ing.GrupoID               = Par_GrupoID
          AND Ing.Estatus               = Esta_Activo
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          AND Ing.ProrrateaPago         = Si_Prorratea
          AND Sol.CreditoID             = Cre.CreditoID
          AND	(   Cre.Estatus		= Esta_Vigente
               OR  Cre.Estatus		= Esta_Vencido
               OR  Cre.Estatus    = Estatus_Suspendido
          );
ELSE
    SELECT  COUNT(MontoCredito),
            SUM(FUNCIONCONFINIQCRE(Cre.CreditoID)) INTO
            Var_TotalCiclo, Var_TotGrupo
        FROM `HIS-INTEGRAGRUPOSCRE` Ing,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre
        WHERE Ing.GrupoID               = Par_GrupoID
          AND Ing.Estatus               = Esta_Activo
          AND Ing.Ciclo                 = Par_CicloGrupo
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          AND Ing.ProrrateaPago         = Si_Prorratea
          AND Sol.CreditoID             = Cre.CreditoID
          AND	(   Cre.Estatus		= Esta_Vigente
               OR  Cre.Estatus		= Esta_Vencido
               OR  Cre.Estatus    = Estatus_Suspendido
          );
END IF;

SET Var_TotGrupo := IFNULL(Var_TotGrupo, Entero_Cero);

IF (Var_TotGrupo <= Entero_Cero) THEN
    SET Par_NumErr    := 1;
    SET Par_ErrMen    := 'Error en Pago. El Grupo no Presenta Adeudos';
    SET Par_Consecutivo := 0;
    LEAVE ManejoErrores;
END IF;


IF (Par_MontoPagar < Var_TotGrupo) THEN
    SET Par_NumErr    := 2;
    SET Par_ErrMen    := 'Error en Pago. En Finiquito el Monto del Pago debe ser por el Total.';
    SET Par_Consecutivo := 0;
    LEAVE ManejoErrores;
END IF;

SELECT FechaSistema INTO Var_FechaSis
  FROM PARAMETROSSIS;

SET Var_NumCiclo    := 1;
SET Var_AcumPagos   := Decimal_Cero;
SET Var_MontoAplic  := Decimal_Cero;


IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
    CALL MAESTROPOLIZAALT(
        Var_Poliza,     Par_EmpresaID,  Var_FechaSis,   Pol_Automatica,     Coc_PagoCred,
        Des_ConPagCre,  Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
END IF;



IF(Par_CicloGrupo = Var_CicloActual) THEN
    OPEN CURSORGRUPO;
ELSE
    OPEN CURSORGRUPOHIS;
END IF;

BEGIN
  DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
  CICLO:LOOP

    IF(Par_CicloGrupo = Var_CicloActual) THEN
        FETCH CURSORGRUPO INTO
        Var_CreditoID,  Var_CuentaID,   Var_ClienteID,  Var_MonedaID,   Var_SolCredID,
        Var_SucCliente, Var_TotCredito;
    ELSE
        FETCH CURSORGRUPOHIS INTO
        Var_CreditoID,  Var_CuentaID,   Var_ClienteID,  Var_MonedaID,   Var_SolCredID,
        Var_SucCliente, Var_TotCredito;
    END IF;

    SET Var_PorcPago    := Entero_Cero;
    SET Var_PagoIndiv   := Entero_Cero;
    SET Var_MontoPago   := Entero_Cero;


  SET Var_PorcPago    := ROUND(Var_TotCredito / Var_TotGrupo, 8);
  SET Var_PagoIndiv   := ROUND(Var_PorcPago * Par_MontoPagar, 2);

  -- Si es la ultima iteracion del Ciclo, por el Tema de Redondeos
    IF(Var_NumCiclo = Var_TotalCiclo) THEN
        SET Var_PagoIndiv   = Par_MontoPagar - Var_AcumPagos;
    END IF;

    SET Var_CreditoStr  := CONVERT(Var_CreditoID, CHAR(15));

    IF (Var_PagoIndiv > Entero_Cero) THEN

        IF(Par_FormaPago = Forma_Efectivo ) THEN
            CALL CONTAAHORROPRO (
                Var_CuentaID,       Var_ClienteID,  Aud_NumTransaccion, Var_FechaSis,       Var_FechaSis,
                Nat_Abono,          Var_PagoIndiv,  Des_DepPagCre,      Var_CreditoStr,     Aho_DepEfeVen,
                Var_MonedaID,       Var_SucCliente, AltaPoliza_NO,      Entero_Cero,        Var_Poliza,
                AltaMovAho_SI,      Con_AhoCapital, Nat_Abono,          Par_NumErr,         Par_ErrMen,
                Par_Consecutivo,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);
        ELSE
            SET Var_CuentaID    := Par_CuentaPago;
        END IF;

		CALL PAGOCREDITOPRO(
      Var_CreditoID,        Var_CuentaID,         Var_PagoIndiv,      Var_MonedaID,       NO_EsPrePago,
      SI_EsFiniquito,		    Par_EmpresaID,         Par_SalidaNO,       AltaPoliza_NO,      Var_MontoPago,
      Var_Poliza,           Par_NumErr,           Par_ErrMen,         Par_Consecutivo,     Par_FormaPago,
      Par_OrigenPago,         RespaldaCredSI,     Aud_Usuario,        Aud_FechaActual,     Aud_DireccionIP,
      Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            SET Var_MontoPago   := Entero_Cero;
            SET Var_MontoAplic  := Entero_Cero;
            LEAVE CICLO;
        END IF;

        SET Var_MontoAplic  := Var_MontoAplic + Var_MontoPago;
        SET Var_AcumPagos   := Var_AcumPagos + Var_PagoIndiv;

    END IF;

    SET Var_NumCiclo    := Var_NumCiclo + 1;

  END LOOP CICLO;
END;

IF(Par_CicloGrupo = Var_CicloActual) THEN
    CLOSE CURSORGRUPO;
ELSE
    CLOSE CURSORGRUPOHIS;
END IF;


IF (Par_NumErr <> Entero_Cero)THEN
    LEAVE ManejoErrores;
END IF;

SET Var_MontoPago := Var_MontoAplic;


SET Par_NumErr    := 0;
SET Par_ErrMen    := CONCAT('Finiquito del Grupo Aplicado Correctamente. Monto del Pago Aplicado: ', format(Var_MontoPago,2));
SET Par_Consecutivo := 0;

END ManejoErrores;

IF (Par_Salida = Par_SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'creditoID' AS control,
            Var_Poliza AS consecutivo;
END IF;

END TerminaStore$$