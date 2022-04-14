-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUEAHOBLOAUTCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUEAHOBLOAUTCREPRO`;DELIMITER $$

CREATE PROCEDURE `CUEAHOBLOAUTCREPRO`(
    Par_CreditoID       BIGINT(12),
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11) ,
    Aud_Usuario         INT(11) ,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11) ,
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Var_MontoCred   DECIMAL(14,2);
DECLARE Var_AporteCli   DECIMAL(12,2);
DECLARE Var_CuentaAhoID BIGINT;
DECLARE Var_EsBloqueoAuto   CHAR(1);
DECLARE Var_MonBloqueo   DECIMAL(12,2);
DECLARE Var_MontoBloq   DECIMAL(14,2);
DECLARE Var_BloqueoID   BIGINT;
DECLARE Var_FechaSis    DATE;




DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE Fecha_Vacia         DATE;
DECLARE SalidaSI               CHAR(1);
DECLARE SalidaNO               CHAR(1);
DECLARE Bloq_AutoSI         CHAR(1);
DECLARE Est_Bloqueo         CHAR(1);
DECLARE Tipo_DesBloqueo     CHAR(1);
DECLARE Blo_AutoDep         INT;
DECLARE Blo_BloqGL          INT;
DECLARE Des_DesBloqAut      VARCHAR(50);
DECLARE Des_BloqueoAut      VARCHAR(50);


DECLARE CURSORDESBLOQUEO CURSOR FOR
    SELECT BloqueoID, MontoBloq
        FROM BLOQUEOS Blo
        WHERE CuentaAhoID = Var_CuentaAhoID
          AND TiposBloqID = Blo_AutoDep
          AND NatMovimiento = Est_Bloqueo
          AND IFNULL(FolioBloq, Entero_Cero) = Entero_Cero;


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET SalidaSI        := 'S';
SET SalidaNO        := 'N';
SET Bloq_AutoSI     := 'S';
SET Est_Bloqueo     := 'B';
SET Tipo_DesBloqueo := 'D';
SET Blo_AutoDep     := 13;
SET Blo_BloqGL      := 8;

SET Des_DesBloqAut  := 'Desbloqueo Automatico';
SET Des_BloqueoAut  := 'Bloqueo Automatico';

SELECT FechaSistema INTO Var_FechaSis
    FROM PARAMETROSSIS
    LIMIT 1;

SELECT Cre.CuentaID, Cre.MontoCredito,    Cre.AporteCliente,    Tic.EsBloqueoAuto INTO
       Var_CuentaAhoID,   Var_MontoCred,   Var_AporteCli,   Var_EsBloqueoAuto
    FROM CREDITOS Cre,
         CUENTASAHO Cue,
         TIPOSCUENTAS Tic
   WHERE CreditoID = Par_CreditoID
      AND Cre.CuentaID  = Cue.CuentaAhoID
      AND Cue.TipoCuentaID = Tic.TipoCuentaID;

SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);
SET Var_MontoCred   := IFNULL(Var_MontoCred, Entero_Cero);
SET Var_AporteCli   := IFNULL(Var_AporteCli, Entero_Cero);
SET Var_EsBloqueoAuto   := IFNULL(Var_EsBloqueoAuto, Cadena_Vacia);



IF(Var_EsBloqueoAuto = Bloq_AutoSI) THEN

    SET Var_MonBloqueo  := (SELECT SUM(MontoBloq)
                                    FROM BLOQUEOS
                                    WHERE CuentaAhoID = Var_CuentaAhoID
                                      AND TiposBloqID   = Blo_AutoDep
                                      AND NatMovimiento = Est_Bloqueo
                                      AND IFNULL(FolioBloq, Entero_Cero) = Entero_Cero);

    SET Var_MonBloqueo := IFNULL(Var_MonBloqueo, Entero_Cero);

    IF(Var_MonBloqueo >= Var_AporteCli AND Var_AporteCli> Entero_Cero) THEN
        OPEN CURSORDESBLOQUEO;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            CICLODESBLO: LOOP

            FETCH CURSORDESBLOQUEO INTO
                Var_BloqueoID, Var_MontoBloq;

                CALL `BLOQUEOSPRO`(
                    Var_BloqueoID,  Tipo_DesBloqueo,    Var_CuentaAhoID,    Var_FechaSis,           Var_MontoBloq,
                    Var_FechaSis,   Blo_AutoDep,        Des_DesBloqAut,     Par_CreditoID,          Cadena_Vacia,
                    Cadena_Vacia,   SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_EmpresaID,
                    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
                    Aud_NumTransaccion  );

                IF (Par_NumErr <> Entero_Cero) THEN
                    LEAVE CICLODESBLO;
                END IF;

            END LOOP CICLODESBLO;
        END;
        CLOSE CURSORDESBLOQUEO;


        IF(Par_NumErr != Entero_Cero) THEN
            IF(Par_Salida = SalidaSI) THEN
                SELECT Par_NumErr AS NumErr,
                       Par_ErrMen  AS ErrMen,
                       'creditoID'  AS control,
                       Entero_Cero AS consecutivo;
            END IF;
            LEAVE TerminaStore;
        END IF;


        CALL `BLOQUEOSPRO`(
            Entero_Cero,    Est_Bloqueo,        Var_CuentaAhoID,    Var_FechaSis,           Var_AporteCli,
            Var_FechaSis,   Blo_BloqGL,         Des_BloqueoAut,     Par_CreditoID,          Cadena_Vacia,
            Cadena_Vacia,   SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_EmpresaID,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
            Aud_NumTransaccion  );


        IF(Par_NumErr != Entero_Cero) THEN
            IF(Par_Salida = SalidaSI) THEN
                SELECT Par_NumErr AS NumErr,
                       Par_ErrMen  AS ErrMen,
                       'creditoID'  AS control,
                       Entero_Cero AS consecutivo;
            END IF;
            LEAVE TerminaStore;
        END IF;

    END IF;
END IF;

SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := CONCAT("Proceso Realizado con Exito");

IF(Par_Salida = SalidaSI) THEN
    SELECT  '000' AS NumErr,
            Par_ErrMen AS ErrMen,
            'creditoID' AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$