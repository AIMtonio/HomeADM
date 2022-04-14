-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOPRO`;
DELIMITER $$


CREATE PROCEDURE `CREDITOFONDEOPRO`(
	Par_SolicitudCredID	bigint,
	Par_CreditoID		bigint,

	Par_FechaOperacion	date,
	Par_FechaAplicacion	date,

	Par_FechaInicio		date,
	Par_FechaVencimiento	date,
	Par_NumCuotas			int,
	Par_NumRetMes			int,
	Par_Poliza			bigint,

out	Par_NumErr			int(11),
out	Par_ErrMen			varchar(100),
out	Par_Consecutivo		bigint,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(20),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN


DECLARE	Var_ClienteID			bigint;
DECLARE	Var_Consecutivo		int;
DECLARE	Var_TasaPasiva		decimal(12,4);
DECLARE	Var_TipoFondeadorID	int;
DECLARE	Var_MontoFondeo		decimal(12,4);
DECLARE	Var_PorcentajeFondeo	decimal(8,6);
DECLARE	Var_MonedaID			int;
DECLARE	Var_PorcentajeMora	decimal(12,4);
DECLARE	Var_PorcentajeComisi	decimal(12,4);
DECLARE	Var_CuentaAhoID		bigint(12);
DECLARE	Var_SucCliente		int;
DECLARE	Var_FolioKubo			varchar(20);
DECLARE	Var_Referencia		varchar(50);



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Sta_ProFondeo		char(1);
DECLARE	Salida_NO		char(1);
DECLARE	For_TasaFija 		int;
DECLARE	Fon_PubInv		int;
DECLARE	Pol_Automatica	char(1);
DECLARE	Tas_BaseVacia		int;
DECLARE	Tas_SobTasCero	decimal(8,4);
DECLARE	Tas_PisoCero		decimal(8,4);
DECLARE	Tas_TechoCero		decimal(8,4);
DECLARE	EstatusVigente	char(1);
DECLARE  Mov_Desbloq		char(1);
DECLARE  Var_FechaSis		date;
DECLARE  Var_TipoBloqID	int;
DECLARE	Var_DescripBlo	varchar(50) ;



DECLARE CURSORSOLICIFON CURSOR FOR
	select	Sol.ClienteID,	Consecutivo,			TasaPasiva,		Tif.TipoFondeadorID,
			MontoFondeo,		PorcentajeFondeo,		MonedaID,		PorcentajeMora,
			PorcentajeComisi,	CuentaAhoID,			Cli.SucursalOrigen
		from FONDEOSOLICITUD Sol,
			 TIPOSFONDEADORES Tif,
			 CLIENTES Cli
		where Sol.SolicitudCreditoID 	= Par_SolicitudCredID
		  and Sol.TipoFondeadorID		= Tif.TipoFondeadorID
		  and Sol.ClienteID			= Cli.ClienteID
		  and Tif.TipoFondeadorID		= 1
		  and Sol.Estatus				= 'F';


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Sta_ProFondeo		= 'F';
Set	Salida_NO		:= 'N';
Set	For_TasaFija		:= 1;
Set	Fon_PubInv		:= 1;
Set	Pol_Automatica	:= 'A';
Set	EstatusVigente	:= 'N';
set	Var_TipoBloqID 	:= 7;


Set	Tas_BaseVacia		:= 0;
Set	Tas_SobTasCero	:= 0.00;
Set	Tas_PisoCero		:= 0.00;
Set	Tas_TechoCero		:= 0.00;
set  Mov_Desbloq		:= 'D';


select Descripcion into Var_DescripBlo from TIPOSBLOQUEOS where TiposBloqID = Var_TipoBloqID;
select FechaSistema 	into Var_FechaSis from PARAMETROSSIS;


OPEN CURSORSOLICIFON;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORSOLICIFON into
		Var_ClienteID,		Var_Consecutivo,		Var_TasaPasiva,	Var_TipoFondeadorID,
		Var_MontoFondeo,		Var_PorcentajeFondeo,	Var_MonedaID,		Var_PorcentajeMora,
		Var_PorcentajeComisi,	Var_CuentaAhoID,		Var_SucCliente;


		set Var_FolioKubo	:= Cadena_Vacia;

		set Var_FolioKubo	:= 	concat(lpad(convert(Par_CreditoID, char), 11, '0'),
								  lpad(convert(Var_Consecutivo, char), 3, '0'));

		set	Var_Referencia	:= convert(Par_CreditoID, char);

        call BLOQUEOSPRO(
            Entero_Cero,        Mov_Desbloq,		Var_CuentaAhoID,    Var_FechaSis,
            Var_MontoFondeo,    Fecha_Vacia,        Var_TipoBloqID,	    Var_DescripBlo,
			Aud_NumTransaccion,     Cadena_Vacia,       Cadena_Vacia,       Salida_NO,
			Par_NumErr, Par_ErrMen, Aud_EmpresaID,          Aud_Usuario,	    Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

		call  CREDITOFONDEOALT (
        Var_InstitutFondeoID,   Var_CuentaAhoID,        Var_FolioKubo,      Entero_Cero,
        Tas_BaseVacia,          Tas_SobTasCero,         For_TasaFija,       Tas_PisoCero,
        Tas_TechoCero,          Entero_Cero,            Var_MontoFondeo,    Var_MonedaID,
        Par_FechaInicio,        Par_FechaVencimiento,   Par_NumCuotas,      Cadena_Vacia,
        Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,       Entero_Cero,
        Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,       Entero_Cero,
        Entero_Cero,            Var_SucCliente,         Par_FechaOperacion, Par_FechaAplicacion,
        Var_Referencia,         Par_NumRetMes,          Par_Poliza,         Salida_NO,
        Par_NumErr,             Par_ErrMen,             Par_Consecutivo,    Aud_EmpresaID,
        Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,           Aud_NumTransaccion  );







	End LOOP;
END;

CLOSE CURSORSOLICIFON;

set Par_NumErr      := '000';
set Par_ErrMen      := 'Proceso de Fondeo Exitoso';
set Par_Consecutivo := Par_CreditoID;

END TerminaStore$$