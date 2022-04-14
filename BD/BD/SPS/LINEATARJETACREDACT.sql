-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEATARJETACREDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEATARJETACREDACT`;

DELIMITER $$
CREATE PROCEDURE `LINEATARJETACREDACT`(
-- ---------------------------------------------------------------------------------
-- SP PARA ACTUALIZAR EL ESTATUS DE LA LINEA DE CREDITO
-- ---------------------------------------------------------------------------------
    Par_LineaTarCredID          INT(11),        -- Identificador de la Linea de Credito
    Par_Fecha                   DATE,           -- Fecha de actualizacion
    Par_MontoOperacion          DECIMAL(12,2),  -- Monto en pesos de la transaccion
    Par_NumAct                  TINYINT(1),     -- Tipo de actualizacion a realizar

    Par_Salida                  CHAR    (1),
    INOUT Par_NumErr            INT     (11),   -- PARAMETRO DE SALIDA CON EL NUMERO DE ERROR
    INOUT Par_ErrMen            VARCHAR (400),  -- PARAMETRO DE SALIDA CON EL MENSAJE DE ERROR
    Aud_EmpresaID               INT     (11),   -- Auditoria
    Aud_Usuario                 INT     (11),   -- Auditoria

    Aud_FechaActual             DATE,           -- Auditoria
    Aud_DireccionIP             VARCHAR (20),   -- Auditoria
    Aud_ProgramaID              VARCHAR (50),   -- Auditoria
    Aud_Sucursal                INT     (11),   -- Auditoria
    Aud_NumTransaccion          BIGINT  (20)    -- Auditoria
)

TerminaStore:BEGIN

    -- DECLARACION DE VARIBALES
    DECLARE Var_Control             VARCHAR(20);
    DECLARE Var_Tarjeta             CHAR(16);
    DECLARE Var_ClienteID           INT (11);
    DECLARE Var_ProductoCreditoID   INT;
    DECLARE Var_Clasificacion       CHAR(1);
    DECLARE Var_SubClasificacion    INT(11);
    DECLARE Var_SucursalCte         INT(11);
    DECLARE Var_Poliza              BIGINT;
    DECLARE Var_Consecutivo         INT(11);
    DECLARE Var_LimiteCredito       DECIMAL(16,2);
    DECLARE Var_FechaSistema        DATE;
    DECLARE Var_CobComisionAper     CHAR(1);
    DECLARE Var_TipoCobComAper      CHAR(1);
    DECLARE Var_FacComisionAper     DECIMAL(16,2);
    DECLARE Var_MontoComApertura    DECIMAL(16,2);
    DECLARE Var_MontoIVAComApertura DECIMAL(16,2);
    DECLARE Var_IVASuc              DECIMAL(8,4);
    DECLARE Var_CliPagIVA           CHAR(1);

    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia            CHAR(1);      -- Cadena vacia
    DECLARE Fecha_Vacia             DATE;             -- Fecha vacia
    DECLARE Entero_Cero             INT(11);     -- Entero  cero
    DECLARE SalidaSI                CHAR(1);      -- Genera una salida
    DECLARE SalidaNO                CHAR(1);
    DECLARE Tar_Activa              CHAR(1);
    DECLARE Act_Estatus             INT(1);
    DECLARE Act_BloqueoSaldo        INT(11);        -- Actualizacion de Bloqueo de Saldo
    DECLARE Act_DesbloqueoSaldo     INT(11);        -- Actualizacion de Desbloqueo de Saldo
    DECLARE Moneda                  INT(1);
    DECLARE Concepto_TarCred        INT(11);
    DECLARE AltaPolCre_NO           CHAR(1);
    DECLARE RegistraMov_SI          CHAR(1);
    DECLARE AltaMovLin_NO           CHAR(1);
    DECLARE AltaMovBita_NO          CHAR(1);
    DECLARE Alta_Enc_Pol_SI         CHAR(1);
    DECLARE Des_LineaTar            VARCHAR(50);
    DECLARE Des_ComApertura         VARCHAR(50);
    DECLARE Des_IVAComApertura      VARCHAR(50);
    DECLARE SubClas_TarCred         INT;
    DECLARE Cons_SI                 CHAR(1);
    DECLARE Cons_NO                 CHAR(1);
    DECLARE Nat_Abono               CHAR(1);
    DECLARE Nat_Cargo               CHAR(1);
    DECLARE Tipo_Porcentaje         CHAR(1);
    DECLARE Corte_Dia               CHAR(1);
    DECLARE Corte_FinMes            CHAR(1);
    DECLARE Tipo_MovAper            INT;
    DECLARE Tipo_MovIVAAper         INT;
    DECLARE Concep_ComAper          INT;
    DECLARE Concep_ComIVAAper       INT;
	DECLARE TipoOperaTarjeta		VARCHAR(2);

-- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia            :=  '';             -- Cadena Vacia
    SET Fecha_Vacia             :=  '1900-01-01';   -- Fecha Vacia
    SET Entero_Cero             :=  0;              -- Entero 0
    SET SalidaSI                :=  'S';            -- El Store SI genera una Salida
    SET SalidaNO                :=  'N';
    SET Tar_Activa              := 'A';
    SET Act_Estatus             :=  1;
    SET Act_BloqueoSaldo        :=  2;
    SET Act_DesbloqueoSaldo     :=  3;
    SET Moneda                  :=  1;
    SET Concepto_TarCred        :=1100;
    SET AltaPolCre_NO           := 'N';
    SET RegistraMov_SI          := 'S';
    SET AltaMovLin_NO           := 'N';
    SET AltaMovBita_NO          := 'N';
    SET Alta_Enc_Pol_SI         := 'S';
    SET Des_LineaTar            :='ALTA LINEA TARJETA CREDITO';
    SET Des_ComApertura         :='COMISION POR APERTURA';
    SET Des_IVAComApertura      :='IVA COMISION POR APERTURA';
    SET Cons_SI                 := 'S';
    SET Cons_NO                 := 'N';
    SET Tipo_MovAper            := 41;
    SET Tipo_MovIVAAper         := 23;
    SET Nat_Abono               :='A';
    SET Nat_Cargo               :='C';
    SET Concep_ComAper          := 22;
    SET Concep_ComIVAAper       := 23;
    SET SubClas_TarCred         := 201;
    SET Tipo_Porcentaje         := 'P';
    SET Corte_Dia               := 'D';
    SET Corte_FinMes            := 'F';
	SET TipoOperaTarjeta		:= '19';

    ManejoErrores: BEGIN

       DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-LINEATARJETACREDACT');
            SET Var_Control = 'SQLEXCEPTION';
        END;

        SELECT FechaSistema INTO Var_FechaSistema
            FROM PARAMETROSSIS WHERE EmpresaID = Aud_EmpresaID;

        IF(Par_LineaTarCredID = Entero_Cero) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'La linea de credito esta vacia';
            SET Var_Control := 'LineaTarCredID';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_Fecha = Fecha_Vacia) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'La fecha esta vacia';
            SET Var_Control := 'Fecha';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_NumAct = Entero_Cero) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'El Numero de Actualizacion esta vacio';
            SET Var_Control := 'NumAct';
            LEAVE ManejoErrores;
        END IF;

       /*
        *===============================================================================================================
        *   ACTUALIZACION DEL ESTATUS  DE LA LINEA
        *===============================================================================================================
        */

        IF(Par_NumAct = Act_Estatus) THEN

            SELECT Tar.TarjetaCredID, Tar.ClienteID
              INTO Var_Tarjeta,       Var_ClienteID
              FROM TARJETACREDITO Tar
             WHERE Tar.LineaTarCredID = Par_LineaTarCredID;

           SELECT ProductoCredID,               CobComisionAper,     TipoCobComAper,        FacComisionAper
                    INTO Var_ProductoCreditoID, Var_CobComisionAper, Var_TipoCobComAper,    Var_FacComisionAper
                FROM LINEATARJETACRED
                WHERE LineaTarCredID = Par_LineaTarCredID;

           SELECT       Tipo AS Clasificacion,      SubClas_TarCred AS SubClasificacion
                    INTO    Var_Clasificacion,      Var_SubClasificacion
                FROM PRODUCTOSCREDITO
                WHERE ProducCreditoID = Var_ProductoCreditoID;

           SELECT   SucursalOrigen,         PagaIVA
                    INTO Var_SucursalCte,   Var_CliPagIVA
                FROM CLIENTES WHERE ClienteID = Var_ClienteID;

           SELECT IVA INTO Var_IVASuc
                    FROM SUCURSALES
                WHERE SucursalID    = Var_SucursalCte;

            IF (Var_CliPagIVA = Cons_SI) THEN
                SET Var_IVASuc  := IFNULL(Var_IVASuc,Entero_Cero);
            ELSE
                SET Var_IVASuc  := Entero_Cero;
            END IF;

           SELECT MontoLinea INTO Var_LimiteCredito
             FROM LINEATARJETACRED
            WHERE LineaTarCredID = Par_LineaTarCredID;

            CALL TC_CONTALINEAPRO(
                        Par_LineaTarCredID,     Var_Tarjeta,            Var_ClienteID,          DATE(Par_Fecha),        Par_Fecha,
                        Var_LimiteCredito,      Moneda,                 Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                        Var_SucursalCte,        Des_LineaTar,           Cadena_Vacia,           Alta_Enc_Pol_SI,        Concepto_TarCred,
                        Var_Poliza,             AltaPolCre_NO,          RegistraMov_SI,         AltaMovLin_NO,          Entero_Cero,            Entero_Cero,
                        Nat_Abono,              Aud_NumTransaccion,     AltaMovBita_NO,         Cadena_Vacia,			TipoOperaTarjeta,
                        SalidaNO,               Par_NumErr,             Par_ErrMen,
                        Var_Consecutivo,        Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            /* Validar numero de error */
            IF Par_NumErr <> Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;

            /* Agregar la llamada al SP que Cobra Comision por Apertura */
            IF Var_CobComisionAper = Cons_SI THEN

                SET Var_MontoComApertura := CASE WHEN Var_TipoCobComAper = Tipo_Porcentaje
                                                 THEN ROUND(Var_LimiteCredito*Var_FacComisionAper/100)
                                                 ELSE ROUND(Var_FacComisionAper,2)
                                            END;

                SET Var_MontoIVAComApertura := ROUND(Var_MontoComApertura * Var_IVASuc,2);


                CALL TC_CONTALINEAPRO(
                        Par_LineaTarCredID,     Var_Tarjeta,            Var_ClienteID,          DATE(Par_Fecha),        Par_Fecha,
                        Var_MontoComApertura,   Moneda,                 Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                        Var_SucursalCte,        Des_ComApertura,        CONCAT('Linea.',Par_LineaTarCredID),            Cons_NO,                Concepto_TarCred,
                        Var_Poliza,             Cons_SI,                RegistraMov_SI,         Cons_SI,                Concep_ComAper,         Tipo_MovAper,
                        Nat_Cargo,              Aud_NumTransaccion,     Cons_SI,        Des_ComApertura,				TipoOperaTarjeta,
                        SalidaNO,               Par_NumErr,             Par_ErrMen,
                        Var_Consecutivo,        Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


                IF Par_NumErr <> Entero_Cero THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL TC_CONTALINEAPRO(
                        Par_LineaTarCredID,         Var_Tarjeta,            Var_ClienteID,          DATE(Par_Fecha),        Par_Fecha,
                        Var_MontoIVAComApertura,    Moneda,                 Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                        Var_SucursalCte,            Des_IVAComApertura,     CONCAT('Linea.',Par_LineaTarCredID),            Cons_NO,                Concepto_TarCred,
                        Var_Poliza,                 Cons_SI,                RegistraMov_SI,         Cons_SI,                Concep_ComIVAAper,          Tipo_MovIVAAper,
                        Nat_Cargo,                  Aud_NumTransaccion,     Cons_SI,        Des_IVAComApertura,				TipoOperaTarjeta,
                        SalidaNO,                   Par_NumErr,             Par_ErrMen,
                        Var_Consecutivo,            Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,             Aud_Sucursal,           Aud_NumTransaccion);


                IF Par_NumErr <> Entero_Cero THEN
                    LEAVE ManejoErrores;
                END IF;

            END IF;

             UPDATE LINEATARJETACRED SET
                    FechaActivacion    = Par_Fecha,
                    Estatus            = Tar_Activa,
                    FechaProxCorte     = CASE WHEN TipoCorte = Corte_Dia AND DAY(Var_FechaSistema) >  DiaCorte  THEN
                                            STR_TO_DATE(CONCAT(DATE_FORMAT(DATE_ADD(Var_FechaSistema,INTERVAL 1 MONTH), '%Y-%m-'),DiaCorte),'%Y-%m-%d')
                                        WHEN TipoCorte = Corte_Dia AND DAY(Var_FechaSistema) <=  DiaCorte  THEN
                                            STR_TO_DATE(CONCAT(DATE_FORMAT(Var_FechaSistema, '%Y-%m-'),DiaCorte),'%Y-%m-%d')
                                        WHEN TipoCorte = Corte_FinMes THEN
                                            LAST_DAY(Var_FechaSistema)
                                        ELSE Fecha_Vacia END,
                    NumTransaccion     = Aud_NumTransaccion

              WHERE LineaTarCredID     = Par_LineaTarCredID;
        END IF;

        IF( Par_NumAct = Act_BloqueoSaldo ) THEN

            -- Validacion de Monto
            IF( Par_MontoOperacion = Entero_Cero OR Par_MontoOperacion < Entero_Cero) THEN
                SET Par_NumErr  := 1312;
                SET Par_ErrMen  := 'La Cantidad debe de ser mayor que cero.';
                SET Var_Control := 'lineaTarCredID';
                LEAVE ManejoErrores;
            END IF;

            UPDATE LINEATARJETACRED SET
                MontoDisponible = MontoDisponible - Par_MontoOperacion,
                MontoBloqueado  = MontoBloqueado + Par_MontoOperacion,
                EmpresaID       = Aud_EmpresaID,
                Usuario         = Aud_Usuario,
                FechaActual     = Aud_FechaActual,
                DireccionIP     = Aud_DireccionIP,
                ProgramaID      = Aud_ProgramaID,
                Sucursal        = Aud_Sucursal,
                NumTransaccion  = Aud_NumTransaccion
            WHERE LineaTarCredID = Par_LineaTarCredID;
        END IF;

        IF( Par_NumAct = Act_DesbloqueoSaldo ) THEN

            -- Validacion de Monto
            IF( Par_MontoOperacion = Entero_Cero OR Par_MontoOperacion < Entero_Cero) THEN
                SET Par_NumErr  := 1312;
                SET Par_ErrMen  := 'La Cantidad debe de ser mayor que cero.';
                SET Var_Control := 'lineaTarCredID';
                LEAVE ManejoErrores;
            END IF;

            UPDATE LINEATARJETACRED SET
                MontoDisponible = MontoDisponible + Par_MontoOperacion,
                MontoBloqueado  = MontoBloqueado - Par_MontoOperacion,
                EmpresaID       = Aud_EmpresaID,
                Usuario         = Aud_Usuario,
                FechaActual     = Aud_FechaActual,
                DireccionIP     = Aud_DireccionIP,
                ProgramaID      = Aud_ProgramaID,
                Sucursal        = Aud_Sucursal,
                NumTransaccion  = Aud_NumTransaccion
            WHERE LineaTarCredID = Par_LineaTarCredID;
        END IF;

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
        Par_ErrMen AS ErrMen,
        Var_Control AS control,
        IFNULL(Par_LineaTarCredID, Entero_Cero) AS consecutivo;
    END IF;

END TerminaStore$$
