-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCONVENSECALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMCONVENSECALT`;DELIMITER $$

CREATE PROCEDURE `PARAMCONVENSECALT`(
	Par_SucursalID		    int(11),
    Par_Fecha           	date,
	Par_CantSocio  		    int(11),
	Par_EsGral				char(1),

    Par_Salida          	char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID		 	int(11),
    Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_DireccionIP			varchar(20),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint(20)
)
TerminaStore: BEGIN


DECLARE Var_Control  	 varchar(200);
DECLARE Var_ConvenSecID	 bigint(20);
DECLARE Var_CantDis 	 int(11);
DECLARE Var_CantPre		 int(11);


DECLARE Entero_Cero     int(11);
DECLARE Decimal_Cero    decimal(12,2);
DECLARE Cadena_Vacia    char(1);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);
DECLARE CantOcupados    int(11);
DECLARE	CantInscri      int(11);
DECLARE ActRegistro     int;


Set Entero_Cero  		:= 0;
Set SalidaSI     		:= 'S';
Set SalidaNO     		:= 'N';
Set Cadena_Vacia 		:='';
Set Decimal_Cero        := 0.0;
Set CantOcupados		:= 0;
Set CantInscri          := 0;
Set ActRegistro         := 1;

ManejoErrores: BEGIN



DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
								 'estamos trabajando para resolverla. Disculpe las molestias que ',
								 'esto le ocasiona. Ref: SP-PARAMCONVENSECALT');
		SET Var_Control = 'sqlException' ;
	END;


	Set Var_ConvenSecID   := (select ifnull(Max(ConvenSecID),Entero_Cero) + 1
	from PARAMCONVENSEC);


	Set Aud_FechaActual :=CURRENT_TIMESTAMP();



	INSERT INTO PARAMCONVENSEC (
			ConvenSecID,		SucursalID,			Fecha,				CantSocio,      EsGral,
			EmpresaID,			Usuario,			FechaActual,		DireccionIP,	ProgramaID,
			Sucursal,			NumTransaccion)

	VALUES (Var_ConvenSecID,	Par_SucursalID,		Par_Fecha,			Par_CantSocio,  Par_EsGral,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

			set Par_NumErr := 000;
			set Par_ErrMen :='Fecha Registrada Exitosamente';
			set Var_Control := 'convenSecID';
			set Entero_Cero := Var_ConvenSecID;


END ManejoErrores;

if (Par_Salida = SalidaSI) then
select  Par_NumErr as NumErr,
		Par_ErrMen as ErrMen,
		Var_Control as control,
		Entero_Cero as consecutivo;
end if;

END TerminaStore$$