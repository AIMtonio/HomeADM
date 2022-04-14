-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONSOCIOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONSOCIOPRO`;DELIMITER $$

CREATE PROCEDURE `APORTACIONSOCIOPRO`(

    Par_ClienteID           BIGINT,
    Par_NumeroMov           BIGINT,
    Par_CantidadMov         DECIMAL(12,2),
    Par_MonedaID            INT,

    Par_AltaEncPoliza       CHAR(1),
    Par_SucursalID          INT(2),
    INOUT Par_Poliza        BIGINT,
    Par_AltaDetPol          CHAR(1),
    Par_CajaID              INT(11),
    Par_UsuarioID           INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(3),
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN


DECLARE Var_FechaOper        DATE;
DECLARE Var_FechaApl        DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE Var_SucCliente      INT(5);
DECLARE Var_ReferDetPol     VARCHAR(11);
DECLARE Var_MontoAportacion DECIMAL(14,2);
DECLARE Var_Saldo           DECIMAL(14,2);
DECLARE Var_TotalSaldo      DECIMAL(14,2);
DECLARE Var_EsMEnorEdad     CHAR(1);
DECLARE Var_EstatusCli      CHAR(1);
DECLARE Var_NumErr          INT(11);

DECLARE ConContaAportSocio  INT(11);
DECLARE ConceptosCaja       INT(11);
DECLARE NatAbono            CHAR(1);
DECLARE SalidaNO            CHAR(1);
DECLARE SalidaSI            CHAR(1);
DECLARE descrpcionMov       VARCHAR(100);
DECLARE Entero_Cero         INT(1);
DECLARE TipoAportacion      CHAR(1);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Decimal_Cero        DECIMAL;
DECLARE Si                  CHAR(1);
DECLARE TipoInstrumentoID   INT(11);
DECLARE Inactivo            CHAR(1);


SET ConContaAportSocio  := 400;
SET ConceptosCaja       :=1;
SET NatAbono            :='A';
SET SalidaNO            :='N';
SET SalidaSI            :='S';
SET descrpcionMov       :='DEPOSITO APORTACION SOCIAL';
SET Entero_Cero         :=0;
SET TipoAportacion      :='A';
SET Cadena_Vacia        :='';
SET Decimal_Cero        :=0.00;
SET Si                  :='S';
SET TipoInstrumentoID   :=4;
SET Inactivo            :='I';

SET Var_NumErr          :=0;
ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                 'esto le ocasiona. Ref: SP-APORTACIONSOCIOPRO');
        END;


    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := Cadena_Vacia;
    SET Aud_FechaActual := NOW();
    SET Var_FechaOper   := (SELECT FechaSistema
                                FROM PARAMETROSSIS);


    CALL DIASFESTIVOSCAL(
    Var_FechaOper,  Entero_Cero,            Var_FechaApl,       Var_EsHabil,        Par_EmpresaID,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
        Aud_NumTransaccion);


    SELECT  Cli.SucursalOrigen,Cli.EsMenorEdad  INTO Var_SucCliente, Var_EsMEnorEdad
        FROM  CLIENTES Cli
        WHERE Cli.ClienteID   = Par_ClienteID;

    SELECT MontoAportacion INTO Var_MontoAportacion
            FROM PARAMETROSSIS;
    SELECT Saldo INTO Var_Saldo
        FROM APORTACIONSOCIO
            WHERE ClienteID=Par_ClienteID;

    SET Var_MontoAportacion :=IFNULL(Var_MontoAportacion,Decimal_Cero);
    SET Var_Saldo           :=IFNULL(Var_Saldo,Decimal_Cero);
    SET Var_EsMEnorEdad     :=IFNULL(Var_EsMEnorEdad,Cadena_Vacia);

    SET Var_TotalSaldo:=Var_Saldo+Par_CantidadMov;

    SELECT Estatus INTO Var_EstatusCli
        FROM CLIENTES
            WHERE ClienteID=Par_ClienteID;
    IF (Var_EstatusCli = Inactivo)THEN
        SET Par_NumErr := 1;
        SET Par_ErrMen := 'El Cliente indicado se encuentra Inactivo';
        LEAVE ManejoErrores;
    END IF;

    IF (Var_TotalSaldo > Var_MontoAportacion)THEN
        SET Par_NumErr := 1;
        SET Par_ErrMen := 'El monto del deposito excede el monto de aportacion solicitado';
        LEAVE ManejoErrores;
    END IF;
    IF(Var_EsMEnorEdad = Si)THEN
        SET Par_NumErr := 2;
        SET Par_ErrMen := 'La persona es un Socio Menor. No es necesario Aportacion Social ';
        LEAVE ManejoErrores;
    END IF;




    CALL APORTASOCIOMOVALT(
            Par_ClienteID,  Par_CantidadMov,TipoAportacion, Par_SucursalID, Par_CajaID,
            Var_FechaOper,  Par_UsuarioID,  descrpcionMov,  Par_NumeroMov,  Par_MonedaID,
            SalidaNO,       Par_NumErr,     Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


        SET Var_ReferDetPol     := CONVERT(Par_ClienteID, CHAR);

    CALL CONTACAJAPRO(
        Par_NumeroMov,      Var_FechaApl,       Par_CantidadMov,    descrpcionMov,      Par_MonedaID,
        Var_SucCliente,     Par_AltaEncPoliza,  ConContaAportSocio, Par_Poliza,         Par_AltaDetPol,
        ConceptosCaja,      NatAbono,           Var_ReferDetPol,    Var_ReferDetPol,    Entero_Cero,
        TipoInstrumentoID,  SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

    IF(Par_NumErr>Entero_Cero) THEN
        LEAVE ManejoErrores;
    END IF;

    SET Par_NumErr := Entero_Cero;
    SET Par_ErrMen := "Aportacion Social Cobrada Exitosamente.";

END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            '' AS control,
            Par_Poliza AS consecutivo;
END IF;

END TerminaStore$$