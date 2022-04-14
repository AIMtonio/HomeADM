-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGCLIVENGENPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGCLIVENGENPRO`;DELIMITER $$

CREATE PROCEDURE `SEGCLIVENGENPRO`(

	Par_CajaID				int,
	Par_UsuarioID 			int,
	Par_fechaActual			date,
	Par_Salida				char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
)
TerminaStore:BEGIN


declare Var_Seguro			int(11);
declare Var_Poliza 			bigint;
declare Var_Cliente			int;
declare Var_NumMov			int;
declare Var_Cantidad		decimal(12,2);
declare Var_Moneda			int;
declare Var_AltEncPoliz		char(1);
declare Var_SucursalID		int;
declare Var_AltDetPol		char(1);
declare Var_numerr			int;
declare Var_ErrMen			varchar(100);
declare Var_Usuario			int;


declare Entero_Cero			int;
declare Salida_Si			char(1);
declare Salida_No			char(1);
declare Estatus_Vencido		char(1);
declare Estatus_Vigente		char(1);
declare ConstanteSI			char(1);
declare ConstanteUno		int;

DECLARE CURSORVENCIDOS CURSOR FOR
	select	SeguroClienteID, ClienteID, 	Aud_NumTransaccion, MontoSeguro, 	ConstanteUno,
			ConstanteSI,	 Aud_Sucursal,	ConstanteSI,		Par_UsuarioID
	from SEGUROCLIENTE
 	where DATEDIFF(Par_fechaActual , FechaVencimiento)> Entero_Cero
	  AND Estatus = Estatus_Vigente;


set Entero_Cero 	:= 0;
set Salida_Si 		:= 'S';
set Salida_No 		:= 'N';
set Estatus_Vencido := 'B';
set Estatus_Vigente := 'V';
set Var_numerr 		:= 0;
set ConstanteSI		:= 'S';
set ConstanteUno	:= 1;

if  not exists(select UsuarioID from USUARIOS where Par_UsuarioID != UsuarioID) then
	if (Par_Salida = Salida_Si)then
		select
			 '002' as NumErr,
			'El Usuario Selecionado No Existe' as ErrMen,
			'CajaID' as control,
			 Entero_Cero as consecutivo;
	else
		set Par_NumErr 	:= 2;
		set Par_ErrMen	:= 'El Usuario Selecionado No Existe';
	end if;
	LEAVE TerminaStore;
end if;

if exists(
	Select SeguroClienteID from SEGUROCLIENTE where DATEDIFF(DATE(Par_fechaActual), FechaVencimiento)> Entero_Cero and Estatus = Estatus_Vigente
	) then
	 OPEN CURSORVENCIDOS;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
			FETCH CURSORVENCIDOS into
			Var_Seguro,			Var_Cliente,		Var_NumMov,		Var_Cantidad,	Var_Moneda,
			Var_AltEncPoliz,	Var_SucursalID,		Var_AltDetPol,	Var_Usuario;
			 call `SEGUROCLIVENPRO`(
			 	Var_Seguro,		Var_Cliente,	Var_NumMov,		Var_Cantidad,		Var_Moneda,
				Var_AltEncPoliz,Var_SucursalID,	Var_Poliza,		Var_AltDetPol,		Entero_Cero,
				Var_Usuario,	Salida_No,		Var_numerr,		Var_ErrMen,			Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion
			 );
			end LOOP;
		end;
	CLOSE CURSORVENCIDOS;
end if;

if  (ifnull(Var_numerr,Entero_Cero) != Entero_Cero) then
	if (Par_Salida = Salida_Si)then
		select
		 Var_numerr	as NumErr,
		 Var_ErrMen	as ErrMen,
		 'CajaID' 	as control,
		 Entero_Cero as consecutivo;
	else
		set Par_NumErr 	:= Var_numerr;
		set Par_ErrMen	:= Var_ErrMen;
	end if;
	LEAVE TerminaStore;
end if;

if (Par_Salida = Salida_Si)then
	select
		Var_numerr 		as NumErr,
		Var_ErrMen 		as ErrMen,
		'seguroClienteID' as control,
		Entero_Cero 	as consecutivo;
else
	set Par_NumErr 	:= Var_numerr;
	set Par_ErrMen		:= Var_ErrMen;

end if;

END TerminaStore$$