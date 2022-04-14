-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_GENCOMINTERESORDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_GENCOMINTERESORDPRO`;
DELIMITER $$


CREATE PROCEDURE `TC_GENCOMINTERESORDPRO`(
/*- + ----------------------------------------------------------------- + ---
--- | Genera Interes Ordinario y Comision por falta de pago             | ---
--- + ----------------------------------------------------------------- + -*/
    Par_Fecha           DATE,               -- Parametro Fecha de Operaciones

    Par_Salida          CHAR(1),            -- Parametro de Salida
    INOUT Par_NumErr    INT(11),            -- Parametro Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),       -- Parametro Descripcion del Error

    Par_EmpresaID       INT(11),            -- Parametro de Auditoria
    Aud_Usuario         INT(11),            -- Parametro de Auditoria
    Aud_FechaActual     DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),        -- Parametro de Auditoria

    Aud_ProgramaID      VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal        INT(11),            -- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT              -- Parametro de Auditoria
)

TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_NumeroTarjetas      INT;                -- Numero de tarjetas
    DECLARE Var_Consecutivo         INT;                -- Consecutivo del WHILE
    DECLARE Var_LineaTarCredID      INT;                -- Linea de tarjeta
    DECLARE Var_FechaCorte          DATE;               -- Fecha de corte
    DECLARE Var_TasaFija            DECIMAL(16,4);      -- Tasa Fija
    DECLARE Var_TipoTarjetaDeb      INT;                -- Tipo de tarjeta
    DECLARE Var_DiasPeriodo         INT;                -- Dias del periodo
    DECLARE Var_SaldoPromedio       DECIMAL(16,2);      -- Saldo promedio del periodo
    DECLARE Var_InteresGenerado     DECIMAL(16,2);      -- Interes generado
    DECLARE Var_IVAInteresGen       DECIMAL(16,2);      -- Iva de interes generado
    DECLARE Var_NumeroTarjeta       VARCHAR(16);        -- Num Tarjeta Individual
    DECLARE Var_ClienteID           INT;                -- Identificador del Cliente
    DECLARE Var_FechaActual         DATE;               -- Fecha Actual
    DECLARE Var_ProductoCreditoID   INT;                -- Producto de Credito
    DECLARE Var_Clasificacion       CHAR(1);            -- Clasificacion
    DECLARE Var_SubClasificacion    INT(11);            -- Subclasificacion
    DECLARE Var_SucursalCte         INT(11);            -- Sucursal del cliente
    DECLARE Var_Consec              INT(11);            -- Consecutivo
    DECLARE Var_Poliza              BIGINT;             -- Numero de poliza
    DECLARE Var_DiasCredito         INT(11);            -- Dias de Credito
    DECLARE Var_PagoMinimo          DECIMAL(16,2);      -- Pago Minimo
    DECLARE Var_MontoPagado         DECIMAL(16,2);      -- Monto pagado
    DECLARE Var_SaldoInsuluto       DECIMAL(16,2);      -- Saldo Insuluto
    DECLARE Var_CobraFaltaPago      CHAR(1);            -- Cobra com falta de pago
    DECLARE Var_TipoFaltaPag        CHAR(1);            -- Tipo de comi falta de pago
    DECLARE Var_CliPagIVA           CHAR(1);            -- El Cliente paga IVA
    DECLARE Var_FactorFalPag        DECIMAL(16,2);      -- Factor de com Falta de Pago
    DECLARE Var_SaldoCorte          DECIMAL(16,2);      -- Saldo al corte
    DECLARE Var_MontoComFalPag      DECIMAL(16,2);      -- Monto de com por falta de pago
    DECLARE Var_IVAComFalPag        DECIMAL(16,2);      -- IVA de Comision por falta de pago
    DECLARE Var_IVASuc              DECIMAL(8,4);       -- Iva de sucursal


    -- Declaracion de Constantes
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Entero_Cero             INT(11);
    DECLARE ProgramaResID           VARCHAR(200);
    DECLARE SalidaNO                CHAR(1);
    DECLARE Cons_SI                 CHAR(1);
    DECLARE Cons_NO                 CHAR(1);
    DECLARE Var_MonedaID            INT;
    DECLARE Alta_Enc_Pol_SI         CHAR(1);
    DECLARE Alta_Enc_Pol_NO         CHAR(1);
    DECLARE Concepto_TarCred        INT(11);
    DECLARE AltaPolCre_Si           CHAR(1);
    DECLARE RegistraMov_NO          CHAR(1);
    DECLARE AltaMovLin_SI           CHAR(1);
    DECLARE Con_InteresOrd          INT(11);
    DECLARE Con_IVAIntOrd           INT(11);
    DECLARE Mov_InteresOrd          INT(11);
    DECLARE Mov_IVAIntOrd           INT(11);
    DECLARE Nat_Cargo               CHAR(1);
    DECLARE Salida_NO               CHAR(1);
    DECLARE Salida_SI               CHAR(1);
    DECLARE Tipo_Porcentaje         CHAR(1);
    DECLARE Pol_Automatica          CHAR(1);
    DECLARE Desc_Interes            VARCHAR(150);
    DECLARE Desc_IVAInteres         VARCHAR(150);
    DECLARE Desc_ComFalPag          VARCHAR(150);
    DECLARE Desc_IVAComFalPag       VARCHAR(150);
    DECLARE Des_IntGenerado         VARCHAR(150);
    DECLARE Des_IvaIntGenerado      VARCHAR(150);
    DECLARE Con_ComFalPag           INT(11);
    DECLARE Con_IVAComFalPag        INT(11);
    DECLARE Mov_ComFalPag           INT(11);
    DECLARE Mov_IVAComFalPag        INT(11);
    DECLARE Cla_TarCred             INT(11);        -- Clasificacion de Tarjeta de Credito
    DECLARE Valor_Cien              INT(11);        -- Numero para dividir el valor de porcentaje
	DECLARE TipoOperaTarjeta		VARCHAR(2);

    -- Asignacion de Constantes
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Aud_ProgramaID      := 'TC_LINEACIEDIAPRO';
    SET Cons_SI             := 'S';                     -- Constante S: SI
    SET Cons_NO             := 'N';                     -- COnstante N: NO
    SET Var_Consecutivo     := 1;
    SET Var_MonedaID        := 1;                       -- Transaccion en Pesos
    SET Alta_Enc_Pol_SI     := 'S';
    SET Alta_Enc_Pol_NO     := 'N';
    SET Concepto_TarCred    := 1100;                    -- Concepto contable de tarjetas
    SET AltaPolCre_Si       := 'S';
    SET RegistraMov_NO      := 'N';
    SET AltaMovLin_SI       := 'S';
    SET Con_InteresOrd      := 19;                      -- Interes provisionado
    SET Con_IVAIntOrd       := 8;                       -- IVA de Interes
    SET Mov_InteresOrd      := 14;
    SET Mov_IVAIntOrd       := 20;
    SET Nat_Cargo           := 'C';
    SET Salida_NO           := 'N';
    SET Salida_SI           := 'S';
    SET Con_ComFalPag       := 7;                       -- Comision por falta de pago
    SET Con_IVAComFalPag    := 10;                      -- IVA de Comision falta de pago
    SET Mov_ComFalPag       := 40;
    SET Mov_IVAComFalPag    := 22;
    SET Desc_Interes        := 'INTERES GENERADO';
    SET Desc_IVAInteres     := 'IVA INTERES GENERADO';
    SET Desc_ComFalPag      := 'COMISION FALTA PAGO';
    SET Desc_IVAComFalPag   := 'IVA COMISION FALTA PAGO';
    SET Cla_TarCred         := 201;
    SET Valor_Cien          := 100;
    SET Tipo_Porcentaje     := 'P';
    SET Des_IntGenerado     := 'INTERES GENERADO';
    SET Des_IvaIntGenerado  := 'IVA INTERES GENERADO';
    SET Pol_Automatica  	:= 'A';
	SET TipoOperaTarjeta	:= '19';


    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_GENCOMINTERESORDPRO');
            END;


        SELECT      FechaSistema,       DiasCredito
            INTO    Var_FechaActual,    Var_DiasCredito
         FROM PARAMETROSSIS
         WHERE EmpresaID = Par_EmpresaID;


        DELETE FROM TMPTARCREDINTERES
            WHERE NumTransaccion = Aud_NumTransaccion;

        SET @Consecutivo := Entero_Cero;

        INSERT INTO TMPTARCREDINTERES
        SELECT Aud_NumTransaccion, (@Consecutivo := @Consecutivo + 1 ),  Lin.LineaTarCredID,    Per.FechaCorte,
                Par_EmpresaID,      Aud_Usuario,                        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal
            FROM LINEATARJETACRED Lin, TC_PERIODOSLINEA Per
            WHERE Lin.LineaTarCredID = Per.LineaTarCredID
            AND Lin.FechaUltCorte = Per.FechaCorte
            AND Per.MontoPagado <= Per.PagoNoGenInteres
            AND Per.FechaExigible = Par_Fecha;


        SELECT COUNT(LineaTarCredID)
            INTO Var_NumeroTarjetas
            FROM TMPTARCREDINTERES
            WHERE NumTransaccion = Aud_NumTransaccion;


        IF Var_NumeroTarjetas > Entero_Cero THEN

            CALL MAESTROPOLIZASALT(
                Var_Poliza,         Par_EmpresaID,     Var_FechaActual,       Pol_Automatica,         Concepto_TarCred,
                Desc_Interes,       Salida_NO,       Par_NumErr,            Par_ErrMen,             Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP, Aud_ProgramaID,        Aud_Sucursal,           Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;

            -- Ciclo para recorrer todos las lineas de credito
            WHILE (Var_Consecutivo <= Var_NumeroTarjetas) DO

                SELECT   LineaTarCredID,     FechaCorte
                    INTO Var_LineaTarCredID, Var_FechaCorte
                    FROM TMPTARCREDINTERES
                    WHERE NumTransaccion = Aud_NumTransaccion
                    AND Consecutivo= Var_Consecutivo;

                /* Obtenemos los parametros para poder realizar el calculo de interes ordinario para las cuentas
                    que no han pagado el monto para generar intereses */
                SELECT  Lin.TasaFija,       Lin.TipoTarjetaDeb,     Per.DiasPeriodo,    Per.SaldoPromedio,      Lin.TarjetaPrincipal,
                        Lin.ClienteID,      Lin.ProductoCredID,     Per.PagoMinimo,     Per.MontoPagado,        Lin.CobraFaltaPago,
                        Lin.TipCobComFalPago, Lin.FactorFaltaPago,  Per.SaldoCorte
                    INTO  Var_TasaFija,     Var_TipoTarjetaDeb,     Var_DiasPeriodo,    Var_SaldoPromedio,      Var_NumeroTarjeta,
                        Var_ClienteID,      Var_ProductoCreditoID,  Var_PagoMinimo,     Var_MontoPagado,        Var_CobraFaltaPago,
                        Var_TipoFaltaPag,   Var_FactorFalPag,       Var_SaldoCorte
                FROM LINEATARJETACRED Lin,TC_PERIODOSLINEA Per
                WHERE Lin.LineaTarCredID = Per.LineaTarCredID
                AND Per.FechaCorte = Var_FechaCorte
                AND Lin.LineaTarCredID = Var_LineaTarCredID;

                SELECT      Tipo AS Clasificacion,  Cla_TarCred AS SubClasificacion
                    INTO    Var_Clasificacion,      Var_SubClasificacion
                FROM PRODUCTOSCREDITO
                WHERE ProducCreditoID = Var_ProductoCreditoID;

                SELECT      SucursalOrigen,      PagaIVA
                    INTO    Var_SucursalCte,     Var_CliPagIVA
                FROM CLIENTES WHERE ClienteID = Var_ClienteID;

                SELECT IVA INTO Var_IVASuc
                    FROM SUCURSALES
                WHERE SucursalID    = Var_SucursalCte;

                IF (Var_CliPagIVA = Cons_SI) THEN
                    SET Var_IVASuc  := IFNULL(Var_IVASuc,Entero_Cero);
                ELSE
                    SET Var_IVASuc  := Entero_Cero;
                END IF;


                /* Calculo del Interes Generado */
                SET Var_InteresGenerado := ((Var_TasaFija * Var_DiasPeriodo * Var_SaldoPromedio ) / (Var_DiasCredito * Valor_Cien));

                SET Var_InteresGenerado := IFNULL(Var_InteresGenerado,Entero_Cero);

                SET Var_IVAInteresGen := CASE WHEN Var_InteresGenerado <= Entero_Cero THEN Entero_Cero ELSE (Var_InteresGenerado * Var_IVASuc) END;

                /* Registro contable y Operativo de Interes Generado */
                IF Var_InteresGenerado > Entero_Cero THEN

                    -- INTERES
                    CALL TC_CONTALINEAPRO(
                        Var_LineaTarCredID,     Var_NumeroTarjeta,      Var_ClienteID,          DATE(Var_FechaActual),  Var_FechaActual,
                        Var_InteresGenerado,    Var_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                        Var_SucursalCte,        Desc_Interes,           Var_LineaTarCredID,     Cons_NO,                Concepto_TarCred,
                        Var_Poliza,             AltaPolCre_Si,          Cons_SI,                AltaMovLin_SI,          Con_InteresOrd,
                        Mov_InteresOrd,         Nat_Cargo,              Aud_NumTransaccion,     Cons_SI,                Des_IntGenerado,
						TipoOperaTarjeta,
                        Salida_NO,              Par_NumErr,             Par_ErrMen,
                        Var_Consec,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                    IF Par_NumErr != Entero_Cero THEN
                            LEAVE ManejoErrores;
                    END IF;

                     -- IVA
                    IF Var_IVAInteresGen > Entero_Cero THEN
                         CALL TC_CONTALINEAPRO(
                            Var_LineaTarCredID,     Var_NumeroTarjeta,      Var_ClienteID,          DATE(Var_FechaActual),  Var_FechaActual,
                            Var_IVAInteresGen,      Var_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                            Var_SucursalCte,        Desc_IVAInteres,        Var_LineaTarCredID,     Alta_Enc_Pol_NO,        Concepto_TarCred,
                            Var_Poliza,             AltaPolCre_Si,          Cons_SI,                AltaMovLin_SI,          Con_IVAIntOrd,
                            Mov_IVAIntOrd,          Nat_Cargo,              Aud_NumTransaccion,     Cons_SI,                Des_IvaIntGenerado,
							TipoOperaTarjeta,	
                            Salida_NO,              Par_NumErr,             Par_ErrMen,
                            Var_Consec,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                        IF Par_NumErr != Entero_Cero THEN
                                LEAVE ManejoErrores;
                        END IF;
                    END IF;

                END IF;

                /* Registro contable y operativo de Comision por Falta de pago */
                IF IFNULL(Var_PagoMinimo,Entero_Cero) > IFNULL(Var_MontoPagado,Entero_Cero) AND Var_CobraFaltaPago = Cons_SI THEN
                    SET Var_SaldoInsuluto := Var_SaldoCorte - Var_MontoPagado;

                    UPDATE TC_PERIODOSLINEA
                        SET MontoBaseCom = Var_SaldoInsuluto
                    WHERE FechaCorte = Var_FechaCorte
                    AND LineaTarCredID = Var_LineaTarCredID;

                    IF Var_TipoFaltaPag = Tipo_Porcentaje THEN
                        SET Var_MontoComFalPag := ROUND((Var_SaldoInsuluto * Var_FactorFalPag)/Valor_Cien,2);
                    ELSE
                        SET Var_MontoComFalPag := ROUND(Var_FactorFalPag,2);
                    END IF;

                    SET Var_IVAComFalPag := ROUND(Var_MontoComFalPag*Var_IVASuc,2);

                    IF Var_MontoComFalPag > Entero_Cero THEN
                        -- INTERES
                            CALL TC_CONTALINEAPRO(
                                Var_LineaTarCredID,     Var_NumeroTarjeta,      Var_ClienteID,          DATE(Var_FechaActual),  Var_FechaActual,
                                Var_MontoComFalPag,     Var_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                                Var_SucursalCte,        Desc_ComFalPag,         Var_LineaTarCredID,     Alta_Enc_Pol_SI,        Concepto_TarCred,
                                Var_Poliza,             AltaPolCre_Si,          Cons_SI,                AltaMovLin_SI,          Con_ComFalPag,
                                Mov_ComFalPag,          Nat_Cargo,              Aud_NumTransaccion,     Cons_SI,                Desc_ComFalPag,
								TipoOperaTarjeta,
                                Salida_NO,              Par_NumErr,             Par_ErrMen,
                                Var_Consec,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                            IF Par_NumErr != Entero_Cero THEN
                                    LEAVE ManejoErrores;
                            END IF;

                             -- IVA
                            IF Var_IVAComFalPag > Entero_Cero THEN
                                 CALL TC_CONTALINEAPRO(
                                    Var_LineaTarCredID,     Var_NumeroTarjeta,      Var_ClienteID,          DATE(Var_FechaActual),  Var_FechaActual,
                                    Var_IVAComFalPag,       Var_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                                    Var_SucursalCte,        Desc_IVAComFalPag,      Var_LineaTarCredID,     Alta_Enc_Pol_NO,        Concepto_TarCred,
                                    Var_Poliza,             AltaPolCre_Si,          Cons_SI,                AltaMovLin_SI,          Con_IVAComFalPag,
                                    Mov_IVAComFalPag,       Nat_Cargo,              Aud_NumTransaccion,     Cons_SI,                Desc_IVAComFalPag,
									TipoOperaTarjeta,
                                    Salida_NO,              Par_NumErr,             Par_ErrMen,
                                    Var_Consec,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                                    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                                IF Par_NumErr != Entero_Cero THEN
                                        LEAVE ManejoErrores;
                                END IF;
                            END IF;

                    END IF;


                END IF;


                SET Var_Consecutivo := Var_Consecutivo + 1 ;

            END WHILE;

        END IF;

        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Generacion de Interes Realizado Exitosamente';

    END ManejoErrores;

     IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr  AS NumErr,
               Par_ErrMen  AS ErrMen;

    END IF;

END TerminaStore$$
