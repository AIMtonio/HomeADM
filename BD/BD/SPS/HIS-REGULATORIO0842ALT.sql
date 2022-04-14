-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIO0842ALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-REGULATORIO0842ALT`;DELIMITER $$

CREATE PROCEDURE `HIS-REGULATORIO0842ALT`(

  Par_Anio              INT,
  Par_Mes               INT,
  Par_NumeroIden        VARCHAR(12),
  Par_TipoPrestamista   VARCHAR(12),
  Par_ClavePrestamista  VARCHAR(20),


  Par_NumeroContrato    VARCHAR(12),
  Par_NumeroCuenta      VARCHAR(12),
  Par_FechaContra       VARCHAR(12),
  Par_FechaVencim       VARCHAR(12),
  Par_TasaAnual         DECIMAL(6,2),


  Par_Plazo             VARCHAR(12),
  Par_PeriodoPago       VARCHAR(12),
  Par_MontoRecibido     DOUBLE,
  Par_TipoCredito       VARCHAR(12),

  Par_Destino           VARCHAR(12),
  Par_TipoGarantia      VARCHAR(12),
  Par_MontoGarantia     DOUBLE,
  Par_FechaPago         VARCHAR(12),
  Par_MontoPago         DOUBLE,

  Par_ClasificaCortLarg VARCHAR(12),
  Par_SalInsoluto       DOUBLE,
  Par_Salida            CHAR(1),
  INOUT Par_NumErr      INT,
  INOUT Par_ErrMen      VARCHAR(400),

  Aud_Empresa           INT(11),
  Aud_Usuario           INT(11),
  Aud_FechaActual       DATETIME,
  Aud_DireccionIP       VARCHAR(15),
  Aud_ProgramaID        VARCHAR(50),

  Aud_Sucursal          INT,
  Aud_NumTransaccion    BIGINT


)
TerminaStore: BEGIN

DECLARE Var_Control     VARCHAR(100);
DECLARE Var_Periodo     VARCHAR(6);
DECLARE Var_Destino     VARCHAR(8);
DECLARE Var_Plazo       VARCHAR(8);
DECLARE Var_TipoCred    VARCHAR(8);
DECLARE Var_TipoGaran   VARCHAR(8);
DECLARE Var_TipoPres    VARCHAR(8);
DECLARE Var_Consecutivo INT;

DECLARE SalidaSI         CHAR(1);
DECLARE Entero_Cero      INT;
DECLARE Decimal_Cero     DECIMAL(4,2);
DECLARE Cadena_Vacia     CHAR;
DECLARE Var_Formulario   VARCHAR(4);
DECLARE Var_ClaveEntidad VARCHAR(6);


SET SalidaSI          :='S';
SET Entero_Cero     :=0;
SET Decimal_Cero    :=0.0;
SET Cadena_Vacia    :='';
SET Par_NumErr        :=1;
SET Par_ErrMen        :=Cadena_Vacia;
SET Var_Formulario    := '0842';

SELECT ClaveEntidad INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Aud_Empresa;

 ManejoErrores: BEGIN

      DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
         SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
                          concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-HIS-REGULATORIO0842ALT');
          SET Var_Control = 'sqlException';
        END;

  SELECT (COUNT(*)+1) INTO Var_Consecutivo FROM
    `HIS-REGULATORIOD0842` WHERE Anio = Par_Anio
    AND Mes = Par_Mes;

    SET Var_Consecutivo = IFNULL(Var_Consecutivo,Entero_Cero);


  IF (Par_Anio=Entero_Cero)THEN
    SET Par_NumErr  := 1;
        SET Par_ErrMen  := 'El Año esta vacio';
        LEAVE ManejoErrores;
  END IF;

    IF (Par_Mes=Entero_Cero)THEN
    SET Par_NumErr  := 2;
        SET Par_ErrMen  := 'El Mes esta vacio';
        LEAVE ManejoErrores;
  END IF;


    IF (IFNULL(Par_NumeroIden,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 3;
        SET Par_ErrMen  := 'El Numero de Identificacion esta vacio';
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_TipoPrestamista,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 4;
        SET Par_ErrMen  := CONCAT('El tipo de Prestamista con Numero de Identificacion:  ',Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;
    IF (IFNULL(Par_ClavePrestamista,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 5;
        SET Par_ErrMen  := CONCAT('La Clave de Prestamista con Numero de Identificacion:  ',Par_NumeroIden, ' esta vacia');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_NumeroContrato,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 6;
        SET Par_ErrMen  := CONCAT('El Numero de Contrato con Numero de Identificacion: ',Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_NumeroCuenta,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 7;
        SET Par_ErrMen  := CONCAT('El Numero de Cuenta con Numero de Identificacion: ',Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (Par_FechaContra=Cadena_Vacia)THEN
    SET Par_NumErr  := 8;
        SET Par_ErrMen  := CONCAT('La Fecha de Contratacion con Numero de Identificacion: ',Par_NumeroIden, ' esta vacia');
        LEAVE ManejoErrores;
  END IF;

    IF (Par_FechaVencim=Cadena_Vacia)THEN
    SET Par_NumErr  := 9;
        SET Par_ErrMen  := CONCAT('La Fecha de Vencimiento con Numero de Identificacion:  ',Par_NumeroIden, ' esta vacia');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_TasaAnual,Decimal_Cero)=Decimal_Cero)THEN
    SET Par_NumErr  := 10;
        SET Par_ErrMen  := CONCAT('El Numero de Tasa Anual con Numero de Identificacion:  ',Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_Plazo,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 11;
        SET Par_ErrMen  := CONCAT('El Plazo  con Numero de Identificacion:  ',Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_PeriodoPago,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 12;
        SET Par_ErrMen  := CONCAT('El Periodo de Plan de Pagos con Numero de Identificacion:  ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_MontoRecibido,Entero_Cero)=Entero_Cero)THEN
    SET Par_NumErr  := 13;
        SET Par_ErrMen  := CONCAT('El Monto Original Recibido con Numero de Identificacion:  ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_TipoCredito,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 14;
        SET Par_ErrMen  := CONCAT('El Tipo de Credito con Numero de Identificacion:  ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_Destino,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 15;
        SET Par_ErrMen  :=  CONCAT('El Valor del Destino  con Numero de Identificacion:  ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;


    IF (Var_TipoGaran<0)THEN
    SET Par_NumErr  := 16;
        SET Par_ErrMen  := CONCAT('El Tipo de Garantia con Numero de Identificacion:  ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_MontoGarantia,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 17;
        SET Par_ErrMen  := CONCAT('El Monto o valor de Garantia con Numero de Identificacion: ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (Par_FechaPago=Cadena_Vacia)THEN
    SET Par_NumErr  := 18;
        SET Par_ErrMen  := CONCAT('La Fecha del Pago Inmediato con Numero de Identificacion:  ' ,Par_NumeroIden, ' esta vacia');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_MontoPago,Entero_Cero)=Entero_Cero)THEN
    SET Par_NumErr  := 19;
        SET Par_ErrMen  := CONCAT('El Monto del Pago Inmediato con Numero de Identificacion:  ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_ClasificaCortLarg,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 20;
        SET Par_ErrMen  := CONCAT('La Clasificacion del Plazo' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF (IFNULL(Par_SalInsoluto,Entero_Cero)=Entero_Cero)THEN
    SET Par_NumErr  := 21;
        SET Par_ErrMen  := CONCAT('El Saldo Insoluto del Prestamo con Numero de Identificacion: ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;


    SELECT CodigoOpcion INTO Var_Destino FROM OPCIONESMENUREG WHERE CodigoOpcion = Par_Destino AND MenuID = 10;

    IF (IFNULL(Var_Destino,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 22;
        SET Par_ErrMen  := CONCAT('El Numero del Destino del Credito con Numero de Identificacion: ' ,Par_NumeroIden, ' es invalido');
        LEAVE ManejoErrores;
  END IF;
  IF (IFNULL(Par_TipoGarantia,Cadena_Vacia)=Cadena_Vacia)THEN
    SET Par_NumErr  := 23;
        SET Par_ErrMen  := CONCAT('El Tipo de Garantia con Numero de Identificacion: ' ,Par_NumeroIden, ' esta vacio');
        LEAVE ManejoErrores;
  END IF;

    IF(Par_Mes < 10) THEN
    SET Var_Periodo    :=  CONCAT(Par_Anio,'0',Par_Mes);
  ELSE
    SET Var_Periodo    :=  CONCAT(Par_Anio,Par_Mes);
    END IF;



INSERT INTO `HIS-REGULATORIOD0842`(
  Anio,               Mes,                Periodo,              ClaveEntidad,
  Formulario,         NumeroIden,         TipoPrestamista,      ClavePrestamista,
  NumeroContrato,     NumeroCuenta,       FechaContra,          FechaVencim,
  TasaAnual,          Plazo,              PeriodoPago,          MontoRecibido,
  TipoCRedito,        Destino,            TipoGarantia,         MontoGarantia,
  FechaPago,          MontoPago,          ClasificaCortLarg,    SalInsoluto,
  EmpresaID,          Usuario,            FechaActual,          DireccionIP,
  ProgramaID,         Sucursal,           NumTransaccion,   Consecutivo )

  VALUES(
  Par_Anio,               Par_Mes,            Var_Periodo,            Var_ClaveEntidad,
  Var_Formulario,         Par_NumeroIden,     Par_TipoPrestamista,    Par_ClavePrestamista,
  Par_NumeroContrato,     Par_NumeroCuenta,   Par_FechaContra,        Par_FechaVencim,
  Par_TasaAnual,      Par_Plazo,          Par_PeriodoPago,        Par_MontoRecibido,
  Par_TipoCredito,        Par_Destino,        Par_TipoGarantia,       Par_MontoGarantia,
  Par_FechaPago,          Par_MontoPago,      Par_ClasificaCortLarg,  Par_SalInsoluto,
  Aud_Empresa,            Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
  Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion,   Var_Consecutivo

    );
    SET Par_NumErr  := 0;
    SET Par_ErrMen  := 'Reporte Regulatorio D0842 agregado correctamente';

END ManejoErrores;
 IF (Par_Salida = SalidaSI) THEN
     SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'regulatorio0842ID' AS control,
            Entero_Cero AS consecutivo;
 END IF;

END TerminaStore$$