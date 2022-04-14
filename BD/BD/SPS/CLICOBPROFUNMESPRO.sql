-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICOBPROFUNMESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLICOBPROFUNMESPRO`;DELIMITER $$

CREATE PROCEDURE `CLICOBPROFUNMESPRO`(

    Par_FechaOperacion  DATE,
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(350),
    INOUT Par_PolizaID  BIGINT(20),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),

    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

    )
TerminaStore: BEGIN


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Uno          INT(11);

    DECLARE Pol_Automatica      CHAR(1);
    DECLARE Nat_Cargo           CHAR(1);
    DECLARE Nat_Abono           CHAR(1);
    DECLARE Est_Registrado      CHAR(1);
    DECLARE Est_Inactivo        CHAR(1);
    DECLARE Salida_NO           CHAR(1);
    DECLARE Salida_SI           CHAR(1);

    DECLARE AltaEncPolizaNo     CHAR(1);
    DECLARE AltaPolizaAhoSi     CHAR(1);
    DECLARE VarProcedimiento    VARCHAR(20);
    DECLARE VarConcepConta      INT;
    DECLARE VarConcepContaAho   INT;
    DECLARE Act_AplicaCobro     INT(11);
    DECLARE VarMaxAtraPagPROFUN INT(11);



    DECLARE VarMontoPen         DECIMAL(12,2);
    DECLARE VarSaldoDispon      DECIMAL(12,2);
    DECLARE VarMonedaID         INT(11);
    DECLARE VarSucursalCte      INT(11);
    DECLARE VarClienteID        INT(11);
    DECLARE VarFechaCobro       DATE;
    DECLARE VarFechaSistema     DATE;
    DECLARE VarCuentaAhoID      BIGINT(12);
    DECLARE VarNumCuentas       INT(12);
    DECLARE varControl          VARCHAR(20);

    DECLARE VarDescripMovAho    VARCHAR(150);
    DECLARE VarCtaContaPROFUN   CHAR(25);
    DECLARE VarTipoMovAhoProfun CHAR(4);



    DECLARE CURSORCLICOBROSPROFUN CURSOR FOR
    SELECT CP.ClienteID,  CP.MontoPendiente,  CP.FechaCobro
            FROM    CLICOBROSPROFUN CP, CLIENTESPROFUN C, CUENTASAHO CA
            WHERE   CP.MontoPendiente > 0
            AND    CA.SaldoDispon >= CP.MontoPendiente
            AND     CP.ClienteID NOT IN (SELECT  ClienteID FROM CLIENTESCANCELA WHERE AreaCancela = 'Pro')
            AND   C.ClienteID = CP.ClienteID
            AND     CA.ClienteID  = CP.ClienteID
            AND     C.Estatus IN ('R','I');

    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET Fecha_Vacia         := STR_TO_DATE('1900-01-01', '%Y-%m-%d');
    SET Salida_NO           := 'N';
    SET Entero_Uno          := 1;

    SET Salida_SI           := 'S';
    SET Pol_Automatica      := 'A';
    SET Nat_Cargo           := 'C';
    SET Nat_Abono           := 'A';
    SET AltaEncPolizaNo     := 'N';

    SET AltaPolizaAhoSi     := 'S';
    SET Est_Registrado      := 'R';
    SET Est_Inactivo        := 'I';
    SET Aud_ProgramaID      := 'CLICOBPROFUNMESPRO';
    SET VarProcedimiento    := 'CLICOBROSPROFUNPRO';
    SET VarDescripMovAho    := 'PAGO MUTUAL PROFUN';

    SET VarConcepConta      := '802';
    SET VarConcepContaAho   := '1';
    SET VarTipoMovAhoProfun := '26';
    SET Act_AplicaCobro     := 2;


    SET varControl          := 'clienteID' ;


    SET VarCtaContaProfun   := (SELECT CtaContaPROFUN FROM PARAMETROSCAJA);
    SET VarMaxAtraPagPROFUN := (SELECT MaxAtraPagPROFUN FROM PARAMETROSCAJA);
    SET VarCtaContaProfun   := IFNULL(VarCtaContaProfun, Cadena_Vacia);
    SET VarMaxAtraPagPROFUN := IFNULL(VarMaxAtraPagPROFUN, 0);

    SET VarFechaSistema     := ( SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores:BEGIN

    SET VarNumCuentas := (SELECT COUNT(CP.ClienteID)
                            FROM CLICOBROSPROFUN CP, CLIENTESPROFUN C, CUENTASAHO CA
                           WHERE CP.MontoPendiente > 0
                             AND CA.SaldoDispon >= CP.MontoPendiente
                             AND CP.ClienteID NOT IN (SELECT  ClienteID FROM CLIENTESCANCELA WHERE AreaCancela = 'Pro')
                             AND C.ClienteID = CP.ClienteID
                             AND CA.ClienteID  = CP.ClienteID
                             AND C.Estatus IN ('R','I'));


    SET VarNumCuentas       := IFNULL(VarNumCuentas, 0);
    SET VarDescripMovAho    := (SELECT Descripcion
                                  FROM CONCEPTOSCONTA
                                 WHERE ConceptoContaID = VarConcepConta);


    IF(VarNumCuentas >0 )THEN

        CALL MAESTROPOLIZAALT(
            Par_PolizaID,       Par_EmpresaID,      Par_FechaOperacion, Pol_Automatica,     VarConcepConta,
            VarDescripMovAho,   Salida_NO,          Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


        OPEN CURSORCLICOBROSPROFUN;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            CICLO: LOOP

            FETCH CURSORCLICOBROSPROFUN INTO
                VarClienteID,       VarMontoPen,        VarFechaCobro;

                CALL CLICOBROSPROFUNPRO(
                    VarClienteID,       Par_FechaOperacion,     VarMontoPen,    AltaEncPolizaNo,    Salida_NO,
                    Par_NumErr,         Par_ErrMen,             Par_PolizaID,   Par_EmpresaID,      Aud_Usuario,
                    Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion  );

                IF(Par_NumErr <> Entero_Cero)THEN
                    LEAVE CICLO;
                END IF;


                UPDATE CLIENTESPROFUN SET
                    MesesConsPago = IFNULL(MesesConsPAgo,Entero_Cero)+ Entero_Uno
                WHERE ClienteID = VarClienteID;

                SET Par_NumErr  := 0;
                SET Par_ErrMen  := 'Cobro Realizado Exitosamente';
                SET varControl  := 'clienteID' ;

            END LOOP CICLO;
        END;
        CLOSE CURSORCLICOBROSPROFUN;
    ELSE
        SET Par_NumErr  := 0;
        SET Par_ErrMen  := 'Cobro Realizado Exitosamente';
        SET varControl  := 'clienteID' ;
    END IF;


    UPDATE  CLIENTESPROFUN CP,
            CLICOBROSPROFUN CC  SET
        CP.MesesConsPago    = Entero_Cero
    WHERE   CP.ClienteID = CC.ClienteID
     AND    CC.MontoPendiente > Entero_Cero;

    UPDATE  CLIENTESPROFUN CP,
            CLICOBROSPROFUN CC  SET
        CP.Estatus          = Est_Inactivo,
        CP.EmpresaID        = Par_EmpresaID,
        CP.Usuario          = Aud_Usuario,
        CP.FechaActual      = Aud_FechaActual,
        CP.DireccionIP      = Aud_DireccionIP,
        CP.ProgramaID       = Aud_ProgramaID,
        CP.Sucursal         = Aud_Sucursal,
        CP.NumTransaccion   = Aud_NumTransaccion
    WHERE   CP.ClienteID = CC.ClienteID
     AND    DATEDIFF(Par_FechaOperacion,CC.FechaCobro) > (VarMaxAtraPagPROFUN * 30)
     AND    CC.MontoPendiente > 0;


    UPDATE  CLICOBROSPROFUN CC,
            CLIENTESPROFUN  CP SET
        CP.Estatus          = Est_Registrado,
        CP.EmpresaID        = Par_EmpresaID,
        CP.Usuario          = Aud_Usuario,
        CP.FechaActual      = Aud_FechaActual,
        CP.DireccionIP      = Aud_DireccionIP,
        CP.ProgramaID       = Aud_ProgramaID,
        CP.Sucursal         = Aud_Sucursal,
        CP.NumTransaccion   = Aud_NumTransaccion
    WHERE   CC.ClienteID    = CP.ClienteID
     AND    Estatus         = Est_Inactivo
     AND    MontoPendiente  = 0;



   UPDATE CLIENTESPROFUN a, CLICOBROSPROFUN b
      SET FechaBaja = Fecha_Vacia
    WHERE a.Estatus = Est_Registrado
      AND b.ClienteID = a.ClienteID
      AND b.FechaBaja <> Fecha_Vacia;




    IF(Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    ELSE
        SET Par_NumErr  := 0;
        SET Par_ErrMen  := 'Cobro Realizado Exitosamente';
        SET varControl  := 'clienteID' ;
        LEAVE ManejoErrores;
    END IF;



END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen       AS ErrMen,
            varControl       AS control,
            Entero_Cero      AS consecutivo;
END IF;

END TerminaStore$$