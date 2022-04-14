-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIBERAGARANTIALIQPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIBERAGARANTIALIQPRO`;DELIMITER $$

CREATE PROCEDURE `LIBERAGARANTIALIQPRO`(
/* Store que libera las garantias liquidas al liquidar un credito
  solo si el producto de credito asi lo indica
   Las garantias liquidas que libera pueden ser por ahorro e inversiones */
  Par_CreditoID     BIGINT,
  Par_Poliza        BIGINT,

  Par_Salida        CHAR(1),
  INOUT Par_NumErr    INT,
  INOUT Par_ErrMen    VARCHAR(400),

  Par_EmpresaID     INT(11),
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion    BIGINT(20)

  )
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_Cliente       INT;
DECLARE Var_BloqueoID     INT;
DECLARE Var_Referencia      VARCHAR(20);
DECLARE Var_CuentaAhoID     BIGINT(12);
DECLARE Var_FechaSistema      DATE;
DECLARE Var_EstatusCredito    CHAR(1);
DECLARE Var_ProductoCredito   INT(11);
DECLARE Var_ProdUsaGarLiq   CHAR(1);
DECLARE Var_LiberaAlLiquidar  CHAR(1);
DECLARE Var_FolioDesbloqueo   BIGINT(20);
DECLARE Var_NumCreditoTexto   VARCHAR(20);
DECLARE Var_ClaveUsuario    VARCHAR(50);
DECLARE Var_RequiereContaGarLiq CHAR(1);
DECLARE Var_MontoDesbloquear  DECIMAL(18,4);
DECLARE Var_ReqGarLiq         CHAR(1);
DECLARE Var_LiberaGarFOGAFI     CHAR(1);

-- Variables para generar la Poliza contable en caso de que aplique
DECLARE Var_MonedaID        INT;
DECLARE Var_ConceptoContaDevGarLiq  INT;

-- Declaracion de Constantes
DECLARE CodigoError     INT;
DECLARE Entero_Cero     INT;
DECLARE BloqPorGarLiq   INT;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE EstatusLiquidado  CHAR(1);
DECLARE ValorSI       CHAR(1);
DECLARE ValorNO       CHAR(1);
DECLARE NatBloqueo      CHAR(1); -- se agrego para liberar garantia liquida;
DECLARE NatDesbloqueo   CHAR(1);
DECLARE DescripcionDesblo VARCHAR(50);
DECLARE DevolucionGarLiq  CHAR(1);



DECLARE cur_DesBloqueo CURSOR FOR
  SELECT Bloq.BloqueoID,  Bloq.CuentaAhoID, Bloq.MontoBloq, Bloq.Referencia, Cue.MonedaID
    FROM BLOQUEOS Bloq
    INNER JOIN CUENTASAHO Cue ON Bloq.CuentaAhoID = Cue.CuentaAhoID
    WHERE  Bloq.TiposBloqID = BloqPorGarLiq
      AND IFNULL(Bloq.FolioBloq, Entero_Cero) = Entero_Cero
          AND  Bloq.NatMovimiento =NatBloqueo
      AND Bloq.Referencia = Par_CreditoID;



-- Asignacion de Constantes
SET CodigoError       := 1;           -- Le indica a Java que ocurrio un error
SET Entero_Cero       := 0;           -- Constante de entero Cero
SET BloqPorGarLiq     := 8;           -- Constante del Tipo de Bloqueo por Garantia liquida
SET Cadena_Vacia      := '';            -- Constante de Cadena Vacia
SET EstatusLiquidado    := 'P';           -- Estatus de Credito que indica que esta pagado
SET ValorSI         := 'S';           -- Representa el valor Si o True
SET ValorNO         := 'N';           -- Representa el valor No o False
SET NatBloqueo        := 'B';           -- Naturaleza de Bloqueo en el saldo de cuenta por Garantia Liquida
SET NatDesbloqueo     := 'D';           -- Natauraleza de Desbloqueo en saldo de cuenta por Garantia liquida
SET DevolucionGarLiq    := 'V';           -- Operacion contable de Devolucion de Garantia liquida

SET DescripcionDesblo   := 'LIBERACION GL POR LIQUIDACION DE CREDITO';
SET Var_ConceptoContaDevGarLiq    := 62;


ManejoErrores:BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
concretar la operación. Disculpe las molestias que ', 'esto le ocasiona. Ref: LIBERAGARANTIALIQPRO');
    END;


-- Inicializacion
SET Par_NumErr      := Entero_Cero;
SET Par_ErrMen      := Cadena_Vacia;
SET Aud_FechaActual   := NOW();

SELECT FechaSistema,  ContabilidadGL
INTO Var_FechaSistema, Var_RequiereContaGarLiq
FROM PARAMETROSSIS;



-- Validar que el credito este liquidado
SELECT Estatus, ProductoCreditoID, ClienteID
  INTO Var_EstatusCredito,  Var_ProductoCredito, Var_Cliente

  FROM CREDITOS
  WHERE CreditoID = Par_CreditoID;

SET Var_EstatusCredito  := IFNULL(Var_EstatusCredito, Cadena_Vacia);
SET Var_ProductoCredito := IFNULL(Var_ProductoCredito, Entero_Cero);


IF(Var_EstatusCredito != EstatusLiquidado ) THEN
  SET Par_NumErr := CodigoError;
  SET Par_ErrMen := CONCAT("El Credito ", CAST(Par_CreditoID AS CHAR), " no se encuentra liquidado.");

  LEAVE ManejoErrores;
END IF;

SELECT Garantizado, LiberarGaranLiq INTO Var_ProdUsaGarLiq, Var_LiberaAlLiquidar
  FROM PRODUCTOSCREDITO
  WHERE ProducCreditoID = Var_ProductoCredito;

  -- Obtiene los valores de las garantias y si permiten bonificacion
      SELECT RequiereGarantia,  LiberaGarLiq
        INTO Var_ReqGarLiq,   Var_LiberaGarFOGAFI
      FROM DETALLEGARLIQUIDA
      WHERE CreditoID = Par_CreditoID;

  SET Var_ReqGarLiq   := IFNULL(Var_ReqGarLiq, Cadena_Vacia);
  SET Var_LiberaGarFOGAFI := IFNULL(Var_LiberaGarFOGAFI, Cadena_Vacia);

  IF(Var_ReqGarLiq = Cadena_Vacia) THEN
    SET Var_ProdUsaGarLiq   := IFNULL(Var_ProdUsaGarLiq, ValorNO);
  ELSE
    SET Var_ProdUsaGarLiq := Var_ReqGarLiq;
  END IF;

  IF(Var_LiberaGarFOGAFI = Cadena_Vacia) THEN
    SET Var_LiberaAlLiquidar    := IFNULL(Var_LiberaAlLiquidar, ValorNO);
  ELSE
    SET Var_LiberaAlLiquidar  := Var_LiberaGarFOGAFI;
  END IF;

  SET Var_ProdUsaGarLiq   := IFNULL(Var_ProdUsaGarLiq, ValorNO);
  SET Var_LiberaAlLiquidar  := IFNULL(Var_LiberaAlLiquidar, ValorNO);


IF(Var_ProdUsaGarLiq != ValorSI) THEN
  SET Par_NumErr := CodigoError;
  SET Par_ErrMen := CONCAT("El Producto de Credito ", CAST(Var_ProductoCredito AS CHAR), " no requiere de garantia liquida.");

  LEAVE ManejoErrores;
END IF;


IF(Var_LiberaAlLiquidar !=  ValorSI) THEN
  SET Par_NumErr := CodigoError;
  SET Par_ErrMen := CONCAT("El Producto de Credito ", CAST(Var_ProductoCredito AS CHAR), " no libera garantia liquida al liquidar credito.");

  LEAVE ManejoErrores;
END IF;

SET Var_NumCreditoTexto := CAST(Par_CreditoID AS CHAR);


SET Var_ClaveUsuario = NULL;

OPEN  cur_DesBloqueo;
    BEGIN
      DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
          CICLO:LOOP
          FETCH cur_DesBloqueo  INTO
            Var_BloqueoID, Var_CuentaAhoID, Var_MontoDesbloquear, Var_Referencia,   Var_MonedaID;

          --  Se Genera el Desbloqueo operativo
          CALL BLOQUEOSPRO( Var_BloqueoID,    NatDesbloqueo,    Var_CuentaAhoID,  Var_FechaSistema, Var_MontoDesbloquear,
            Var_FechaSistema, BloqPorGarLiq,    DescripcionDesblo,  Var_Referencia,   Var_ClaveUsuario,
            Cadena_Vacia,   ValorNO,    Par_NumErr,   Par_ErrMen,   Par_EmpresaID,
            Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
            Aud_NumTransaccion);

          SET Par_NumErr  := IFNULL(Par_NumErr, Entero_Cero);

          IF(Par_NumErr != Entero_Cero) THEN
            LEAVE CICLO;
          END IF;



          IF(Var_RequiereContaGarLiq = ValorSI) THEN
            --  Se Genera el Desbloqueo Contable
            CALL CONTAGARLIQPRO(
          Par_Poliza,       Var_FechaSistema, Var_Cliente,        Var_CuentaAhoID,  Var_MonedaID,
          Var_MontoDesbloquear,   ValorNO,      Var_ConceptoContaDevGarLiq, DevolucionGarLiq, BloqPorGarLiq,
          DescripcionDesblo,    ValorNO,      Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
          Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,      Aud_ProgramaID,   Aud_Sucursal,
          Aud_NumTransaccion);

        SET Par_NumErr  := IFNULL(Par_NumErr, Entero_Cero);

        IF(Par_NumErr != Entero_Cero) THEN
          LEAVE CICLO;
        END IF;
      END IF;

      END LOOP CICLO;
    END;
CLOSE cur_DesBloqueo;




IF (Par_NumErr != Entero_Cero) THEN
  LEAVE ManejoErrores;
END IF;


SET Par_NumErr := Entero_Cero;
SET Par_ErrMen := CONCAT("Garantia(s) Liquida(s) del Credito No.", CAST(Par_CreditoID AS CHAR), " se liberaron con exito.");

END ManejoErrores;  -- End del Handler de Errores


 IF (Par_Salida = ValorSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'CreditoID' AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$