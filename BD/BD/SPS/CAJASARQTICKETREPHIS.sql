-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASARQTICKETREPHIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASARQTICKETREPHIS`;DELIMITER $$

CREATE PROCEDURE `CAJASARQTICKETREPHIS`(
    Par_SucursalID      int,
    Par_CajaID          int,
    Par_Fecha           date,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_Encabezado  varchar(40);
DECLARE Var_NumeroMovs  int;
DECLARE Var_MontoMovs   decimal(14,2);
DECLARE Nat_Anterior    int;
DECLARE Var_MontoTotMov decimal(14,2);

DECLARE Var_Numero      int;
DECLARE Var_DescCorta varchar(40);
DECLARE Var_Naturaleza  int;
DECLARE Var_BalActEfe   decimal(14,2);
DECLARE Var_DifEntSal   decimal(14,2);
DECLARE Var_NomCajero   varchar(250);
DECLARE Var_SucursalCaja	int;



DECLARE Entero_Cero     int;
DECLARE Var_Vacio       char(1);
DECLARE Tipo_Encabezado char(1);
DECLARE Tipo_Detalle    char(1);
DECLARE Estilo_cursiva  char(1);
DECLARE Nat_Entrada     int;
DECLARE Nat_Salida      int;
DECLARE EstatusR		char(1);
DECLARE EstatusE		char(1);
DECLARE VarEstatus		char(1);
DECLARE CURSORTIPOPE CURSOR FOR
	select  Numero, DescCorta, Naturaleza
		from CAJATIPOSOPERA
       order by Naturaleza,Orden;


set Entero_Cero     := 0;
set Var_Vacio       := '';
set Tipo_Encabezado := 'E';
set Tipo_Detalle    := 'D';

Set Nat_Entrada     := 1;
Set Nat_Salida      := 2;
Set EstatusR		:= 'R';
Set EstatusE		:= 'E';

CREATE TEMPORARY TABLE TMPARQUEO(
    `Tmp_DescCorta`   varchar(40),
    `Tmp_Tipo`          char(1),
    `Tmp_Estilo`        char(1)
);

select SucursalID into Var_SucursalCaja
		from CAJASVENTANILLA
		where CajaID        =   Par_CajaID;



set Var_Encabezado  := RPAD('', 40, ' ');
insert TMPARQUEO values(Var_Encabezado, Tipo_Detalle,    Var_Vacio  );
insert TMPARQUEO values(Var_Encabezado, Tipo_Detalle,    Var_Vacio  );



set Var_Encabezado  :='REPORTE DE TIRA AUDITORA';
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado,    Var_Vacio   );

set Var_Encabezado  := RPAD(Var_Vacio, 40, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 1, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 1, ' '));


    insert TMPARQUEO
	select concat('TIRA AUDITORA DEL DIA:  ',Par_Fecha) as Movimiento, Var_Vacio, Var_Vacio;

insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado,    Var_Vacio   );

set Var_Encabezado  := RPAD(Var_Vacio, 40, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 1, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 1, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Var_Vacio,    Var_Vacio  );

set Var_Encabezado  := RPAD('DENOMINACION', 16, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('CANTIDAD',8, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('SALDO', 15, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,   Var_Vacio );

insert into TMPARQUEO
    select  concat(RPAD(LPAD(CASE WHEN Den.Valor = 1
                                THEN 'Monedas'
                                ELSE format(Den.Valor, 2)
                             END, 13, ' '),
                    14, ' '),
					case when Den.DenominacionID = 7 then
						 LPAD(format(ifnull(Bal.Cantidad, 0), 2), 12, ' ')
					 else  LPAD(format(ifnull(Bal.Cantidad, 0), 0), 14, ' ')  end ,
                   LPAD(format(ifnull(Bal.Cantidad, 0) * Den.Valor, 2), 13, ' ')),
            Tipo_Detalle, Var_Vacio
        from DENOMINACIONES Den
        LEFT OUTER JOIN  `HIS-BALANZADENO` as Bal ON
            (    Bal.SucursalID     = Var_SucursalCaja
             and Bal.CajaID         = Par_CajaID
             and Bal.DenominacionID = Den.DenominacionID
			 and Bal.Fecha = Par_Fecha);

set Var_Encabezado  := RPAD('', 40, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('', 0, ''));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );


select sum((ifnull(Bal.Cantidad, 0) * Den.Valor)) into Var_BalActEfe
    from DENOMINACIONES Den
    LEFT OUTER JOIN  `HIS-BALANZADENO` as Bal ON
        (    Bal.SucursalID     = Var_SucursalCaja
         and Bal.CajaID         = Par_CajaID
         and Bal.DenominacionID = Den.DenominacionID
		 and Bal.Fecha = Par_Fecha );

set Var_BalActEfe   := ifnull(Var_BalActEfe, Entero_Cero);

set Var_Encabezado  := RPAD('TOTAL', 26, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_BalActEfe,2), 14, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );


set Var_Encabezado  := RPAD(Var_Vacio, 40, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 0, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 0, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Var_Vacio,    Var_Vacio  );




set Var_Encabezado  := 'MOVIMIENTOS DE ENTRADA / ORIGEN';

insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado,    Var_Vacio   );

set Var_Encabezado  := RPAD(Var_Vacio, 40, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 0, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 0, ' '));

insert TMPARQUEO values(
    Var_Encabezado, Var_Vacio,    Var_Vacio  );

set Var_Encabezado  := RPAD('Movimiento',21 , ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('Num', 5, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('Monto', 14, ' '));

insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Estilo_cursiva  );

set Nat_Anterior    := Nat_Entrada;
set Var_MontoTotMov := Entero_Cero;
set Var_DifEntSal   := Entero_Cero;

OPEN CURSORTIPOPE;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

    FETCH CURSORTIPOPE into
	Var_Numero, Var_DescCorta, Var_Naturaleza;
	select count(Transaccion), sum(MontoEnFirme + MontoSBC) into Var_NumeroMovs, Var_MontoMovs
		from  `HIS-CAJASMOVS`
		where Fecha         = Par_Fecha
		and SucursalID    = Var_SucursalCaja
		and CajaID        = Par_CajaID
		and TipoOperacion = Var_Numero;
    set Var_NumeroMovs  := ifnull(Var_NumeroMovs, Entero_Cero);
    set Var_MontoMovs   := ifnull(Var_MontoMovs, Entero_Cero);

    if (Var_Naturaleza = Nat_Entrada) then
        set Var_DifEntSal   := Var_DifEntSal + Var_MontoMovs;
    else
        set Var_DifEntSal   := Var_DifEntSal - Var_MontoMovs;
    end if;

    if (Var_Naturaleza != Nat_Anterior) then

        set Var_Encabezado  := RPAD('', 40, '-');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD('', 0, ' '));
        insert TMPARQUEO values(
            Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

        set Var_Encabezado  := RPAD('TOTAL ENTRADAS', 26, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_MontoTotMov, 2), 14, ' '));
        insert TMPARQUEO values(
            Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

        set Var_Encabezado  := RPAD(Var_Vacio, 26, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 14, ' '));
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 0, ' '));

        insert TMPARQUEO values(
            Var_Encabezado, Var_Vacio,    Var_Vacio  );

        set Var_Encabezado  := 'MOVIMIENTOS DE SALIDA / APLICACION';

        insert TMPARQUEO values(
            Var_Encabezado, Tipo_Encabezado,    Var_Vacio   );

        set Var_Encabezado  := RPAD(Var_Vacio, 40, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 0, ' '));
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 0, ' '));

        insert TMPARQUEO values(
            Var_Encabezado, Var_Vacio,    Var_Vacio  );

        set Var_Encabezado  := RPAD('Movimiento', 21, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD('Num', 5, ' '));
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD('Monto', 14, ' '));

        insert TMPARQUEO values(
            Var_Encabezado, Tipo_Detalle,   Var_Vacio   );

        set Var_MontoTotMov := Var_MontoMovs;
    else
        set Var_MontoTotMov := Var_MontoTotMov + Var_MontoMovs;
    end if;

    set Var_Encabezado  := RPAD(ltrim(rtrim(Var_DescCorta)), 20, ' ');
    set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_NumeroMovs, 0), 6, ' '));
    set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_MontoMovs, 2), 14, ' '));

    insert TMPARQUEO values(
        Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

    set Nat_Anterior    := Var_Naturaleza;

	End LOOP;
END;
CLOSE CURSORTIPOPE;

set Var_Encabezado  := RPAD('', 40, '-');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('', 0, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

set Var_Encabezado  := RPAD('TOTAL SALIDAS', 26, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_MontoTotMov, 2), 14, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );


set Var_Encabezado  := RPAD('', 40, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

set Var_Encabezado  := 'CIFRAS DE CONTROL';
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado,    Var_Vacio   );

set Var_Encabezado  := RPAD('Diferencia', 20, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado,    Estilo_cursiva  );

set Var_Encabezado  := 'ENTRADAS - SALIDAS';
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_DifEntSal, 2), 22, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );


set Var_Encabezado  := RPAD('', 40, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );
set Var_Encabezado  := RPAD('', 40, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

select  NombreCompleto into Var_NomCajero
    from CAJASVENTANILLA Caj,
         USUARIOS Usu
    where Caj.SucursalID    = Var_SucursalCaja
      and Caj.CajaID        = Par_CajaID
      and Caj.UsuarioID     = Usu.UsuarioID;

set Var_NomCajero   := ifnull(Var_NomCajero, Var_Vacio);

set Var_Encabezado  := RPAD('', 17, '-');
set Var_Encabezado  := concat(Var_Encabezado, LPAD(Var_Vacio,5,' '));
set Var_Encabezado  := concat(Var_Encabezado, LPAD(Var_Vacio,17,'-'));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,   Var_Vacio  );

set Var_Encabezado  := RPAD(rtrim(ltrim(Var_NomCajero)), 25	, ' ');
set Var_Encabezado  :=concat(Var_Encabezado,LPAD(Var_vacio,3,' '));
set Var_Encabezado  :=concat(Var_Encabezado, LPAD('GTE.SUCURSAL',12,' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio );

select  Tmp_DescCorta,    Tmp_Tipo,   Tmp_Estilo
    from TMPARQUEO;

drop table TMPARQUEO;

END TerminaStore$$