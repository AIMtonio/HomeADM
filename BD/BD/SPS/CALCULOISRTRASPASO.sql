-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOISRTRASPASO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOISRTRASPASO`;DELIMITER $$

CREATE PROCEDURE `CALCULOISRTRASPASO`(
# ====================================================================
# -------SP ENCARGADO DE MOVER EL ISR GENERADO A LA TABLA-------------
# -------         COBROISR                     -------------
# ====================================================================
  Par_Fecha     DATE,     -- Fecha de Operacion
    Par_Salida      CHAR(1),    -- Tipo de Salida.
    INOUT Par_NumErr  INT(11),    -- Numero de Error.
    INOUT Par_ErrMen  VARCHAR(400), -- Mensaje de Error.

  Par_EmpresaID   INT(11),    -- Parametro de Auditoria
  Aud_Usuario     INT(11),    -- Parametro de Auditoria
  Aud_FechaActual   DATETIME,   -- Parametro de Auditoria
  Aud_DireccionIP   VARCHAR(15),  -- Parametro de Auditoria
  Aud_ProgramaID    VARCHAR(50),  -- Parametro de Auditoria
  Aud_Sucursal    INT(11),    -- Parametro de Auditoria
  Aud_NumTransaccion  BIGINT(20)    -- Parametro de Auditoria
    )
TerminaStore : BEGIN

-- Declaracion de Variables
DECLARE Var_Control   VARCHAR(50);  -- Control ID

-- Declaracion de constantes
DECLARE SalidaSI    CHAR(1);
DECLARE PagaISR     CHAR(1);
DECLARE DecimalCero     DECIMAL(12,2);
DECLARE FactorUno   INT(1);
DECLARE Est_NoAplicado  CHAR(1);
DECLARE Estatus_Vigente CHAR(1);
DECLARE ProcesoCierre CHAR(1);

-- Asignacion de constantes
SET SalidaSI      := 'S';     -- El Store si regresa una Salida
SET PagaISR       := 'S';     -- Constante SI PAGA ISR
SET DecimalCero     := 0.00;    -- Decimal en cero
SET FactorUno     := 1;     -- Factor UNO
SET Est_NoAplicado    := 'N';     -- Estatus NO Aplicado
SET Aud_ProgramaID    := 'CALCULOISRTRASPASO';  -- Programa que realiza el Proceso
SET Estatus_Vigente   := 'N';     -- Estatus VIGENTE Inversion
SET ProcesoCierre   := 'C';     -- ISR en Proceso de Cierre

ManejoErrores : BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SET Par_NumErr  :=  999;
      SET Par_ErrMen  :=  CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                      'Disculpe las molestias que esto le ocasiona. Ref: SP-CALCULOISRTRASPASO');
            SET Var_Control := 'sqlException';
    END;

    -- ==================Se obtienen los registros de ISR de INVERSIONES =================================== --

   INSERT INTO COBROISR(
          Fecha,           ClienteID,        InstrumentoID,   ProductoID,
                    PagaISR,         TasaISR,        SumSaldos,     SaldoProm,
                    InicioPeriodo,       FinPeriodo,       ISRTotal,        ISR,
                    Factor,                Estatus,        TipoRegistro,    EmpresaID,
          Usuario,         FechaActual,      DireccionIP,       ProgramaID,
                    Sucursal,
          NumTransaccion)

        SELECT    MAX(COB.FechaSistema),   COB.ClienteID,      COB.TipoInstrumentoID, COB.InstrumentoID,
          PagaISR,         INV.TasaISR,      COB.SaldoAcumulado,      COB.SaldoAcumulado,
                    INV.FechaInicio,       MAX(FechaSistema),    SUM(COB.ISR_dia),    INV.ISRReal,
                    FactorUno,         Est_NoAplicado,     ProcesoCierre,     Par_EmpresaID,
                    Aud_Usuario,       Aud_FechaActual,    Aud_DireccionIP,         Aud_ProgramaID,
          Aud_Sucursal,            Aud_NumTransaccion

          FROM CLIENTESISR        AS COB
            INNER JOIN INVERSIONES  AS INV ON COB.InstrumentoID=INV.InversionID
                        WHERE INV.Estatus     = Estatus_Vigente
                         AND  INV.ISRReal     > DecimalCero
             AND  INV.FechaVencimiento  > Par_Fecha
            GROUP BY INV.InversionID;

                SET Par_NumErr  := 0;
                SET Par_ErrMen  := 'ISR Registrado Correctamente';
                SET Var_Control := 'IsrID';


END ManejoErrores;
  IF (Par_Salida = SalidaSI) THEN
      SELECT  Par_NumErr  AS NumErr,
          Par_ErrMen  AS ErrMen,
                    Var_Control AS Control;
  END IF;
END TerminaStore$$