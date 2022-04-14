-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSCAJAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSCAJAMOD`;
DELIMITER $$


CREATE PROCEDURE `PARAMETROSCAJAMOD`(

    Par_EmpresaID           INT(11),
    Par_CtaProtecCre        CHAR(25),
    Par_CtaProtecCta        CHAR(25),
    Par_HaberExSocios       CHAR(25),
    Par_CtaContaPROFUN      CHAR(25),
    Par_TipoCtaProtec       INT(11),
    Par_PerfilAutoriProtec  INT(11),
    Par_MontoMaxProtec      DECIMAL(14,2),
    Par_MontoPROFUN         DECIMAL(14,2),
    Par_AporteMaxPROFUN     DECIMAL(14,2),

    Par_MaxAtraPagPROFUN    INT(11),
    Par_PerfilCancelPROFUN  INT(11),
    Par_MontoApoyoSRVFUN    DECIMAL(12,2),
    Par_MonApoFamSRVFUN     DECIMAL(14,2),
    Par_PerfilAutoriSRVFUN  INT(11),
    Par_EdadMaximaSRVFUN    INT(11),
    Par_TiempoMinimoSRVFUN  INT(11),
    Par_MesesValAhoSRVFUN   INT(11),
    Par_SaldoMinMesSRVFUN   DECIMAL(12,2),
    Par_CtaContaSRVFUN      CHAR(25),
    Par_RolAutoApoyoEsc     INT(11),

    Par_TipoCtaApoyoEscMay  INT(11),
    Par_TipoCtaApoyoEscMen  INT(11),
    Par_MesInicioAhoCons    INT(11),
    Par_MontoMinMesApoyoEsc DECIMAL(12,2),
    Par_CtaContaApoyoEsc    CHAR(25),
    Par_CompromisoAho       DECIMAL(14,2),
    Par_PorcentajeCob       DECIMAL(12,2),
    Par_CoberturaMin        DECIMAL(12,2),
    Par_CtaOrdinaria        INT(11),
    Par_CCHaberesEx         VARCHAR(30),

    Par_CCProtecAhorro      VARCHAR(30),
    Par_CCServifun          VARCHAR(30),
    Par_CCApoyoEscolar      VARCHAR(30),
    Par_CCContaPerdida      VARCHAR(30),
    Par_TipoCtaBeneCancel   INT(11),
    Par_CuentaVista         INT(11),
    Par_CtaContaPerdida     CHAR(25),
    Par_EjecutivoFR         INT(11),
    Par_TipoCtaProtecMen    INT(11),
    Par_EdadMinimaCliMen    INT(11),

    Par_EdadMaximaCliMen    INT(11),
    Par_GastosRural         DECIMAL(12,2),
    Par_GastosUrbana        DECIMAL(12,2),

    Par_GastosPasivos       VARCHAR(100),
    Par_PuntajeMinimo       DECIMAL(14,2),
    Par_IdGastoAlimenta     DECIMAL(14,2),
    Par_VersionWS           VARCHAR(40),
    Par_RolCancelaCheq      INT(11),

    Par_CodCooperativa      VARCHAR(9),
    Par_CodMoneda           VARCHAR(3),
    Par_CodUsuario          VARCHAR(19),
    Par_PermiteAdicional    CHAR(1),
    Par_TipoProdCap         CHAR(1),

    Par_AntigueSocio        INT(11),
    Par_MontoAhoMes         DECIMAL(18,2),
    Par_ImpMinParSoc        DECIMAL(18,2),
    Par_MesesEvalAho        INT(11),
    Par_ValidaCredAtras     CHAR(1),
    Par_ValidaGaranLiq      CHAR(1),

    Par_MesesConsPago       INT(11),
    Par_montoMaxActCom		DECIMAL(14,2),
    Par_montoMinActCom		DECIMAL(14,2),

    Par_Salida              CHAR(1),

    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )

TerminaStore:BEGIN


    DECLARE varControl          CHAR(15);


    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL;
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Salida_SI           CHAR(1);


    SET Entero_Cero         :=0;
    SET Decimal_Cero        :=0.0;
    SET Cadena_Vacia        :='';
    SET Salida_SI           :='S';


    SET Par_NumErr      := 0;
    SET Par_ErrMen      := '';



    ManejoErrores:BEGIN

        IF(IFNULL(Par_EmpresaID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := 'El numero de empresa esta vacio';
            SET varControl  := 'empresaID' ;
            LEAVE ManejoErrores;
        END IF;


        IF NOT EXISTS(SELECT CuentaCompleta
                    FROM CUENTASCONTABLES
                    WHERE CuentaCompleta = Par_CtaContaPerdida)THEN
                SET Par_NumErr  := 36;
                SET Par_ErrMen  := 'No existe la Cuenta Contable';
                SET varControl  := 'ctaContaPerdida' ;
                LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CtaProtecCre,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := 'El numero de cuenta contable de proteccion al credito esta vacio';
            SET varControl  := 'ctaProtecCre' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CtaProtecCta,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  := 'El numero de cuenta contable de proteccion esta vacio';
            SET varControl  := 'ctaProtecCta' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_HaberExSocios,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'El numero de cuenta contable de haberes esta vacio';
            SET varControl  := 'haberExSocios' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CtaContaPROFUN,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'El numero de cuenta de contable de profun esta vacio';
            SET varControl  := 'ctaContaPROFUN' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TipoCtaProtec,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 6;
            SET Par_ErrMen  := 'El tipo de cuenta a la cual se permitira aplicar el programa de Proteccion de Ahorro y Credito esta vacio';
            SET varControl  := 'tipoCtaProtec' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MontoMaxProtec,Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr  := 7;
            SET Par_ErrMen  := 'El monto maximo del beneficio del programa de Proteccion al Ahorro y Credito esta vacio';
            SET varControl  := 'montoMaxProtec' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MontoPROFUN,Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr  := 8;
            SET Par_ErrMen  := 'El monto a recibir como beneficio de programa PROFUN esta vacio';
            SET varControl  := 'montoPROFUN' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_AporteMaxPROFUN,Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr  := 9;
            SET Par_ErrMen  := 'El monto de la aportacion maxima de los socios incritos en la mutual de PROFUN esta vacio';
            SET varControl  := 'aporteMaxPROFUN' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_PerfilCancelPROFUN,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 11;
            SET Par_ErrMen  := 'Rol del pefil que puede hacer cancelaciones de PROFUN esta vacio';
            SET varControl  := 'perfilCancelPROFUN';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MontoApoyoSRVFUN,Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr  := 10;
            SET Par_ErrMen  := 'Monto del apoyo del Servicio funerario esta vacio';
            SET varControl  := 'montoApoyoSRVFUN';
            LEAVE ManejoErrores;
        END IF;


        IF(IFNULL(Par_MonApoFamSRVFUN,Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr  := 11;
            SET Par_ErrMen  := 'Monto del apoyo del Servicio funerario de familiar esta vacio';
            SET varControl  := 'monApoFamSRVFUN';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_PerfilAutoriProtec,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 12;
            SET Par_ErrMen  := 'Rol del pefil que puede hacer autorizaciones esta vacio';
            SET varControl  := 'perfilAutoriProtec';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_PerfilAutoriSRVFUN,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 13;
            SET Par_ErrMen  := 'Rol del pefil que puede hacer autorizaciones esta vacio';
            SET varControl  := 'perfilAutoriSRVFUN';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_EdadMaximaSRVFUN,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 14;
            SET Par_ErrMen  := 'Edad al ingresar a la institucion esta vacia';
            SET varControl  := 'edadMaximaSRVFUN';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TiempoMinimoSRVFUN,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 15;
            SET Par_ErrMen  := 'Tiempo minimo de haber ingresado esta vacio';
            SET varControl  := 'tiempoCuentaSRVFUN';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_MesesValAhoSRVFUN,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 16;
            SET Par_ErrMen  := 'Numero de meses a validar el Ahorro esta vacio';
            SET varControl  := 'mesesValAhoSRVFUN';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CtaContaSRVFUN,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := 17;
            SET Par_ErrMen  := 'Cuenta contable de ServiFun esta vacia';
            SET varControl  := 'ctaContaSRVFUN';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_RolAutoApoyoEsc,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 18;
            SET Par_ErrMen  := 'Rol del perfil que puede autorizar el apoyo escolar esta vacio';
            SET varControl  := 'rolAutoApoyoEsc';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_TipoCtaApoyoEscMay,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 19;
            SET Par_ErrMen  := 'Tipo de cuenta de ahorro para apoyo escolar de socio mayor de edad esta vacio';
            SET varControl  := 'tipoCtaApoyoEscMay';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_TipoCtaApoyoEscMen,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 20;
            SET Par_ErrMen  := 'Tipo de cuenta de ahorro para apoyo escolar de socio menor de edad esta vacio';
            SET varControl  := 'tipoCtaApoyoEscMen';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_MesInicioAhoCons,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 21;
            SET Par_ErrMen  := 'Mes de inicio de ahorro constante para condiciones de apoyo escolar esta vacio';
            SET varControl  := 'mesInicioAhoCons';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_CtaContaApoyoEsc,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 23;
            SET Par_ErrMen  := 'Cuenta contable de apoyo escolar esta vacia';
            SET varControl  := 'ctaContaApoyoEsc';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_CtaOrdinaria,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 24;
            SET Par_ErrMen  := 'Tipo cuenta considerada como ordinaria esta vacia';
            SET varControl  := 'ctaOrdinaria';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_EjecutivoFR,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 25;
            SET Par_ErrMen  := 'El Rol de Ejecutivo Financiero Rural esta vacio';
            SET varControl  := 'ejecutivoFR';
            LEAVE ManejoErrores;
        END IF;

    IF NOT EXISTS(SELECT EmpresaID
                    FROM PARAMETROSCAJA
                    WHERE EmpresaID = Par_EmpresaID)THEN
                SET Par_NumErr  := 26;
                SET Par_ErrMen  := 'El ID de la empresa no se ecuentra registrado';
                SET varControl  := 'empresaID' ;
                LEAVE ManejoErrores;
        END IF;

    IF NOT EXISTS(SELECT CuentaCompleta
                FROM CUENTASCONTABLES
                WHERE CuentaCompleta = Par_CtaProtecCre)THEN
            SET Par_NumErr  := 27;
            SET Par_ErrMen  := 'No existe la cuenta contable de proteccion al credito';
            SET varControl  := 'ctaProtecCre' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT CuentaCompleta
                FROM CUENTASCONTABLES
                WHERE CuentaCompleta = Par_CtaProtecCta)THEN
            SET Par_NumErr  := 28;
            SET Par_ErrMen  := 'No existe la cuenta contable de proteccion';
            SET varControl  := 'ctaProtecCta' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT CuentaCompleta
                FROM CUENTASCONTABLES
                WHERE CuentaCompleta = Par_HaberExSocios)THEN
            SET Par_NumErr  := 29;
            SET Par_ErrMen  := 'No existe la cuenta contable de haberes';
            SET varControl  := 'haberExSocios' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT CuentaCompleta
                FROM CUENTASCONTABLES
                WHERE CuentaCompleta = Par_CtaContaPROFUN)THEN
            SET Par_NumErr  := 30;
            SET Par_ErrMen  := 'No existe la cuenta contable profun';
            SET varControl  := 'ctaContaPROFUN' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT TipoCuentaID
                FROM TIPOSCUENTAS
                WHERE TipoCuentaID = Par_TipoCtaProtec)THEN
            SET Par_NumErr  := 31;
            SET Par_ErrMen  := 'No existe el tipo cuenta';
            SET varControl  := 'tipoCtaProtec' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT CuentaCompleta
                FROM CUENTASCONTABLES
                WHERE CuentaCompleta = Par_CtaContaSRVFUN)THEN
            SET Par_NumErr  := 32;
            SET Par_ErrMen  := 'No existe la cuenta contable SRVFUN';
            SET varControl  := 'ctaContaSRVFUN' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT RolID
                FROM ROLES
                WHERE RolID = Par_RolAutoApoyoEsc)THEN
            SET Par_NumErr  := 33;
            SET Par_ErrMen  := 'No el rol del perfil para autorizar apoyo escolar';
            SET varControl  := 'rolAutoApoyoEsc' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT TipoCuentaID
                FROM TIPOSCUENTAS
                WHERE TipoCuentaID = Par_TipoCtaApoyoEscMay)THEN
            SET Par_NumErr  := 34;
            SET Par_ErrMen  := 'No existe el tipo cuenta';
            SET varControl  := 'tipoCtaApoyoEscMay' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT TipoCuentaID
                FROM TIPOSCUENTAS
                WHERE TipoCuentaID = Par_TipoCtaApoyoEscMen)THEN
            SET Par_NumErr  := 35;
            SET Par_ErrMen  := 'No existe el tipo cuenta';
            SET varControl  := 'tipoCtaApoyoEscMen' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT CuentaCompleta
                FROM CUENTASCONTABLES
                WHERE CuentaCompleta = Par_CtaContaApoyoEsc)THEN
            SET Par_NumErr  := 36;
            SET Par_ErrMen  := 'No existe la Cuenta Contable';
            SET varControl  := 'tipoCtaApoyoEscMen' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT TipoCuentaID
                FROM TIPOSCUENTAS
                WHERE TipoCuentaID = Par_CtaOrdinaria)THEN
            SET Par_NumErr  := 37;
            SET Par_ErrMen  := 'No existe el Tipo Cuenta';
            SET varControl  := 'ctaOrdinaria' ;
            LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_TipoCtaBeneCancel,Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := 38;
        SET Par_ErrMen  := 'Tipo de Cuenta para tomar los beneficiarios en la solicitud de cancelacion esta vacia';
        SET varControl  := 'tipoCtaBeneCancel';
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT TipoCuentaID
                FROM TIPOSCUENTAS
                WHERE TipoCuentaID = Par_TipoCtaBeneCancel)THEN
            SET Par_NumErr  := 39;
            SET Par_ErrMen  := 'No existe el tipo cuenta';
            SET varControl  := 'tipoCtaBeneCancel' ;
            LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_CuentaVista,Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := 40;
        SET Par_ErrMen  := 'Tipo de Cuenta Vista esta vacia';
        SET varControl  := 'cuentaVista';
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT TipoCuentaID
                FROM TIPOSCUENTAS
                WHERE TipoCuentaID = Par_CuentaVista)THEN
            SET Par_NumErr  := 41;
            SET Par_ErrMen  := 'No existe el tipo cuenta';
            SET varControl  := 'cuentaVista' ;
            LEAVE ManejoErrores;
    END IF;

        IF NOT EXISTS(SELECT RolID
                FROM ROLES
                WHERE RolID = Par_EjecutivoFR)THEN
            SET Par_NumErr  := 42;
            SET Par_ErrMen  := 'No existe el Rol asignado a Ejecutivo Financiero Rural';
            SET varControl  := 'ejecutivoFR' ;
            LEAVE ManejoErrores;
        END IF;

    IF(IFNULL(Par_TipoCtaProtecMen,Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := 43;
        SET Par_ErrMen  := 'Cuenta Proteccion Ahorro y Credito para Menores de Edad esta vacia';
        SET varControl  := 'tipoCtaProtecMen';
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT TipoCuentaID
                FROM TIPOSCUENTAS
                WHERE TipoCuentaID = Par_TipoCtaProtecMen)THEN
            SET Par_NumErr  := 44;
            SET Par_ErrMen  := 'No Existe el Tipo de Cuenta Proteccion Ahorro y Credito';
            SET varControl  := 'tipoCtaProtecMen' ;
            LEAVE ManejoErrores;
    END IF;

                IF(IFNULL(Par_EdadMinimaCliMen,Entero_Cero) > IFNULL(Par_EdadMaximaCliMen,Entero_Cero) ) THEN
            SET Par_NumErr  := 45;
            SET Par_ErrMen  := 'Rango de Edades Incorrecto';
            SET varControl  := 'edadMinimaCliMen';
            LEAVE ManejoErrores;
        END IF;
    IF(IFNULL(Par_RolCancelaCheq,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 46;
            SET Par_ErrMen  := 'El Rol Para Cancelacion de Cheque Esta Vacio';
            SET varControl  := 'rolCancelaCheque' ;
            LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ValidaCredAtras,Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := 47;
        SET Par_ErrMen  := 'Valida creditos atrasados esta vacio';
        SET varControl  := 'validaCredAtras' ;
        LEAVE ManejoErrores;
    END IF;


    IF(Par_MesesConsPago < Entero_Cero) THEN
        SET Par_NumErr  := 48;
        SET Par_ErrMen  := 'El Numero de meses debe ser Mayor o Igual a Cero';
        SET varControl  := 'mesesConsPago' ;
        LEAVE ManejoErrores;
    END IF;




    SET Aud_FechaActual := NOW();
     UPDATE PARAMETROSCAJA SET
                    CtaProtecCre        = Par_CtaProtecCre,
                    CtaProtecCta        = Par_CtaProtecCta,
                    HaberExSocios       = Par_HaberExSocios,
                    CtaContaPROFUN      = Par_CtaContaPROFUN,
                    TipoCtaProtec       = Par_TipoCtaProtec,
                    MontoMaxProtec      = Par_MontoMaxProtec,
                    MontoPROFUN         = Par_MontoPROFUN,
                    AporteMaxPROFUN     = Par_AporteMaxPROFUN,

                    MontoApoyoSRVFUN    = Par_MontoApoyoSRVFUN,
                    MonApoFamSRVFUN     = Par_MonApoFamSRVFUN,
                    PerfilAutoriProtec  = Par_PerfilAutoriProtec,
                    PerfilAutoriSRVFUN  = Par_PerfilAutoriSRVFUN,
                    EdadMaximaSRVFUN    = Par_EdadMaximaSRVFUN,
                    TiempoMinimoSRVFUN  = Par_TiempoMinimoSRVFUN,
                    MesesValAhoSRVFUN   = Par_MesesValAhoSRVFUN,
                    SaldoMinMesSRVFUN   = Par_SaldoMinMesSRVFUN,
                    CtaContaSRVFUN      = Par_CtaContaSRVFUN,
                    RolAutoApoyoEsc     = Par_RolAutoApoyoEsc,
                    TipoCtaApoyoEscMay  = Par_TipoCtaApoyoEscMay,
                    TipoCtaApoyoEscMen  = Par_TipoCtaApoyoEscMen,
                    MesInicioAhoCons    = Par_MesInicioAhoCons,
                    MontoMinMesApoyoEsc = Par_MontoMinMesApoyoEsc,
                    CtaContaApoyoEsc    = Par_CtaContaApoyoEsc,
                    CompromisoAhorro    = Par_CompromisoAho,
                    MaxAtraPagPROFUN    = Par_MaxAtraPagPROFUN,
                    PerfilCancelPROFUN  = Par_PerfilCancelPROFUN,

                    PorcentajeCob       = Par_PorcentajeCob,
                    CoberturaMin        = Par_CoberturaMin,
                    CtaOrdinaria        = Par_CtaOrdinaria,
                    CCHaberesEx         = Par_CCHaberesEx,
                    CCProtecAhorro      = Par_CCProtecAhorro,
                    CCServifun          = Par_CCServifun,
                    CCApoyoEscolar      = Par_CCApoyoEscolar,
                    CCContaPerdida      = Par_CCContaPerdida,

                    TipoCtaBeneCancel   = Par_TipoCtaBeneCancel,
                    CuentaVista         = Par_CuentaVista,
                    CtaContaPerdida     = Par_CtaContaPerdida,
                    EjecutivoFR         = Par_EjecutivoFR,
                    TipoCtaProtecMen    = Par_TipoCtaProtecMen,
                    EdadMinimaCliMen    = Par_EdadMinimaCliMen,
                    EdadMaximaCliMen    = Par_EdadMaximaCliMen,
                    GastosRural         = Par_GastosRural,
                    GastosUrbana        = Par_GastosUrbana,

                    GastosPasivos       = Par_GastosPasivos,
                    PuntajeMinimo       = Par_PuntajeMinimo,
                    IdGastoAlimenta     = Par_IdGastoAlimenta,
                    VersionWS           = Par_VersionWS,
                    RolCancelaCheque    = Par_RolCancelaCheq,
                    CodCooperativa      = Par_CodCooperativa,
                    CodMoneda           = Par_CodMoneda,
                    CodUsuario          = Par_CodUsuario,
                    PermiteAdicional    = Par_PermiteAdicional,

                    TipoProdCap         = Par_TipoProdCap,
                    AntigueSocio        = Par_AntigueSocio,
                    MontoAhoMes         = Par_MontoAhoMes,
                    ImpMinParSoc        = Par_ImpMinParSoc,
                    MesesEvalAho        = Par_MesesEvalAho,
                    ValidaCredAtras     = Par_ValidaCredAtras,
                    ValidaGaranLiq      = Par_ValidaGaranLiq,

                    MesesConsPago       = Par_MesesConsPago,
                    montoMaxActCom		= Par_montoMaxActCom,
                    montoMinActCom		= Par_montoMinActCom,

                    Usuario             = Aud_Usuario,
                    FechaActual         = Aud_FechaActual,
                    DireccionIP         = Aud_DireccionIP,
                    ProgramaID          = Aud_ProgramaID,
                    Sucursal            = Aud_Sucursal,
                    NumTransaccion      = Aud_NumTransaccion
        WHERE EmpresaID = Par_EmpresaID;

    SET Par_NumErr  := 0;
    SET Par_ErrMen  := 'Parametros de Caja Modificados Exitosamente';
    SET varControl  := 'empresaID' ;
    LEAVE ManejoErrores;


END ManejoErrores;



    IF (Par_Salida = Salida_SI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen       AS ErrMen,
                varControl       AS control,
                Par_EmpresaID    AS consecutivo;
    END IF;

END TerminaStore$$