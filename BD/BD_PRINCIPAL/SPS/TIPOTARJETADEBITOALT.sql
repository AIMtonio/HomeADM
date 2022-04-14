-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOTARJETADEBITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOTARJETADEBITOALT`;
DELIMITER $$

CREATE PROCEDURE `TIPOTARJETADEBITOALT`(
  # SP PARA ALTA DE TIPO TARJETA DEBITO Y CREDITO
    Par_Descripcion     VARCHAR(150), -- Parametro Descripcion
    Par_CompraPOS     CHAR(1),    -- Parametro de Compra POS S= Si N = No
    Par_Estatus       CHAR(3),    -- Parametro de Estatus Tipo Tarjeta
    Par_TipoTran      INT,      -- Corresponde con la tabla TIPOSTARJETAS
    Par_IdentificaSocio   CHAR(1),    -- Parametro si requiere Identificacion

    Par_TipoProsaID     CHAR(4),    -- Id de prosa
    Par_VigenciaMeses   INT(11),    -- Parametro de Vigencia en Meses
    Par_ColorTarjeta    CHAR(2),    -- Parametro de color de tarjeta
    Par_TipoTarjeta     CHAR(1),    -- Parametro de Tipo Tarjeta
    Par_ProductoCredito   INT(11),    -- Parametro de Producto de Credito

    Par_TasaFija      DECIMAL(12,4),  -- Parametro de Tasa Fija
    Par_MontoAnual      DECIMAL(12,2),  -- Parametro de Monto Anual
    Par_CobraMora     CHAR(1),    -- Parametro de Cobra Moratorios S= Si N= No
    Par_TipoMora      CHAR(1),    -- Parametro de Tipo de Moratorio
    Par_FactorMora      DECIMAL(12,4),  -- Parametro de Factor de Moratorio

    Par_CobFalPago      CHAR(1),    -- Parametro de Cobra Falta de Pago S= Si N= No
    Par_TipoFalPago     CHAR(1),    -- Parametro de Tipo de falta de Pago
    Par_FacFalPago      DECIMAL(12,4),  -- Parametro de Factor de Falta de Pago
    Par_PorcPagMin      DECIMAL(10,4),  -- Parametro de Procentaje de Pago Minimo
    Par_MontoCredito    DECIMAL(12,2),  -- Parametro de monto de credito

    Par_FacComisionAper   DECIMAL(12,4),  -- Parametro de Factor de comision por apertura
    Par_CobComisionAper   CHAR(1),    -- Parametro de Cobro Comisiones por Apertura
    Par_TipoCobComAper    CHAR(1),    -- Parametro de Tipo de Cobro comision por apertura
    Par_TarBinParamsID    INT(11),        -- Identificador de tabla TARBINPARAMS
    Par_NumSubBIN         CHAR(2),        -- Numero del SubBin

    Par_PatrocinadorID    INT(11),        -- identificar a que institución pertenece el subbin
    Par_TipoCore          INT(11),        -- Tipo de Core 1-Core Externo, 2-SAFI Externo, 3-SAFI (Copayment)
    Par_UrlCore           VARCHAR(100),   -- La cadena de la url del core
    Par_TipoMaquilador    INT(11),        -- Tipo de maquilador

    Par_Salida        CHAR(1),    -- indica una salida
  INOUT Par_NumErr    INT,      -- Numero de Error
  INOUT Par_ErrMen    VARCHAR(400), -- Mensaje de Error

  Aud_EmpresaID     INT(11),    -- Parametro de Auditoria
  Aud_Usuario       INT,      -- Parametro de Auditoria
  Aud_FechaActual     DATETIME,   -- Parametro de Auditoria
  Aud_DireccionIP     VARCHAR(15),  -- Parametro de Auditoria
  Aud_ProgramaID      VARCHAR(50),  -- Parametro de Auditoria
  Aud_Sucursal      INT,      -- Parametro de Auditoria
  Aud_NumTransaccion    BIGINT      -- Parametro de Auditoria
    )
TerminaStore: BEGIN

-- Variables
DECLARE Var_TipoTarjetaDebExit  INT(11); -- valida que no se repita el subbin

DECLARE Estatus_Activo  CHAR(1);      -- Variable de Estatus Activo
DECLARE Cadena_Vacia  CHAR(1);      -- Cadena Vacia
DECLARE Fecha_Vacia   DATE;       -- Fecha Vacia
DECLARE Entero_Cero   INT;        -- Entero Cero
DECLARE TranTipoTarjeta INT;        -- Transaccion de tipo Tarjeta
DECLARE TipoCred    CHAR(1);      -- Tipo de Credito
DECLARE TipoDeb     CHAR(1);      -- Tipo de Debito
DECLARE Decimal_Cero    DECIMAL(2,2);   -- DECIMAL Cero
DECLARE varControl    VARCHAR(50);    -- Variable de Control
DECLARE NumeroTipoTarjeta INT;      -- Numero de Tipo Tarjeta
DECLARE SalidaSI        CHAR(1);      -- Salida SI
DECLARE CadenaSi    CHAR(1);      -- Cadena SI
DECLARE MaquiTGS    INT(11);      -- Tipo de maquilador TGS
DECLARE MaquiISS    INT(11);      -- Tipo de maquilador ISS

SET Estatus_Activo  := 'A';
SET Cadena_Vacia  := '';
SET TipoCred    := 'C';
SET TipoDeb     := 'D';
SET Fecha_Vacia   := '1900-01-01';
SET Entero_Cero   := 0;
SET TranTipoTarjeta := 1;
SET Decimal_Cero    := '0.00';
SET SalidaSI        := 'S';           -- El Store SI genera una Salida
SET CadenaSi    := 'S';
SET MaquiTGS    := 2;                 -- Tipo maquilador TGS
SET MaquiISS    := 1;                 -- Tipo maquilador ISS

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
            'esto le ocasiona. Ref: SP-TIPOTARJETADEBITOALT');
    END;

    IF(IFNULL(Par_TipoMaquilador,Entero_Cero)) = Entero_Cero THEN
          SET Par_NumErr  := 1;
          SET Par_ErrMen  := 'El tipo de maquilador esta vacio';
          SET varControl  := 'tipoMaquilador' ;
          LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
          SET Par_NumErr  := 2;
          SET Par_ErrMen  := 'Especifique la Descripcion';
                SET varControl  := 'descripcion' ;
          LEAVE ManejoErrores;
    END IF;


    IF(IFNULL(Par_Estatus, Cadena_Vacia)) = Cadena_Vacia THEN
          SET Par_NumErr  := 3;
          SET Par_ErrMen  :='Especifique el Estatus';
                SET varControl  := 'estatus' ;
          LEAVE ManejoErrores;
    END IF;

    IF(Par_TipoMaquilador = MaquiISS)THEN
      IF(IFNULL(Par_TipoProsaID,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'Especifique el ID de PROSA';
                  SET varControl  := 'tipoProsaID' ;
            LEAVE ManejoErrores;
      END IF;

      IF(IFNULL(Par_ColorTarjeta,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'Especifique el Color de la Tarjeta';
                  SET varControl  := 'colorTarjeta' ;
            LEAVE ManejoErrores;
      END IF;
    END IF;

    IF(IFNULL(Par_TipoTarjeta,Cadena_Vacia)) = Cadena_Vacia THEN
          SET Par_NumErr  := 6;
          SET Par_ErrMen  := 'Especifique el Tipo de Tarjeta';
                SET varControl  := 'tipoTarjeta' ;
          LEAVE ManejoErrores;
    END IF;

    IF(Par_TipoTarjeta = TipoCred) THEN
      IF(IFNULL(Par_ProductoCredito,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 7;
            SET Par_ErrMen  := 'Especifique el Producto de Credito';
            SET varControl  := 'productoCredito' ;
            LEAVE ManejoErrores;
      END IF;
    END  IF;


    IF(Par_TipoTarjeta = TipoCred) THEN
      IF(IFNULL(Par_TasaFija,Decimal_Cero)) = Decimal_Cero THEN
          SET Par_NumErr  := 8;
          SET Par_ErrMen  := 'Especifique la Tasa Fija';
                SET varControl  := 'tasaFija' ;
          LEAVE ManejoErrores;
      END IF;
        IF(IFNULL(Par_CobraMora,Cadena_Vacia)) = Cadena_Vacia THEN
          SET Par_NumErr  := 9;
          SET Par_ErrMen  := 'Especifique si Cobra Mora';
                SET varControl  := 'cobraMora' ;
          LEAVE ManejoErrores;
      END IF;
        IF(Par_CobraMora = CadenaSi) THEN
        IF(IFNULL(Par_TipoMora,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 10;
            SET Par_ErrMen  := 'Especifique el tipo de cobranza de moratorios';
            SET varControl  := 'tipoMora' ;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_FactorMora,Decimal_Cero)) = Decimal_Cero THEN
            SET Par_NumErr  := 11;
            SET Par_ErrMen  := 'Especifique el Factor de Moratorios';
            SET varControl  := 'factorMora' ;
            LEAVE ManejoErrores;
        END IF;
      END IF;
      IF(Par_CobFalPago = CadenaSi) THEN
        IF(IFNULL(Par_CobFalPago,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 12;
            SET Par_ErrMen  := 'Especifique si cobra por Falta de Pago';
            SET varControl  := 'cobFaltaPago' ;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_TipoFalPago,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 13;
            SET Par_ErrMen  := 'Especifique el tipo de cobranza por falta de pago';
            SET varControl  := 'tipoFaltaPago' ;
            LEAVE ManejoErrores;
        END IF;

            IF(IFNULL(Par_FacFalPago,Decimal_Cero)) = Decimal_Cero THEN
          SET Par_NumErr  := 14;
          SET Par_ErrMen  := 'Especifique el Factor de Falta de Pago';
                SET varControl  := 'facFaltaPago' ;
          LEAVE ManejoErrores;
        END IF;

      END IF;

        IF(IFNULL(Par_PorcPagMin,Decimal_Cero)) = Decimal_Cero THEN
          SET Par_NumErr  := 15;
          SET Par_ErrMen  := 'Especifique el porcentaje de pago minimo';
                SET varControl  := 'porcPagoMin' ;
          LEAVE ManejoErrores;
      END IF;
        IF(IFNULL(Par_MontoCredito,Decimal_Cero)) = Decimal_Cero THEN
          SET Par_NumErr  := 16;
          SET Par_ErrMen  := 'Especifique el monto del credito';
                SET varControl  := 'montoCredito' ;
          LEAVE ManejoErrores;
      END IF;
        IF(Par_CobComisionAper = CadenaSi) THEN
        IF(IFNULL(Par_CobComisionAper,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 17;
            SET Par_ErrMen  := 'Especifique si cobra por Comision por Apertura';
            SET varControl  := 'cobComisionAper' ;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_TipoCobComAper,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 18;
            SET Par_ErrMen  := 'Especifique el tipo de cobranza por Apertura';
            SET varControl  := 'tipoCobComAper' ;
            LEAVE ManejoErrores;
        END IF;
            IF(IFNULL(Par_FacComisionAper,Decimal_Cero)) = Decimal_Cero THEN
          SET Par_NumErr  := 19;
          SET Par_ErrMen  := 'Especifique el Factor de Comision por Apertura';
                SET varControl  := 'facComisionAper' ;
          LEAVE ManejoErrores;
        END IF;
      END IF;
    END IF;

  IF(Par_TipoMaquilador = MaquiTGS)THEN

    IF(IFNULL(Par_TarBinParamsID,Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := 20;
        SET Par_ErrMen  := 'Especifique el BIN configurado';
        SET varControl  := 'tarBinParamsID' ;
        LEAVE ManejoErrores;
    END IF;
    SET Par_TipoCore := IFNULL(Par_TipoCore,Entero_Cero);
    IF(Par_TipoCore NOT IN (1,2,3)) THEN
        SET Par_NumErr  := 21;
        SET Par_ErrMen  := 'Especifique un tipo de core valido 1-Externo, 2-SAFI Externo o 3-SAFI Copayment';
        SET varControl  := 'tipoCore';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_UrlCore,Cadena_Vacia)) = Cadena_Vacia AND Par_TipoCore IN (1,2) THEN
        SET Par_NumErr  := 22;
        SET Par_ErrMen  := 'Especifique el Core o Ruta URL';
        SET varControl  := 'urlCore';
        LEAVE ManejoErrores;
    END IF;
      IF(IFNULL(Par_PatrocinadorID,Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := 23;
        SET Par_ErrMen  := 'Especifique el patrocinador';
        SET varControl  := 'PatrocinadorID';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_NumSubBIN,Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 24;
        SET Par_ErrMen  := 'Especifique el numero del subbin';
        SET varControl  := 'numSubBIN';
        LEAVE ManejoErrores;
    END IF;
    SELECT TipoTarjetaDebID
      INTO Var_TipoTarjetaDebExit
    FROM TIPOTARJETADEB
      WHERE TarBinParamsID = Par_TarBinParamsID
        AND NumSubBIN = Par_NumSubBIN;

    IF(IFNULL(Var_TipoTarjetaDebExit,Entero_Cero)) != Entero_Cero THEN
        SET Par_NumErr  := 25;
        SET Par_ErrMen  := 'Ya existe un subbin asociado al bin configurado.';
        SET varControl  := 'TarBinParamsID';
        LEAVE ManejoErrores;
    END IF;
  END IF;

  IF (Par_TipoTran = TranTipoTarjeta) THEN
    SET NumeroTipoTarjeta := (SELECT IFNULL(MAX(TipoTarjetaDebID),Entero_Cero) + 1 FROM TIPOTARJETADEB);

    SET Aud_FechaActual := CURRENT_TIMESTAMP();

    INSERT INTO TIPOTARJETADEB (
            TipoTarjetaDebID,   Descripcion,      CompraPOSLinea,     Estatus,        IdentificacionSocio,
            TipoProsaID,        VigenciaMeses,    ColorTarjeta,       TipoTarjeta,    TasaFija,
            MontoAnualidad,     CobraMora,        TipCobComMorato,    FactorMora,     CobraFaltaPago,
            TipCobComFalPago,   FactorFaltaPago,  PorcPagoMin,        MontoCredito,   ProductoCredito,
            CobComisionAper,    TipoCobComAper,   FacComisionAper,    TarBinParamsID, NumSubBIN,
            PatrocinadorID,     TipoCore,         UrlCore,            tipoMaquilador, EmpresaID,
            Usuario,            FechaActual,      DireccionIP,        ProgramaID,     Sucursal,
            NumTransaccion)
    VALUES(
            NumeroTipoTarjeta,    Par_Descripcion,    Par_CompraPOS,        Par_Estatus,        Par_IdentificaSocio,
            Par_TipoProsaID,      Par_VigenciaMeses,  Par_ColorTarjeta,     Par_TipoTarjeta,    Par_TasaFija,
            Par_MontoAnual,       Par_CobraMora,      Par_TipoMora,         Par_FactorMora,     Par_CobFalPago,
            Par_TipoFalPago,      Par_FacFalPago,     Par_PorcPagMin,       Par_MontoCredito,   Par_ProductoCredito,
            Par_CobComisionAper,  Par_TipoCobComAper, Par_FacComisionAper,  Par_TarBinParamsID, Par_NumSubBIN,
            Par_PatrocinadorID,      Par_TipoCore,       Par_UrlCore,          Par_TipoMaquilador, Aud_EmpresaID,
            Aud_Usuario,          Aud_FechaActual,    Aud_DireccionIP,      Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);


      SET Par_NumErr  := 000;
      SET Par_ErrMen  := CONCAT('Tipo de Tarjeta de Debito Agregado Exitosamente: ', NumeroTipoTarjeta);
      SET varControl  := 'tipoTarjetaDebID' ;

            IF(Par_TipoTarjeta = TipoCred) THEN
        SET Par_ErrMen  := CONCAT('Tipo de Tarjeta de Credito Agregado Exitosamente: ', NumeroTipoTarjeta);
            END IF;

    LEAVE ManejoErrores;
    END IF;
END ManejoErrores;

  IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
        Par_ErrMen AS ErrMen,
        varControl AS control,
        NumeroTipoTarjeta AS consecutivo;
  END IF;

END TerminaStore$$
