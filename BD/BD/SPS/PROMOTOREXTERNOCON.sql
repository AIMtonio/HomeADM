-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTOREXTERNOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMOTOREXTERNOCON`;DELIMITER $$

CREATE PROCEDURE `PROMOTOREXTERNOCON`(
	Par_Numero 		int,
	Par_NumCon 		int,

	Aud_EmpresaID       int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


	DECLARE	Con_Principal	        int;
    DECLARE Con_PromExtSocioMenor   int;
    DECLARE Estatus_Activo          char;
	DECLARE Cadena_Vacia			char(1);
	DECLARE Entero_Cero				int(1);
	DECLARE Var_Estatus				char(1);


	Set	Con_Principal		  	:= 1;
    Set Con_PromExtSocioMenor 	:= 7;
	Set Estatus_Activo        	:='A';
	set Cadena_Vacia			:='';
	set Entero_Cero				:=0;


	if(Par_NumCon = Con_Principal) then
		SELECT
			`Numero`,    `Nombre`,    `Telefono`,    `NumCelular`,    `Correo`,
			`Estatus`,	`ExtTelefono`
		FROM PROMOTOREXTERNO
		WHERE Numero = Par_Numero;

	end if;


	if(Par_NumCon = Con_PromExtSocioMenor) then
		set Var_Estatus :=ifnull((select Estatus
									from PROMOTOREXTERNO
										where Numero = Par_Numero),Cadena_Vacia);
	if(Var_Estatus = Estatus_Activo)then
		select `Numero`, `Nombre`,Var_Estatus
			from PROMOTOREXTERNO
			where  Numero = Par_Numero and Estatus = Estatus_Activo;
	else
			select Numero, Nombre, Var_Estatus
				from PROMOTOREXTERNO
				where  Numero = Par_Numero;
	end if;
end if;


END TerminaStore$$