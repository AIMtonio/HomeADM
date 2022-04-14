-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPENDIENTESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPENDIENTESREP`;DELIMITER $$

CREATE PROCEDURE `DEPENDIENTESREP`(
	Par_Ident			int(20),	-- dato que liga a la consulta de Dependientes economicos
	Par_Tipo			int,		-- tipo de consulta segun el la fuente de datos,Clientes,prospectos Solicitud, Credito, Cuenta, Inversion, Cetes
	Par_Seccion			int,		-- tipo de seccion 0 para obtener la lista completa de dependientes
	Par_Limit			int,		-- Limite de consulta de la lista

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN
/* Declaracion Variables */
	DECLARE Dep_Nombre 		varchar(300);
	DECLARE Dep_Porcentaje 	varchar(300);
	DECLARE Cli_Identi	 	int(11);
	DECLARE Pros_Identi		int(11);
/* Declaracion Constantes */
	DECLARE Entero_Cero    		int;
	DECLARE Decimal_Cero		decimal(12,2);
	DECLARE Cadena_Vacia		char(1);
	DECLARE Tipo_Cliente		int;
	DECLARE Tipo_Prospecto		int;
/* Asignacion de Constantes */
	Set Entero_Cero     	:= 0;
	Set Decimal_Cero		:= 0.00;
	Set Cadena_Vacia		:= '';
	Set Tipo_Cliente		:= 1;
	Set Tipo_Prospecto		:= 2;

	case Par_Tipo
		when Tipo_Cliente then set Cli_Identi = Par_Ident;
		when Tipo_Prospecto then set Pros_Identi = Par_Ident;
		else
			select Cadena_Vacia;
			leave TerminaStore;
	end case;

	select
	sd.DependienteID,		sd.ProspectoID,		sd.ClienteID,		sd.FechaRegistro,	tr.Descripcion as Relacion,
	sd.PrimerNombre,		sd.SegundoNombre,	sd.TercerNombre,	sd.ApellidoPaterno,	sd.ApellidoMaterno,
	concat( trim(	concat(	sd.PrimerNombre,	' ',
							sd.SegundoNombre,	' ',
							sd.TercerNombre)
				),
			' ',
			trim(	concat(	sd.ApellidoPaterno,	' ',
							sd.ApellidoMaterno)
			)
	) as NombreCompleto,	sd.Edad,			sd.OcupacionID,		ocup.Descripcion AS Ocupacion
	from SOCIODEMODEPEND sd
	INNER JOIN OCUPACIONES AS ocup ON sd.OcupacionID = ocup.OcupacionID
	left outer join TIPORELACIONES tr on tr.TipoRelacionID = sd.TipoRelacionID
	where IF(Cli_Identi > 0, sd.ClienteID = Cli_Identi, sd.ProspectoID = Pros_Identi)
	limit Par_Limit;

END TerminaStore$$