-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOGRUPALCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGOGRUPALCREPRO`;
DELIMITER $$


CREATE PROCEDURE `PREPAGOGRUPALCREPRO`(
    Par_GrupoID         INT,
    Par_MontoPagar      DECIMAL(12, 2),
    Par_CuentaPago      BIGINT(12),
    Par_MonedaID        INT(11),
    Par_FormaPago       CHAR(1),

    Par_CicloGrupo      INT,
    Par_EmpresaID       INT(11),
    Par_AltaEncPoliza   CHAR(1),
    Par_OrigenPago      CHAR(1),        -- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida          CHAR(1),

INOUT	Var_Poliza		BIGINT,
OUT Var_MontoPago		DECIMAL(12, 2),
OUT Par_NumErr			INT(11),
OUT Par_ErrMen			VARCHAR(400),
OUT Par_Consecutivo		BIGINT,

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_MontoCreOri DECIMAL(14,2);
DECLARE Var_FechaSis    DATETIME;
DECLARE Var_NumCiclo    INT;
DECLARE Var_TotalCiclo  INT;
DECLARE Var_PorcPago    DECIMAL(14,8);
DECLARE Var_PagoIndiv   DECIMAL(14,2);
DECLARE Var_AcumPagos   DECIMAL(14,2);
DECLARE Var_CreditoStr  VARCHAR(20);
DECLARE Var_MontoAplic  DECIMAL(14,2);
DECLARE Var_TotGrupo    DECIMAL(14,2);
DECLARE Var_TotGrupoEx  DECIMAL(14,2);
DECLARE Var_PagoIndivEx DECIMAL(14,2);


DECLARE Var_CreditoID   BIGINT(12);
DECLARE Var_CuentaID    BIGINT(12);
DECLARE Var_ClienteID   BIGINT;
DECLARE Var_MonedaID    INT(11);
DECLARE Var_SolCredID   BIGINT;
DECLARE Var_SucCliente  INT;
DECLARE Var_TotCredito  DECIMAL(14,2);
DECLARE Var_TotCreditoEx         DECIMAL(14,2);
DECLARE Var_TipoPrepago          CHAR(1);
DECLARE Var_PrepagGpoCuotaActual CHAR(1);

/* Declaracion de Constantes */
DECLARE	Cadena_Vacia		CHAR(1);
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

DECLARE Forma_CargoCue  CHAR(1);
DECLARE Forma_Efectivo  CHAR(1);
DECLARE Des_DepPagCre   VARCHAR(50);
DECLARE Des_ConPagCre   VARCHAR(50);
DECLARE Aho_DepEfeVen   CHAR(4);

DECLARE Var_CicloActual     INT;
DECLARE Con_Origen		    CHAR(1);
DECLARE RespaldaCredSI		CHAR(1);
DECLARE Prepago_CuotasSig	  CHAR(1);
DECLARE PrepagoGpoCuotaActual VARCHAR(50);
DECLARE Si_ProrrateaGpo       CHAR(1);

-- Declaracion de Cursores
DECLARE CURSORGRUPO CURSOR FOR
    SELECT  Cre.CreditoID,          Cre.CuentaID,           Cre.ClienteID,      Cre.MonedaID,
            Sol.SolicitudCreditoID, Cli.SucursalOrigen,		Cre.TipoPrepago,
            FUNCIONCONFINIQCRE(Cre.CreditoID),
            FUNCIONEXIGIBLEACT(Cre.CreditoID)
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
          AND	(Cre.Estatus		= Esta_Vigente
               OR  Cre.Estatus		= Esta_Vencido);

DECLARE CURSORGRUPOHIS CURSOR FOR
    SELECT  Cre.CreditoID,          Cre.CuentaID,           Cre.ClienteID,      Cre.MonedaID,
            Sol.SolicitudCreditoID, Cli.SucursalOrigen,		Cre.TipoPrepago,
            FUNCIONCONFINIQCRE(Cre.CreditoID),
            FUNCIONEXIGIBLEACT(Cre.CreditoID)
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
          AND	(Cre.Estatus		= Esta_Vigente
               OR  Cre.Estatus		= Esta_Vencido);

/* Asignacion de Constantes */
SET	Cadena_Vacia		:= '';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Par_SalidaNO    := 'N';
SET Par_SalidaSI    := 'S';
SET Si_Prorratea    := 'S';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET AltaPoliza_NO   := 'N';
SET AltaPoliza_SI   := 'S';
SET AltaMovAho_SI   := 'S';
SET Con_AhoCapital  := 1;

SET Pol_Automatica  := 'A';
SET Coc_PagoCred    := 54;

SET Esta_Activo     := 'A';
SET Esta_Vencido    := 'B';
SET Esta_Vigente    := 'V';

SET Esta_Pagado     := 'P';
SET Forma_CargoCue  := 'C';
SET Forma_Efectivo  := 'E';

SET Des_DepPagCre   := 'DEP.PAGO DE CREDITO';
SET Des_ConPagCre   := 'PAGO DE CREDITO';
SET Aho_DepEfeVen   := '10';

SET Aud_ProgramaID  := 'PAGOCREDITOPRO';
SET Con_Origen		:= 'S';			-- Constante Origen donde se llama el SP (S= safy, W=WS)
SET RespaldaCredSI	:= 'S';
SET Prepago_CuotasSig	:= 'I'; 	-- Prepago a las cuotas siguientes inmediatas
SET PrepagoGpoCuotaActual:='PrepagoGrupoCuotaActual';
SET Si_ProrrateaGpo    := 'S';


ManejoErrores: BEGIN

SELECT CicloActual INTO Var_CicloActual
    FROM 	GRUPOSCREDITO
    WHERE GrupoID = Par_GrupoID;

SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);
SET Var_PrepagGpoCuotaActual:=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro=PrepagoGpoCuotaActual);

-- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
-- Entonces Buscamos los Integrantes en el Historico
IF(Par_CicloGrupo = Var_CicloActual) THEN
    SELECT  SUM(MontoCredito), COUNT(MontoCredito),
            SUM(FUNCIONCONFINIQCRE(Cre.CreditoID)),
            SUM(FUNCIONEXIGIBLEACT(Cre.CreditoID)) INTO
            Var_MontoCreOri, Var_TotalCiclo, Var_TotGrupo,
            Var_TotGrupoEx
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre
        WHERE Ing.GrupoID               = Par_GrupoID
          AND Ing.Estatus               = Esta_Activo
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          AND Ing.ProrrateaPago         = Si_Prorratea
          AND Sol.CreditoID             = Cre.CreditoID
          AND	(   Cre.Estatus		= Esta_Vigente
               OR  Cre.Estatus		= Esta_Vencido	);
ELSE
    SELECT  SUM(MontoCredito), COUNT(MontoCredito),
            SUM(FUNCIONCONFINIQCRE(Cre.CreditoID)),
            SUM(FUNCIONEXIGIBLEACT(Cre.CreditoID)) INTO
            Var_MontoCreOri, Var_TotalCiclo, Var_TotGrupo,
            Var_TotGrupoEx
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
               OR  Cre.Estatus		= Esta_Vencido	);
END IF;


SET Var_MontoCreOri := IFNULL(Var_MontoCreOri, Entero_Cero);
SET Var_TotGrupo := IFNULL(Var_TotGrupo, Entero_Cero);

IF (Var_TotGrupo <= Entero_Cero) THEN
    SET Par_NumErr		:= 001;
    SET Par_ErrMen		:= 'Error en Pago. El Grupo no Presenta Adeudos';
    SET Par_Consecutivo	:= 0;
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

-- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
-- Entonces Buscamos los Integrantes en el Historico
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
        Var_CreditoID,          Var_CuentaID,   	Var_ClienteID,  Var_MonedaID,   Var_SolCredID,
        Var_SucCliente,         Var_TipoPrepago,	Var_TotCredito,	Var_TotCreditoEx;
    ELSE
        FETCH CURSORGRUPOHIS INTO
        Var_CreditoID,          Var_CuentaID,   	Var_ClienteID,  Var_MonedaID,   Var_SolCredID,
        Var_SucCliente,         Var_TipoPrepago,	Var_TotCredito,	Var_TotCreditoEx;
    END IF;

    SET Var_PorcPago    := Entero_Cero;
    SET Var_PagoIndiv   := Entero_Cero;
    SET Var_MontoPago   := Entero_Cero;
    
  
        IF (Var_TipoPrepago = Prepago_CuotasSig AND Var_PrepagGpoCuotaActual =  Si_ProrrateaGpo) THEN
            IF Par_MontoPagar >= Var_TotGrupoEx THEN
                SET Var_PagoIndiv   := Var_TotCreditoEx;
                SET Var_PorcPago    := ROUND(Var_TotCredito / Var_TotGrupo, 8);
                SET Var_PagoIndiv   := Var_PagoIndiv + ROUND(Var_PorcPago * (Par_MontoPagar-Var_TotGrupoEx), 2);
            ELSE
                SET Var_PorcPago    := ROUND(Var_TotCredito / Var_TotGrupo, 8);
                SET Var_PagoIndiv   := ROUND(Var_PorcPago * Par_MontoPagar, 2);
            END IF;
        ELSE
            SET Var_PorcPago    := ROUND(Var_TotCredito / Var_TotGrupo, 8);
            SET Var_PagoIndiv   := ROUND(Var_PorcPago * Par_MontoPagar, 2);
        END IF;
    -- Verificamos si es el Ultimo Registro el CURSOR
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
        /* se llama al sp que realiza el prepago */
        CALL PREPAGOCREDITOPRO(
            Var_CreditoID,      Var_CuentaID,       Var_PagoIndiv,      Var_MonedaID,       Par_EmpresaID,
            Par_SalidaNO,       AltaPoliza_NO,      Var_MontoPago,      Var_Poliza,         Par_NumErr,
            Par_ErrMen,         Par_Consecutivo,    Par_FormaPago,      Par_OrigenPago,			RespaldaCredSI,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

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

SET Par_NumErr		:= 000;
SET Par_ErrMen		:= CONCAT('PrePago Exitoso. Monto del Pago Aplicado: ', FORMAT(Var_MontoPago,2));
SET Par_Consecutivo	:= 0;

END ManejoErrores;

IF (Par_Salida = Par_SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Poliza AS control,
            Aud_NumTransaccion AS consecutivo;
END IF;

END TerminaStore$$