-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACANCSOCMENOR
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACANCSOCMENOR`;DELIMITER $$

CREATE PROCEDURE `POLIZACANCSOCMENOR`(
	Par_FechaOperacion		date,

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN
DECLARE Var_Descripcion		varchar(50);
DECLARE Var_Contador		int(11);
DECLARE Var_Poliza			bigint;
DECLARE Var_SucursalOrigen	int(11);
DECLARE Var_ClienteID		int(11);
DECLARE Var_SaldoAhorro		decimal(14,2);
DECLARE Var_CuentaAhoID		bigint(12);
DECLARE Var_MonedaBase		int(11);
DECLARE Var_EstatusCta			char(1);

DECLARE	Cadena_Vacia		char(1);
DECLARE	Entero_Cero			int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE Fecha_Vacia			date;
DECLARE EsMenor				char(1);
DECLARE TipoInstumentoCta	int(11);
DECLARE ConceptoConta		int(11);
DECLARE Pol_Automatica		char(1);
DECLARE TipoInstumentoCTE	int(11);
DECLARE SalidaNO			char(1);
DECLARE ConceptoCaja		int(11);
DECLARE Par_NumErr			int(11);
DECLARE Par_ErrMen			varchar(500);
DECLARE ConceptoAhorro		int(11);
DECLARE TipoMovAho			int(11);
DECLARE Desc_Inactiva		varchar(100);
DECLARE Cancelada			char(1);
DECLARE Nat_Cargo			char(1);
DECLARE AltaPolizaNO		char(1);
DECLARE AltaDetalle			char(1);
DECLARE Estatus_Desbloqueada char(1);
DECLARE MotivoDesbl			varchar(100);
DECLARE CtaBloqueada		char(1);

DECLARE CUENTACONTABLE CURSOR FOR
	select  Cli.SucursalOrigen,	Cta.ClienteID,	IFNULL(Cta.SaldoAhorro,Decimal_Cero),Cta.CuentaAhoID,ifnull(Cta.EstatusCta,"")
			from CANCSOCMENORCTA Cta
				inner join CLIENTES Cli on Cli.ClienteID=Cta.ClienteID
					where Cta.FechaCancela=Par_FechaOperacion
						and Cta.Aplicado="N" ;



Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
Set	Decimal_Cero			:= 0.0;
Set EsMenor					:="S";
Set TipoInstumentoCTE		:=4;
Set ConceptoConta			:=805;
Set	Pol_Automatica			:='A';
Set SalidaNO				:='N';
set ConceptoCaja			:=8;
set Par_NumErr				:=0;
set Par_ErrMen				:='';
set ConceptoAhorro			:=1;
set Var_Descripcion			:="CANCELACION SOCIO MENOR";
set TipoMovAho				:=400;
set Cancelada				:="C";
set Desc_Inactiva			:= (select  ifnull(Descripcion,Cadena_Vacia) from  MOTIVACTIVACION where MotivoActivaID=11);
set Nat_Cargo				:="C";
set AltaPolizaNO			:="N";
set AltaDetalle				:="S";
set Estatus_Desbloqueada	:="A";
set MotivoDesbl				:="DESBLOQUEO POR CANCELACION AUT. SOCIO MENOR";
SET CtaBloqueada			:="B";

	select MonedaBaseID
		into Var_MonedaBase
		from PARAMETROSSIS;



	select  count(*) into Var_Contador
		from CANCSOCMENORCTA Cta
			inner join CLIENTES Cli on Cli.ClienteID=Cta.ClienteID
				where Cta.FechaCancela=Par_FechaOperacion
					and Cta.Aplicado="N";

	IF Var_Contador>Entero_Cero THEN

		call MAESTROPOLIZAALT(	Var_Poliza,		Par_EmpresaID,      Par_FechaOperacion,     Pol_Automatica,		ConceptoConta,
								Var_Descripcion,SalidaNO,   	    Aud_Usuario,    		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion);


    OPEN CUENTACONTABLE;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP  FETCH CUENTACONTABLE into
			Var_SucursalOrigen,	Var_ClienteID,	Var_SaldoAhorro,Var_CuentaAhoID,Var_EstatusCta;

		set Var_SucursalOrigen	:=(select  Cli.SucursalOrigen
									from CLIENTES Cli where Cli.ClienteID = Var_ClienteID);
			IF Var_EstatusCta=CtaBloqueada then
					update CUENTASAHO set
						   UsuarioDesbID 	= Aud_Usuario,
						   FechaDesbloq	 	= Par_FechaOperacion,
						   MotivoDesbloq 	= MotivoDesbl,
						   Estatus		 	= Estatus_Desbloqueada,

						   EmpresaID		= Par_EmpresaID,
						   Usuario			= Aud_Usuario,
						   FechaActual 		= Aud_FechaActual,
						   DireccionIP 		= Aud_DireccionIP,
					       ProgramaID  		= Aud_ProgramaID,
						   Sucursal			= Aud_Sucursal,
						   NumTransaccion	= Aud_NumTransaccion
						where CuentaAhoID 	= Var_CuentaAhoID;


			END IF;

			IF Var_SaldoAhorro>Decimal_Cero THEN

				call POLIZACAJAPRO(
									Par_EmpresaID,		Var_Poliza,		Par_FechaOperacion,	ConceptoCaja,	Var_ClienteID,
									Var_MonedaBase,		Decimal_Cero,	Var_SaldoAhorro, 	Var_Descripcion,convert(Var_CuentaAhoID, char),
									Var_SucursalOrigen,	Entero_Cero,	TipoInstumentoCTE, 	SalidaNO,		Par_NumErr,
									Par_ErrMen,			Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID,
									Aud_Sucursal, 		Aud_NumTransaccion);



			      call CONTAAHORROPRO(Var_CuentaAhoID,Var_ClienteID,  		Aud_NumTransaccion,  Par_FechaOperacion,	 Par_FechaOperacion,
									  Nat_Cargo,	  Var_SaldoAhorro,		Var_Descripcion,     Var_CuentaAhoID,		 TipoMovAho,
									  Var_MonedaBase, Var_SucursalOrigen,	AltaPolizaNO,		 Entero_Cero,            Var_Poliza,
									  AltaDetalle,	  ConceptoAhorro,		Nat_Cargo,			 Par_NumErr,			 Par_ErrMen,
									  Entero_Cero,	  Par_EmpresaID, 		Aud_Usuario,         Aud_FechaActual,        Aud_DireccionIP,
									  Aud_ProgramaID, Aud_Sucursal,  		Aud_NumTransaccion);

			END IF;


			UPDATE CUENTASAHO
				set
					UsuarioCanID	= Aud_Usuario,
					FechaCan		= Par_FechaOperacion,
					MotivoCan		= Desc_Inactiva,
					Estatus			= Cancelada
				   where CuentaAhoID= Var_CuentaAhoID ;
		END LOOP;
    END;
    CLOSE CUENTACONTABLE;
	END IF;
END$$