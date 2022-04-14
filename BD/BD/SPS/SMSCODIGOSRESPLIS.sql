-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCODIGOSRESPLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCODIGOSRESPLIS`;DELIMITER $$

CREATE PROCEDURE `SMSCODIGOSRESPLIS`(
	Par_CampaniaID 		int,
	Par_NumLis			tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Var_NumCodigos	int;
DECLARE	contador		int;
DECLARE	Var_Codigo		varchar(10);
DECLARE	Var_Descrip		varchar(15);




DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal	int;
DECLARE	EstatusActivo	char(1);
DECLARE	Lis_PorCamp		int;
DECLARE	Lis_ResumAct	int;



Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Lis_Principal		:= 1;
Set EstatusActivo		:='A';
Set	Lis_PorCamp			:= 2;
Set	Lis_ResumAct		:= 3;



if(Par_NumLis = Lis_PorCamp) then

select	CodigoRespID,	Descripcion,	CampaniaID
    from SMSCODIGOSRESP
    where CampaniaID = Par_CampaniaID;
end if;


if(Par_NumLis = Lis_ResumAct) then

Create Temporary Table TMPCODIGOS
							(	codigo		varchar(10),
								descripcion varchar(30),
								numero		int);

set contador := 1;

while (select count(CodigoRespID)from	SMSCODIGOSRESP
    where  CampaniaID = Par_CampaniaID)>= contador do

set Var_Codigo:= 0;

set Var_Codigo:= (select CodigoRespID from	SMSCODIGOSRESP
    where  CampaniaID = Par_CampaniaID and Consecutivo=contador);


select c.CodigoRespID, c.Descripcion, count(e.CodigoRespuesta)
into
		Var_Codigo,		Var_Descrip,	Var_NumCodigos
							from SMSENVIOMENSAJE e,
								SMSCODIGOSRESP c
							where e.CampaniaID = Par_CampaniaID
							and e.CampaniaID = c.CampaniaID
							and e.CodigoRespuesta =c.CodigoRespID
							and c.CodigoRespID =Var_Codigo;


insert into TMPCODIGOS (
						codigo,		descripcion,		numero)
						values
						(Var_Codigo,Var_Descrip,		Var_NumCodigos);

set contador := contador+1;
end while;

Set Var_NumCodigos := (
	select count(CodigoRespuesta)
								from SMSENVIOMENSAJE
								where not exists (select CodigoRespID from  SMSCODIGOSRESP
									where CodigoRespuesta =CodigoRespID)
									and  CampaniaID = Par_CampaniaID );
insert into TMPCODIGOS (
						codigo,		descripcion,		numero)
						values
						(Cadena_Vacia,'DESCONOCIDO',		Var_NumCodigos);

select codigo,	descripcion,	numero
 from TMPCODIGOS;

 drop table TMPCODIGOS;
end if;

END TerminaStore$$