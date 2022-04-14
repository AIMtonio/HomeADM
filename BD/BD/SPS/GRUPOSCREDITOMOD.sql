-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSCREDITOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSCREDITOMOD`;
DELIMITER $$


CREATE PROCEDURE `GRUPOSCREDITOMOD`(

	Par_GrupoID			int(10),
	Par_NombreGrupo		varchar(200),
	Par_SucursalID		int(11),
	Par_CicloActual		int(11),
	Par_EstatusCiclo		char(1),
	Par_FechaUltCiclo		date,
	Par_Salida       	    	char(1),
	inout Par_NumErr 	    	int,
	inout Par_ErrMen 	    	varchar(400),

	Aud_EmpresaID        	int(11),
	Aud_Usuario          	int(11),
	Aud_FechaActual      	datetime,
	Aud_DireccionIP      	varchar(15),
	Aud_ProgramaID       	varchar(50),
	Aud_Sucursal         	int(11),
	Aud_NumTransaccion   	bigint(20)

	)

TerminaStore: BEGIN


DECLARE	Entero_Cero 		int;
DECLARE Cad_Vacia 			char(1);
DECLARE Fecha_Vacia			date;
DECLARE	SalidaSI     		char(1);
DECLARE	SalidaNO     		char(1);
DECLARE	varControl   		char(15);
DECLARE	Var_NomGrupo		char(200);


DECLARE	Var_GrupoID				int(10);
DECLARE	Fecha_REg				datetime;
DECLARE Var_FechaSistema		DATE;		-- Fecha del sistema
DECLARE Var_FechaSistemaHora	DATETIME;	-- Fecha del sistema con Hora

Set Entero_Cero 			:= 0;
Set Cad_Vacia 				:= '';
Set Fecha_Vacia				:= '1900-01-01';
Set	SalidaSI    	    	:= 'S';
Set	SalidaNO    	    	:= 'N';
Set	Var_NomGrupo			:=(select NombreGrupo FROM GRUPOSCREDITO	where NombreGrupo = Par_NombreGrupo
								and SucursalID = Par_SucursalID and GrupoID <> Par_GrupoID);
SET Var_FechaSistema 		:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_FechaSistemaHora 	:= CONCAT(Var_FechaSistema,' ',SUBSTRING(NOW(),12));

		ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-GRUPOSCREDITOMOD");
				END;

						if(ifnull(Par_GrupoID, Entero_Cero)) = Entero_Cero then
							set Par_NumErr :='001';
							set Par_ErrMen := 'El Numero de Grupo esta vacio';
							set varControl:= 'nombreGrupo' ;
							LEAVE ManejoErrores;
						end if;

						if(ifnull(Par_NombreGrupo, Cad_Vacia)) = Cad_Vacia then
							set Par_NumErr :='002';
							set Par_ErrMen := 'El nombre del Grupo esta vacio';
							set varControl:= 'nombreGrupo' ;
							LEAVE ManejoErrores;
						end if;


						if(ifnull(Par_SucursalID, Entero_Cero)) = Entero_Cero then
							set Par_NumErr := '003';
							set Par_ErrMen := 'La Sucursal está vacia';
							set varControl := 'sucursalID';
							LEAVE ManejoErrores;
						end if;



						if(ifnull(Par_EstatusCiclo, Cad_Vacia)) = Cad_Vacia then
							set Par_NumErr := '005';
							set Par_ErrMen := 'El Estado del Ciclo está vacio';
							set varControl := 'estatusCiclo';
							LEAVE ManejoErrores;
						end if;
						if(ifnull(Var_NomGrupo, Cad_Vacia)) <> Cad_Vacia then
							set Par_NumErr := '006';
							set Par_ErrMen := 'El Nombre ya Existe en esta Sucursal';
							set varControl := 'NombreGrupo';
							LEAVE ManejoErrores;
						end if;



Set Fecha_REg := CURRENT_TIMESTAMP();
Set Aud_FechaActual := CURRENT_TIMESTAMP();

	Update GRUPOSCREDITO set

	NombreGrupo		=Par_NombreGrupo,
	SucursalID		=Par_SucursalID,
	CicloActual		=Par_CicloActual,
	EstatusCiclo		=Par_EstatusCiclo,
	FechaUltCiclo		= Var_FechaSistemaHora

	where GrupoID=Par_GrupoID;




set	Par_NumErr := 0;
set	Par_ErrMen := concat("Grupo de Credito Modificado: ",Par_GrupoID);


END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'grupoID' as control,
			Par_GrupoID as consecutivo;
end if;

END TerminaStore$$