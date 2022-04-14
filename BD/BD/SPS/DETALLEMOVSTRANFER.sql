-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEMOVSTRANFER
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEMOVSTRANFER`;DELIMITER $$

CREATE PROCEDURE `DETALLEMOVSTRANFER`(
     Par_SucursalID      int,
    Par_CajaID          int,
    Par_Fecha           date,
    Par_TipoOperacion	int,
    Par_Estatus		char(1),

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
DECLARE Var_Hora		Time;
DECLARE Var_Desc		varchar(200);




DECLARE Entero_Cero     int;
DECLARE Var_Vacio       char(1);
DECLARE Tipo_Encabezado char(1);
DECLARE Tipo_Detalle    char(1);
DECLARE Estilo_cursiva  char(1);
DECLARE Est_Recepcion	char(1);
DECLARE Est_Enviado		char(1);
DECLARE Nat_Entrada     int;
DECLARE Nat_Salida      int;
DECLARE Op_EnvEfecBanc  int;
DECLARE Op_RecEfecBanc  int;
DECLARE Op_EntEfecBanc	int;
DECLARE Op_SalEfecBanc  int;

DECLARE CURSORDETALLEMOVS CURSOR FOR

	select	Cantidad,	concat(IT.NombreCorto, ' - Cta: ', NumCtaInstit )as Referencia,TR.FechaActual

	from TRANSFERBANCO TR,
		INSTITUCIONES IT
	where Fecha = Par_Fecha
	and SucursalID = Var_SucursalCaja
	and CajaID = Par_CajaID
	and Estatus = Par_Estatus
	and IT.InstitucionID = TR.InstitucionID ;



set Entero_Cero     := 0;
set Var_Vacio       := '';
set Tipo_Encabezado := 'E';
set Tipo_Detalle    := 'D';
Set Nat_Entrada     := 1;
Set Nat_Salida      := 2;
Set Est_Recepcion	:= 'R';
Set Est_Enviado		:= 'E';
set Op_EnvEfecBanc  :=42;
set Op_RecEfecBanc  :=16;
set Op_EntEfecBanc	:=41;
set Op_SalEfecBanc  :=36;
DROP TABLE IF EXISTS TMPDETALLEARQ;
CREATE TEMPORARY TABLE TMPDETALLEARQ(
    `Tmp_Descripcion`   varchar(500),
    `Tmp_Tipo`          char(1),
    `Tmp_Estilo`        char(1)
);


CASE Par_TipoOperacion
	WHEN Op_EnvEfecBanc THEN Set Par_Estatus:='E';
	WHEN Op_RecEfecBanc THEN Set Par_Estatus:='R';
	WHEN Op_EntEfecBanc THEN Set Par_Estatus:='E';
	WHEN Op_SalEfecBanc THEN Set Par_Estatus:='R';
END CASE;

select SucursalID into Var_SucursalCaja
		from CAJASVENTANILLA
		where CajaID        =   Par_CajaID;

  select Descripcion into Var_Desc
		from CAJATIPOSOPERA
		 where Numero        =   Par_TipoOperacion;


  insert TMPDETALLEARQ
	select concat('TIRA AUDITORA DEL DIA:  ',Par_Fecha) as Movimiento, Var_Vacio, Var_Vacio;

	insert TMPDETALLEARQ
		select  CASE Par_TipoOperacion
				WHEN Op_EnvEfecBanc	THEN 'ENVIO DE EFECTIVO A BANCOS '
				WHEN Op_RecEfecBanc THEN 'RECEPCION DE EFECTIVO A BANCOS '
				WHEN Op_EntEfecBanc THEN 'ENTRADA POR RECEPCION DE EFECTIVO A BANCOS '
				WHEN Op_SalEfecBanc THEN 'SALIDA POR RECEPCION DE EFECTIVO A BANCOS ' END AS Descripcion,
		Var_Vacio, Var_Vacio
	from CAJATIPOSOPERA CT
			where CT.Numero = Par_TipoOperacion limit 1;

	Set Var_Descripcion := concat('Referencia',LPAD('Hora',40,' '), LPAD('Monto Total', 55, ' '));
	insert TMPDETALLEARQ values(
		Var_Descripcion, Var_Vacio, Var_Vacio);

set Var_MontoTotal := Entero_Cero;

OPEN CURSORDETALLEMOVS;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

    FETCH CURSORDETALLEMOVS into
        Var_Monto,  Var_Referencia,Var_Hora;


		set Var_Descripcion  := Var_Vacio;


		set Var_Descripcion := concat(Var_Descripcion,  RPAD(Var_Referencia, 45, ' '));
		set Var_Descripcion := concat(Var_Descripcion,  RPAD(Var_Hora, 8, ' '));
		set Var_Descripcion := concat(Var_Descripcion,  LPAD(format(Var_Monto, 2), 52, ' '));


		Set Var_MontoTotal := Var_MontoTotal + Var_Monto;

		insert TMPDETALLEARQ values(
			Var_Descripcion, Var_Vacio, Var_Vacio);

	End LOOP;
END;
CLOSE CURSORDETALLEMOVS;
	set Var_Descripcion  := RPAD('', 80, ' ');
	set Var_Descripcion  := concat(Var_Descripcion,  LPAD('', 10, ' '));


	insert TMPDETALLEARQ values(
		Var_Descripcion, Var_Vacio, Var_Vacio);

	set Var_Descripcion  := RPAD('TOTAL ', 70, ' ');
	set Var_Descripcion := concat(Var_Descripcion, LPAD('$',17,' '));
	set Var_Descripcion  := concat(Var_Descripcion,  LPAD(format(Var_MontoTotal, 2), 18, ' '));
	insert TMPDETALLEARQ values(
		Var_Descripcion, Var_Vacio, Var_Vacio  );

	select  Tmp_Descripcion, Tmp_Tipo, Tmp_Estilo
		from TMPDETALLEARQ;

	drop table TMPDETALLEARQ;

END TerminaStore$$