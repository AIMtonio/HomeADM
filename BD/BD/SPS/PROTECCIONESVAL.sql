-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROTECCIONESVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROTECCIONESVAL`;DELIMITER $$

CREATE PROCEDURE `PROTECCIONESVAL`(

    Par_ClienteID			int,
    Par_AreaCancela			char(3),
    Par_Salida				char(1),
    inout	Par_NumErr 		int,
    inout	Par_ErrMen  	varchar(350),

    Par_EmpresaID			int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),

    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
		)
TerminaStore: BEGIN


DECLARE VarControl			char(50);
DECLARE VarCantPenAct		decimal(14,2);
DECLARE VarTotalDeudaCre	decimal(14,2);
DECLARE VarSaldoTotalCue	decimal(14,2);
DECLARE Var_MontoPendiente	decimal(14,2);
DECLARE VarSaldoInversion	decimal(14,2);
DECLARE VarNumCreditos		int(11);
DECLARE VarNumInversion		int(11);
DECLARE Var_ClienteID		int(11);
DECLARE Var_ClienteCancel	int(11);
DECLARE VarClienteCancelaID	int(11);
DECLARE VarClienteProfunID	int(11);
DECLARE VarClienteSERVIFUN	int(11);
DECLARE VarClienteProtec	int(11);
DECLARE VarFechaAutProfun	date;
DECLARE VarFechaSistema		date;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE	Salida_SI       	char(1);
DECLARE	Var_AtencioSoc		char(3);
DECLARE	Var_Proteccion		char(3);
DECLARE	Var_Cobranza		char(3);
DECLARE	Est_Registrado		char(1);
DECLARE	Est_Vigente			char(1);
DECLARE	Est_VigenteIn		char(1);
DECLARE	Est_Vencido			char(1);
DECLARE AreaCancelaPro		char(3);


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
Set	Decimal_Cero			:= 0.0;
set Est_Registrado			:= 'R';
set Salida_SI				:= 'S';
set Var_AtencioSoc			:= 'Soc';
set Var_Proteccion			:= 'Pro';
set Var_Cobranza			:= 'Cob';
set Est_Registrado			:= 'R';
set Est_Vigente				:= 'V';
set Est_VigenteIn			:= 'N';
set Est_Vencido				:= 'B';
set AreaCancelaPro			:= 'Pro';



set Par_NumErr  		:= Entero_Cero;
set Par_ErrMen  		:= Cadena_Vacia;
set Aud_FechaActual 	:= now();

ManejoErrores:BEGIN

set Var_ClienteID := (select ClienteID from CLIENTES where ClienteID = Par_ClienteID);
if(ifnull(Var_ClienteID, Entero_Cero) = Entero_Cero) then
	set Par_NumErr   := 04;
	set Par_ErrMen   := 'El safilocale.cliente No Existe';
	set VarControl   := 'clienteID';
	LEAVE ManejoErrores;
end if;

set Var_ClienteCancel :=(select ClienteCancelaID from CLIENTESCANCELA where ClienteID = Par_ClienteID and AreaCancela = AreaCancelaPro);
if(ifnull(Var_ClienteCancel,Entero_Cero) = Entero_Cero) then
	set Par_NumErr   := 01;
	set Par_ErrMen   := concat('El safilocale.cliente no tiene Asignada una Solicitud de Cancelacion.');
	set VarControl   := 'clienteID';
	LEAVE ManejoErrores;
end if;

case Par_AreaCancela
	when Var_AtencioSoc	then
		set Par_NumErr  := 001;
		set Par_ErrMen  := concat('El Area Que Cancela no es Valida.');
		set varControl	:= 'clienteID';
	when Var_Proteccion	then
		set VarFechaSistema		:= (select FechaSistema from PARAMETROSSIS);

		select	ClienteID,			FechaAutoriza
		 into	VarClienteProfunID,	VarFechaAutProfun
			from CLIAPLICAPROFUN
				where 	ClienteID	= Par_ClienteID
				 and 	Estatus		= Est_Registrado;
		set VarClienteProfunID	:= ifnull(VarClienteProfunID, Entero_Cero);
		set VarFechaAutProfun	:= ifnull(VarFechaAutProfun, Fecha_Vacia);

		if(ifnull(VarClienteProfunID,Entero_Cero) != Entero_Cero) then
			set Par_NumErr   := 01;
			set Par_ErrMen   := concat('La Solicitud PROFUN no ha Sido Finalizada.');
			set VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		end if;


		select	ClienteID,			FechaAutoriza
		 into	VarClienteProfunID,	VarFechaAutProfun
			from CLIAPLICAPROFUN
				where 	ClienteID	= Par_ClienteID;
		set VarClienteProfunID	:= ifnull(VarClienteProfunID, Entero_Cero);
		set VarFechaAutProfun	:= ifnull(VarFechaAutProfun, Fecha_Vacia);
		if(VarFechaAutProfun = VarFechaSistema and ifnull(VarClienteProfunID,Entero_Cero) != Entero_Cero )then
			set Par_NumErr   := 01;
			set Par_ErrMen   := concat('Debe pasar al menos un dia de la autorizacion de la solicitud de PROFUN.');
			set VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		end if;

		set VarClienteSERVIFUN	:= (select DifunClienteID from SERVIFUNFOLIOS where DifunClienteID = Par_ClienteID and Estatus ="C");
		set VarClienteSERVIFUN	:= ifnull(VarClienteSERVIFUN, Entero_Cero);
		if(ifnull(VarClienteSERVIFUN,Entero_Cero) != Entero_Cero) then
			set Par_NumErr   := 01;
			set Par_ErrMen   := concat('La Solicitud SERVIFUN no ha Sido Finalizada.');
			set VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		end if;

		set VarClienteProtec	:= (select ClienteID from CLIAPLICAPROTEC where ClienteID =Par_ClienteID  and Estatus = "R");
		set VarClienteProtec	:= ifnull(VarClienteProtec, Entero_Cero);
		if(ifnull(VarClienteProtec,Entero_Cero) != Entero_Cero) then
			set Par_NumErr   := 01;
			set Par_ErrMen   := concat('La Solicitud de Proteccion al Ahorro y Credito no ha Sido Finalizada.');
			set VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		end if;
		set Par_NumErr  := 000;
		set Par_ErrMen  := concat('Validacion Realizada Exitosamente.');
		set varControl	:= 'clienteID';
	when Var_Cobranza	then
		set Par_NumErr  := 001;
		set Par_ErrMen  := concat('El Area Que Cancela no es Valida.');
		set varControl	:= 'clienteID';
	else

		set Par_NumErr  := 1;
		set Par_ErrMen  := concat('El Area Que Cancela no es Valida.');
		set varControl	:= 'areaCancela';
end case ;



END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Par_ClienteID	 AS consecutivo;
end IF;

END TerminaStore$$