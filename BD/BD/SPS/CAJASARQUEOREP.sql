-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASARQUEOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASARQUEOREP`;DELIMITER $$

CREATE PROCEDURE `CAJASARQUEOREP`(
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


DECLARE Var_Encabezado  varchar(400);
DECLARE Var_NumeroMovs  int;
DECLARE Var_MontoMovs   decimal(14,2);
DECLARE Nat_Anterior    int;
DECLARE Var_MontoTotMov decimal(14,2);

DECLARE Var_Numero      int;
DECLARE Var_Descripcion varchar(200);
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

	 select  Numero, Descripcion, Naturaleza
		from CAJATIPOSOPERA
       order by Naturaleza, Orden;



set Entero_Cero     := 0;
set Var_Vacio       := '';
set Tipo_Encabezado := 'E';
set Tipo_Detalle    := 'D';
set Estilo_cursiva  := 'C';
Set Nat_Entrada     := 1;
Set Nat_Salida      := 2;
Set EstatusR		:= 'R';
Set EstatusE		:= 'E';

CREATE TEMPORARY TABLE TMPARQUEO(
    `Tmp_Descripcion`   varchar(400),
    `Tmp_Tipo`          char(1),
    `Tmp_Estilo`        char(1)

);


select SucursalID into Var_SucursalCaja
		from CAJASVENTANILLA
		where CajaID        =   Par_CajaID;


set Var_Encabezado  := RPAD('', 34, ' ');
insert TMPARQUEO values(Var_Encabezado, Tipo_Detalle,    Var_Vacio  );
insert TMPARQUEO values(Var_Encabezado, Tipo_Detalle,    Var_Vacio   );



set Var_Encabezado  := 'BALANZA ACTUAL DE EFECTIVO (MXN)';
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado, Var_Vacio   );

set Var_Encabezado  := RPAD(Var_Vacio, 60, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 14, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 20, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Var_Vacio,    Var_Vacio  );

set Var_Encabezado  := RPAD('Denominación', 20, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('Cantidad', 14, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('Saldo', 21, ' '));
insert TMPARQUEO values(
   Var_Encabezado, Tipo_Detalle, Estilo_cursiva );

insert into TMPARQUEO

 select  concat(RPAD(CASE WHEN Den.Valor = 1 THEN concat('M',LPAD('Monedas',11,' '))
					else concat('B',LPAD(format(Den.Valor, 2),11,' '))
                             END,13,' '),

		concat(LPAD(CASE WHEN Den.DenominacionID !=7 THEN format(ifnull(Bal.Cantidad,0),0) else format(ifnull(Bal.Cantidad,0),2)END
			,21,' ')),
			 concat(' ',' ',' ',concat(LPAD(format(ifnull(Bal.Cantidad,0) * Den.Valor, 2), 18, ' ')))),
         Tipo_Detalle, Var_Vacio
        from DENOMINACIONES Den
		left outer join BALANZADENOM AS Bal ON Den.DenominacionID = Bal.DenominacionID
		where Bal.SucursalID =Var_SucursalCaja and Bal.CajaID = Par_CajaID  ;

set Var_Encabezado  := RPAD('', 34, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('', 20, '-'));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );


select sum((ifnull(Bal.Cantidad, 0) * Den.Valor)) into Var_BalActEfe
    from DENOMINACIONES Den
    LEFT OUTER JOIN BALANZADENOM as Bal ON
        (    Bal.SucursalID     = Var_SucursalCaja
         and Bal.CajaID         = Par_CajaID
         and Bal.DenominacionID = Den.DenominacionID);

set Var_BalActEfe   := ifnull(Var_BalActEfe, Entero_Cero);

set Var_Encabezado  := RPAD('TOTAL', 34, ' ');
set Var_Encabezado  := concat(Var_Encabezado,   concat(' ',' ',' ',concat('$',LPAD(format(Var_BalActEfe,2), 17, ' '))));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );


set Var_Encabezado  := RPAD(Var_Vacio, 60, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 14, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 20, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Var_Vacio, Var_Vacio  );




set Var_Encabezado  := 'MOVIMIENTOS DE ENTRADA / ORIGEN';

insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado,    Var_Vacio   );

set Var_Encabezado  := RPAD(Var_Vacio, 60, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 14, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 20, ' '));

insert TMPARQUEO values(
    Var_Encabezado, Var_Vacio,    Var_Vacio  );

set Var_Encabezado  := RPAD('Movimiento', 60, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('No.Movimientos', 14, ' '));
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('Monto Total', 20, ' '));

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
	Var_Numero, Var_Descripcion, Var_Naturaleza;
	select count(Transaccion), sum(MontoEnFirme + MontoSBC) into Var_NumeroMovs, Var_MontoMovs
		from CAJASMOVS
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

        set Var_Encabezado  := RPAD('', 60, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD('', 34, '-'));
        insert TMPARQUEO values(
            Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

        set Var_Encabezado  := RPAD('TOTAL ENTRADAS', 60, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_MontoTotMov, 2), 34, ' '));
        insert TMPARQUEO values(
            Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

        set Var_Encabezado  := RPAD(Var_Vacio, 60, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 14, ' '));
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 20, ' '));

        insert TMPARQUEO values(
            Var_Encabezado, Var_Vacio,    Var_Vacio  );

        set Var_Encabezado  := 'MOVIMIENTOS DE SALIDA / APLICACION';

        insert TMPARQUEO values(
            Var_Encabezado, Tipo_Encabezado,    Var_Vacio   );

        set Var_Encabezado  := RPAD(Var_Vacio, 60, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 14, ' '));
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 20, ' '));

        insert TMPARQUEO values(
            Var_Encabezado, Var_Vacio,    Var_Vacio  );

        set Var_Encabezado  := RPAD('Movimiento', 60, ' ');
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD('No.Movimientos', 14, ' '));
        set Var_Encabezado  := concat(Var_Encabezado,  LPAD('Monto Total', 20, ' '));

        insert TMPARQUEO values(
            Var_Encabezado, Tipo_Detalle,    Estilo_cursiva  );

        set Var_MontoTotMov := Var_MontoMovs;
    else
        set Var_MontoTotMov := Var_MontoTotMov + Var_MontoMovs;
    end if;

    set Var_Encabezado  := RPAD(Var_Descripcion, 60, ' ');
    set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(rtrim(ltrim(Var_NumeroMovs)), 0), 14, ' '));
    set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(rtrim(ltrim(Var_MontoMovs)), 2), 20, ' '));

    insert TMPARQUEO values(
        Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

    set Nat_Anterior    := Var_Naturaleza;

	End LOOP;
END;
CLOSE CURSORTIPOPE;

set Var_Encabezado  := RPAD('', 60, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD('', 34, '-'));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

set Var_Encabezado  := RPAD('TOTAL SALIDAS', 60, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_MontoTotMov, 2), 34, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );


set Var_Encabezado  := RPAD('', 54, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

set Var_Encabezado  := 'CIFRAS DE CONTROL';
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado,    Var_Vacio   );

set Var_Encabezado  := LPAD('Diferencia', 54, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Encabezado,    Estilo_cursiva  );

set Var_Encabezado  := 'ENTRADAS - SALIDAS';
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(format(Var_DifEntSal, 2), 36, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );


set Var_Encabezado  := RPAD('', 54, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio );
set Var_Encabezado  := RPAD('', 54, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );
set Var_Encabezado  := RPAD('', 54, ' ');
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Var_Vacio  );

select  NombreCompleto into Var_NomCajero
    from CAJASVENTANILLA Caj,
         USUARIOS Usu
    where Caj.SucursalID    = Var_SucursalCaja
      and Caj.CajaID        = Par_CajaID
      and Caj.UsuarioID     = Usu.UsuarioID;

set Var_NomCajero   := ifnull(Var_NomCajero, Var_Vacio);

set Var_Encabezado  := LPAD(Var_Vacio, 30, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  LPAD(Var_Vacio, 50, '-'));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Estilo_cursiva );

set Var_Encabezado  := LPAD(Var_Vacio, 30, ' ');
set Var_Encabezado  := concat(Var_Encabezado,  RPAD(Var_NomCajero, 50, ' '));
insert TMPARQUEO values(
    Var_Encabezado, Tipo_Detalle,    Estilo_cursiva  );

select  Tmp_Descripcion,    Tmp_Tipo,   Tmp_Estilo
    from TMPARQUEO;

drop table TMPARQUEO;

END TerminaStore$$