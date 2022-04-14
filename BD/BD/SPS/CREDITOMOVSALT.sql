-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOMOVSALT`;

DELIMITER $$
CREATE PROCEDURE `CREDITOMOVSALT`(
    -- SP para el alta de movimiento de creditos
    -- Modulo de Cartera
    Par_CreditoID           BIGINT(12),         -- Parametro del identificador del credito
    Par_AmortiCreID         INT(4),             -- Amortizacion del credito
    Par_Transaccion         BIGINT(20),         -- Numero de transacion
    Par_FechaOperacion      DATE,               -- Fecha de la operacion
    Par_FechaAplicacion     DATE,               -- Fecha de la aplicacion

    Par_TipoMovCreID        INT(4),             -- Tipo del movimiento del credito
    Par_NatMovimiento       CHAR(1),            -- Naturaleza del movimiento
    Par_MonedaID            INT(11),            -- Moneda MXN
    Par_Cantidad            DECIMAL(14,4),      -- Cantidad o monto del movimiento
    Par_Descripcion         VARCHAR(100),       -- Descripcion del movimiento

    Par_Referencia          VARCHAR(50),        -- Referencia del movimiento
    Par_Poliza              BIGINT(20),         -- Numero de la poliza
    Par_OrigenPago          VARCHAR(2),         -- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida              CHAR(1),            -- Salidad
    OUT Par_NumErr          INT(11),            -- Numero del error

    OUT Par_ErrMen          VARCHAR(400),       -- Mensaje del error
    OUT Par_Consecutivo     BIGINT(20),         -- Consecutivo
    Par_ModoPago            CHAR(1),            -- Modo del pago
    Aud_EmpresaID           INT(11),            -- Parametro de auditoria ID de la empresa
    Aud_Usuario             INT(11),            -- Parametro de auditoria ID del usuario

    Aud_FechaActual         DATETIME,           -- Parametro de auditoria Fecha actual
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de auditoria Direccion IP
    Aud_ProgramaID          VARCHAR(50),        -- Parametro de auditoria Programa
    Aud_Sucursal            INT(11),            -- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

    DECLARE Fecha               DATE;           -- Variable de la Fecha
    DECLARE Mov_Cantidad        DECIMAL(12,4);  -- Cantidad del movimiento
    DECLARE Var_CreStatus       CHAR(1);        -- Estatus del credito
    DECLARE Var_AcumProv        DECIMAL(12,4);  -- Provision acumulada
    DECLARE Var_ClienteID       INT(11);        -- Cliente ID
    DECLARE Var_Control         VARCHAR(100);   -- Variable de control
    DECLARE Var_Consecutivo     VARCHAR(20);

    DECLARE Cadena_Vacia        CHAR(1);        -- Constante de cadena vacia
    DECLARE Fecha_Vacia         DATE;           -- Constante de fecha vacia
    DECLARE Entero_Cero         INT(11);        -- Entero cero
    DECLARE Float_Cero          DECIMAL(12,2);  -- Decimal cero
    DECLARE EstatusActivo       CHAR(1);        -- Estatus activo
    DECLARE Nat_Cargo           CHAR(1);        -- Constante Naturaleza de tipo cargo
    DECLARE Nat_Abono           CHAR(1);        -- Constante Naturaleza de tipo movimiento
    DECLARE Cre_Vigente         CHAR(1);        -- Constante Estatus vigente
    DECLARE Cre_Vencido         CHAR(1);        -- Constante Estatus vencido
    DECLARE Cre_Castigado       CHAR(1);        -- Constante Estatus castigado
    DECLARE Cre_Suspendido      CHAR(1);        -- Constante Estatus Suspendido
    DECLARE Mov_CapOrd          INT(11);        -- Movimiento del tipo capital ordinario
    DECLARE Mov_CapAtr          INT(11);        -- Movimiento del tipo capital atrasado
    DECLARE Mov_CapVen          INT(11);        -- Movimiento del tipo capital vencido
    DECLARE Mov_CapVNE          INT(11);        -- Movimiento del tipo vencido
    DECLARE Mov_IntOrd          INT(11);        -- Movimiento del tipo intereses ordinario
    DECLARE Mov_IntAtr          INT(11);        -- Movimiento del tipo interes atrasado
    DECLARE Mov_IntVen          INT(11);        -- Movimiento del tipo intereses vencido
    DECLARE Mov_IntPro          INT(11);        -- Movimiento del tipo interes provisionado
    DECLARE Mov_IntCalNoCon     INT(11);        -- Movimiento del tipo interes no contable
    DECLARE Mov_IntMor          INT(11);        -- Movimiento del tipo interes moratorio
    DECLARE Mov_IVAInt          INT(11);        -- Movimiento del tipo IVA del interes
    DECLARE Mov_IVAMor          INT(11);        -- Movimiento del tipo IVA moratorio
    DECLARE Mov_IVAFalPag       INT(11);        -- Movimiento del tipo IVA por falta de pago
    DECLARE Mov_IVAComApe       INT(11);        -- Movimiento del tipo IVA de comision por apertura
    DECLARE Mov_ComFalPag       INT(11);        -- Movimiento del tipo comision por falta de pago
    DECLARE Mov_ComApeCre       INT(11);        -- Movimiento del tipo comision por apertura del credito
    DECLARE Mov_ComLiqAnt       INT(11);        -- Movimiento del tipo comision por liquidacion anticipada
    DECLARE Mov_IVAComLiqAnt    INT(11);        -- Movimiento del tipo IVA de comsion por liquidacion anticipada
    DECLARE Mov_IntMoratoVen    INT(11);        -- Movimiento del tipo interes moratorio vencido
    DECLARE Mov_IntMoraCarVen   INT(11);        -- Movimiento del tipo interes moratorio
    DECLARE Mov_SegCuota        INT;
    DECLARE Mov_IVASegCuota     INT;
    #COMISION ANUALIDAD
    DECLARE Mov_ComAnual        INT;
    DECLARE Mov_ComAnualIVA     INT;
	DECLARE	Mov_NotaCargoConIVA		INT(11);		-- Movimiento de credito por Nota de Cargo con iva
	DECLARE	Mov_NotaCargoSinIVA		INT(11);		-- Movimiento de credito por Nota de Cargo sin iva
	DECLARE	Mov_NotaCargoNoRecon	INT(11);		-- Movimiento de credito por Nota de Cargo no reconocido
	DECLARE	Mov_IVANotaCargo		INT(11);		-- Movimiento de credito por Nota de Cargo IVA
    DECLARE Mov_ComSerGarantia      INT(11);        -- Movimiento de Comision de Servicio de Garantia
    DECLARE Mov_IVAComSerGarantia   INT(11);        -- Movimiento de IVA Comision de Servicio de Garantia

    DECLARE Pro_GenInt          VARCHAR(50);    -- Constante del proceso GENERAINTERECREPRO
    DECLARE Pro_PagCre          VARCHAR(50);    -- Constante del proceso PAGOCREDITOPRO
    DECLARE Pro_Bonifi          VARCHAR(50);    -- Constante del proceso BONIFICACION
    DECLARE Des_PagoCred        VARCHAR(50);    -- Constante del proceso pago de credito
    DECLARE Salida_NO           CHAR(1);        -- Salida no
    DECLARE Salida_SI           CHAR(1);        -- Salidad SI


    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Float_Cero          := 0.0;
    SET EstatusActivo       := 'A';
    SET Nat_Cargo           := 'C';
    SET Nat_Abono           := 'A';
    SET Cre_Vigente         := 'V';
    SET Cre_Vencido         := 'B';
    SET Cre_Castigado       := 'K';
    SET Cre_Suspendido      := 'S';
    SET Mov_CapOrd          := 1;
    SET Mov_CapAtr          := 2;
    SET Mov_CapVen          := 3;
    SET Mov_CapVNE          := 4;
    SET Mov_IntOrd          := 10;
    SET Mov_IntAtr          := 11;
    SET Mov_IntVen          := 12;
    SET Mov_IntCalNoCon     := 13;
    SET Mov_IntPro          := 14;
    SET Mov_IntMor          := 15;
    SET Mov_IVAInt          := 20;
    SET Mov_IVAMor          := 21;
    SET Mov_IVAFalPag       := 22;
    SET Mov_IVAComApe       := 23;
    SET Mov_IVAComLiqAnt    := 24;
    SET Mov_ComFalPag       := 40;
    SET Mov_ComApeCre       := 41;
    SET Mov_ComLiqAnt       := 42;
    SET Mov_IntMoratoVen    := 16;
    SET Mov_IntMoraCarVen   := 17;
    SET Mov_SegCuota        := 50;          -- Tipo de Movimiento TIPOSMOVSCRE: Seguro por Cuota
    SET Mov_IVASegCuota     := 25;          -- Tipo de Movimiento TIPOSMOVSCRE: IVA Seguro por Cuota
    #COMISION ANUALIDAD
    SET Mov_ComAnual        := 51;              -- TIPOSMOVSCRE: 51 Comision por Anualidad
    SET Mov_ComAnualIVA     := 52;              -- TIPOSMOVSCRE: 52 IVA Comision por Anualidad
	SET	Mov_NotaCargoConIVA	   := 53;		-- Movimiento de credito por Nota de Cargo con iva
	SET	Mov_NotaCargoSinIVA	   := 54;		-- Movimiento de credito por Nota de Cargo sin iva
	SET	Mov_NotaCargoNoRecon   := 55;		-- Movimiento de credito por Nota de Cargo no reconocido
	SET	Mov_IVANotaCargo       := 56;		-- Movimiento de credito por Nota de Cargo IVA
    SET Mov_ComSerGarantia     := 59;
    SET Mov_IVAComSerGarantia  := 60;

    SET Salida_NO           := 'N';
    SET Pro_GenInt          := 'GENERAINTERECREPRO';
    SET Pro_PagCre          := 'PAGOCREDITOPRO';
    SET Pro_Bonifi          := 'BONIFICACION';
    SET Des_PagoCred        := 'PAGO DE CREDITO';
    SET Salida_SI           := 'S';
    SET Par_NumErr          := 999;
    SET Par_ErrMen          := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
        'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOMOVSALT');
    SET Var_Control := 'sqlException' ;
    SET Var_Consecutivo := '0';

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOMOVSALT');
            SET Var_Control := 'sqlException' ;
            SET Var_Consecutivo := Cadena_Vacia;
        END;

        IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr          := 001;
            SET Par_ErrMen          := CONCAT('El Numero de Credito esta vacio.');
            SET Var_Control         := 'creditoID' ;
            LEAVE ManejoErrores;
        END IF;

        SELECT Estatus, ClienteID  INTO Var_CreStatus, Var_ClienteID
            FROM CREDITOS
                WHERE CreditoID = Par_CreditoID;

        SET Var_CreStatus := IFNULL(Var_CreStatus, Cadena_Vacia);

        IF Var_CreStatus= Cadena_Vacia THEN
            SET Par_NumErr      := 002;
            SET Par_ErrMen      := CONCAT('El Credito no Existe.');
            SET Var_Control     := 'creditoID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(Aud_ProgramaID != "CLIENTESCANCELAPRO")THEN
                    IF (Aud_ProgramaID != "/microfin/creQuitasAgroContVista.htm" ) THEN
            IF (Var_CreStatus != Cre_Vigente AND Var_CreStatus != Cre_Vencido  AND Var_CreStatus != Cre_Castigado AND Var_CreStatus != Cre_Suspendido) THEN
                    SET Par_NumErr      := 003;
                    SET Par_ErrMen      := CONCAT('Estatus del Credito Incorrecto.');
                    SET Var_Control     := 'creditoID' ;
                    LEAVE ManejoErrores;
            END IF;
                    ELSE
                        SELECT Estatus  INTO Var_CreStatus
                        FROM CREDITOSCONT
                        WHERE CreditoID = Par_CreditoID;
                        IF (Var_CreStatus != Cre_Vigente AND Var_CreStatus != Cre_Vencido  AND Var_CreStatus != Cre_Castigado ) THEN
                                SET Par_NumErr      := 003;
                                SET Par_ErrMen      := CONCAT('Estatus del Credito Incorrecto.');
                                SET Var_Control     := 'creditoID' ;
                                LEAVE ManejoErrores;
                        END IF;
                    END IF;
        END IF;

        IF(IFNULL(Par_Transaccion, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr      := 004;
            SET Par_ErrMen      := CONCAT('El Numero de Movimiento esta Vacio.');
            SET Var_Control     := 'creditoID' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_FechaOperacion, Fecha_Vacia)) = Fecha_Vacia THEN
            SET Par_NumErr      := 005;
            SET Par_ErrMen      := CONCAT('La Fecha Op. esta Vacia.');
            SET Var_Control     := 'fecha' ;
            SET Var_Consecutivo := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_FechaAplicacion, Fecha_Vacia)) = Fecha_Vacia THEN
            SET Par_NumErr      := 006;
            SET Par_ErrMen      := CONCAT('La Fecha de la Aplicacion del Movimiento esta Vacia.');
            SET Var_Control     := 'fecha' ;
            SET Var_Consecutivo := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 007;
            SET Par_ErrMen      := CONCAT('La Naturaleza del Movimiento esta Vacia.');
            SET Var_Control     := 'natMovimiento' ;
            SET Var_Consecutivo := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

        IF(Par_NatMovimiento<>Nat_Cargo)THEN
            IF(Par_NatMovimiento<>Nat_Abono)THEN
                SET Par_NumErr      := 008;
                SET Par_ErrMen      := CONCAT('La Naturaleza del Movimiento no es Correcta.');
                SET Var_Control     := 'natMovimiento' ;
                SET Var_Consecutivo := Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(Par_NatMovimiento<>Nat_Abono)THEN
            IF(Par_NatMovimiento<>Nat_Cargo)THEN
                SET Par_NumErr      := 009;
                SET Par_ErrMen      := CONCAT('La Naturaleza del Movimiento no es Correcta.');
                SET Var_Control     := 'natMovimiento' ;
                SET Var_Consecutivo := Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(IFNULL(Par_Cantidad, Float_Cero)) <= Float_Cero THEN
            SET Par_NumErr      := 010;
            SET Par_ErrMen      := CONCAT('Cantidad del Movimiento de Credito Incorrecta.');
            SET Var_Control     := 'cantidad' ;
            SET Var_Consecutivo := 0;
            LEAVE ManejoErrores;
        END IF;


        IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 011;
            SET Par_ErrMen      := CONCAT('La Descripcion del Movimiento esta Vacia.');
            SET Var_Control     := 'descripcion' ;
            SET Var_Consecutivo := 0;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 012;
            SET Par_ErrMen      := CONCAT('La Referencia esta Vacia.');
            SET Var_Control     := 'referencia' ;
            SET Var_Consecutivo := 0;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TipoMovCreID, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr      := 013;
            SET Par_ErrMen      := CONCAT('El Tipo de Movimiento esta Vacio.');
            SET Var_Control     := 'tipoMovCreID' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(NOT EXISTS(SELECT AmortizacionID
                            FROM AMORTICREDITO
                                WHERE CreditoID         = Par_CreditoID
                                    AND AmortizacionID  = Par_AmortiCreID)) THEN
            SET Par_NumErr      := 014;
            SET Par_ErrMen      := CONCAT('La Amortizacion no Existe.');
            SET Var_Control     := 'amortizacionID' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        SET Mov_Cantidad = Par_Cantidad;

        IF (Par_NatMovimiento = Nat_Abono) THEN
            SET Mov_Cantidad := Mov_Cantidad * -1;
        END IF;

        IF (Par_TipoMovCreID = Mov_IntOrd) THEN
            UPDATE CREDITOS SET
                SaldoInterOrdin = SaldoInterOrdin + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoInteresOrd = SaldoInterOrdin + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_CapOrd) THEN
            UPDATE CREDITOS SET
                SaldoCapVigent  = SaldoCapVigent + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoCapVigente = SaldoCapVigente + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_CapAtr) THEN
            UPDATE CREDITOS SET
                SaldoCapAtrasad = SaldoCapAtrasad + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoCapAtrasa  = SaldoCapAtrasa + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_CapVen) THEN
            UPDATE CREDITOS SET
                SaldoCapVencido = SaldoCapVencido + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoCapVencido = SaldoCapVencido + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_CapVNE) THEN
            UPDATE CREDITOS SET
                SaldCapVenNoExi = SaldCapVenNoExi + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoCapVenNExi = SaldoCapVenNExi + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IntAtr) THEN
            UPDATE CREDITOS SET
                SaldoInterAtras = SaldoInterAtras + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoInteresAtr = SaldoInteresAtr + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IntVen) THEN
            UPDATE CREDITOS SET
                SaldoInterVenc  = SaldoInterVenc + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoInteresVen = SaldoInteresVen + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IntPro) THEN

            IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_GenInt) THEN
                SET Var_AcumProv := Mov_Cantidad;
            ELSE
                SET Var_AcumProv := Entero_Cero;
            END IF;

            UPDATE CREDITOS SET
                SaldoInterProvi = SaldoInterProvi + Mov_Cantidad,
                ProvisionAcum       = ProvisionAcum + Var_AcumProv
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoInteresPro = SaldoInteresPro + Mov_Cantidad,
                ProvisionAcum       = ProvisionAcum + Var_AcumProv
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IntCalNoCon) THEN

            IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_GenInt) THEN
                SET Var_AcumProv := Mov_Cantidad;
            ELSE
                SET Var_AcumProv := Entero_Cero;
            END IF;

            UPDATE CREDITOS SET
                SaldoIntNoConta = SaldoIntNoConta + Mov_Cantidad,
                ProvisionAcum       = ProvisionAcum + Var_AcumProv
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoIntNoConta = SaldoIntNoConta + Mov_Cantidad,
                ProvisionAcum       = ProvisionAcum + Var_AcumProv
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IntMor) THEN
            UPDATE CREDITOS SET
                SaldoMoratorios = SaldoMoratorios + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoMoratorios = SaldoMoratorios + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IntMoratoVen) THEN

            UPDATE CREDITOS SET
                SaldoMoraVencido    = SaldoMoraVencido + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoMoraVencido    = SaldoMoraVencido + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IntMoraCarVen) THEN

            UPDATE CREDITOS SET
                SaldoMoraCarVen = SaldoMoraCarVen + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoMoraCarVen = SaldoMoraCarVen + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IVAInt) THEN
            UPDATE CREDITOS SET
                SaldoIVAInteres = SaldoIVAInteres + Par_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoIVAInteres = SaldoIVAInteres + Par_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IVAMor) THEN
            UPDATE CREDITOS SET
                SaldoIVAMorator = SaldoIVAMorator + Par_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoIVAMorato  = SaldoIVAMorato + Par_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IVAFalPag) THEN
            UPDATE CREDITOS SET
                SalIVAComFalPag = SalIVAComFalPag + Par_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoIVAComFalP = SaldoIVAComFalP + Par_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_IVAComApe OR Par_TipoMovCreID = Mov_IVAComLiqAnt) THEN
            UPDATE CREDITOS SET
                SaldoIVAComisi  = SaldoIVAComisi + Par_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoIVAComisi  = SaldoIVAComisi + Par_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_ComFalPag) THEN
            UPDATE CREDITOS SET
                SaldComFaltPago = SaldComFaltPago + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoComFaltaPa = SaldoComFaltaPa + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;

          ELSEIF (Par_TipoMovCreID = Mov_ComApeCre OR Par_TipoMovCreID = Mov_ComLiqAnt) THEN
            UPDATE CREDITOS SET
                SaldoOtrasComis = SaldoOtrasComis + Mov_Cantidad
                WHERE CreditoID = Par_CreditoID;

            UPDATE AMORTICREDITO SET
                SaldoOtrasComis = SaldoOtrasComis + Mov_Cantidad
                WHERE CreditoID        = Par_CreditoID
                  AND AmortizacionID = Par_AmortiCreID;


        ELSEIF (Par_TipoMovCreID = Mov_SegCuota) THEN

            UPDATE AMORTICREDITO SET
                SaldoSeguroCuota = SaldoSeguroCuota + Mov_Cantidad
            WHERE CreditoID  = Par_CreditoID
              AND AmortizacionID = Par_AmortiCreID;

        ELSEIF (Par_TipoMovCreID = Mov_IVASegCuota) THEN

            UPDATE AMORTICREDITO SET
                SaldoIVASeguroCuota = SaldoIVASeguroCuota + Mov_Cantidad
            WHERE CreditoID = Par_CreditoID
              AND AmortizacionID = Par_AmortiCreID;

        ELSEIF (Par_TipoMovCreID = Mov_ComAnual) THEN

            -- COMISION ANUAL
            UPDATE AMORTICREDITO SET
                SaldoComisionAnual = SaldoComisionAnual + Mov_Cantidad
            WHERE CreditoID  = Par_CreditoID
              AND AmortizacionID = Par_AmortiCreID;

        ELSEIF (Par_TipoMovCreID = Mov_ComAnualIVA) THEN

            -- COMISION ANUAL
            UPDATE AMORTICREDITO SET
                SaldoComisionAnualIVA = SaldoComisionAnualIVA + Mov_Cantidad
            WHERE CreditoID  = Par_CreditoID
              AND AmortizacionID = Par_AmortiCreID;

			ELSEIF (Par_TipoMovCreID = Mov_NotaCargoConIVA) THEN -- Nota cargo con IVA
				UPDATE CREDITOS SET
					SaldoNotCargoConIVA = SaldoNotCargoConIVA + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

				UPDATE AMORTICREDITO SET
					SaldoNotCargoConIVA = SaldoNotCargoConIVA + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID
				AND AmortizacionID = Par_AmortiCreID;

			ELSEIF (Par_TipoMovCreID = Mov_NotaCargoSinIVA) THEN -- Nota Cargo sin IVA
				UPDATE CREDITOS SET
					SaldoNotCargoSinIVA = SaldoNotCargoSinIVA + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

				UPDATE AMORTICREDITO SET
					SaldoNotCargoSinIVA = SaldoNotCargoSinIVA + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID
				AND AmortizacionID = Par_AmortiCreID;

			ELSEIF (Par_TipoMovCreID = Mov_NotaCargoNoRecon) THEN -- Nota cargo no reconocido
				UPDATE CREDITOS SET
					SaldoNotCargoRev = SaldoNotCargoRev + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

				UPDATE AMORTICREDITO SET
					SaldoNotCargoRev = SaldoNotCargoRev + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID
				AND AmortizacionID = Par_AmortiCreID;

        ELSEIF ( Par_TipoMovCreID = Mov_ComSerGarantia ) THEN

            -- comision por Servicio de Garantia
            UPDATE AMORTICREDITO SET
                SaldoComServGar = IFNULL(SaldoComServGar, Entero_Cero) + Mov_Cantidad
            WHERE CreditoID = Par_CreditoID
              AND AmortizacionID = Par_AmortiCreID;

            UPDATE CREDITOS SET
                SaldoComServGar     = IFNULL(SaldoComServGar, Entero_Cero) + Mov_Cantidad,
                MontoPagComGarantia = MontoPagComGarantia +
                                      CASE WHEN (Par_NatMovimiento = Nat_Cargo)
                                                THEN Mov_Cantidad
                                                ELSE Entero_Cero
                                      END,
                MontoCobComGarantia = IFNULL(MontoCobComGarantia, Entero_Cero) +
                                      CASE WHEN (Par_NatMovimiento = Nat_Abono)
                                                THEN Mov_Cantidad
                                                ELSE Entero_Cero
                                      END
            WHERE CreditoID = Par_CreditoID;

        ELSEIF ( Par_TipoMovCreID = Mov_IVAComSerGarantia ) THEN
            -- IVA de comision por Servicio de Garantia
            UPDATE AMORTICREDITO SET
                SaldoIVAComSerGar = IFNULL(SaldoIVAComSerGar, Entero_Cero) + Mov_Cantidad
            WHERE CreditoID  = Par_CreditoID
              AND AmortizacionID = Par_AmortiCreID;

            UPDATE CREDITOS SET
                SaldoIVAComSerGar = IFNULL(SaldoIVAComSerGar, Entero_Cero) + Mov_Cantidad,
                MontoPagComGarantia = MontoPagComGarantia +
                                      CASE WHEN (Par_NatMovimiento = Nat_Cargo)
                                                THEN Mov_Cantidad
                                                ELSE Entero_Cero
                                      END,
                MontoCobComGarantia = IFNULL(MontoCobComGarantia, Entero_Cero) +
                                      CASE WHEN (Par_NatMovimiento = Nat_Abono)
                                                THEN Mov_Cantidad
                                                ELSE Entero_Cero
                                      END
            WHERE CreditoID = Par_CreditoID;

        END IF;

        INSERT CREDITOSMOVS (
            CreditoID,          AmortiCreID,        Transaccion,        FechaOperacion,     FechaAplicacion,
            TipoMovCreID,       NatMovimiento,      MonedaID,           Cantidad,           Descripcion,
            Referencia,         PolizaID,           EmpresaID,          Usuario,            FechaActual,
            DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion)
        VALUES(
            Par_CreditoID,      Par_AmortiCreID,    Par_Transaccion,    Par_FechaOperacion, Par_FechaAplicacion,
            Par_TipoMovCreID,   Par_NatMovimiento,  Par_MonedaID,       Par_Cantidad,       Par_Descripcion,
            Par_Referencia,     Par_Poliza,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

        IF (Par_Descripcion = Des_PagoCred AND Aud_ProgramaID = Pro_PagCre) THEN

            CALL DETALLEPAGCREPRO(
                Par_AmortiCreID,    Par_CreditoID,      Par_FechaOperacion, Par_Transaccion,    Var_ClienteID,
                Par_Cantidad,       Par_TipoMovCreID,   Par_OrigenPago,     Salida_NO,          Par_NumErr,
                Par_ErrMen,         Par_ModoPago,       Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

            IF(Par_NumErr > Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Movimiento de Credito Agregado Exitosamente.');
        SET Var_Control := 'cuentaAhoID' ;
        SET Par_Consecutivo := Entero_Cero;
        SET Var_Consecutivo := CONCAT(Par_Consecutivo);

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr  AS NumErr,
                Par_ErrMen  AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$