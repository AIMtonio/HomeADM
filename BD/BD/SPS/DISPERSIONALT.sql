-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONALT`;DELIMITER $$

CREATE PROCEDURE `DISPERSIONALT`(
	Par_FechaOperacion	DateTime,
	Par_Institucion		int(11),
	Par_CuentaAho			bigint(12),
	Par_NumCtaInstit 		varchar(20),

    Par_Salida 			char(1),
    inout	Par_NumErr	 	int,
    inout	Par_ErrMen	 	varchar(100),

    inout Var_FolioSalida   int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
			)
TerminaStore: BEGIN

	DECLARE	Cadena_Vacia			char(1);
	DECLARE	Entero_Cero			int;
	DECLARE  Var_FolioOperacion	int;
	DECLARE	SalidaSi 			char(1);
	DECLARE	SalidaNo 			char(1);
	DECLARE	EstatusAbierto		char(1);


	DECLARE Var_Institucion	int;
	DECLARE Var_CtaInstitu	varchar(20);


	Set	Cadena_Vacia		:= '';
	Set	Entero_Cero		:= 0;
	Set	SalidaSi 		:= 'S';
	Set	SalidaNo 		:= 'N';
	Set	EstatusAbierto	:= 'A';


BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                     "estamos trabajando para resolverla. Disculpe las molestias que ",
                                     "esto le ocasiona. Ref: SP-DISPERSIONALT");
        END;

	if(ifnull(Par_Institucion, Entero_Cero))= Entero_Cero then

         if(Par_Salida = SalidaSi)then
            select '003' as NumErr,
                 'El numero de institucion esta vacio.' as ErrMen,
                 'institucionID' as control,
			    Var_CtaInstitu as consecutivo;
            LEAVE TerminaStore;
        end if;

        if(Par_Salida = SalidaNo)then
            set Par_NumErr := 2;
            set Par_ErrMen := 'El numero de institucion esta vacio.';
        end if;

	end if;


	Set Var_Institucion := ifnull((select InstitucionID
								from INSTITUCIONES
								where InstitucionID= Par_Institucion ),Entero_Cero);

	if(Par_Salida = SalidaSi) then
		if(ifnull(Var_Institucion,Entero_Cero)) = Entero_Cero then
				select '001' as NumErr,
				'La Institucion especificada no Existe.' as ErrMen,
				'institucionID' as control,
				Par_Institucion as consecutivo;
				LEAVE TerminaStore;
		end if;
	else
		set Par_NumErr := 2;
		set Par_ErrMen := 'La Institucion especificada no Existe"';
	end if;


	Set Var_CtaInstitu := ifnull((select NumCtaInstit
							from CUENTASAHOTESO
							where InstitucionID= Par_Institucion
							and NumCtaInstit= Par_NumCtaInstit),Cadena_Vacia);

	if(ifnull(Var_CtaInstitu,Cadena_Vacia)) = Cadena_Vacia then
		if(Par_Salida = SalidaSi)then
			select '002' as NumErr,
				concat("La Cuenta Bancaria especificada no Existe: ",
				convert(Var_CtaInstitu, CHAR))  as ErrMen,
			    'numCtaInstit' as control,
			    Par_NumCtaInstit as consecutivo;

		else
			set Par_NumErr := 2;
			set Par_ErrMen := 'La Cuenta Bancaria especificada no Existe.';
		end if;
		LEAVE TerminaStore;
	end if;


	Set Par_CuentaAho:= ifnull((select CuentaAhoID
							from CUENTASAHOTESO
							where InstitucionID= Par_Institucion
							and NumCtaInstit= Par_NumCtaInstit),Cadena_Vacia);

	if(ifnull(Par_CuentaAho, Entero_Cero))= Entero_Cero then

		if(Par_Salida = SalidaSi)then
            select '001' as NumErr,
                 'El numero de Cuenta esta vacio.' as ErrMen,
                 'cuentaAhoID' as control,
				Entero_Cero as consecutivo;
            LEAVE TerminaStore;
		end if;

		if(Par_Salida = SalidaNo)then
			set Par_NumErr := 1;
			set Par_ErrMen := 'El numero de Cuenta esta vacio.';
			LEAVE TerminaStore;
		end if;

	end if;




    call FOLIOSAPLICAACT('DISPERSION', Var_FolioOperacion);

    Set Aud_FechaActual := CURRENT_TIMESTAMP();

	INSERT INTO DISPERSION(
			FolioOperacion,		FechaOperacion,		InstitucionID,	CuentaAhoID,		EmpresaID,
			Usuario,				FechaActual,		    	DireccionIP,		ProgramaID,		Sucursal,
			NumTransaccion,		NumCtaInstit,			Estatus)
	VALUES(	Var_FolioOperacion,	Par_FechaOperacion, 	Par_Institucion, 	Par_CuentaAho,   Aud_EmpresaID,
			Aud_Usuario,         	Aud_FechaActual,	    	Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
			Aud_NumTransaccion,	Par_NumCtaInstit,		EstatusAbierto);

	set Par_NumErr := 0;
	set Par_ErrMen := 'Dispersion Agregada...';
	set Var_FolioSalida := Var_FolioOperacion;

END;

if(Par_Salida = SalidaSi)then

    select '000' as NumErr,
            concat("Dispersion Agregada: ",
                convert(Var_FolioOperacion, CHAR))  as ErrMen,
            'folioOperacion' as control,
            Var_FolioOperacion as consecutivo;

end if;

END TerminaStore$$