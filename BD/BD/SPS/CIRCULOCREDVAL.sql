-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREDVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCREDVAL`;
DELIMITER $$


CREATE PROCEDURE `CIRCULOCREDVAL`(
    Par_ClaveOtorgante		varchar(10),
    Par_NombreUsuario		varchar(12),
    Par_Password			varchar(16),
    Par_FolioConOtor		varchar(25),
	Par_ProductoReq			int,
	Par_TipoCuenta			varchar(2),
	Par_ClaveUniMon			varchar(2),
	Par_ImporteContrato		int(9),
	Par_NumeroFirma			varchar(25),
	Par_ApellidoPaterno		varchar(30),

	Par_ApellidoMaterno		varchar(30),
	Par_Nombres				varchar(50),
	Par_FechaNacimiento		date,
	Par_RFC					varchar(13),
	Par_CURP				varchar(18),
	Par_Residencia			int(1),
	Par_EstadoCivil			char(1),
	Par_Sexo				char(1),
	Par_ClaveIFE			varchar(20),
	Par_NumeroDep			int(2),

	Par_Direccion			varchar(80),
	Par_ColoniaPoblacion	varchar(65),
	Par_DelMunicipio		varchar(65),
	Par_Estado				varchar(4),
	Par_CP					varchar(5),
	Par_NumTelefono			varchar(20),
	Par_TipoDomicilio		char(1),
	Par_NombreEmpresa		varchar(40),
	Par_DireccionEmp		varchar(80),
	Par_ColoniaEmp			varchar(65),

	Par_DelMunicipioEmp		varchar(65),
	Par_EstadoEmp			varchar(4),
	Par_CPEmpleo			varchar(5),
	Par_NumTelefonoEmp		varchar(20),
	Par_Extension			int(8),
	Par_Puesto				varchar(60),
	Par_SalarioMensual		int(9),
	Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350),

	Par_EmpresaID			int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
	)

TerminaStore: BEGIN

DECLARE Var_TipoCta 	varchar(2);
DECLARE Valida_RFC		int;
DECLARE Valida_CURP		char(18);
DECLARE VarControl		char(15);
DECLARE Valida_Estado	char(5);
DECLARE Var_Alfa		char(4);
DECLARE Var_Año 		int;
DECLARE Var_Mes			int;
DECLARE Var_Dia			int;
DECLARE Var_Tamano		int;


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Fecha_Alta		date;
DECLARE	Salida_SI       char(1);
DECLARE	Var_NO			char(1);
DECLARE	Estatus_Activo	char(1);
DECLARE Tel_Vacio		int;


Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;
Set Par_NumErr  		:= 0;
Set Par_ErrMen  		:='DATOS CORRECTOS';
Set Salida_SI			:='S';
Set Var_NO				:='N';
Set	Estatus_Activo		:='A';
Set Tel_Vacio			:='00000';

ManejoErrores:BEGIN









if(ifnull(Par_ClaveOtorgante, Cadena_Vacia) = Cadena_Vacia ) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'La Clave de Otorgante no debe estar vacía.';
		set VarControl   := 'ClaveOtorgante';
		LEAVE ManejoErrores;
end if;

if(ifnull(Par_NombreUsuario, Cadena_Vacia) = Cadena_Vacia ) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'El Nombre de Usuario no debe estar vacío.';
		set VarControl   := 'NombreUsuario';
		LEAVE ManejoErrores;
end if;

if(ifnull(Par_Password, Cadena_Vacia) = Cadena_Vacia ) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'La Contraseña no debe de estar Vacia.';
		set VarControl   := 'Password';
		LEAVE ManejoErrores;
end if;


Set Par_FolioConOtor := ifnull(Par_FolioConOtor, Cadena_Vacia);
if(Par_FolioConOtor = Cadena_Vacia ) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'El Folio de Consulta del Otorgante no debe estar vacío';
		set VarControl   := 'FolioConsultaOtorgante';
		LEAVE ManejoErrores;
end if;
if(length(Par_FolioConOtor)>25 ) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'El Folio de Consulta del Otorgante no debe ser mayor de 25 caracteres';
		set VarControl   := 'FolioConsultaOtorgante';
		LEAVE ManejoErrores;
end if;


Set Par_ProductoReq := ifnull(Par_ProductoReq, Cadena_Vacia);
if(Par_ProductoReq= Cadena_Vacia ) then
		set Par_NumErr   := 02;
		set Par_ErrMen   := 'El Producto requerido está vacío';
		set VarControl   := 'ProductoReq';
		LEAVE ManejoErrores;
end if;


Set Par_TipoCuenta := ifnull(Par_TipoCuenta, Cadena_Vacia);
if(Par_TipoCuenta= Cadena_Vacia ) then
		set Par_NumErr   := 02;
		set Par_ErrMen   := 'El Tipo de Cuenta está vacío';
		set VarControl   := 'TipoCuenta';
		LEAVE ManejoErrores;
else
	Set Var_TipoCta :=(Select TipoContratoCCID from CIRCULOCRETIPCON where TipoContratoCCID= Par_TipoCuenta);
	if (ifnull(Var_TipoCta, Cadena_Vacia) = Cadena_Vacia)then
		set Par_NumErr   := 02;
		set Par_ErrMen   := 'El Tipo de Cuenta es Incorrecto.';
		set VarControl   := 'TipoCuenta';
		LEAVE ManejoErrores;
	end if;
end if;
if(length(Par_TipoCuenta)> 2 ) then
		set Par_NumErr   := 02;
		set Par_ErrMen   := 'El Tipo de Cuenta no debe ser mayor de 2 caracteres';
		set VarControl   := 'TipoCuenta';
		LEAVE ManejoErrores;
end if;



Set Par_ImporteContrato := ifnull(Par_ImporteContrato, Entero_Cero);

if(length(Par_ImporteContrato)>9 ) then
		set Par_NumErr   := 03;
		set Par_ErrMen   := 'El Importe del Contrato no debe rebasar los 9 dígitos permitidos';
		set VarControl   := 'ImporteContrato';
		LEAVE ManejoErrores;
end if;


Set Par_NumeroFirma := ifnull(Par_NumeroFirma, Cadena_Vacia);
if(Par_NumeroFirma = Cadena_Vacia) then
		set Par_NumErr   := 04;
		set Par_ErrMen   := 'El Número de Firma es Incorrecto o está vacío';
		set VarControl   := 'NumeroFirma';
		LEAVE ManejoErrores;
end if;
if(length(Par_NumeroFirma)>25) then
		set Par_NumErr   := 04;
		set Par_ErrMen   := 'El Número de Firma no debe rebasar los 25 dígitos permitidos';
		set VarControl   := 'NumeroFirma';
		LEAVE ManejoErrores;
end if;


Set Par_ApellidoPaterno := ifnull(Par_ApellidoPaterno, Cadena_Vacia);
if(Par_ApellidoPaterno = Cadena_Vacia ) then
		set Par_NumErr   := 05;
		set Par_ErrMen   := 'El Apellido Paterno está vacío';
		set VarControl   := 'ApellidoPaterno';
		LEAVE ManejoErrores;
end if;
if(length(Par_ApellidoPaterno)>30 ) then
		set Par_NumErr   := 05;
		set Par_ErrMen   := 'El Apellido Paterno rebasa los 30 caracteres permitidos';
		set VarControl   := 'ApellidoPaterno';
		LEAVE ManejoErrores;
end if;


Set Par_ApellidoMaterno := ifnull(Par_ApellidoMaterno, Cadena_Vacia);
if(Par_ApellidoMaterno = Cadena_Vacia ) then
		set Par_NumErr   := 05;
		set Par_ErrMen   := 'El Apellido Materno está vacío';
		set VarControl   := 'ApellidoMaterno';
		LEAVE ManejoErrores;
end if;
if(length(Par_ApellidoMaterno)>30 ) then
		set Par_NumErr   := 05;
		set Par_ErrMen   := 'El Apellido Materno rebasa los 30 caracteres permitidos';
		set VarControl   := 'ApellidoMaterno';
		LEAVE ManejoErrores;
end if;


Set Par_Nombres := ifnull(Par_Nombres, Cadena_Vacia);
if(Par_Nombres = Cadena_Vacia) then
		set Par_NumErr   := 07;
		set Par_ErrMen   := 'El Nombre no debe estar vacío';
		set VarControl   := 'Nombres';
		LEAVE ManejoErrores;
end if;
if(length(Par_Nombres)>30 ) then
		set Par_NumErr   := 07;
		set Par_ErrMen   := 'El Nombre no debe rebasar los 30 caracteres';
		set VarControl   := 'Nombres';
		LEAVE ManejoErrores;
end if;


Set Par_FechaNacimiento := ifnull(Par_FechaNacimiento, Cadena_Vacia);
if(Par_FechaNacimiento = Fecha_Vacia ) then
		set Par_NumErr   := 08;
		set Par_ErrMen   := 'La Fecha de Nacimiento está vacía o el Valor es Incorrecto';
		set VarControl   := 'FechaNacimiento';
		LEAVE ManejoErrores;
end if;
if(length(Par_FechaNacimiento)>30 ) then
		set Par_NumErr   := 08;
		set Par_ErrMen   := 'La Fecha de Nacimiento rebasa los 30 caracteres permitidos';
		set VarControl   := 'FechaNacimiento';
		LEAVE ManejoErrores;
end if;


Set Par_RFC := ifnull(Par_RFC, Cadena_Vacia);
if(Par_RFC != Cadena_Vacia)then
	if(length(Par_RFC) >13 ) then
		set Par_NumErr   := 09;
		set Par_ErrMen   := 'El RFC no debe ser mayor a 13 caracteres';
		set VarControl   := 'RFC';
		LEAVE ManejoErrores;
	else
		set Valida_RFC:=(select  count(RFCOficial) from CLIENTES where RFCOficial = Par_RFC);
			if (ifnull(Valida_RFC,0) >1 )then
				set Par_NumErr   := 09;
				set Par_ErrMen   := 'RFC asociado con otro safilocale.cliente';
				set VarControl   := 'RFC';
				LEAVE ManejoErrores;
			end if;
	end if;

	Set Var_Alfa :=SUBSTRING(Par_RFC, 1, 4);
	Set Var_Año  :=SUBSTRING(Par_RFC, 5, 2);
	Set Var_Mes	 :=SUBSTRING(Par_RFC, 7, 2);
	Set Var_Dia	 :=SUBSTRING(Par_RFC, 9, 2);

	if(Var_Año < 0 or Var_Año >99  )then
		set Par_NumErr   := 09;
		set Par_ErrMen   := 'Posiciones 5 y 6 del RFC deben contener un número entre 00 y 99';
		set VarControl   := 'RFC';
		LEAVE ManejoErrores;
	end if;
	if(Var_Mes < 1 or Var_Mes > 12)then
		set Par_NumErr   := 09;
		set Par_ErrMen   := 'Posiciones 7 y 8 del RFC deben contener un número entre 01 y 12';
		set VarControl   := 'RFC';
		LEAVE ManejoErrores;
	end if;
	if(Var_Dia < 1 or Var_Dia > 31)then
		set Par_NumErr   := 09;
		set Par_ErrMen   := 'Posiciones 9 y 10 del RFC deben contener un número entre 01 y 31';
		set VarControl   := 'RFC';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_CURP := ifnull(Par_CURP, Cadena_Vacia);
if(Par_CURP != Cadena_Vacia)then
	if(length(Par_CURP) >18 ) then
		set Par_NumErr   := 10;
		set Par_ErrMen   := 'La CURP no debe ser mayor a 18 caracteres';
		set VarControl   := 'CURP';
		LEAVE ManejoErrores;
	else
		set Valida_CURP:=(select  CURP from CLIENTES where CURP = Par_CURP  and EsMenorEdad='N');
		if (Valida_CURP = Par_CURP)then
			set Par_NumErr   :=10;
			set Par_ErrMen   := 'CURP asociada a otro safilocale.cliente';
			set VarControl   :='CURP';
			LEAVE ManejoErrores;
		end if;
	end if;

	set Valida_CURP:=(select  CURP from CLIENTES where CURP = Par_CURP  and EsMenorEdad='S' and Estatus =Estatus_Activo);
	if (Valida_CURP = Par_CURP)then
		set Par_NumErr   :=10;
		set Par_ErrMen   :='CURP asociada a un safilocale.cliente Menor Activo';
		set VarControl   :='CURP ';
		LEAVE ManejoErrores;
	end if;


	Set Var_Alfa :=SUBSTRING(Par_CURP, 1, 4);
	Set Var_Año  :=SUBSTRING(Par_CURP, 5, 2);
	Set Var_Mes	 :=SUBSTRING(Par_CURP, 7, 2);
	Set Var_Dia	 :=SUBSTRING(Par_CURP, 9, 2);

	if(Var_Año < 0 or Var_Año >99  )then
		set Par_NumErr   := 09;
		set Par_ErrMen   := 'Posiciones 5 y 6 de la CURP deben contener un número entre 00 y 99';
		set VarControl   := 'CURP';
		LEAVE ManejoErrores;
	end if;
	if(Var_Mes < 1 or Var_Mes > 12)then
		set Par_NumErr   := 09;
		set Par_ErrMen   := 'Posiciones 7 y 8 de la CURP deben contener un número entre 01 y 12';
		set VarControl   := 'CURP';
		LEAVE ManejoErrores;
	end if;
	if(Var_Dia < 1 or Var_Dia > 31)then
		set Par_NumErr   := 09;
		set Par_ErrMen   := 'Posiciones 9 y 10 de la CURP deben contener un número entre 01 y 31';
		set VarControl   := 'CURP';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_Residencia := ifnull(Par_Residencia, Entero_Cero);
if(Par_Residencia != Entero_Cero)then
	if(length(Par_Residencia)>1) then
		set Par_NumErr   := 11;
		set Par_ErrMen   := 'La Residencia debe ser sólo un número';
		set VarControl   := 'Residencia';
		LEAVE ManejoErrores;
	end if;
	if(Par_Residencia < 0 or Par_Residencia > 4) then
		set Par_NumErr   := 11;
		set Par_ErrMen   := 'La Residencia tiene un valor incorrecto';
		set VarControl   := 'Residencia';
		LEAVE ManejoErrores;
	end if;
end if;

Set Par_EstadoCivil := ifnull(Par_EstadoCivil, Cadena_Vacia);
if(Par_EstadoCivil != Cadena_Vacia)then
	if(length(Par_EstadoCivil)>1) then
		set Par_NumErr   := 12;
		set Par_ErrMen   := 'El Estado Civil debe ser sólo un caractér';
		set VarControl   := 'EstadoCivil';
		LEAVE ManejoErrores;
	end if;
	if(   Par_EstadoCivil!= 'D' and Par_EstadoCivil != 'L' and Par_EstadoCivil!= 'C' and Par_EstadoCivil!= 'S'
		and Par_EstadoCivil!= 'V' and Par_EstadoCivil!= 'E') then
		set Par_NumErr   := 12;
		set Par_ErrMen   := 'El Estado Civil tiene un valor incorrecto';
		set VarControl   := 'EstadoCivil';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_Sexo := ifnull(Par_Sexo, Cadena_Vacia);
if(Par_Sexo != Cadena_Vacia)then
	if(length(Par_Sexo)>1) then
		set Par_NumErr   := 13;
		set Par_ErrMen   := 'El Sexo debe ser sólo un caractér F ó M';
		set VarControl   := 'Sexo';
		LEAVE ManejoErrores;
	end if;
	if(Par_Sexo!= 'F' and Par_Sexo!= 'M') then
		set Par_NumErr   := 13;
		set Par_ErrMen   := 'El Sexo tiene un valor incorrecto';
		set VarControl   := 'Sexo';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_ClaveIFE := ifnull(Par_ClaveIFE, Cadena_Vacia);
if(Par_ClaveIFE != Cadena_Vacia)then
	if(length(Par_ClaveIFE)>20) then
		set Par_NumErr   := 14;
		set Par_ErrMen   := 'La Clave Electoral no debe ser mayor de 20 caracteres';
		set VarControl   := 'ClaveIF';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_NumeroDep := ifnull(Par_NumeroDep, Entero_Cero);
if(Par_NumeroDep != Cadena_Vacia)then
	if(length(Par_NumeroDep)>2) then
		set Par_NumErr   := 15;
		set Par_ErrMen   := 'El Número de Dependientes no debe contener más de 2 números';
		set VarControl   := 'NumDependientes';
		LEAVE ManejoErrores;
	end if;
	if(Par_NumeroDep < 0) then
		set Par_NumErr   := 15;
		set Par_ErrMen   := 'El Número de Dependientes debe ser mayor o igual a 0';
		set VarControl   := 'NumDependientes';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_Direccion := ifnull(Par_Direccion, Cadena_Vacia);
if(Par_Direccion = Cadena_Vacia) then
		set Par_NumErr   := 16;
		set Par_ErrMen   := 'La Direccion no debe estar vacía';
		set VarControl   := 'Direccion';
		LEAVE ManejoErrores;
end if;
if(length(Par_Direccion) > 80) then
		set Par_NumErr   := 16;
		set Par_ErrMen   := 'La Direccion rebasa los 80 caracteres permitidos';
		set VarControl   := 'Direccion';
		LEAVE ManejoErrores;
end if;


Set Par_ColoniaPoblacion := ifnull(Par_ColoniaPoblacion, Cadena_Vacia);
if(Par_ColoniaPoblacion != Cadena_Vacia)then
	if(length(Par_ColoniaPoblacion)>65) then
		set Par_NumErr   := 17;
		set Par_ErrMen   := 'La Colonia rebasa los 65 caracteres permitidos';
		set VarControl   := 'ColoniaPoblacion';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_DelMunicipio := ifnull(Par_DelMunicipio, Cadena_Vacia);
if(Par_DelMunicipio = Cadena_Vacia) then
		set Par_NumErr   := 18;
		set Par_ErrMen   := 'El Municipio no debe estar vacío';
		set VarControl   := 'Direccion';
		LEAVE ManejoErrores;
end if;
if(length(Par_DelMunicipio)>65) then
		set Par_NumErr   := 18;
		set Par_ErrMen   := 'El Municipio rebasa los 65 caracteres permitidos';
		set VarControl   := 'DelMunicipio';
		LEAVE ManejoErrores;
end if;


Set Par_Estado := ifnull(Par_Estado, Cadena_Vacia);
if(Par_Estado = Cadena_Vacia) then
		set Par_NumErr   := 19;
		set Par_ErrMen   := 'El Estado no debe estar vacío';
		set VarControl   := 'Direccion';
		LEAVE ManejoErrores;
end if;
if(length(Par_Estado) > 4) then
		set Par_NumErr   := 19;
		set Par_ErrMen   := 'El Estado rebasa los 4 caracteres permitidos';
		set VarControl   := 'DelMunicipio';
		LEAVE ManejoErrores;
end if;
if (Par_Estado != Cadena_Vacia)then
	set Valida_Estado:=(select  EqCirCre from ESTADOSREPUB where EqCirCre = Par_Estado);
	if (Valida_Estado != Par_Estado)then
		set Par_NumErr   :=19;
		set Par_ErrMen   :='El Estado es incorrecto';
		set VarControl   :='Estado ';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_CP := ifnull(Par_CP, Cadena_Vacia);
if(Par_CP = Cadena_Vacia) then
		set Par_NumErr   := 20;
		set Par_ErrMen   := 'El Codigo Postal no debe estar vacío';
		set VarControl   := 'CP';
		LEAVE ManejoErrores;
end if;
if(length(Par_CP) > 5) then
		set Par_NumErr   := 20;
		set Par_ErrMen   := 'El CodigoPstal rebasa los 5 caracteres permitidos';
		set VarControl   := 'CP';
		LEAVE ManejoErrores;
end if;


Set Par_NumTelefono := ifnull(Par_NumTelefono, Tel_Vacio);
if(Par_NumTelefono != Cadena_Vacia)then
	if(length(Par_NumTelefono) > 20) then
		set Par_NumErr   := 21;
		set Par_ErrMen   := 'El Numero de Telefono rebasa los 20 dígitos permitidos';
		set VarControl   := 'NumTelefono';
		LEAVE ManejoErrores;
	end if;
	if(length(Par_NumTelefono) < 5) then
		set Par_NumErr   := 21;
		set Par_ErrMen   := 'El Numero de Telefono debe tener 5 dígitos como mínimo';
		set VarControl   := 'NumTelefono';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_TipoDomicilio := ifnull(Par_TipoDomicilio, Cadena_Vacia);
if(Par_TipoDomicilio != Cadena_Vacia)then
	if(length(Par_TipoDomicilio)>1) then
		set Par_NumErr   := 22;
		set Par_ErrMen   := 'El Tipo Domicilio debe ser sólo un caractér';
		set VarControl   := 'TipoDomicilio';
		LEAVE ManejoErrores;
	end if;
	if(	   Par_TipoDomicilio!= 'N' and Par_TipoDomicilio!= 'O' and Par_TipoDomicilio!= 'C'
		and Par_TipoDomicilio!= 'P' and Par_TipoDomicilio!= 'E' ) then
		set Par_NumErr   := 22;
		set Par_ErrMen   := 'El Tipo Domicilio tiene un valor incorrecto';
		set VarControl   := 'TipoDomicilio';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_NombreEmpresa := ifnull(Par_NombreEmpresa, Cadena_Vacia);
if(Par_NombreEmpresa != Cadena_Vacia)then
	if(length(Par_NombreEmpresa)>40) then
		set Par_NumErr   := 23;
		set Par_ErrMen   := 'El Nombre de la Empresa rebasa los 40 caracteres';
		set VarControl   := 'NombreEmpresa';
		LEAVE ManejoErrores;
	end if;
end if;

Set Par_DireccionEmp := ifnull(Par_DireccionEmp, Cadena_Vacia);
if(Par_DireccionEmp != Cadena_Vacia)then
	if(length(Par_DireccionEmp)>80) then
		set Par_NumErr   := 24;
		set Par_ErrMen   := 'La Direccion del Empleo rebasa los 80 caracteres';
		set VarControl   := 'DireccionEmp';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_ColoniaEmp := ifnull(Par_ColoniaEmp, Cadena_Vacia);
if(Par_ColoniaEmp != Cadena_Vacia)then
	if(length(Par_ColoniaEmp)>65) then
		set Par_NumErr   := 25;
		set Par_ErrMen   := 'La Colonia del Empleo rebasa los 65 caracteres permitidos';
		set VarControl   := 'ColoniaEmp';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_DelMunicipioEmp := ifnull(Par_DelMunicipioEmp, Cadena_Vacia);
if(Par_DelMunicipioEmp != Cadena_Vacia)then
	if(length(Par_DelMunicipioEmp)>65) then
		set Par_NumErr   := 26;
		set Par_ErrMen   := 'El Municipio del Empleo rebasa los 65 caracteres permitidos';
		set VarControl   := 'DelMunicipio';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_EstadoEmp := ifnull(Par_EstadoEmp, Cadena_Vacia);
if(Par_EstadoEmp != Cadena_Vacia)then
	if(length(Par_EstadoEmp) > 4) then
		set Par_NumErr   := 27;
		set Par_ErrMen   := 'El Estado del Empleo rebasa los 4 caracteres permitidos';
		set VarControl   := 'DelMunicipio';
		LEAVE ManejoErrores;
	end if;
	set Valida_Estado:=(select  EqCirCre from ESTADOSREPUB where EqCirCre = Par_EstadoEmp);
		if (Valida_Estado != Par_EstadoEmp)then
			set Par_NumErr   :=27;
			set Par_ErrMen   :='El Estado del Empleo es incorrecto';
			set VarControl   :='Estado ';
			LEAVE ManejoErrores;
	end if;
end if;


Set Par_CPEmpleo := ifnull(Par_CPEmpleo, Cadena_Vacia);
if(Par_CPEmpleo != Cadena_Vacia)then
	if(length(Par_CP) > 5) then
		set Par_NumErr   := 28;
		set Par_ErrMen   := 'El Codigo Postal del Empleo rebasa los 5 caracteres permitidos';
		set VarControl   := 'CPEmpleo';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_NumTelefonoEmp := ifnull(Par_NumTelefonoEmp, Tel_Vacio);

if(Par_NumTelefonoEmp != Cadena_Vacia)then
	if(length(Par_NumTelefonoEmp) > 20) then
		set Par_NumErr   := 29;
		set Par_ErrMen   := 'El Numero de Telefono del Empleo rebasa los 20 dígitos permitidos';
		set VarControl   := 'NumTelefonoEmp';
		LEAVE ManejoErrores;
	end if;
	if(length(Par_NumTelefonoEmp) < 5) then
		set Par_NumErr   := 29;
		set Par_ErrMen   := 'El Numero de Telefono del Empleo debe tener 5 dígitos mínimo';
		set VarControl   := 'NumTelefonoEmp';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_Extension := ifnull(Par_Extension, Entero_Cero);
if(Par_Extension != Cadena_Vacia)then
	if(length(Par_Extension) > 8) then
		set Par_NumErr   := 30;
		set Par_ErrMen   := 'El Numero de Extension del Empleo rebasa los 8 dígitos permitidos';
		set VarControl   := 'Extension';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_Puesto := ifnull(Par_Puesto, Cadena_Vacia);
if(Par_Puesto != Cadena_Vacia)then
	if(length(Par_Puesto) > 60) then
		set Par_NumErr   := 31;
		set Par_ErrMen   := 'El Puesto rebasa los 60 caracteres permitidos';
		set VarControl   := 'Puesto';
		LEAVE ManejoErrores;
	end if;
end if;


Set Par_SalarioMensual := ifnull(Par_SalarioMensual, Entero_Cero);
if(Par_SalarioMensual != Entero_Cero)then
	if(length(Par_SalarioMensual)>9 ) then
		set Par_NumErr   := 32;
		set Par_ErrMen   := 'El Salario Mensual rebasa los 9 dígitos permitidos';
		set VarControl   := 'SalarioMensual';
		LEAVE ManejoErrores;
	end if;
end if;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
  IF(Par_NumErr = Entero_Cero) THEN
	SELECT Par_NumErr AS NumErr,
		   Par_ErrMen AS ErrMen,
		   Cadena_Vacia AS control,
		   Cadena_Vacia	 AS consecutivo;
  ELSE
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			varControl AS control,
			varControl	 AS consecutivo;
   END IF;
end IF;

END TerminaStore$$