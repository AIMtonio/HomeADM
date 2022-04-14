-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTCALCSALDOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTCALCSALDOSPRO`;
DELIMITER $$


CREATE PROCEDURE `APORTCALCSALDOSPRO`(
# ============================================================================
# --- SP QUE INSERTA EN LA TABLA SALDOSAPORT LA FOTO DEL CIERRE DE ESTE DIA---
# ============================================================================
  Par_Fecha     DATE,       -- Fecha de calculo
  Par_Salida      CHAR(1),      -- Indica si espera un SELECT de salida
  INOUT Par_NumErr    INT(11),      -- Numero de error
  INOUT Par_ErrMen    VARCHAR(400),   -- Descripcion de error
  Par_EmpresaID   INT(11),

  Aud_Usuario     INT(11),
  Aud_FechaActual   DATETIME,
  Aud_DireccionIP   VARCHAR(15),
  Aud_ProgramaID    VARCHAR(50),
  Aud_Sucursal    INT(11),

  Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

  -- Declaracion de Variables
  DECLARE Var_Control     VARCHAR(100);   -- Variable de control

  -- Declaracion de Constantes
  DECLARE Cadena_Vacia      CHAR(1);
  DECLARE Fecha_Vacia       DATE;
  DECLARE Entero_Cero       INT(3);
  DECLARE Decimal_Cero    DECIMAL(12,2);
  DECLARE Estatus_Vigente   CHAR(2);
  DECLARE Estatus_Cancelado CHAR(2);
  DECLARE Estatus_Pagado    CHAR(2);
  DECLARE Salida_SI     CHAR(1);
  DECLARE NatMovCargo     CHAR(1);

  -- Asignacion de Constantes
  SET Fecha_Vacia       := '1900-01-01';      -- Fecha Vacia
  SET Cadena_Vacia          := '';            -- Cadena Vacia
  SET Decimal_Cero      := 0.00;          -- DECIMAL Cero
  SET Entero_Cero       := 0;           -- Entero Cero
  SET Estatus_Vigente     := 'N';           -- Estatus de la Inversion: Vigente
  SET Estatus_Cancelado   := 'C';           -- Estatus de la Inversion: Cancelado
  SET Estatus_Pagado      := 'P';           -- Estatus de la Inversion: Pagado
  SET Salida_SI           := 'S';                   -- Salida si
  SET NatMovCargo       := 'C';           -- Naturaleza de movimiento: Cargo

  ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que ',
                    'esto le ocasiona. Ref: SP-APORTCALCSALDOSPRO');
        SET Var_Control:= 'SQLEXCEPTION';
      END;

    DELETE FROM SALDOSAPORT WHERE FechaCorte >= Par_Fecha;
    DROP TABLE IF EXISTS TMPSALDOSAPORT;

    CREATE TABLE `TMPSALDOSAPORT` (
      `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `FechaCorte`    DATE NOT NULL ,
      `AportacionID`    INT(11) NOT NULL ,
      `TipoAportacionID`  INT(11) NOT NULL,
      `SaldoCapital`    DECIMAL(16,2) NOT NULL DEFAULT '0.00' ,
      `SaldoIntProvision` DECIMAL(14,2) NOT NULL DEFAULT '0.00' ,
      `Estatus`       CHAR(1) NOT NULL,
      `TasaFija`      DECIMAL(14,4) DEFAULT NULL ,
      `TasaISR`       DECIMAL(12,4) DEFAULT NULL ,
      `InteresGenerado`   DECIMAL(12,2) DEFAULT '0.00' ,
      `InteresRecibir`  DECIMAL(12,2) DEFAULT '0.00',
      `InteresRetener`  DECIMAL(12,2) DEFAULT '0.00',
      `TasaBase`      INT(11) DEFAULT NULL,
      `SobreTasa`     DECIMAL(12,4) DEFAULT '0.0000',
      INDEX (`FechaCorte`,`AportacionID`)
      );

    DROP TABLE IF EXISTS TMPSALDOSPROVAPORT;

    CREATE TABLE `TMPSALDOSPROVAPORT` (
      `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `AportacionID` INT(11) NOT NULL ,
      `SaldoIntProv` DECIMAL(14,2) NOT NULL DEFAULT '0.00'
      );

    INSERT INTO TMPSALDOSAPORT	(
			FechaCorte,					AportacionID,				TipoAportacionID,			SaldoCapital,					SaldoIntProvision,
			Estatus,					TasaFija,					TasaISR,					InteresGenerado,				InteresRecibir,
			InteresRetener,				TasaBase,					SobreTasa)
    SELECT Par_Fecha,     Ap.AportacionID,  Ap.TipoAportacionID,  Ap.Monto,       Decimal_Cero,
        Ap.Estatus,   Ap.TasaFija,    Ap.TasaISR,       Ap.InteresGenerado,   Ap.InteresRecibir,
        Ap.InteresRetener, Ap.TasaBase,   Ap.SobreTasa
      FROM  APORTACIONES Ap
      WHERE   Ap.Estatus  = Estatus_Vigente -- APORTACIONES VIGENTE
      OR    (Ap.Estatus   = Estatus_Pagado  AND Ap.FechaVencimiento >= Par_Fecha) -- APORTACIONES PAGADAS EL DIA DE HOY
      OR    (Ap.Estatus   = Estatus_Cancelado -- APORTACIONES CANCELADAS POR UN VENCIMIENTO ANTICIPADO
      AND   Ap.FechaVenAnt = Par_Fecha
      AND   Ap.FechaInicio != Par_Fecha);

    INSERT INTO TMPSALDOSPROVAPORT	( AportacionID,		SaldoIntProv)
      SELECT Sal.AportacionID, IFNULL(SUM(Monto),Decimal_Cero)
        FROM  TMPSALDOSAPORT Sal INNER JOIN APORTMOV Mov ON Mov.AportacionID = Sal.AportacionID
        WHERE   Mov.NatMovimiento   = NatMovCargo
        AND   Mov.TipoMovAportID   = 100
        AND   Mov.Fecha     <= Par_Fecha
        GROUP BY Sal.AportacionID;


    UPDATE TMPSALDOSAPORT TSal INNER JOIN  TMPSALDOSPROVAPORT TPSal
      ON TSal.AportacionID = TPSal.AportacionID
      SET TSal.SaldoIntProvision = TPSal.SaldoIntProv;


    INSERT INTO SALDOSAPORT(
      FechaCorte,     AportacionID, TipoAportacionID, SaldoCapital,   SaldoIntProvision,
      Estatus,      TasaFija,   TasaISR,      InteresGenerado,  InteresRecibir,
      InteresRetener,   TasaBase,     SobreTasa,      EmpresaID,      Usuario,
      FechaActual,    DireccionIP,  ProgramaID,     Sucursal,     NumTransaccion)
    SELECT
      Par_Fecha,      Ap.AportacionID,Ap.TipoAportacionID,Ap.SaldoCapital,  Ap.SaldoIntProvision,
      Ap.Estatus,     Ap.TasaFija,  Ap.TasaISR,     Ap.InteresGenerado, Ap.InteresRecibir,
      Ap.InteresRetener,  Ap.TasaBase,  Ap.SobreTasa,   Par_EmpresaID,    Aud_Usuario,
      Aud_FechaActual,  Aud_DireccionIP,Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion
      FROM TMPSALDOSAPORT Ap;

    SET Par_NumErr  :=  0;
    SET Par_ErrMen  :=  'Calculo de Saldos Diarios de Aportaciones Realizados Exitosamente.';

  END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr  AS NumErr,
        Par_ErrMen  AS ErrMen,
        Var_Control AS control;
  END IF;

END TerminaStore$$
