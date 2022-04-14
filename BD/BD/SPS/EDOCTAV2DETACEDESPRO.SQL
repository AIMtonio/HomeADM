-- EDOCTAV2DETACEDESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2DETACEDESPRO`;
DELIMITER $$

CREATE  PROCEDURE `EDOCTAV2DETACEDESPRO`(
  Par_Salida            CHAR(1),        -- Indica si el error lo regresa en un select o no
  INOUT Par_NumErr      INT(11),        -- Parametro que corresponde a un numero de exito o error
  INOUT Par_ErrMen      VARCHAR(400),   -- Parametro que corresponde a un mensaje de exito o error

  Par_EmpresaID         INT(11),        -- Parametros de Auditoria
  Aud_Usuario           INT(11),        -- Parametros de Auditoria
  Aud_FechaActual       DATETIME,       -- Parametros de Auditoria
  Aud_DireccionIP       VARCHAR(15),    -- Parametros de Auditoria
  Aud_ProgramaID        VARCHAR(50),    -- Parametros de Auditoria
  Aud_Sucursal          INT(11),        -- Parametros de Auditoria
  Aud_NumTransaccion    BIGINT(20)      -- Parametros de Auditoria
)
TerminaStore: BEGIN
  -- Declaracion de Variables
  DECLARE Var_Control             VARCHAR(50);    -- Variable de Control
  DECLARE Var_AnioMes             INT(11);        -- el mes proceso
  DECLARE Var_FecIniMes           DATE;
  DECLARE Var_FecFinMes           DATE;
  DECLARE Var_FolioProceso        BIGINT(20);
  DECLARE EstCedeVigente          CHAR(1);
  DECLARE EstCedePagada           CHAR(1);
  DECLARE EstCedeCancelada        CHAR(1);
  DECLARE TipoProdCede            INT(11);

  -- Declaracion de Constantes.
  DECLARE Cadena_Vacia            CHAR(1);          -- Cadena Vacia
  DECLARE Fecha_Vacia             DATE;             -- Fecha Vacia
  DECLARE Entero_Cero             INT(11);          -- Entero Cero
  DECLARE Var_SalidaSI            CHAR(1);          -- Salida si
  DECLARE Var_ActFolio            TINYINT UNSIGNED; -- Actualizacion del folio generado en el estado de cuenta
  DECLARE Orden_SaldoIniCap       INT(11);
  DECLARE Orden_SaldoIniInt       INT(11);
  DECLARE Orden_Apertura          INT(11);
  DECLARE Orden_Devengamiento     INT(11);
  DECLARE Orden_PagoInteres       INT(11);
  DECLARE Orden_Liquidacion       INT(11);

  -- Asignacion de Constantes
  SET Cadena_Vacia                := '';            -- Cadena Vacia
  SET Fecha_Vacia                 := '1900-01-01';  -- Fecha Vacia
  SET Entero_Cero                 := 0;             -- Entero Cero
  SET Var_SalidaSI                := 'S';           -- Salida si
  SET Var_ActFolio                := 1;             -- Actualizacion del folio generado en el estado de cuenta
  SET EstCedeVigente              := 'N';           -- Estatus de la Cede: Vigente (cargada a cuenta)
  SET EstCedePagada               := 'P';           -- Estatus de la Cede: Pagada (abonada a cuenta)
  SET EstCedeCancelada            := 'C';           -- Estatus de la Cede: Cancelada
  SET TipoProdCede                :=  2;            -- Tipo de Proctos de CEDES de la tabla EDOCTAV2PRODUCTOS
  SET Orden_SaldoIniCap           := 1;
  SET Orden_SaldoIniInt           := 2;
  SET Orden_Apertura              := 4;
  SET Orden_Devengamiento         := 6;
  SET Orden_PagoInteres           := 8;
  SET Orden_Liquidacion           := 10;

  -- Valores por default
  SET Par_EmpresaID               := IFNULL(Par_EmpresaID, Entero_Cero);
  SET Aud_Usuario                 := IFNULL(Aud_Usuario, Entero_Cero);
  SET Aud_FechaActual             := IFNULL(Aud_FechaActual, Fecha_Vacia);
  SET Aud_DireccionIP             := IFNULL(Aud_DireccionIP, Cadena_Vacia);
  SET Aud_ProgramaID              := IFNULL(Aud_ProgramaID, Cadena_Vacia);
  SET Aud_Sucursal                := IFNULL(Aud_Sucursal, Entero_Cero);
  SET Aud_NumTransaccion          := IFNULL(Aud_NumTransaccion, Entero_Cero);

  ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr  = 999;
      SET Par_ErrMen  = CONCAT( 'El SAFI ha tenido un problema al concretar la operacion. ',
                    'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2DETACEDESPRO');
      SET Var_Control = 'sqlException';
    END;

      SELECT  MesProceso,   FechaInicio,  FechaFin,     FolioProceso
      INTO  Var_AnioMes,  Var_FecIniMes, Var_FecFinMes,   Var_FolioProceso
      FROM  EDOCTAV2PARAMS
      LIMIT 1;

      DELETE FROM EDOCTAV2DETACEDES
      WHERE FolioProcesoID = Var_FolioProceso;

        DROP TEMPORARY TABLE IF EXISTS TMP_EDOCTA_SALDOOSCEDES;
        CREATE TEMPORARY TABLE TMP_EDOCTA_SALDOOSCEDES
        SELECT      Amo.CedeID,   Amo.AmortizacionID,   Amo.FechaInicio,    Amo.FechaVencimiento,   Amo.FechaPago,
                    (   SELECT SUM(Monto)
                        FROM CEDESMOV
                        WHERE CedeID = Amo.CedeID
                          AND Fecha >= Amo.FechaInicio
                          AND  Fecha >= Var_FecIniMes
                          AND Fecha <= CASE WHEN Amo.FechaVencimiento < Var_FecFinMes THEN DATE_SUB(Amo.FechaVencimiento,INTERVAL 1 DAY) ELSE Var_FecFinMes END
                          AND NatMovimiento = 'C') AS DevengoMes,
                    (   SELECT SUM(Monto)
                        FROM CEDESMOV
                        WHERE CedeID = Amo.CedeID
                          AND Fecha >= Amo.FechaInicio
                          AND Fecha <= CASE WHEN Amo.FechaVencimiento < Var_FecFinMes THEN DATE_SUB(Amo.FechaVencimiento,INTERVAL 1 DAY) ELSE Var_FecFinMes END
                          AND NatMovimiento = 'C') AS DevengoCompleto,
                    (   SELECT SUM(Monto)
                        FROM CEDESMOV
                        WHERE CedeID = Amo.CedeID
                          AND Fecha > Amo.FechaInicio
                          AND Fecha <= CASE WHEN Amo.FechaPago <= Var_FecFinMes THEN Amo.FechaPago ELSE Var_FecFinMes END
                          AND NatMovimiento = 'A') AS PagoInt
        FROM EDOCTAV2HEADERCEDES Head
        INNER JOIN AMORTIZACEDES Amo ON Head.CedeID = Amo.CedeID AND Amo.FechaInicio <= Var_FecFinMes AND Amo.FechaPago >= Var_FecIniMes
        ORDER BY Head.CedeID;

        CREATE INDEX IDX_TMP_EDOCTA_SALDOOSCEDES_01 ON TMP_EDOCTA_SALDOOSCEDES (CedeID);
        CREATE INDEX IDX_TMP_EDOCTA_SALDOOSCEDES_02 ON TMP_EDOCTA_SALDOOSCEDES (FechaInicio);
        CREATE INDEX IDX_TMP_EDOCTA_SALDOOSCEDES_03 ON TMP_EDOCTA_SALDOOSCEDES (FechaVencimiento);
        CREATE INDEX IDX_TMP_EDOCTA_SALDOOSCEDES_04 ON TMP_EDOCTA_SALDOOSCEDES (FechaPago);

    -- Saldo Inicial
      INSERT INTO EDOCTAV2DETACEDES
      SELECT    NULL,
                Var_AnioMes,            CedeID,                 Var_FecIniMes,     'SALDO INICIAL CAPITAL',             Capital as Deposito,
                Entero_Cero as Retiro,  Orden_SaldoIniCap,      Entero_Cero,        Var_FolioProceso,                   Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,                     Aud_Sucursal,
                Aud_NumTransaccion
      FROM EDOCTAV2HEADERCEDES
      WHERE FechaInicio < Var_FecIniMes;

    -- Saldo Inicial de Interes
      INSERT INTO EDOCTAV2DETACEDES
      SELECT    NULL,
                Var_AnioMes,            CedeID,                 Var_FecIniMes,     'SALDO INICIAL INTERES',            SUM( IFNULL(DevengoCompleto, Entero_Cero) - IFNULL(DevengoMes, Entero_Cero) ) as Deposito,
                Entero_Cero as Retiro,  Orden_SaldoIniInt,      Entero_Cero,        Var_FolioProceso,                   Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,                     Aud_Sucursal,
                Aud_NumTransaccion
      FROM TMP_EDOCTA_SALDOOSCEDES
      GROUP BY CedeID
      HAVING Deposito > Entero_Cero;

    -- Apertura de Cedes
      INSERT INTO EDOCTAV2DETACEDES
      SELECT    NULL,
                Var_AnioMes,            CedeID,                 FechaInicio,        'APERTURA CAPITAL',                 Capital as Deposito,
                Entero_Cero as Retiro,  Orden_Apertura,         Entero_Cero,        Var_FolioProceso,                   Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,                     Aud_Sucursal,
                Aud_NumTransaccion
      FROM EDOCTAV2HEADERCEDES
      WHERE FechaInicio >= Var_FecIniMes AND FechaInicio <= Var_FecFinMes;

    -- Intereses Generados
      INSERT INTO EDOCTAV2DETACEDES
      SELECT    NULL,
                Var_AnioMes,        CedeID,
                CASE WHEN FechaVencimiento < Var_FecFinMes THEN DATE_SUB(FechaVencimiento,INTERVAL 1 DAY) ELSE Var_FecFinMes END,
                'INTERES GENERADO EN EL PERIODO',
                DevengoMes,
                Entero_Cero,        Orden_Devengamiento,    Entero_Cero,        Var_FolioProceso,                   Par_EmpresaID,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,                     Aud_Sucursal,
                Aud_NumTransaccion
      FROM TMP_EDOCTA_SALDOOSCEDES
      WHERE IFNULL(DevengoMes, Entero_Cero) > Entero_Cero;

    -- Intereses Pagados
      INSERT INTO EDOCTAV2DETACEDES
      SELECT    NULL,
                Var_AnioMes,        CedeID,
                FechaPago,
                'INTERES PAGADO EN EL PERIODO',
                Entero_Cero,
                PagoInt,            Orden_PagoInteres,      Entero_Cero,        Var_FolioProceso,                   Par_EmpresaID,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,                     Aud_Sucursal,
                Aud_NumTransaccion
      FROM TMP_EDOCTA_SALDOOSCEDES
      WHERE IFNULL(PagoInt, Entero_Cero) > Entero_Cero;

       -- Capital Pagado por Liquidacion de CEDE
      INSERT INTO EDOCTAV2DETACEDES
      SELECT    NULL,
                Var_AnioMes,            CedeID,                 IFNULL(FechaLiquida, Fecha_Vacia),         'PAGO DE CAPITAL',       Entero_Cero,
                Capital as Retiro,      Orden_Liquidacion,      Entero_Cero,                                Var_FolioProceso,       Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,                            Aud_ProgramaID,         Aud_Sucursal,
                Aud_NumTransaccion
      FROM EDOCTAV2HEADERCEDES
      WHERE FechaLiquida >= Var_FecIniMes
        AND FechaLiquida <= Var_FecFinMes
        AND Estatus = 'P';
        DROP TEMPORARY TABLE IF EXISTS TMP_EDOCTA_SALDOOSCEDES;
        SET Par_NumErr := Entero_Cero;
        SET Par_ErrMen := CONCAT('Detalle de Cedes Terminado con Exito con el Folio: ', Var_FolioProceso);

  END ManejoErrores; -- Fin del bloque manejo de errores

  IF Par_Salida = Var_SalidaSI THEN
    SELECT  Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen,
            Var_FolioProceso    AS control;
  END IF;

END TerminaStore$$



