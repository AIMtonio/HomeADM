-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOANUALTARJETAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOANUALTARJETAPRO`;DELIMITER $$

CREATE PROCEDURE `PAGOANUALTARJETAPRO`(

	Par_TarjetaDebID		char(16),
	Par_SucursalID			int(11),
	Par_CajaID				int(11),
	Par_MontoComision		decimal(14,2),
	Par_MontoIVA			decimal(14,2),
	Par_PolizaID			bigint(20),
	Par_Salida              char(1),
	inout Par_NumErr        int,
	inout Par_ErrMen        varchar(400),

	Par_EmpresaID           int(11),
	Aud_Usuario             int,
	Aud_FechaActual         DateTime,
	Aud_DireccionIP         varchar(15),
	Aud_ProgramaID          varchar(50),
	Aud_Sucursal            int(11),
	Aud_NumTransaccion      bigint(20)
)
TerminaStore:BEGIN
DECLARE Var_FechaSistema	date;
DECLARE Var_TipoTarjeta		int(11);
DECLARE Var_TarDebPagoComID	int(11);
DECLARE Var_MontoTotal		decimal(14,2);
DECLARE Var_ClienteID		int(11);
DECLARE Var_FPagoComAnual	date;
DECLARE Var_FechaActivacion	date;
DECLARE Var_Poliza			bigint(20);


DECLARE Entero_Cero			int(11);
DECLARE Cadena_Vacia		char(1);
DECLARE Cons_FormaPago		CHAR(1);
DECLARE PagadoSI			char(1);
DECLARE Estatus_Activada	INT(11);
DECLARE Estatus_Bloqueado	INT(11);
DECLARE TD_DesBloqueada		INT(11);
DECLARE Fecha_Vacia			date;
DECLARE Con_Meses			INT(11);
DECLARE SalidaSI			char(1);
DECLARE Pol_Automatica			char(1);
DECLARE ConceptoCon			int(11);
DECLARE DescripcionMov		varchar(150);
DECLARE ConceptoTarDeb		int(11);
DECLARE ConceptoTarDebIVA	int(11);
DECLARE Var_MonedaBaseID	int(11);
DECLARE DescripcionMov1		varchar(150);
DECLARE DescripcionMov2		varchar(150);
DECLARE TD_Bloqueada		int(11);
DECLARE SalidaNO			char(1);
DECLARE TipoEvenActTar		int;
DECLARE MotivoActivaTar		int;
DECLARE DescAdicActTar		varchar(60);
DECLARE ProActualiza 		int;


set Entero_Cero			:= 0;
SET Cadena_Vacia		:= '';
SET Cons_FormaPago		:= 'A';
set Pol_Automatica		:= 'A';
SET PagadoSI			:= 'S';
SET Estatus_Activada	:= 7;
SET Estatus_Bloqueado	:= 8;
SET TD_DesBloqueada		:= 14;
SET Fecha_Vacia			:= '1900-01-01';
SET Con_Meses			:= 6;
set SalidaSI			:= 'S';
set ConceptoCon			:= 301;
set DescripcionMov		:= 'COMISION POR ANUALIDAD DE TD';
set ConceptoTarDeb		:= 5;
set ConceptoTarDebIVA	:= 6;
set DescripcionMov1		:= 'COMISION POR ANUALIDAD DE TD';
set DescripcionMov2		:= 'IVA POR OTROS INGRESOS';
set TD_Bloqueada		:= 13;
set SalidaNO			:= 'N';
Set TipoEvenActTar		:= 7;
Set MotivoActivaTar		:= 14;
Set DescAdicActTar		:= 'Pago de Anualidad';
set ProActualiza 		:= 2;

ManejoErrores: BEGIN

	select FechaSistema, MonedaBaseID  into Var_FechaSistema, Var_MonedaBaseID
			from PARAMETROSSIS LIMIT 1;

	select TipoTarjetaDebID, ClienteID, FPagoComAnual,FechaActivacion
			into Var_TipoTarjeta,Var_ClienteID, Var_FPagoComAnual,Var_FechaActivacion
		from TARJETADEBITO
		where TarjetaDebID = Par_TarjetaDebID;


	IF(IFNULL(Var_FPagoComAnual, Fecha_Vacia) = Fecha_Vacia)THEN
		SET Var_FpagoComAnual := DATE_ADD(IFNULL(Var_FechaActivacion ,Fecha_Vacia), INTERVAL Con_Meses MONTH);
	ELSE
		SET Var_FpagoComAnual := DATE_ADD(Var_FpagoComAnual, INTERVAL 1 YEAR);
	END IF;


	IF(Var_FpagoComAnual >  Var_FechaSistema) THEN
		set Par_NumErr 	:=1;
		set Par_ErrMen	:=concat(' La Fecha de Pago de Comision Anual es: ',Var_FpagoComAnual) ;
		LEAVE ManejoErrores;
	END IF;


		IF EXISTS(SELECT TarjetaDebID
					FROM 	TARJETADEBITO
					WHERE TarjetaDebID = Par_TarjetaDebID
					 AND Estatus		= Estatus_Bloqueado
					AND MotivoBloqueo = TD_Bloqueada) THEN
				UPDATE TARJETADEBITO SET
							MotivoDesbloqueo = TD_DesBloqueada,
							FechaDesbloqueo  = Var_FechaSistema,
							Estatus 		  = Estatus_Activada
					WHERE TarjetaDebID = Par_TarjetaDebID;


				INSERT INTO BITACORATARDEB (
					`TarjetaDebID`,		`TipoEvenTDID`,		`MotivoBloqID`,		`DescripAdicio`,	`Fecha`,
					`NombreCliente`,	`EmpresaID`,    	`Usuario`,			`FechaActual`,		`DireccionIP`,
					`ProgramaID`,		`Sucursal`,			`NumTransaccion`)
				VALUES (
					Par_TarjetaDebID, 	TipoEvenActTar, 	MotivoActivaTar, 	DescAdicActTar,		Var_FechaSistema,
					Cadena_Vacia,		Par_EmpresaID,		Aud_Usuario,  		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,   	Aud_Sucursal, 		Aud_NumTransaccion);



		END IF;


	UPDATE TARJETADEBITO SET
			FpagoComAnual = Var_FPagoComAnual,
			PagoComAnual  = PagadoSI
			WHERE TarjetaDebID = Par_TarjetaDebID;

	set Var_MontoTotal = Par_MontoComision+ Par_MontoIVA;

	CALL FOLIOSAPLICAACT('TARDEBPAGOCOM', Var_TarDebPagoComID);


	INSERT INTO TARDEBPAGOCOM (
				TarDebPagoComID,	TarjetaDebID,		ClienteID,			MontoComision,		MontoIVA,
				MontoTotal,			CuentaAhoID,		Fecha,				FormaPago,			CajaID,
				SucursalID,			EmpresaID,			Usuario,			FechaActual,		DireccionIP,
				ProgramaID,			Sucursal,			NumTransaccion)

	VALUES	( Var_TarDebPagoComID,	Par_TarjetaDebID,	Var_ClienteID,		Par_MontoComision, 		Par_MontoIVA,
				Var_MontoTotal,		Entero_Cero,		Var_FechaSistema,	Cons_FormaPago,			Par_CajaID,
				Par_SucursalID,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);





	call POLIZATARJETAPRO(
				Par_PolizaID, 	Par_EmpresaID,			Var_FechaSistema,	Par_TarjetaDebID,	Var_ClienteID,
				ConceptoTarDeb, Var_MonedaBaseID,		Entero_Cero,		Par_MontoComision,	DescripcionMov1,
				Par_CajaID,		Entero_Cero,			SalidaNO,				Par_NumErr,			Par_ErrMen, 		Aud_Usuario,
				Aud_FechaActual,Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			if(Par_NumErr <> Entero_Cero)then
				LEAVE ManejoErrores;
			end if;


	call POLIZATARJETAPRO(
				Par_PolizaID, 		Par_EmpresaID,			Var_FechaSistema,	Par_TarjetaDebID,	Var_ClienteID,
				ConceptoTarDebIVA,	Var_MonedaBaseID,		Entero_Cero,		Par_MontoIVA,		DescripcionMov2,
				Par_CajaID,			Entero_Cero,			SalidaNO,				Par_NumErr,			Par_ErrMen, 		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			if(Par_NumErr <> Entero_Cero)then
				LEAVE ManejoErrores;
			end if;



END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            '' as control,
            Par_PolizaID as consecutivo;
end if;

END TerminaStore$$