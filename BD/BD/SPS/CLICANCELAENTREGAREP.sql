-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICANCELAENTREGAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLICANCELAENTREGAREP`;DELIMITER $$

CREATE PROCEDURE `CLICANCELAENTREGAREP`(




	Par_ClienteID			INT(11),
	Par_ClienteCancelaID	int(11),

	Par_NumRep			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Rep_Principal		INT;
DECLARE	Rep_PagoSol			INT;
DECLARE	Est_Pagado			char(1);
DECLARE	Est_Autorizado		char(1);
DECLARE	Est_PagadoDes		varchar(11);
DECLARE	Est_AutorizadoDes	varchar(11);


DECLARE Var_Sentencia		VARCHAR(9000);
DECLARE	Var_FechaSis		DATE;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Rep_Principal		:= 1;
Set	Rep_PagoSol			:= 2;
Set Est_Pagado			:= 'P';
Set Est_Autorizado		:= 'A';
Set Est_PagadoDes		:= 'PAGADO';
Set Est_AutorizadoDes	:= 'AUTORIZADO';


if(Par_NumRep = Rep_Principal) then

	set Var_Sentencia :=  'SELECT Ent.ClienteBenID, Ent.NombreBeneficiario, Ent.Porcentaje, Rel.Descripcion AS Parentesco, Ent.CantidadRecibir, ';
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' case Ent.Estatus ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Autorizado,'"	 then "',Est_AutorizadoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Pagado,'"		 then "',Est_PagadoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' else Ent.Estatus ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' end as Estatus');

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' from CLICANCELAENTREGA Ent
													  left outer join TIPORELACIONES Rel');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' on	Ent.Parentesco = Rel.TipoRelacionID ');


	if(ifnull(Par_ClienteCancelaID,Entero_Cero) != Entero_Cero)then
		set Var_Sentencia :=  CONCAT(Var_Sentencia,' where Ent.ClienteCancelaID = ', Par_ClienteCancelaID);
	end if;

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by  Ent.ClienteBenID;');

	set @Sentencia	= (Var_Sentencia);

	PREPARE STCLICANCELAENTREGAREP FROM @Sentencia;
	EXECUTE STCLICANCELAENTREGAREP;

	DEALLOCATE PREPARE STCLICANCELAENTREGAREP;

end if;


if(Par_NumRep = Rep_PagoSol) then
	select FechaSistema INTO 	Var_FechaSis FROM PARAMETROSSIS;

	SELECT	ClienteCancelaID,		NombreBeneficiario, format(CantidadRecibir,2) as CantidadRecibir,	Var_FechaSis as FechaSistema,  CURTIME() as Hora,
			FUNCIONNUMLETRAS(CantidadRecibir) as MontoEnLetras
		FROM CLICANCELAENTREGA
		WHERE ClienteID	= Par_ClienteID
		AND ClienteCancelaID = Par_ClienteCancelaID;
end if;


END TerminaStore$$