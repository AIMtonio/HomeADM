-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROSPECTOSWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSWSALT`;
DELIMITER $$


CREATE PROCEDURE `PROSPECTOSWSALT`(
	Par_InstitNominaID		int,
	Par_NegocioAfiliadoID	int,
	Par_ProspectoIDExt		bigint(20),
	Par_PrimerNom 			varchar(50),
	Par_SegundoNom 			varchar(50),
	Par_TercerNom 			varchar(50),
	Par_ApellidoPat	 		varchar(50),
	Par_ApellidoMat	 		varchar(50),
	Par_Telefono 			char(13),
	Par_Calle 				varchar(50),
	Par_NumExterior 		char(10),

	Par_NumInterior 		char(10),
	Par_Colonia				varchar(200),
	Par_Manzana	 			varchar(20),
	Par_Lote		 		varchar(20),
	Par_LocalidadID			int,
	Par_ColoniaID 			int,
	Par_MunicipioID 		int(11),
	Par_EstadoID 			int(11),
	Par_CP 					varchar(5),
	Par_TipoPersona 		char(1),

	Par_RazonSocial 		varchar(50),
	Par_FechaNacimiento		date,
	Par_RFC 				char(13),
	Par_Sexo				char(1),
	Par_EstadoCivil			char(2),
	Par_Latitud 			varchar(45),
	Par_Longitud			varchar(45),
	Par_TipoDireccionID		int,
    Par_OcupacionID     	int(5),
	Par_Puesto          	varchar(100),

	Par_LugarTrabajo    	varchar(100),
	Par_AntiguedadTra   	decimal(12,2),
	Par_TelTrabajo      	varchar(20),
	Par_Clasificacion   	char(1),
	Par_NoEmpleado      	varchar(20),
    Par_TipoEmpleado    	char(1),
    Par_RFCpm            	char(13),
	Par_ExtTelefonoPart		varchar(6),
	Par_ExtTelefonoTrab		varchar(6),

	Par_Salida              char(1),
	inout Par_NumErr	    int,
	inout Par_ErrMen	    varchar(400),

	Par_EmpresaID        	int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),

    Aud_Sucursal		  	int,
	Aud_NumTransaccion  	bigint
	)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Control            varchar(100);
DECLARE Var_ProspectoID		   int(11);
DECLARE Var_ErrMen			   varchar(400);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    char(1);		-- cadena vacia
DECLARE Entero_Cero     int;			-- entero en cero
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);
DECLARE	Fecha_Vacia		date;
DECLARE PaisMexico		int(11);
DECLARE NacNacional		CHAR(1);
DECLARE Var_PaisInsuf	INT(11);

-- Asignacion de Constantes
Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';
Set	Fecha_Vacia		:= '1900-01-01';
set PaisMexico		:= 700;
set NacNacional		:= 'N';
set Var_ProspectoID := 0;
SET Var_PaisInsuf	:= 999;

  ManejoErrores: BEGIN
		-- Bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
 		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									'estamos trabajando para resolverla. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-PROSPECTOSWSALT');
			SET Var_Control = 'sqlException';
		END;

		CALL PROSPECTOSALT(
		   Par_ProspectoIDExt, 	Par_PrimerNom,  	Par_SegundoNom, 	Par_TercerNom,  Par_ApellidoPat,
		   Par_ApellidoMat,		Par_Telefono,		Par_Calle,			Par_NumExterior,Par_NumInterior,
		   Par_Colonia,			Par_Manzana,		Par_Lote,			Par_LocalidadID,Par_ColoniaID,
		   Par_MunicipioID,		Par_EstadoID,		Par_CP,				Par_TipoPersona,Par_RazonSocial,
		   Par_FechaNacimiento,	Par_RFC,			Par_Sexo,			Par_EstadoCivil,Par_Latitud,
		   Par_Longitud,		Par_TipoDireccionID,Par_OcupacionID,	Par_Puesto,		Par_LugarTrabajo,
		   Par_AntiguedadTra,	Par_TelTrabajo,		Par_Clasificacion,	Par_NoEmpleado,	Par_TipoEmpleado,
		   Par_RFCpm,			Par_ExtTelefonoPart,Par_ExtTelefonoTrab,NacNacional,	PaisMexico,
		   Var_PaisInsuf,		SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
		   Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		   Aud_NumTransaccion);

		if(Par_NumErr <> Entero_Cero) then
			leave ManejoErrores;
		end if;


		set Var_ProspectoID := (select ProspectoID from PROSPECTOS where NumTransaccion = Aud_NumTransaccion);
		if(Par_InstitNominaID > Entero_Cero) then
			CALL NOMINAEMPLEADOSALT(Par_InstitNominaID,		Entero_Cero,		Var_ProspectoID,  Entero_Cero,
									Entero_Cero,			Entero_Cero,		Cadena_Vacia,	  Entero_Cero,
									Cadena_Vacia,			Fecha_Vacia,		Cadena_Vacia,	  SalidaNO,
									Par_NumErr,				Var_ErrMen,			Par_EmpresaID,	  Aud_Usuario,
									Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	  Aud_Sucursal,
									Aud_NumTransaccion

			);
		else if(Par_NegocioAfiliadoID > Entero_Cero) then
			CALL NEGAFILICLIENTEALT(Par_NegocioAfiliadoID,	Entero_Cero, 		Var_ProspectoID,  SalidaNO,
									Par_NumErr,				Var_ErrMen,			Par_EmpresaID,	  Aud_Usuario,
									Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	  Aud_Sucursal,
									Aud_NumTransaccion
			);
		end if;end if;

		if(Par_NumErr <> Entero_Cero) then
			set Par_ErrMen := Var_ErrMen;
			leave ManejoErrores;
		end if;

		set Var_Control = 'prospectoID';

  END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Var_ProspectoID as consecutivo;
end if;


END TerminaStore$$