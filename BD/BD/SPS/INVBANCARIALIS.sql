-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANCARIALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANCARIALIS`;DELIMITER $$

CREATE PROCEDURE `INVBANCARIALIS`(


	Par_NombreBanco		varchar(50),
	Par_NumLis			tinyint unsigned,
	Aud_EmpresaID		int,
	Aud_Usuario			int,

	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)
TerminaStore: BEGIN


	DECLARE	Lis_Principal 		int;
	DECLARE	EstatusPagada		char(1);
	DECLARE	EstatusCancelada	char(1);
	DECLARE	EstatusAperturada	char(1);


	SET	Lis_Principal		:= 1;
	SET	EstatusPagada		:= 'P';
	SET	EstatusCancelada	:= 'C';
	SET EstatusAperturada	:= 'A';


	if(Par_NumLis = Lis_Principal) then
		SELECT InversionID,ins.Nombre, inv.NumCtaInstit,FORMAT(inv.Monto,2) as Monto, date(FechaVencimiento) AS FechaVencimiento,
			CASE WHEN inv.Estatus = 'P' then 'PAGADA' ELSE
			CASE WHEN inv.Estatus='C' then 'CANCELADA'ELSE
			CASE WHEN inv.Estatus='A' then 'APERTURADA' END END END as Estatus
		FROM INVBANCARIA as inv inner join CUENTASAHOTESO as ca on inv.NumCtaInstit=ca.NumCtaInstit
			inner join INSTITUCIONES as ins on ca.InstitucionID=ins.InstitucionID
		WHERE
			ins.Nombre	like concat("%", Par_NombreBanco, "%")
		ORDER BY FechaInicio, FechaVencimiento, inv.Estatus
			LIMIT 0,15;
	end if;
END TerminaStore$$