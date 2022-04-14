-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITNOMINAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITNOMINAMOD`;
DELIMITER $$


CREATE PROCEDURE `INSTITNOMINAMOD`(
	Par_InstitNominaID		int,
	Par_NombreInstit		varchar(200),
	Par_ClienteID	    	int,
	Par_ContactoRH			varchar(400),
	Par_TelContactoRH		varchar(20),
   Par_ExtTelContacto    varchar(7),
	Par_BancoDeposito		int,
	Par_CuentaDeposito		char(18),
   Par_Correo            varchar(200),
   Par_ReqVerificacion  char(1),
   Par_Domicilio         varchar(200),
   Par_EspCta			CHAR(1), 				-- Especifica Cuenta S:SI/N:NO
	Par_NumCta			VARCHAR(30),			-- Numero de cuenta
	Par_TipoMovID		INT(11),				-- ID del tipo de movimiento
	Par_AplicaTabla		CHAR(1),				-- Indica si aplica tabla real S:SI/N:NO


	Par_Salida				char(1),
	inout Par_NumErr    	int,
	inout Par_ErrMen    	varchar(200),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)

TerminaStore: BEGIN

DECLARE Var_Control         varchar(100);
DECLARE Var_ClienteID       int(11);


DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero			int;
DECLARE SalidaSI 			char(1);
DECLARE CorporativoN     char(1);
DECLARE SocioInd         char(1);


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';
set CorporativoN    :=  'N';
set SocioInd        := 'I';

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-INSTITNOMINAMOD');
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
        set Par_ErrMen  := 'El Numero de Cliente no Existe';
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
SET Var_ClienteID :=  (SELECT ClienteID
                            FROM INSTITNOMINA
                                WHERE InstitNominaID= Par_InstitNominaID);



Set Aud_FechaActual := now();

IF(Par_EspCta = SalidaSI AND IFNULL(Par_NumCta,Cadena_Vacia) = Cadena_Vacia)THEN
	SET Par_NumErr  := 007;
	SET Par_ErrMen  := 'La cuenta contable esta vacia';
	SET Var_Control := 'numCtaContable';
	LEAVE ManejoErrores;
END IF;

IF(Par_EspCta = SalidaSI AND IFNULL(Par_TipoMovID,Entero_Cero) = Entero_Cero)THEN
	SET Par_NumErr  := 008;
	SET Par_ErrMen  := 'El tipo de movimiento esta vacio';
	SET Var_Control := 'tipoMovID';
	LEAVE ManejoErrores;
END IF;

update INSTITNOMINA set
	NombreInstit    	= Par_NombreInstit,
	ClienteID         	= Par_ClienteID,
	ContactoRH			= Par_ContactoRH,
	TelContactoRH		= Par_TelContactoRH,
        ExtTelContacto     = Par_ExtTelContacto,
	BancoDeposito		= Par_BancoDeposito,
	CuentaDeposito	   = Par_CuentaDeposito,
        Domicilio          = Par_Domicilio,
        Correo             = Par_Correo,
        ReqVerificacion    =Par_ReqVerificacion,
        EspCtaCon           = Par_EspCta,
        CtaContable         = Par_NumCta,
        TipoMovID    		= Par_TipoMovID,
        AplicaTabla    		= Par_AplicaTabla,
    

	EmpresaID	    = Par_EmpresaID,
	Usuario	   	    = Aud_Usuario,
	FechaActual 	   = Aud_FechaActual,
	DireccionIP	   = Aud_DireccionIP,
	ProgramaID	   = Aud_ProgramaID,
	Sucursal	   = Aud_Sucursal,
	NumTransaccion	    = Aud_NumTransaccion
	where InstitNominaID = Par_InstitNominaID;

    UPDATE CLIENTES SET
    Clasificacion = CorporativoN
    WHERE ClienteID= Par_ClienteID;

     UPDATE CLIENTES SET
    Clasificacion = SocioInd
    WHERE ClienteID= Var_ClienteID;

		set Par_NumErr  := 000;
        set Par_ErrMen  :=  concat("Institucion de Nomina Modificada Exitosamente: ", convert(Par_InstitNominaID, CHAR));
        set Var_Control := 'institNominaID';
		set Entero_Cero := Par_InstitNominaID;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;
END TerminaStore$$