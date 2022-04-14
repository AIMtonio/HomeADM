-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CAJASARQUEOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-CAJASARQUEOLIS`;DELIMITER $$

CREATE PROCEDURE `HIS-CAJASARQUEOLIS`(
    Par_SucursalID      int,
    Par_CajaID          int,
    Par_Fecha           date,
    Par_Naturaleza	int,
    Par_NumCon          tinyint unsigned,


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
DECLARE VarEstatus		 char(1);
DECLARE EstatusR		 char(1);
DECLARE EstatusE		 char(1);
DECLARE Con_Mov         int;
DECLARE Lis_Fecha		int;


DECLARE CURSORTIPOPE CURSOR FOR
	select  Numero, Descripcion, Naturaleza
		from CAJATIPOSOPERA
		where Naturaleza = Par_Naturaleza
       order by Naturaleza,Orden;


set Entero_Cero     := 0;
set Var_Vacio       := '';
set Tipo_Encabezado := 'E';
set Tipo_Detalle    := 'D';
set Estilo_cursiva  := 'C';
Set Nat_Entrada     := 1;
Set Nat_Salida      := 2;
Set EstatusR		:= 'R';
Set EstatusE		:= 'E';
Set Con_Mov         := 7;
Set Lis_Fecha       := 2;

set Nat_Anterior    := Nat_Entrada;
set Var_MontoTotMov := Entero_Cero;
set Var_DifEntSal   := Entero_Cero;


drop table if exists TMPARQUEO;

CREATE TEMPORARY TABLE TMPARQUEO(
    `Descripcion`   varchar(400),
    `NoMovimiento`  char(3),
    `Monto`         varchar(15),
	`Naturaleza`    varchar(50),
	`Numero`		int
);

Set Var_Descripcion := 'MOVIMIENTOS DE ENTREGA / ORIGEN';
Set Var_NumeroMovs	:= 0;
Set Var_MontoMovs	:= 0.0;
Set Var_Naturaleza	:= 0;


select SucursalID into Var_SucursalCaja
		from CAJASVENTANILLA
		where CajaID        =   Par_CajaID;
if( Con_Mov = Par_NumCon ) then
OPEN CURSORTIPOPE;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

    FETCH CURSORTIPOPE into
        Var_Numero, Var_Descripcion, Var_Naturaleza;

		select count(Transaccion), sum(MontoEnFirme + MontoSBC) into Var_NumeroMovs, Var_MontoMovs
			from `HIS-CAJASMOVS` CM
			where CM.Fecha       = Par_Fecha
			and CM.SucursalID    = Var_SucursalCaja
			and CM.CajaID        = Par_CajaID
			and CM.TipoOperacion = Var_Numero;

		set Var_NumeroMovs  := ifnull(Var_NumeroMovs, Entero_Cero);
		set Var_MontoMovs   := ifnull(Var_MontoMovs, Entero_Cero);

		set Var_MontoTotMov := Var_MontoTotMov + Var_MontoMovs;
		insert TMPARQUEO values(
			Var_Descripcion, Var_NumeroMovs, Var_MontoMovs, Var_Naturaleza, Var_Numero );


	End LOOP;

END;
CLOSE CURSORTIPOPE;

if (Par_Naturaleza = Nat_Entrada)then
			set Var_Descripcion := 'TOTAL ENTRADAS';
		end if;
		if (Par_Naturaleza = Nat_Salida)then
			set Var_Descripcion := 'TOTAL SALIDAS';
		end if;
		insert TMPARQUEO values(
			Var_Descripcion, Var_Vacio, Var_MontoTotMov, Var_Vacio, Entero_Cero);

	select  Descripcion, NoMovimiento, Monto, Naturaleza, Numero
		from TMPARQUEO;

drop table TMPARQUEO;
	end if;
if( Lis_Fecha = Par_NumCon )then
	select distinct Fecha
	from `HIS-CAJASMOVS`
	where Fecha like concat("%",Par_Fecha,"%")
	and 	CajaID =Par_CajaID
	and 	SucursalID = Par_SucursalID
	and	    MonedaID= MonedaID
	limit 0,10;
end if;

END TerminaStore$$