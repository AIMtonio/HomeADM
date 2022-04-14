-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEATARJETACREDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEATARJETACREDALT`;DELIMITER $$

CREATE PROCEDURE `LINEATARJETACREDALT`(
-- SP PARA EL ALTA DE LINEA DE CREDITO
    Par_ClienteID           INT(11),            -- Cliente
    Par_TarjetaCredID       CHAR(16),           -- tarjeta de credito
    Par_NombreUsuario       VARCHAR(250),       -- Nombre del usuario
    Par_TipoTarjetaCred     INT(11),            -- Tipo de tarjeta
    Par_TipoCorte           CHAR(1),            -- Tipo de corte
    Par_DiaCorte            INT(11),            -- Dia de corte

    Par_TipoPago            CHAR(1),            -- Tipo de pago
    Par_DiaPago             INT(11),            -- Dia de pago
    Par_Relacion            CHAR(1),
    Par_CuentaClabe         CHAR(18),           -- Cuenta Clabe

    Par_Salida              CHAR(1),            -- Salida
    OUT Par_NumErr          INT,                -- Salida
    OUT Par_ErrMen          VARCHAR(200),       -- Salida

    Aud_EmpresaID           INT(11),            -- Auditoria
    Aud_Usuario             INT,                -- Auditoria
    Aud_FechaActual         DATETIME,           -- Auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Auditoria
    Aud_ProgramaID          VARCHAR(50),        -- Auditoria
    Aud_Sucursal            INT,                -- Auditoria
    Aud_NumTransaccion      BIGINT              -- Auditoria
    )
TerminaStore: BEGIN
    -- VARIABLES
    DECLARE Var_Control             VARCHAR(100);
    DECLARE Var_TasaFija            DECIMAL(8,4);  -- Tasa Fija
    DECLARE Var_CobraMora           CHAR(1);       -- Cobra mora
    DECLARE Var_TipoCobMora         CHAR(1);       -- Tipo de combra mora porsentaje o fija
    DECLARE Var_FactorMora          DECIMAL(8,4);  -- Moonto de cobra mora
    DECLARE Var_MontoLinea          DECIMAL(16,2); -- Monto de la linea
    DECLARE Var_TipoPagMin          CHAR(1);       -- Tipo de pago minimo
    DECLARE Var_FactorPagMin        DECIMAL(8,4);  -- Monto del pago minimo
    DECLARE Var_ProductoCredID      INT(11);       -- Producto de credito
    DECLARE Var_LineaTarCredID      INT;           -- Linea de credito
    DECLARE Var_FechaSistema        DATETIME;      -- Fecha del sistena
    DECLARE Var_Tipotarjeta         INT(11);       -- Tipo de tarjeta
    DECLARE Var_DesTipoTar          VARCHAR(15);   -- descripcion de tipo de tarjeta
    DECLARE Var_CobraFaltaPago      CHAR(1);       -- Cobra por falta d epago
    DECLARE Var_TipCobComFalPago    CHAR(1);       -- Tipo de cobro por falta de pago
    DECLARE Var_FactorFaltaPago     DOUBLE(12,4);  -- Monto por falta de pago
    DECLARE Var_CobComisionAper     CHAR(1);       -- Cobra comision por apertura
    DECLARE Var_TipoCobComAper      CHAR(1);       -- Tipo de cobro por coision por apertura
    DECLARE Var_FacComisionAper     DOUBLE(12,4);  -- Monto por comision por apertura
    DECLARE Var_EstatusTarCred      INT(1);        -- Estatus de la tarjeta


    -- DECLARACION DE CONSTANTES
    DECLARE Entero_Cero        INT;
    DECLARE Decimal_Cero       DECIMAL(2,2);
    DECLARE Cadena_Vacia       CHAR(1);
    DECLARE Fecha_Vacia        DATE;
    DECLARE SalidaSI           CHAR(1);
    DECLARE SalidaNO           CHAR(1);
    DECLARE Tar_Registrada     CHAR(1);          -- ESTATUS DE TARJETA REGISTRADA
    DECLARE EstatusAsig        INT(1);           -- ESTATUS ASIGANCION A LINEA DE CREDITO
    DECLARE EstatusAct         INT(1);           -- ESTATUS ACTIVA
    DECLARE MotivoAsig         INT(1);           -- Motivo de acuerda a la tabla CATALCANBLOQTAR
    DECLARE DescripAdiStatus   VARCHAR(17);      -- DESCRIPCION DEL MOTIVO DE ASIGNACION



    SET Entero_Cero     := 0;
    SET Decimal_Cero    := '0.00';
    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET SalidaSI        := 'S';
    SET SalidaNO        := 'N';
    SET Tar_Registrada  := 'R';
    SET EstatusAsig     :=  6;
    SET EstatusAct      :=  7;
    SET MotivoAsig      :=  1;
    SET DescripAdiStatus:= 'Asiganda/Cliente';



ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
                              concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-LINEATARJETACREDALT');
            SET Var_Control = 'SQLEXCEPTION';
        END;



    SET Aud_FechaActual := CURRENT_TIMESTAMP();
    SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_TipoPagMin :='P';
    SET Var_Tipotarjeta:=(SELECT IFNULL(TipoTarjetaDeb,Entero_Cero) FROM LINEATARJETACRED WHERE TipoTarjetaDeb=Par_TipoTarjetaCred AND ClienteID=Par_ClienteID LIMIT 1);
    SET Var_EstatusTarCred :=(SELECT IFNULL(Estatus, Entero_Cero)  FROM TARJETACREDITO WHERE TipoTarjetaCredID=Par_TipoTarjetaCred AND ClienteID=Par_ClienteID AND (Estatus=EstatusAct OR Estatus=EstatusAsig) ORDER BY Estatus=EstatusAct LIMIT 1);
    SET Var_DesTipoTar :=(SELECT IFNULL(Descripcion,Cadena_Vacia) FROM TIPOTARJETADEB WHERE TipoTarjetaDebID = Par_TipoTarjetaCred);

    SELECT CobraFaltaPago,     TipCobComFalPago,     FactorFaltaPago,     CobComisionAper,     TipoCobComAper,     FacComisionAper
      INTO Var_CobraFaltaPago, Var_TipCobComFalPago, Var_FactorFaltaPago, Var_CobComisionAper, Var_TipoCobComAper, Var_FacComisionAper
      FROM TIPOTARJETADEB
     WHERE TipoTarjetaDebID=Par_TipoTarjetaCred;

    IF( Var_Tipotarjeta = Par_TipoTarjetaCred AND Var_EstatusTarCred=EstatusAct) THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  := CONCAT('El cliente ya cuenta con una tarjeta de tipo ',Var_DesTipoTar, ' Activa');
        SET Var_Control := 'tipotarjeta';
        LEAVE ManejoErrores;
    END IF;
     IF( Var_Tipotarjeta = Par_TipoTarjetaCred AND Var_EstatusTarCred=EstatusAsig) THEN
        SET Par_NumErr  := 2;
        SET Par_ErrMen  := CONCAT('El cliente ya cuenta con una tarjeta de tipo ',Var_DesTipoTar, ' Sin Activar');
        SET Var_Control := 'tipotarjeta';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := 3;
        SET Par_ErrMen  := 'El cliente esta vacio';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_TipoTarjetaCred, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := 4;
        SET Par_ErrMen  := 'Tipo de tarjeta esta vacio';
        SET Var_Control := 'TipoTarjetaID';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_Relacion, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 5;
        SET Par_ErrMen  := 'La relacion de la tarjeta esta vacia';
        SET Var_Control := 'Relacion';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_TipoCorte, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 6;
        SET Par_ErrMen  := 'La Fecha de corte esta vacia';
        SET Var_Control := 'tipoCorte';
        LEAVE ManejoErrores;
    END IF;


    IF(Par_TipoCorte ='D') THEN
        IF(IFNULL(Par_DiaCorte, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 7;
            SET Par_ErrMen  := 'El dia de corte esta vacio';
            SET Var_Control := 'diaCorte';
            LEAVE ManejoErrores;
        END IF;

    END IF;

    IF(IFNULL(Par_TipoPago, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 8;
        SET Par_ErrMen  := 'La Fecha de pago esta vacia';
        SET Var_Control := 'tipoPago';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_TipoPago ='D') THEN
        IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 9;
            SET Par_ErrMen  := 'El dia de pago esta vacio';
            SET Var_Control := 'diaPago';
            LEAVE ManejoErrores;
        END IF;

    END IF;




    SET Var_TasaFija :=(SELECT IFNULL(TasaFija,Decimal_Cero) FROM TIPOTARJETADEB WHERE TipoTarjetaDebID = Par_TipoTarjetaCred);
    SET Var_CobraMora :=(SELECT IFNULL(CobraMora,Cadena_Vacia) FROM TIPOTARJETADEB WHERE TipoTarjetaDebID = Par_TipoTarjetaCred);
    SET Var_TipoCobMora :=(SELECT IFNULL(TipCobComMorato,Cadena_Vacia) FROM TIPOTARJETADEB WHERE TipoTarjetaDebID = Par_TipoTarjetaCred);
    SET Var_FactorMora :=(SELECT IFNULL(FactorMora,Decimal_Cero) FROM TIPOTARJETADEB WHERE TipoTarjetaDebID = Par_TipoTarjetaCred);
    SET Var_MontoLinea :=(SELECT IFNULL(MontoCredito,Decimal_Cero) FROM TIPOTARJETADEB WHERE TipoTarjetaDebID = Par_TipoTarjetaCred);

    IF(Var_TipoPagMin='P')THEN
        SET Var_FactorPagMin :=(SELECT IFNULL(PorcPagoMin,Decimal_Cero) FROM TIPOTARJETADEB WHERE TipoTarjetaDebID = Par_TipoTarjetaCred);
    END IF;


  SET Par_CuentaClabe := IFNULL(Par_CuentaClabe,Cadena_Vacia);
  SET Var_ProductoCredID :=(SELECT ProductoCredito FROM TIPOTARJETADEB WHERE TipoTarjetaDebID = Par_TipoTarjetaCred);
  SET Var_LineaTarCredID := (SELECT MAX(LineaTarCredID) FROM LINEATARJETACRED);
  SET Var_LineaTarCredID := IFNULL(Var_LineaTarCredID,Entero_Cero) + 1;

  UPDATE FOLIOSAPLIC SET FolioID=Var_LineaTarCredID WHERE Tabla='LINEATARJETACRED';


  INSERT INTO LINEATARJETACRED (LineaTarCredID,         ClienteID,             MontoLinea,              MontoDisponible,            MontoBloqueado,
                                SaldoAFavor,            SaldoCapVigente,       SaldoCapVencido,         SaldoInteres,               SaldoIVAInteres,
                                SaldoMoratorios,        SaldoIVAMoratorios,    SalComFaltaPag,          SalIVAComFaltaPag,          SalOrtrasComis,
                                SalIVAOrtrasComis,      MontoBaseCal,          SaldoCorte,              PagoNoGenInteres,           PagoMinimo,
                                SaldoInicial,           ComprasPeriodo,        RetirosPeriodo,          PagosPeriodo,               CAT,
                                TipoTarjetaDeb,         ProductoCredID,        TasaFija,                TipoCorte,                  DiaCorte,
                                TipoPago,               DiaPago,               CobraMora,               TipoCobMora,                FactorMora,
                                TipoPagMin,             FactorPagMin,          Estatus,                 FechaRegistro,              FechaActivacion,
                                FechaCancelacion,       CuentaClabe,           CobraFaltaPago,          TipCobComFalPago,           FactorFaltaPago,
                                CobComisionAper,        TipoCobComAper,        FacComisionAper,         TarjetaPrincipal,           SucursalID,
                                EmpresaID,              Usuario,               FechaActual,             DireccionIP,                ProgramaID,
                                Sucursal,               NumTransaccion
                                )
                          VALUES(Var_LineaTarCredID,    Par_ClienteID,         Var_MontoLinea,          Var_MontoLinea,             Decimal_Cero,
                                 Decimal_Cero,          Decimal_Cero,          Decimal_Cero,            Decimal_Cero,               Decimal_Cero,
                                 Decimal_Cero,          Decimal_Cero,          Decimal_Cero,            Decimal_Cero,               Decimal_Cero,
                                 Decimal_Cero,          Decimal_Cero,          Decimal_Cero,            Decimal_Cero,               Decimal_Cero,
                                 Decimal_Cero,          Decimal_Cero,          Decimal_Cero,            Decimal_Cero,               Decimal_Cero,
                                 Par_TipoTarjetaCred,   Var_ProductoCredID,    Var_TasaFija,            Par_TipoCorte,              Par_DiaCorte,
                                 Par_TipoPago,          Par_DiaPago,           Var_CobraMora,           Var_TipoCobMora,            Var_FactorMora,
                                 Var_TipoPagMin,        Var_FactorPagMin,      Tar_Registrada,          Var_FechaSistema,           Fecha_Vacia,
                                 Fecha_Vacia,           Par_CuentaClabe,       Var_CobraFaltaPago,      Var_TipCobComFalPago,       Var_FactorFaltaPago,
                                 Var_CobComisionAper,   Var_TipoCobComAper,    Var_FacComisionAper,     Par_TarjetaCredID,          Aud_Sucursal,
                                 Aud_EmpresaID,         Aud_Usuario,           Aud_FechaActual,         Aud_DireccionIP,            Aud_ProgramaID,
                                 Aud_Sucursal,          Aud_NumTransaccion
                                 );

    CALL ASOCIATARCREDPRO(Par_TarjetaCredID,     Par_ClienteID,         Par_NombreUsuario,          Var_LineaTarCredID,         EstatusAsig,
                          Par_Relacion,          Par_CuentaClabe,       SalidaSI,                   Par_NumErr,                 Par_ErrMen,
                          Aud_EmpresaID,         Aud_Usuario,           Aud_FechaActual,            Aud_DireccionIP,            Aud_ProgramaID,
                          Aud_Sucursal,          Aud_NumTransaccion);

    IF Par_NumErr <> Entero_Cero THEN
        LEAVE ManejoErrores;
    END IF;

    CALL TC_BITACORAALT(Par_TarjetaCredID,      EstatusAsig,        MotivoAsig,         DescripAdiStatus,   Var_FechaSistema,
                        Par_NombreUsuario,      SalidaSI,           Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,
                        Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                        Aud_NumTransaccion);

    IF Par_NumErr <> Entero_Cero THEN
        LEAVE ManejoErrores;
    END IF;


SET Par_NumErr  := 000;
SET Par_ErrMen  := CONCAT('Tarjeta de Credito Asociada Exitosamente: ', Par_TarjetaCredID);
SET Var_Control := 'clienteID';

END ManejoErrores;
 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$