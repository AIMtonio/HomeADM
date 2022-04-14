-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTRUCCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REESTRUCCREDITOACT`;

DELIMITER $$
CREATE PROCEDURE `REESTRUCCREDITOACT`(
	Par_FechaRegistro       DATE,			-- Fecha de Registro
	Par_CreditoDestinoID    BIGINT(12),		-- Credito Destino
	Par_SaldoCredAnteri     DECIMAL(12,2),	-- Saldo credito Anterior
	Par_EstatusCredAnt      CHAR(1),		-- Estatus Credito Anterior
	Par_EstatusCreacion     CHAR(1),		-- Estatus de Creacion

	Par_NumDiasAtraOri      INT(11),		-- Numero de Dias de Atraso
	Par_NumPagoSoste        INT(11),		-- Numero de Pagos Sostenidos
	Par_NumPagoActual       INT(11),		-- Numero de Pagos Actuales
	Par_Poliza              BIGINT,			-- Numero de Poliza
	Par_TipoAct             INT(11),		-- Tipo de Actualizacion

	Par_Salida				CHAR(1),		-- Parametro de Salida
	OUT Par_NumErr			INT(11),		-- Numero de Error
	OUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Par_ModoPago			CHAR(1),
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Varaibles
    DECLARE Var_NumPagoSoste    INT(11);		-- Numero de Pagos Sostenidos
    DECLARE Var_NumPagoActual   INT(11);		-- Numero de Pagos Actuales
    DECLARE Var_EstCreacion     CHAR(1);		-- Estatus de Creacion
    DECLARE Var_Regularizado    CHAR(1);		-- Es Regularizado
    DECLARE Var_Reserva         DECIMAL(14,2);	-- Reserva expuesta

    DECLARE Var_MonedaID        INT(11);		-- Moneda ID
    DECLARE Var_ClasifCre       CHAR(1);		-- Clasificacion de Credito
    DECLARE Var_ProdCreID       INT(11);		-- Clasificacion de Credito
    DECLARE Var_SucCliente      INT(11);		-- Sucursal del Cliente
    DECLARE Str_NumErr          CHAR(3);		-- Cadena Error
    DECLARE Par_Consecutivo     BIGINT;			-- Consecutivo
    DECLARE Var_SubClasifID     INT(11);		-- Subclasificacion
    DECLARE Var_NumAmorti       INT(11);		-- Numero de Amortizaciones
	DECLARE Var_EsConsolidacionAgro	CHAR(1);	-- Es Credito Consolidado Agro
    DECLARE Var_EsConsolidado   VARCHAR(1);     -- Es Credito Consolidado

	-- Declaracion de Constantes
    DECLARE Cadena_Vacia    CHAR(1);		-- Constante Cadena Vacia
    DECLARE Entero_Cero     INT(11);		-- Constante Entero Vacio
    DECLARE Fecha_Vacia     DATE;			-- Constante Fecha Vacia
    DECLARE Var_SI          CHAR(1);		-- Constante SI
    DECLARE Var_NO          CHAR(1);		-- Constante NO
    DECLARE Act_Desembolso  INT(11);		-- Actualizacion de Desembolso
    DECLARE Act_PagoSost    INT(11);		-- Actualizacion de Pago Sostenido
    DECLARE NO_Regulariza   CHAR(1);		-- Constante Regulariza NO
    DECLARE SI_Regulariza   CHAR(1);		-- Constante Regulariza SI
    DECLARE Esta_Vencido    CHAR(1);		-- Constante Estatus Vencido
    DECLARE AltaPoliza_NO   CHAR(1);		-- Constante Alta Poliza NO
    DECLARE Con_EstBalance  INT(11);		-- Constante Balance General
    DECLARE Con_EstResultados   INT(11);	-- Constante Estatus Resultados
    DECLARE Est_Desemb      CHAR(1);		-- Constante Estatus Desembolso
    DECLARE AltaPolCre_SI   CHAR(1);		-- Constante Alta Poliza Credito SI
    DECLARE AltaMovCre_NO   CHAR(1);		-- Constante Alta Movimiento Credito NO
    DECLARE AltaMovAho_NO   CHAR(1);		-- Constante Alta Movimiento Ahorro NO
    DECLARE Nat_Cargo       CHAR(1);		-- Constante Naturaleza Cargo
    DECLARE Nat_Abono       CHAR(1);		-- Constante Naturaleza abono


    DECLARE Des_Reserva     VARCHAR(100);	-- Constante Descripcion Reserva
    DECLARE Ref_Regula      VARCHAR(100);	-- Constante Referencia Regulacion
    DECLARE Var_NumAmoExi   INT(11);		-- Numero de Amortizaciones
    DECLARE Esta_Pagado     CHAR(1);		-- Constante Estatus Pagado
    DECLARE Var_FechaSistema DATE;			-- Fecha de Sistema

    DECLARE Act_PagoSostenido	INT(11);	-- Actualizacion de Pago Sostenido

    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Var_SI          := 'S';
    SET Var_NO          := 'N';
    SET Act_Desembolso  := 1;
    SET Act_PagoSost    := 2;
    SET NO_Regulariza   := 'N';
    SET Esta_Vencido    := 'B';
    SET SI_Regulariza   := 'S';
    SET AltaPoliza_NO   := 'N';
    SET Con_EstBalance  := 17;
    SET Con_EstResultados   := 18;
    SET Est_Desemb      := 'D';
    SET AltaPolCre_SI   := 'S';
    SET AltaMovCre_NO   := 'N';
    SET AltaMovAho_NO   := 'N';
    SET Nat_Cargo       := 'C';
    SET Nat_Abono       := 'A';
    SET Des_Reserva     := 'CANC.ESTIM.CAPITALIZACION INTERES';
    SET Ref_Regula      := 'REGULARIZACION PAGO SOSTENIDO';
    SET Esta_Pagado     := 'P';
    SET Act_PagoSostenido	:= 1;


    SELECT  NumAmortizacion INTO  Var_NumAmorti
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoDestinoID;

    SELECT FechaSistema INTO Var_FechaSistema
        FROM PARAMETROSSIS;


IF ( Par_TipoAct = Act_Desembolso) THEN

    UPDATE REESTRUCCREDITO SET
        FechaRegistro       = Par_FechaRegistro,
        SaldoCredAnteri     = Par_SaldoCredAnteri,
        EstatusCredAnt      = Par_EstatusCredAnt,
        EstatusCreacion     = Par_EstatusCreacion,
        NumDiasAtraOri      = Par_NumDiasAtraOri,
        NumPagoSoste        = Par_NumPagoSoste,
        EstatusReest        = Est_Desemb,

        EmpresaID           = Aud_EmpresaID,
        Usuario             = Aud_Usuario,
        FechaActual         = Aud_FechaActual,
        DireccionIP         = Aud_DireccionIP,
        ProgramaID          = Aud_ProgramaID,
        Sucursal            = Aud_Sucursal,
        NumTransaccion      = Aud_NumTransaccion

        WHERE CreditoDestinoID    = Par_CreditoDestinoID;

    IF (Par_Salida = Var_SI ) THEN
        SELECT '000' AS NumErr,
                'Reestructura Actualizada' AS ErrMen,
                Entero_Cero AS control,
                Entero_Cero  AS consecutivo;
    ELSE
        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Reestructura Actualizada';
    END IF;

END IF;


IF ( Par_TipoAct = Act_PagoSost) THEN

	-- Seccion de consolidacion
	SELECT EsConsolidacionAgro,    EsConsolidado
	INTO Var_EsConsolidacionAgro,  Var_EsConsolidado 
	FROM CREDITOS
	WHERE CreditoID = Par_CreditoDestinoID;

	IF( IFNULL(Var_EsConsolidacionAgro, Var_NO) = Var_SI ) THEN

		CALL REGCRECONSOLIDADOSACT (
			Par_CreditoDestinoID,	Par_NumPagoActual,	Par_Poliza,			Par_ModoPago,	Act_PagoSostenido,
			Par_Salida,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			IF (Par_Salida = Var_SI ) THEN
				SELECT 	Par_NumErr AS NumErr,
						Par_ErrMen AS ErrMen,
						Entero_Cero AS control,
						Entero_Cero  AS consecutivo;
				LEAVE TerminaStore;
			END IF;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Consolidacion Actualizada';
		LEAVE TerminaStore;
	END IF;

    IF( IFNULL(Var_EsConsolidado, Var_NO) = Var_SI) THEN
    
        CALL REGCONSOLIDACIONCARTALIQACT (
            Par_CreditoDestinoID,   Par_NumPagoActual,  Par_Poliza,         Par_ModoPago,   Act_PagoSostenido,
            Par_Salida,             Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            IF (Par_Salida = Var_SI ) THEN
                SELECT  Par_NumErr AS NumErr,
                        Par_ErrMen AS ErrMen,
                        Entero_Cero AS control,
                        Entero_Cero  AS consecutivo;
                LEAVE TerminaStore;
            END IF;
        END IF;

        SET Par_NumErr := Entero_Cero;
        SET Par_ErrMen := 'Consolidacion Actualizada';
        LEAVE TerminaStore;
    END IF;


    UPDATE REESTRUCCREDITO SET
        NumPagoActual       = Par_NumPagoActual,

        EmpresaID           = Aud_EmpresaID,
        Usuario             = Aud_Usuario,
        FechaActual         = Aud_FechaActual,
        DireccionIP         = Aud_DireccionIP,
        ProgramaID          = Aud_ProgramaID,
        Sucursal            = Aud_Sucursal,
        NumTransaccion      = Aud_NumTransaccion

        WHERE CreditoDestinoID    = Par_CreditoDestinoID;


    SELECT  NumPagoSoste, NumPagoActual, EstatusCreacion, Regularizado, ReservaInteres INTO
            Var_NumPagoSoste, Var_NumPagoActual, Var_EstCreacion,Var_Regularizado, Var_Reserva
        FROM REESTRUCCREDITO
        WHERE CreditoDestinoID    = Par_CreditoDestinoID;

    SET Var_NumPagoSoste    := IFNULL(Var_NumPagoSoste, Entero_Cero);
    SET Var_NumPagoActual   := IFNULL(Var_NumPagoActual, Entero_Cero);
    SET Var_EstCreacion     := IFNULL(Var_EstCreacion, Cadena_Vacia);
    SET Var_Regularizado    := IFNULL(Var_Regularizado, Cadena_Vacia);
    SET Var_Reserva         := IFNULL(Var_Reserva, Entero_Cero);



    SELECT  COUNT(AmortizacionID) INTO Var_NumAmoExi
            FROM AMORTICREDITO
            WHERE CreditoID     = Par_CreditoDestinoID
              AND Estatus       = Esta_Pagado;

        SET Var_NumAmoExi := IFNULL(Var_NumAmoExi, Entero_Cero);


    IF((Var_NumPagoActual >= Var_NumPagoSoste AND
        Var_EstCreacion  = Esta_Vencido AND Var_Regularizado = NO_Regulariza) OR Var_NumAmoExi = Var_NumAmorti) THEN

        CALL REGULARIZACREDPRO (
            Par_CreditoDestinoID,   Par_FechaRegistro,  AltaPoliza_NO,  Par_Poliza,     Aud_EmpresaID,
            Var_NO,                 Par_NumErr,         Par_ErrMen,     Par_ModoPago,       Aud_Usuario,
            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        UPDATE REESTRUCCREDITO SET
            Regularizado       = SI_Regulariza,
            FechaRegula         = Par_FechaRegistro,

            EmpresaID           = Aud_EmpresaID,
            Usuario             = Aud_Usuario,
            FechaActual         = Aud_FechaActual,
            DireccionIP         = Aud_DireccionIP,
            ProgramaID          = Aud_ProgramaID,
            Sucursal            = Aud_Sucursal,
            NumTransaccion      = Aud_NumTransaccion

            WHERE CreditoDestinoID    = Par_CreditoDestinoID;


        IF(Var_Reserva > Entero_Cero) THEN

            SET Str_NumErr          := '0';

            SELECT  Cre.MonedaID,   Cre.ProductoCreditoID,  Des.Clasificacion, Cli.SucursalOrigen,  Des.SubClasifID
                    INTO
                    Var_MonedaID, Var_ProdCreID, Var_ClasifCre, Var_SucCliente, Var_SubClasifID
                FROM CREDITOS Cre,
                     DESTINOSCREDITO Des,
                     CLIENTES Cli
                WHERE CreditoID = Par_CreditoDestinoID
                  AND Cre.DestinoCreID  = Des.DestinoCreID
                  AND Cre.ClienteID         = Cli.ClienteID;

            SET Var_SubClasifID := IFNULL(Var_SubClasifID, Entero_Cero);


            CALL  CONTACREDITOPRO (
                Par_CreditoDestinoID,   Entero_Cero,            Entero_Cero,        Entero_Cero,
                Par_FechaRegistro,      Par_FechaRegistro,      Var_Reserva,        Var_MonedaID,
                Var_ProdCreID,          Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_Reserva,            Ref_Regula,             AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,             AltaPolCre_SI,          AltaMovCre_NO,      Con_EstBalance,
                Entero_Cero,            Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Nat_Cargo,              Cadena_Vacia,           /*Var_NO,*/             Par_NumErr,
                Par_ErrMen,             Par_Consecutivo,        Aud_EmpresaID,      Par_ModoPago,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,           Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
                IF (Par_Salida = Var_SI ) THEN
                    SELECT Str_NumErr AS NumErr,
                           Par_ErrMen AS ErrMen,
                           Entero_Cero AS control,
                           Entero_Cero  AS consecutivo;
                END IF;
                LEAVE TerminaStore;
            END IF;


            CALL  CONTACREDITOPRO (
                Par_CreditoDestinoID,   Entero_Cero,            Entero_Cero,        Entero_Cero,
                Par_FechaRegistro,      Par_FechaRegistro,      Var_Reserva,        Var_MonedaID,
                Var_ProdCreID,          Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_Reserva,            Ref_Regula,             AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,             AltaPolCre_SI,          AltaMovCre_NO,      Con_EstResultados,
                Entero_Cero,            Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Nat_Abono,              Cadena_Vacia,           /*Var_NO,*/             Par_NumErr,
                Par_ErrMen,             Par_Consecutivo,        Aud_EmpresaID,      Par_ModoPago,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,           Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
                IF (Par_Salida = Var_SI ) THEN
                    SELECT Str_NumErr AS NumErr,
                           Par_ErrMen AS ErrMen,
                           Entero_Cero AS control,
                           Entero_Cero  AS consecutivo;
                END IF;
                LEAVE TerminaStore;
            END IF;

        END IF;

    END IF;


    IF (Par_Salida = Var_SI ) THEN
        SELECT '000' AS NumErr,
                'Reestructura Actualizada' AS ErrMen,
                Entero_Cero AS control,
                Entero_Cero  AS consecutivo;
    ELSE
        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Reestructura Actualizada';
    END IF;
END IF;

END TerminaStore$$