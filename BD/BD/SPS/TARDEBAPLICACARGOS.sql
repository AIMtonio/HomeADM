-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBAPLICACARGOS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBAPLICACARGOS`;
DELIMITER $$


CREATE PROCEDURE `TARDEBAPLICACARGOS`(

    Par_Salida          char(1),
    inout Par_NumErr    int(11),
    inout Par_ErrMen    varchar(250),

    Aud_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     date,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)
	)

TerminaStore: BEGIN

DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int(11);
DECLARE Salida_NO       char(1);
DECLARE Salida_SI       char(1);
DECLARE Decimal_Cero    decimal(12,2);
DECLARE ConceptoTarDeb  int(11);
DECLARE Con_AhoCapital  int(11);
DECLARE Con_OperacPOS   int(11);
DECLARE Var_Poliza      bigint(20);
DECLARE Pol_Automatica  char(1);

DECLARE Var_MovimientoID    int(11);
DECLARE Var_TipoOperacion   char(2);
DECLARE Var_TarjetaDebID    char(16);
DECLARE Var_ClienteID       int(11);
DECLARE Var_CuentaAhoID     bigint(12);
DECLARE Var_FechaMovimiento date;
DECLARE Var_TipoMovAhoID    int(11);
DECLARE Var_MonedaID        int(11);
DECLARE Var_NatMovimiento   char(1);
DECLARE Var_Monto           decimal(12,2);
DECLARE Var_DescripcionMov  varchar(50);
DECLARE Var_NumTransaccion  bigint(20);
DECLARE Var_ReferenciaMov   varchar(50);
DECLARE Var_DesAhorro       varchar(50);
DECLARE Terminado       int(11) DEFAULT 0;
DECLARE CompraNormal    char(2);
DECLARE CompraRetiroEfec char(2);
DECLARE ConsultaSaldo   char(2);

DECLARE Var_MontoCompra decimal(12,2);
DECLARE Var_MontoAdicional decimal(12,2);
DECLARE Var_MontoSurcharge decimal(12,2);
DECLARE Mov_AhoCompra   char(4);
DECLARE Mov_AhoRetEfe   char(4);
DECLARE Var_IVA         decimal(12,2);
DECLARE Var_MontoIVACom decimal(12,2);
DECLARE Var_MontoCom    decimal(12,2);
DECLARE Des_ComCons     varchar(50);
DECLARE Des_IVAComCon   varchar(50);
DECLARE Mov_AhoComRet   char(4);
DECLARE Mov_AhoIVACom   char(4);
DECLARE Error_Key       int(11);
DECLARE Estatus_Aplicado char(1);

DECLARE CursorMovs Cursor FOR (
    SELECT
        MovimientoID,   TipoOperacionID,    TarjetaDebID,   ClienteID,          CuentaAhoID,
        FechaMovimiento,TipoMovAhoID,       MonedaID,       NatMovimiento,      MontoTransaccion,
        MontoAdicional, MontoSurcharge,     DescripcionMov, NumeroTransaccion,  ReferenciaMov
    FROM TARJETADEBITOMOVS
    WHERE Estatus = 'P');

Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Salida_NO       := 'N';
Set Salida_SI       := 'S';
Set Decimal_Cero    := 0.00;
Set ConceptoTarDeb  := 300;
Set Con_AhoCapital  := 1;
Set Con_OperacPOS   := 2;
Set Pol_Automatica  := 'A';
Set CompraNormal    := '00';
Set CompraRetiroEfec:= '09';
Set ConsultaSaldo   := '30';
Set Estatus_Aplicado:= 'A';

Set Error_Key       := Entero_Cero;

START TRANSACTION;
OPEN CursorMovs;
    BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        DECLARE EXIT HANDLER FOR SQLEXCEPTION  BEGIN Set Error_Key := 1; END;
        LOOP
            Fetch CursorMovs
                INTO Var_MovimientoID,      Var_TipoOperacion,  Var_TarjetaDebID,   Var_ClienteID,      Var_CuentaAhoID,
                     Var_FechaMovimiento,   Var_TipoMovAhoID,   Var_MonedaID,       Var_NatMovimiento,  Var_Monto,
                     Var_MontoAdicional,    Var_MontoSurcharge, Var_DescripcionMov, Var_NumTransaccion, Var_ReferenciaMov;

			CASE Var_TipoOperacion
                WHEN CompraNormal THEN
                    UPDATE CUENTASAHO SET
                        CargosDia   =   CargosDia   +   Var_Monto,
                        CargosMes   =   CargosMes   +   Var_Monto,
                        Saldo       =   Saldo       -   Var_Monto
                    WHERE CuentaAhoID = Var_CuentaAhoID;


				INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
				VALUES	(
                        Var_CuentaAhoID,    Var_NumTransaccion, Var_FechaMovimiento,    Var_NatMovimiento,  Var_Monto,
                        Var_DescripcionMov, Var_ReferenciaMov,  Var_TipoMovAhoID,       Var_MonedaID,       Entero_Cero,
                        Aud_EmpresaID, 	    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
			Aud_Sucursal,	    Var_NumTransaccion );

                WHEN CompraRetiroEfec THEN
                    Set Mov_AhoCompra   := '17';
                    Set Mov_AhoRetEfe   := '20';

                    Set Var_MontoCompra := (Var_Monto - Var_MontoAdicional);

                    UPDATE CUENTASAHO SET
                        CargosDia   = CargosDia + Var_Monto,
                        CargosMes   = CargosMes + Var_Monto,
                        Saldo       = Saldo     - Var_Monto
                    WHERE CuentaAhoID = Var_CuentaAhoID;

                    if (Var_MontoCompra <> Decimal_Cero ) then

                        Set Var_DesAhorro := concat("COMPRA CON TD: ", Var_NumTransaccion);
				INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
				VALUES	(
                            Var_CuentaAhoID,    Var_NumTransaccion, Var_FechaMovimiento,    Var_NatMovimiento,  Var_MontoCompra,
                            Var_DesAhorro,      Var_ReferenciaMov,  Mov_AhoCompra,          Var_MonedaID,       Entero_Cero,
                            Aud_EmpresaID,	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
                            Aud_Sucursal,	Var_NumTransaccion  );
                    end if;

                    Set Var_DesAhorro := concat("RETIRO CON TD ", Var_NumTransaccion);
				INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
				VALUES	(
                        Var_CuentaAhoID,    Var_NumTransaccion, Var_FechaMovimiento,    Var_NatMovimiento,  Var_MontoAdicional,
                        Var_DesAhorro,      Var_ReferenciaMov,  Mov_AhoRetEfe,          Var_MonedaID,       Entero_Cero,
                        Aud_EmpresaID,	    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
                        Aud_Sucursal,	    Var_NumTransaccion  );

                WHEN ConsultaSaldo THEN

                    UPDATE CUENTASAHO SET
                        CargosDia   = CargosDia + Var_MontoSurcharge,
                        CargosMes   = CargosMes + Var_MontoSurcharge,
                        Saldo       = Saldo     - Var_MontoSurcharge
                    WHERE CuentaAhoID = Var_CuentaAhoID;

                    SELECT IVA into Var_IVA
                        FROM SUCURSALES
                        WHERE SucursalID = Aud_Sucursal;

                    Set Var_MontoIVACom := round(Var_MontoSurcharge / (1 + Var_IVA) * Var_IVA, 2);
                    Set Var_MontoCom    := Var_MontoSurcharge - Var_MontoIVACom;

                    Set Des_ComCons     := 'COMISION POR CONSULTA SALDO';
                    Set Des_IVAComCon   := 'IVA COMISION POR CONSULTA SALDO';
                    Set Mov_AhoComRet   := '86';
                    Set Mov_AhoIVACom   := '88';

				INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
				VALUES	(
                        Var_CuentaAhoID,    Var_NumTransaccion, Var_FechaMovimiento,    Var_NatMovimiento,  Var_MontoCom,
                        Des_ComCons,        Var_ReferenciaMov,  Mov_AhoComRet,          Var_MonedaID,       Aud_EmpresaID,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
                        Var_NumTransaccion  );

				INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
				VALUES	(
                        Var_CuentaAhoID,    Var_NumTransaccion, Var_FechaMovimiento,    Var_NatMovimiento,  Var_MontoIVACom,
                        Des_IVAComCon,      Var_ReferenciaMov,  Mov_AhoIVACom,          Var_MonedaID,       Entero_Cero,
                        Aud_EmpresaID,	    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
                        Aud_Sucursal,	    Var_NumTransaccion  );
            END CASE;


                CALL MAESTROPOLIZAALT(
                    Var_Poliza,         Aud_EmpresaID,  Var_FechaMovimiento,    Pol_Automatica,     ConceptoTarDeb,
                    Var_DescripcionMov, Salida_NO,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,   Var_NumTransaccion);


                call POLIZAAHORROPRO(
                    Var_Poliza,         Aud_EmpresaID,  Aud_FechaActual,    Var_ClienteID,      Con_AhoCapital,
                    Var_CuentaAhoID,    Var_MonedaID,   Var_Monto,          Entero_Cero,        Var_DescripcionMov,
                    Var_ReferenciaMov,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Var_NumTransaccion  );


                call POLIZATARJETAPRO(
                    Var_Poliza,         Aud_EmpresaID,      Aud_FechaActual,    Var_TarjetaDebID,   Var_ClienteID,
                    Con_OperacPOS,      Var_MonedaID,       Entero_Cero,        Var_Monto,          Var_DescripcionMov,
                    Var_ReferenciaMov,  Entero_Cero,	    Salida_NO,	        Par_NumErr,         Par_ErrMen,
                    Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                    Var_NumTransaccion );


                UPDATE TARJETADEBITOMOVS SET
                    Estatus = Estatus_Aplicado
                WHERE MovimientoID = Var_MovimientoID;
        End LOOP;
    END;
CLOSE CURSORMOVS;

    if (Error_Key = Entero_Cero ) then
        COMMIT;
        Set Par_NumErr := '00';
        Set Par_ErrMen := 'Operacion Realizada Exitosamente';
    else
        ROLLBACK;
        Set Par_NumErr := '01';
        Set Par_ErrMen := 'Operacion Fallida';
    end if;
    if (Par_Salida = Salida_SI) then
            SELECT Par_NumErr, Par_ErrMen;
    end if;
END TerminaStore$$
