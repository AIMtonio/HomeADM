-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLIZASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPOLIZASALT`;
DELIMITER $$


CREATE PROCEDURE `DETALLEPOLIZASALT`(
/* STORE PARA LA REALIZAR LOS DETALLES DE UN APOLIZA */
    Par_Empresa             INT,
    Par_Poliza              BIGINT(20),
    Par_Fecha               DATE,
    Par_CenCosto            INT,
    Par_Cuenta              VARCHAR(50),

    Par_Instrumento         VARCHAR(20),
    Par_Moneda              INT (11),
    Par_Cargos              DECIMAL(14,4),
    Par_Abonos              DECIMAL(14,4),
    Par_Descripcion         VARCHAR(150),

    Par_Referencia          VARCHAR(200),
    Par_Procedimiento       VARCHAR(30),
    Par_TipoInstrumentoID   INT(11),
    Par_RFC                 CHAR(13),
    Par_TotalFact           DECIMAL(13,2),
    Par_FolioUUID           VARCHAR(100),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),

    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT(20)

    )
TerminaStore: BEGIN

    /* DECLARACION DE CONSTANTES*/
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INT;
    DECLARE Decimal_Cero    DECIMAL(12,2);
    DECLARE Cuenta_Vacia    CHAR(25);
    DECLARE Salida_SI       CHAR(1);
    DECLARE Salida_NO       CHAR(1);
    DECLARE Fecha_Vacia     DATE;

    /* DECLARACION DE VARIABLES*/
    DECLARE VarCuenta       VARCHAR(50);
    DECLARE Var_Control     VARCHAR(100);
    DECLARE Var_FechaSis    DATE;


    /* ASIGNACION DE CONSTANTES*/
    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET Cuenta_Vacia        := '0000000000000000000000000';
    SET Salida_SI           := 'S';
    SET Salida_NO           := 'N';
    SET Fecha_Vacia         := '1900-01-01';

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  := 999;
                SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-DETALLEPOLIZASALT');
                SET Var_Control := 'sqlException';
            END;

        SET Par_Poliza          := IFNULL(Par_Poliza, Entero_Cero);
        SET Par_Fecha           := IFNULL(Par_Fecha, Fecha_Vacia);
        SET Par_CenCosto        := IFNULL(Par_CenCosto, Entero_Cero);
        SET Par_Cuenta          := IFNULL(Par_Cuenta, Cadena_Vacia);
        SET Par_Instrumento     := IFNULL(Par_Instrumento, Cadena_Vacia);

        SET Par_Moneda          := IFNULL(Par_Moneda, Entero_Cero);
        SET Par_Cargos          := IFNULL(Par_Cargos, Decimal_Cero);
        SET Par_Abonos          := IFNULL(Par_Abonos, Decimal_Cero);
        SET Par_Descripcion     := IFNULL(Par_Descripcion, Cadena_Vacia);
        SET Par_Referencia      := IFNULL(Par_Referencia, Cadena_Vacia);

        SET Par_Procedimiento   := IFNULL(Par_Procedimiento, Cadena_Vacia);
        SET Par_TipoInstrumentoID := IFNULL(Par_TipoInstrumentoID, Entero_Cero);
        SET Par_RFC             := IFNULL(Par_RFC, Cadena_Vacia);
        SET Par_TotalFact       := IFNULL(Par_TotalFact, Decimal_Cero);
        SET Par_FolioUUID       := IFNULL(Par_FolioUUID, Cadena_Vacia);

        SET Aud_FechaActual := CURRENT_TIMESTAMP();
        SELECT FechaSistema INTO Var_FechaSis
        FROM PARAMETROSSIS;

        IF(IFNULL( Aud_Usuario, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 001;
            SET Par_ErrMen  := 'El Usuario no esta logeado';
            SET Var_Control := 'inversionID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL( Par_Poliza, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 002;
            SET Par_ErrMen  := 'El Numero de Poliza Esta Vacio';
            SET Var_Control := 'polizaID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL( Par_Fecha, Fecha_Vacia)) = Fecha_Vacia THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'La Fecha del detalle de poliza no puede ser vacio.';
            SET Var_Control := 'fecha' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL( Par_TipoInstrumentoID, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := 'El tipo de instrumento esta vacio.';
            SET Var_Control := 'fecha' ;
            LEAVE ManejoErrores;
        END IF;

        SET VarCuenta := (SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_Cuenta);


        IF EXISTS(SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta=Par_Cuenta)  THEN

            INSERT INTO DETALLEPOLIZA (
                            EmpresaID,              PolizaID,           Fecha,              CentroCostoID,          CuentaCompleta,
                            Instrumento,            MonedaID,           Cargos,             Abonos,                 Descripcion,
                            Referencia,             ProcedimientoCont,  TipoInstrumentoID,  RFC,                    TotalFactura,
                            FolioUUID,              Usuario,            FechaActual,        DireccionIP,            ProgramaID,
                            Sucursal,               NumTransaccion)
                    VALUES(
                            Par_Empresa,            Par_Poliza,         Par_Fecha,              Par_CenCosto,       Par_Cuenta,
                            Par_Instrumento,        Par_Moneda,         Par_Cargos,             Par_Abonos,         Par_Descripcion,
                            Par_Referencia,         Par_Procedimiento,  Par_TipoInstrumentoID,  Par_RFC,            Par_TotalFact,
                            Par_FolioUUID,          Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_Fecha < Var_FechaSis) THEN
                CALL SALDOSDETALLEPOLIZAACT(Par_Fecha,       Par_CenCosto,      Par_Cuenta,       Par_Cargos,        Par_Abonos,
                                            Par_Salida,      Par_NumErr,        Par_ErrMen,       Par_Empresa,       Aud_Usuario,
                                            Aud_FechaActual, Aud_DireccionIP,   Aud_ProgramaID,	  Aud_Sucursal,	     Aud_NumTransaccion);

                IF (Par_NumErr <> Entero_Cero)THEN
                    LEAVE ManejoErrores;
                END IF;

            END IF;

        ELSE

            INSERT INTO DETALLEPOLIZA (
                            EmpresaID,              PolizaID,           Fecha,              CentroCostoID,          CuentaCompleta,
                            Instrumento,            MonedaID,           Cargos,             Abonos,                 Descripcion,
                            Referencia,             ProcedimientoCont,  TipoInstrumentoID,  RFC,                    TotalFactura,
                            FolioUUID,              Usuario,            FechaActual,        DireccionIP,            ProgramaID,
                            Sucursal,               NumTransaccion)
                    VALUES(
                            Par_Empresa,            Par_Poliza,         Par_Fecha,              Par_CenCosto,       Cuenta_Vacia,
                            Par_Instrumento,        Par_Moneda,         Par_Cargos,             Par_Abonos,         Par_Descripcion,
                            Par_Cuenta,             Par_Procedimiento,  Par_TipoInstrumentoID,  Par_RFC,            Par_TotalFact,
                            Par_FolioUUID,          Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,           Aud_NumTransaccion);


            IF(Par_Fecha < Var_FechaSis) THEN
                CALL SALDOSDETALLEPOLIZAACT(Par_Fecha,       Par_CenCosto,      Cuenta_Vacia,     Par_Cargos,        Par_Abonos,
                                            Par_Salida,      Par_NumErr,        Par_ErrMen,       Par_Empresa,       Aud_Usuario,
                                            Aud_FechaActual, Aud_DireccionIP,   Aud_ProgramaID,	  Aud_Sucursal,	     Aud_NumTransaccion);

                IF (Par_NumErr <> Entero_Cero)THEN
                    LEAVE ManejoErrores;
                END IF;
            END IF;
        END IF;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT("Detalle Poliza Agregada: ", CONVERT(Par_Poliza, CHAR));
        SET Var_Control := 'polizaID';

    END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            SELECT  Par_NumErr  AS NumErr,
                    Par_ErrMen  AS ErrMen,
                    Var_Control AS control,
                    Par_Poliza  AS consecutivo;
        END IF;

END TerminaStore$$