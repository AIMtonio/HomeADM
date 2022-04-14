-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITNOMINAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITNOMINAALT`;
DELIMITER $$


CREATE PROCEDURE `INSTITNOMINAALT`(
	Par_NombreInstit		varchar(200),
	Par_ClienteID			int,
	Par_ContactoRH			varchar (400),
   	Par_ExtTelContacto    varchar(7),
	Par_TelContactoRH		varchar(20),
	Par_BancoDeposito		int(11),
	Par_CuentaDeposito		char(18),
   Par_Correo            varchar(200),
   Par_ReqVerificacion   char(1),
   Par_Domicilio         varchar(200),
	Par_EspCta			CHAR(1), 				-- Especifica Cuenta S:SI/N:NO
	Par_NumCta			VARCHAR(30),			-- Numero de cuenta
	Par_TipoMovID		INT(11),				-- ID del tipo de movimiento
	Par_AplicaTabla		CHAR(1),				-- Indica si aplica tabla real S:SI/N:NO

	Par_Salida          	char(1),
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

TerminaStore: BEGIN


DECLARE Var_InstitNominaID  varchar(20);
DECLARE Var_Control         varchar(100);


DECLARE Estatus_Activo  char(1);
DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE SalidaSI        char(1);


Set Estatus_Activo  := 'A';
Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				set Par_NumErr = 999;
				set Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
							 "estamos trabajando para resolverla. Disculpe las molestias que ",
							 "esto le ocasiona. Ref: SP-INSTITNOMINAALT');
						SET Var_Control = 'sqlException' ;
			END;



set Par_Correo := ifnull(Par_Correo,Cadena_Vacia);

if(ifnull(Par_NombreInstit,Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 001;
        set Par_ErrMen  := 'El nombre de la institucion esta vacio';
        set Var_Control := 'nombreInstit';
	LEAVE ManejoErrores;
end if;

set Par_ClienteID := ifnull(Par_ClienteID, Entero_Cero);
if (Par_ClienteID != Entero_Cero) then
    if(not exists(select ClienteID
                    from CLIENTES
                        where ClienteID = Par_ClienteID)) then
        set Par_NumErr  := 002;
        set Par_ErrMen  := 'El Cliente no Existe';
        set Var_Control := 'clienteID';
        LEAVE ManejoErrores;
	end if;
end if;

if(ifnull(Par_ContactoRH,Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 003;
        set Par_ErrMen  := 'El nombre del contacto esta vacio';
        set Var_Control := 'contactoRH';
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_TelContactoRH, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 004;
        set Par_ErrMen  := 'El telefono del contacto esta vacio';
        set Var_Control := 'telContactoRH';
	LEAVE ManejoErrores;
end if;

set Par_CuentaDeposito := ifnull(Par_CuentaDeposito, Entero_Cero);
if (Par_CuentaDeposito != Entero_Cero) then
 if(not exists(select NumCtaInstit
                    from CUENTASAHOTESO
                        where NumCtaInstit = Par_CuentaDeposito
							and InstitucionID=Par_BancoDeposito)) then
        set Par_NumErr  := 005;
        set Par_ErrMen  := 'No Existe la Cuenta Bancaria';
        set Var_Control := 'cuentaDeposito';
        LEAVE ManejoErrores;
 end if;
 end if;


if(ifnull(Par_Domicilio, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 006;
        set Par_ErrMen  := 'El Domicilio no Debe Estar Vacio';
        set Var_Control := 'domicilio';
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_ReqVerificacion, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 007;
        set Par_ErrMen  := 'El Tipo de Conciliacion no Debe Estar Vacio';
        set Var_Control := 'reqVerificacion';
	LEAVE ManejoErrores;
end if;

call FOLIOSAPLICAACT('INSTITNOMINA', Var_InstitNominaID);

Set Aud_FechaActual := now();

IF(Par_EspCta = SalidaSI AND IFNULL(Par_NumCta,Cadena_Vacia) = Cadena_Vacia)THEN
	SET Par_NumErr  := 008;
	SET Par_ErrMen  := 'La cuenta contable esta vacia';
	SET Var_Control := 'numCtaContable';
	LEAVE ManejoErrores;
END IF;

IF(Par_EspCta = SalidaSI AND IFNULL(Par_TipoMovID,Entero_Cero) = Entero_Cero)THEN
	SET Par_NumErr  := 009;
	SET Par_ErrMen  := 'El tipo de movimiento esta vacio';
	SET Var_Control := 'tipoMovID';
	LEAVE ManejoErrores;
END IF;


INSERT INTO INSTITNOMINA (
	InstitNominaID,		NombreInstit,		ClienteID,	ContactoRH,		TelContactoRH,
   ExtTelContacto,		BancoDeposito,		CuentaDeposito,		Estatus,     Domicilio,
   ReqVerificacion,		Correo,				EspCtaCon,			CtaContable,	TipoMovID,
   AplicaTabla, 		EmpresaID,		   Usuario,     FechaActual,	DireccionIP,
   ProgramaID,     	Sucursal,		      NumTransaccion)
	VALUES(
    Var_InstitNominaID,    Par_NombreInstit,		Par_ClienteID,		Par_ContactoRH,		Par_TelContactoRH,	
    Par_ExtTelContacto,    Par_BancoDeposito,     Par_CuentaDeposito,		Estatus_Activo,    Par_Domicilio,    
    Par_ReqVerificacion,   Par_Correo,		      Par_EspCta,			Par_NumCta,			Par_TipoMovID,
    Par_AplicaTabla, 		Par_EmpresaID,  	      Aud_Usuario,       Aud_FechaActual,	Aud_DireccionIP,
    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

		set Par_NumErr  := 000;
        set Par_ErrMen  :=  concat("Institucion de Nomina Agregada Exitosamente: ", convert(Var_InstitNominaID, CHAR));
        set Var_Control := 'institNominaID';
		set Entero_Cero := Var_InstitNominaID;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$