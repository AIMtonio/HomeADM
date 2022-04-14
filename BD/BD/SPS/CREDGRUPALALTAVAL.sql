-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDGRUPALALTAVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDGRUPALALTAVAL`;DELIMITER $$

CREATE PROCEDURE `CREDGRUPALALTAVAL`(
	Par_Grupo				INT(11),
	Par_SucursalID			INT(11),
	Par_Salida          	CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

    /* Parametros de Auditoria */
	Par_EmpresaID 			INT(11) ,
	Aud_Usuario 			INT(11) ,
	Aud_FechaActual 		DATETIME,
	Aud_DireccionIP 		VARCHAR(15),
	Aud_ProgramaID 			VARCHAR(50),
	Aud_Sucursal 			INT(11) ,
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN


DECLARE Var_Solictud		INT(11);
DECLARE Var_Cliente			INT(11);
DECLARE Var_Producto		INT(11);
DECLARE Var_Monto			DECIMAL(12,2);
DECLARE Var_Moneda			INT(11);
DECLARE Var_TasaFija		DECIMAL(12,4);
DECLARE Var_FrecCap			CHAR(1);
DECLARE Var_PeriodCap		INT(11);
DECLARE Var_FrecInter		CHAR(1);
DECLARE Var_PeriodInt		INT(11);
DECLARE Var_TipoPagCap		CHAR(1);
DECLARE Var_NumAmorti		INT(11);
DECLARE Var_DiaPagIn		CHAR(1);
DECLARE Var_DiaPagCap		CHAR(1);
DECLARE Var_DiaMesIn		INT(11);
DECLARE Var_DiaMesCap		INT(11);
DECLARE Var_TipoDisper		CHAR(1);
DECLARE Var_DestCred		INT(11);
DECLARE Var_ValidaCapConta  CHAR(1);
DECLARE Var_PorcMaxCapConta DECIMAL(12,2);
DECLARE Var_Cuenta			BIGINT(12);

DECLARE Var_SalCapConta     DECIMAL(14,2);
DECLARE Var_MonMaxPer       DECIMAL(14,2);
DECLARE Var_CreditoID		BIGINT(20);
DECLARE Var_EsAgropecuario	CHAR(1);

DECLARE SalidaSI        	CHAR(1);
DECLARE Entero_Cero     	INT;
DECLARE Decimal_Cero    	DECIMAL(14,2);
DECLARE Cadena_Vacia    	CHAR;
DECLARE Estatus_Activo		CHAR(1);
DECLARE Estatus_Autori		CHAR(1);
DECLARE EstCerrGrup     	CHAR(1);
DECLARE ValorSI				CHAR(1);
DECLARE Si_ValidaCapConta   CHAR(1);
DECLARE Valor_No			CHAR(1);


DECLARE CURSORALTACRED CURSOR FOR
    SELECT  Sol.SolicitudCreditoID, Sol.ClienteID,          Sol.ProductoCreditoID,  Sol.MontoAutorizado,
            Sol.MonedaID,           Sol.TasaFija,           Sol.FrecuenciaCap,      Sol.PeriodicidadCap,
            Sol.FrecuenciaInt,      Sol.PeriodicidadInt,    Sol.TipoPagoCapital,    Sol.NumAmortizacion,
            Sol.DiaPagoInteres,     Sol.DiaPagoCapital,     Sol.DiaMesInteres,      Sol.DiaMesCapital,
            Sol.TipoDispersion,     Sol.DestinoCreID,       Pro.ValidaCapConta,     Pro.PorcMaxCapConta,
			Sol.CreditoID,			Sol.EsAgropecuario
		FROM	INTEGRAGRUPOSCRE	Inte,
				GRUPOSCREDITO		Gru,
				SOLICITUDCREDITO	Sol,
            PRODUCTOSCREDITO Pro
			WHERE Inte.GrupoID = Gru.GrupoID
			  AND Inte.GrupoID = Par_Grupo
			  AND Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND Sol.Estatus = Estatus_Autori
			  AND Inte.Estatus = Estatus_Activo
			  AND Gru.EstatusCiclo = EstCerrGrup
           AND Pro.ProducCreditoID = Sol.ProductoCreditoID;



SET SalidaSI        	:= 'S';
SET Entero_Cero     	:= 0;
SET Decimal_Cero    	:= 0.00;
SET Cadena_Vacia    	:= '';
SET Estatus_Activo  	:= 'A';
SET Estatus_Autori  	:= 'A';
SET EstCerrGrup     	:= 'C';
SET ValorSI         	:= 'S';
SET Si_ValidaCapConta	:= 'S';
SET Valor_No			:= 'N';
SET Var_SalCapConta 	:= (SELECT SaldoCapContable FROM PARAMETROSSIS);
SET Var_SalCapConta 	:= IFNULL(Var_SalCapConta, Entero_Cero);


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDGRUPALALTAVAL');
		END;

SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;

OPEN CURSORALTACRED;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        CICLOALTA: LOOP

        FETCH CURSORALTACRED INTO
            Var_Solictud,	Var_Cliente,    Var_Producto,       Var_Monto,
            Var_Moneda,     Var_TasaFija,   Var_FrecCap,        Var_PeriodCap,
            Var_FrecInter,  Var_PeriodInt,  Var_TipoPagCap,     Var_NumAmorti,
            Var_DiaPagIn,   Var_DiaPagCap,  Var_DiaMesIn,       Var_DiaMesCap,
            Var_TipoDisper, Var_DestCred,   Var_ValidaCapConta, Var_PorcMaxCapConta,
			Var_CreditoID,	Var_EsAgropecuario;

        SET Par_NumErr  := Entero_Cero;
        SET Par_ErrMen  := Cadena_Vacia;


        SET Var_TasaFija	:= (IFNULL(Var_TasaFija,Decimal_Cero));
        SET Var_FrecCap		:= (IFNULL(Var_FrecCap,Cadena_Vacia));
        SET Var_PeriodCap	:= (IFNULL(Var_PeriodCap,Entero_Cero));
        SET Var_FrecInter	:= (IFNULL(Var_FrecInter,Cadena_Vacia));
        SET Var_PeriodInt	:= (IFNULL(Var_PeriodInt,Entero_Cero));
        SET Var_TipoPagCap	:= (IFNULL(Var_TipoPagCap,Cadena_Vacia));
        SET Var_DiaPagIn	:= (IFNULL(Var_DiaPagIn,Cadena_Vacia));
        SET Var_DiaMesIn	:= (IFNULL(Var_DiaMesIn,Entero_Cero));
        SET Var_DiaMesCap	:= (IFNULL(Var_DiaMesCap,Entero_Cero));
		SET Var_CreditoID	:=(IFNULL(Var_CreditoID,Entero_Cero));
		SET Var_EsAgropecuario:= (IFNULL(Var_EsAgropecuario,Valor_No));

        IF(Var_TasaFija = Decimal_Cero)THEN
            SET Par_NumErr := 1;
            SET	Par_ErrMen := CONCAT('La Tasa esta vacia, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;

        IF(Var_TipoPagCap = Cadena_Vacia )THEN
            SET Par_NumErr := 2;
            SET	Par_ErrMen := CONCAT('El Tipo de pago esta vacio, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));
            LEAVE CICLOALTA;
        END IF;

        IF(Var_FrecCap = Cadena_Vacia )THEN
            SET Par_NumErr := 3;
            SET	Par_ErrMen := '.'  ;
            SET	Par_ErrMen := CONCAT('La Frecuencia de Capital esta Vacia, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;

        IF(Var_PeriodCap = Entero_Cero AND Var_EsAgropecuario= Valor_No)THEN
            SET Par_NumErr := 4;
            SET	Par_ErrMen := CONCAT('La Periodicidad de Capital esta vacia, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));
            LEAVE CICLOALTA;
        END IF;


        SET Var_Cuenta := (SELECT CuentaAhoID
                                FROM CUENTASAHO
                                WHERE ClienteID	= Var_Cliente
                                  AND EsPrincipal 	= ValorSI
                                  AND Estatus		= Estatus_Activo LIMIT 1   );

        SET Var_Cuenta = IFNULL(Var_Cuenta, Entero_Cero);

        IF(Var_Cuenta = Entero_Cero) THEN
            SET Par_NumErr := 5;
            SET	Par_ErrMen := CONCAT('El Cliente ', CONVERT(Var_Cliente, CHAR),
                              ' No Tiene una Cuenta Principal o no Esta Autorizada.');
            LEAVE CICLOALTA;
        END IF;

        IF(Var_NumAmorti = Entero_Cero)THEN
            SET	Par_NumErr := 6;
            SET	Par_ErrMen := CONCAT('Numero de Cuotas Vacio, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));
            LEAVE CICLOALTA;
        END IF;

        IF(Var_TipoDisper = Cadena_Vacia)THEN
            SET	Par_NumErr := 7;
            SET	Par_ErrMen := CONCAT('Tipo de Dispersion Incorrecto, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));
            LEAVE CICLOALTA;
        END IF;

        IF NOT EXISTS(SELECT Descripcion
                        FROM DESTINOSCREDITO Ser
                        WHERE DestinoCreID     = Var_DestCred)   THEN

            SET	Par_NumErr := 8;
            SET	Par_ErrMen := CONCAT('El Destino no existe, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));
            LEAVE CICLOALTA;

        END IF;

        IF NOT EXISTS(SELECT Descripcion
                        FROM PRODUCTOSCREDITO Ser
                        WHERE ProducCreditoID     = Var_Producto)   THEN

            SET	Par_NumErr := 9;
            SET	Par_ErrMen := CONCAT('El Producto de Credito no existe, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));
            LEAVE CICLOALTA;

        END IF;

        IF NOT EXISTS(SELECT Descripcion
                        FROM MONEDAS Ser
                        WHERE MonedaId     = Var_Moneda)   THEN

            SET	Par_NumErr := 10;
            SET	Par_ErrMen := CONCAT('El Moneda o Divisa no existe, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));
            LEAVE CICLOALTA;

        END IF;

        IF(Var_FrecInter = Cadena_Vacia )THEN
            SET Par_NumErr := 11;
            SET	Par_ErrMen := '.'  ;
            SET	Par_ErrMen := CONCAT('La Frecuencia de Interes esta Vacia, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;

        IF(Var_PeriodInt = Entero_Cero AND Var_EsAgropecuario= Valor_No )THEN
            SET Par_NumErr := 12;
            SET	Par_ErrMen := CONCAT('La Periodicidad de Interes esta vacia, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;

        IF(Var_DiaPagIn = Cadena_Vacia )THEN
            SET Par_NumErr := 13;
            SET	Par_ErrMen := CONCAT('El Dia de Pago Interes esta vacio, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;

        IF(Var_DiaPagCap = Cadena_Vacia )THEN
            SET Par_NumErr := 14;
            SET	Par_ErrMen := CONCAT('El Dia de Pago de Capital esta vacio, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;


        IF(Var_DiaPagCap != 'F' AND Var_DiaMesCap = Entero_Cero)THEN
            SET Par_NumErr := 15;
            SET	Par_ErrMen := CONCAT('El Dia del Mes de Capital esta vacio, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;

        IF(Var_DiaPagIn != 'F' AND Var_DiaMesIn = Entero_Cero)THEN
            SET Par_NumErr := 16;
            SET	Par_ErrMen := CONCAT('El Dia del Mes de Interes esta vacio, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;

        IF(Var_Monto <= Entero_Cero)THEN
            SET Par_NumErr := 17;
            SET	Par_ErrMen := CONCAT('El Monto del Credito es Incorrecto, para la Solicitud ',
                                    CONVERT(Var_Solictud, CHAR));

            LEAVE CICLOALTA;
        END IF;


        IF(Var_ValidaCapConta = Si_ValidaCapConta AND Var_PorcMaxCapConta > Entero_Cero) THEN

            SET Var_MonMaxPer = Var_PorcMaxCapConta * Var_SalCapConta / 100.00;
            IF(Var_Monto  > Var_MonMaxPer ) THEN
                SET Par_NumErr := 18;
                SET Par_ErrMen := CONCAT('El Monto de la Solicitud ', CONVERT(Var_Solictud, CHAR),
                                        ' excede el Maximo Permitido de Acuerdo al Capital Contable');

                LEAVE CICLOALTA;
            END IF;
        END IF;

		IF(Var_CreditoID > Entero_Cero)THEN
			 SET Par_NumErr := 19;
            SET	Par_ErrMen := CONCAT('La Solicitud de Credito ',
                                    CONVERT(Var_Solictud, CHAR), ' se encuentra relacionada al Credito ',Var_CreditoID);
            LEAVE CICLOALTA;
		END IF;

        END LOOP CICLOALTA;
    END;
CLOSE CURSORALTACRED;


IF(Par_NumErr != Entero_Cero) THEN
    LEAVE ManejoErrores;
END IF;

SET Par_NumErr := 000;
SET Par_ErrMen := "Validaciones Correctas";

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'grupoID' AS control,
            Cadena_Vacia AS consecutivo;
END IF;

END TerminaStore$$