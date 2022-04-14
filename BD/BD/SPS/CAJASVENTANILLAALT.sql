-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASVENTANILLAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASVENTANILLAALT`;DELIMITER $$

CREATE PROCEDURE `CAJASVENTANILLAALT`(

    Par_TipoCaja         CHAR(2),
    Par_UsuarioID        INT,
    Par_DescripCaja      VARCHAR(50),
    Par_SucursalID       INT,
    Par_LimiteEfec       DECIMAL(14,2),

    Par_LimiteDes        DECIMAL(14,2),
    Par_MaxRetiro        DECIMAL(14,2),
    Par_NomImpresora     VARCHAR(30),
    Par_NomImpresoraCheq VARCHAR(30),
    Par_HuellaDigital    CHAR(1),

    Par_Salida           CHAR(1),
    INOUT Par_NumErr     INT,
    INOUT Par_ErrMen     VARCHAR(400),
    Aud_EmpresaID        INT,
    Aud_Usuario          INT,

    Aud_FechaActual      DATETIME,
    Aud_DireccionIP      VARCHAR(15),
    Aud_ProgramaID       VARCHAR(50),
    Aud_Sucursal         INT,
    Aud_NumTransaccion   BIGINT
    )
TerminaStore: BEGIN


    DECLARE Var_SucUsuario      INT;
    DECLARE Var_UsuEstatus      CHAR(1);
    DECLARE Var_EstatusCaja     CHAR(1);
    DECLARE Var_CajaID          INT;
    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Consecutivo     VARCHAR(20);


    DECLARE  Entero_Cero        INT;
    DECLARE Decimal_Cero        DECIMAL;
    DECLARE  SalidaSI           CHAR(1);
    DECLARE  SalidaNO           CHAR(1);
    DECLARE  Cadena_Vacia       CHAR(1);
    DECLARE  EstatusActivo      CHAR(1);

    DECLARE EstatusOperaA       CHAR(1);
    DECLARE EstatusOperaC       CHAR(1);
    DECLARE  EstatusCaja        CHAR(1);
    DECLARE  TipoCajaBG         CHAR(2);
    DECLARE EjeProceso          CHAR(1);


    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.0;
    SET SalidaSI        := 'S';
    SET SalidaNO        := 'N';
    SET Cadena_Vacia    := '';
    SET EstatusActivo   := 'A';
    SET EstatusOperaA   := 'A';
    SET EstatusOperaC   := 'C';
    SET EstatusCaja     := 'A';
    SET TipoCajaBG      := 'BG';
    SET EjeProceso      := 'N';
    SET Var_Consecutivo := Cadena_Vacia;


    IF Par_TipoCaja = TipoCajaBG THEN
        SET Var_EstatusCaja :=EstatusOperaA;
    ELSE
        SET Var_EstatusCaja :=EstatusOperaC;
    END IF;

    SET Par_UsuarioID = IFNULL(Par_UsuarioID, Entero_Cero);

    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-CAJAVENTANILLAACT');
            SET Var_Control := 'sqlException' ;
        END;

        IF((EXISTS(SELECT UsuarioID, CajaID FROM CAJASVENTANILLA
                        WHERE UsuarioID = Par_UsuarioID)) AND (Par_UsuarioID != 0) ) THEN

            SET Var_CajaID := (SELECT CajaID FROM CAJASVENTANILLA WHERE UsuarioID = Par_UsuarioID);
            SET Par_NumErr := 001;
            SET Par_ErrMen := CONCAT('El Usuario Seleccionado ya esta Asignado a la Caja: ', Var_CajaID );
            SET Var_Control := 'usuarioID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TipoCaja, Cadena_Vacia))= Cadena_Vacia THEN

            SET Par_NumErr := 002;
            SET Par_ErrMen := CONCAT('No Selecciono Tipo de Caja.');
            SET Var_Control := 'tipoCaja' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 003;
            SET Par_ErrMen := CONCAT('La Sucursal Esta Vacia.');
            SET Var_Control := 'sucursalID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_LimiteEfec, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 004;
            SET Par_ErrMen := CONCAT('El Limite de Efectivo esta Vacio.');
            SET Var_Control := 'limiteEfectivoMN' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_LimiteDes, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 005;
            SET Par_ErrMen := CONCAT('El Limite por Desembolso esta Vacio.');
            SET Var_Control := 'limiteEfectivoMN' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MaxRetiro, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 006;
            SET Par_ErrMen := CONCAT('El Máximo de Retiro esta Vacio.');
            SET Var_Control := 'limiteEfectivoMN' ;
            LEAVE ManejoErrores;
        END IF;

        SELECT  SucursalUsuario, Estatus INTO Var_SucUsuario, Var_UsuEstatus
            FROM USUARIOS
                WHERE UsuarioID = Par_UsuarioID;

        SET Var_SucUsuario  := IFNULL(Var_SucUsuario, Entero_Cero);
        SET Var_UsuEstatus  := IFNULL(Var_UsuEstatus, Cadena_Vacia);

        IF (Var_UsuEstatus != EstatusActivo) THEN
            SET Par_NumErr := 008;
            SET Par_ErrMen := CONCAT('El Usuario no se encuentra Activo.');
            SET Var_Control := 'usuarioID' ;
            LEAVE ManejoErrores;
        END IF;

        IF (Var_SucUsuario != Par_SucursalID) THEN
            SET Par_NumErr := 008;
            SET Par_ErrMen := CONCAT('El Usuario debe pertenecer a la misma Sucursal de la Caja.');
            SET Var_Control := 'usuarioID' ;
            LEAVE ManejoErrores;
        END IF;

        IF ( IFNULL(Par_NomImpresora,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 008;
            SET Par_ErrMen := CONCAT('El Nombre de Impresora esta vacio.');
            SET Var_Control := 'usuarioID' ;
            LEAVE ManejoErrores;
        END IF;

        SET Var_CajaID := (SELECT IFNULL(MAX(CajaID),Entero_Cero)+ 1 FROM CAJASVENTANILLA);
        SET Aud_FechaActual := NOW();

        INSERT INTO CAJASVENTANILLA(
            SucursalID,     CajaID,         TipoCaja,       UsuarioID,              DescripcionCaja,
            Estatus,        EstatusOpera,   SaldoEfecMN,    SaldoEfecME,            LimiteEfectivoMN,
            LimiteDesemMN,  MaximoRetiroMN, NomImpresora,   NomImpresoraCheq,       HuellaDigital,
            EjecutaProceso, EmpresaID,      Usuario,        FechaActual,            DireccionIP,
            ProgramaID,     Sucursal,       NumTransaccion
        )VALUES(
            Par_SucursalID, Var_CajaID,         Par_TipoCaja,       Par_UsuarioID,          Par_DescripCaja,
            EstatusActivo,  Var_EstatusCaja,    Decimal_Cero,       Decimal_Cero,           Par_LimiteEfec,
            Par_LimiteDes,  Par_MaxRetiro,      Par_NomImpresora,   Par_NomImpresoraCheq,   Par_HuellaDigital,
            EjeProceso,     Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
            Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion
        );
        SET Par_NumErr      := 000;
        SET Par_ErrMen      := CONCAT("Caja Registrada Exitosamente, No: ",Var_CajaID, " No Olvide Parametrizar la Guia Contable Para Esta Caja");
        SET Var_Control     := 'cajaID' ;
        SET Var_Consecutivo := Var_CajaID;
    END ManejoErrores;

    IF(Par_Salida = SalidaSI)THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$