-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEMOVSCAJA
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEMOVSCAJA`;DELIMITER $$

CREATE PROCEDURE `DETALLEMOVSCAJA`(
	Par_SucursalID      int,
    Par_CajaID          int,
    Par_Fecha           date,
	Par_TipoOperacion	int,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_Monto		varchar(100);
DECLARE Var_Movimiento	varchar(100);
DECLARE Var_Referencia	varchar(100);
DECLARE Var_MontoTotal	decimal(14,2);

DECLARE Var_Encabezado  varchar(400);
DECLARE Var_NumeroMovs  int;
DECLARE Var_MontoMovs   decimal(14,2);
DECLARE Nat_Anterior    int;
DECLARE Var_MontoTotMov decimal(14,2);

DECLARE Var_Numero      int;
DECLARE Var_Descripcion varchar(500);
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

DECLARE CURSORDETALLEMOVS CURSOR FOR
	select MontoEnFirme, CT.Descripcion as Movimiento, CM. Referencia
        from CAJASMOVS CM
		inner join CAJATIPOSOPERA CT on CM.TipoOperacion = CT.Numero
		inner join MONEDAS M on CM.MonedaID = M.MonedaId
        where Fecha         = Par_Fecha
           and SucursalID    = Var_SucursalCaja
          and CajaID        = Par_CajaID
          and TipoOperacion = Par_TipoOperacion;



set Entero_Cero     := 0;
set Var_Vacio       := '';
set Tipo_Encabezado := 'E';
set Tipo_Detalle    := 'D';
Set Nat_Entrada     := 1;
Set Nat_Salida      := 2;

CREATE TEMPORARY TABLE TMPDETALLEARQ(
    `Tmp_Descripcion`   varchar(500),
    `Tmp_Tipo`          char(1),
    `Tmp_Estilo`        char(1)
);


select SucursalID into Var_SucursalCaja
		from CAJASVENTANILLA
		where CajaID        =   Par_CajaID;

	insert TMPDETALLEARQ values(
		Var_Vacio, Var_Vacio, Var_Vacio);


	insert TMPDETALLEARQ
		select CT.Descripcion as Movimiento, Var_Vacio, Var_Vacio
			from CAJASMOVS CM
			inner join CAJATIPOSOPERA CT on CM.TipoOperacion = CT.Numero
			inner join MONEDAS M on CM.MonedaID = M.MonedaId
			where Fecha         = Par_Fecha
			  and SucursalID    = Var_SucursalCaja
			  and CajaID        = Par_CajaID
			  and TipoOperacion = Par_TipoOperacion limit 1;

	Set Var_Descripcion := concat('Referencia', LPAD('Monto Total', 60, ' '));
	insert TMPDETALLEARQ values(
		Var_Descripcion, Var_Vacio, Var_Vacio);


set Var_MontoTotal := Entero_Cero;

OPEN CURSORDETALLEMOVS;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

    FETCH CURSORDETALLEMOVS into
        Var_Monto, Var_Movimiento, Var_Referencia;

		set Var_Descripcion  := Var_Vacio;
		set Var_Descripcion := concat(Var_Descripcion,  RPAD(Var_Referencia, 40, ' '));
		set Var_Descripcion := concat(Var_Descripcion,  LPAD(format(Var_Monto, 2), 30, ' '));


		Set Var_MontoTotal := Var_MontoTotal + Var_Monto;

		insert TMPDETALLEARQ values(
			Var_Descripcion, Var_Vacio, Var_Vacio);

	End LOOP;
END;
CLOSE CURSORDETALLEMOVS;
	set Var_Descripcion  := RPAD('', 60, ' ');
	set Var_Descripcion  := concat(Var_Descripcion,  LPAD('', 10, '-'));
	insert TMPDETALLEARQ values(
		Var_Descripcion, Var_Vacio, Var_Vacio);

	set Var_Descripcion  := RPAD('TOTAL ', 60, ' ');
	set Var_Descripcion  := concat(Var_Descripcion,  LPAD(format(Var_MontoTotal, 2), 10, ' '));
	insert TMPDETALLEARQ values(
		Var_Descripcion, Var_Vacio, Var_Vacio  );

	select  Tmp_Descripcion, Tmp_Tipo, Tmp_Estilo
		from TMPDETALLEARQ;

	drop table TMPDETALLEARQ;

END TerminaStore$$