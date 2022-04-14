-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NEGOCIOAFILIADOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `NEGOCIOAFILIADOCON`;DELIMITER $$

CREATE PROCEDURE `NEGOCIOAFILIADOCON`(

	Par_NegocioAfiliadoID 		varchar(200),
	Par_ClienteID				bigint,
	Par_NumCon					tinyint unsigned,


	Par_EmpresaID       		int(11),
	Aud_Usuario         		int,
	Aud_FechaActual     		DateTime,
	Aud_DireccionIP     		varchar(15),
	Aud_ProgramaID      		varchar(50),
	Aud_Sucursal        		int,
	Aud_NumTransaccion  		bigint
	)
TerminaStore : BEGIN


	DECLARE Con_Principal	int;
	DECLARE Con_Promotor	int;
	DECLARE Con_Cte			int(11);


	SET Con_Principal		:=1;
	SET Con_Promotor		:=2;
	SET Con_Cte				:=3;

IF(Par_NumCon = Con_Principal) THEN
	select 	NegocioAfiliadoID, 	RazonSocial, 	RFC, 				DireccionCompleta, 	TelefonoContacto,
			NombreContacto,		Email,			FechaRegistro,		PromotorOrigen,		ClienteID,
			case Estatus 	when "A" then "ALTA"
							when "B" then "BAJA"
							else Estatus end as EstatusDes, 	Estatus
		from NEGOCIOAFILIADO
		where NegocioAfiliadoID = Par_NegocioAfiliadoID;
END IF;

IF(Par_NumCon = Con_Promotor) THEN
	select Prom.PromotorID, Prom.NombrePromotor, Prom.Telefono
	from PROMOTORES Prom
	inner join NEGOCIOAFILIADO Neg on Prom.PromotorID=Neg.PromotorOrigen
	where Neg.NegocioAfiliadoID= Par_NegocioAfiliadoID;
END IF;

IF(Par_NumCon = Con_Cte) THEN
	select NegocioAfiliadoID, RazonSocial
	from NEGOCIOAFILIADO
	where ClienteID= Par_ClienteID;
END IF;

END TerminaStore$$