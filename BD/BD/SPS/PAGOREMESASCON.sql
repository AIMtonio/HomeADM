-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOREMESASCON
DELIMITER ;
DROP procedure IF EXISTS `PAGOREMESASCON`;
DELIMITER $$

CREATE PROCEDURE `PAGOREMESASCON`(
	Par_RemesaFolio		varchar(45),
    Par_NumCon			tinyint unsigned,
	
    Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN

-- DECLARACION DE VARIABLES 
DECLARE Var_Sentencia 	TEXT;	-- Almacena la Sentencia de la Consulta
DECLARE Var_Referencia	VARCHAR(45);

-- DECLARACION DE CONSTANTES
DECLARE Entero_Cero			int;
DECLARE Con_Referencia		int;
DECLARE Con_RemPagGen		int;
DECLARE Con_RemPagSal		int;
DECLARE Con_RemPagGenLis	int;
DECLARE Cadena_Vacia		CHAR(1);

-- ASIGNACION DE CONSTANTES
set Entero_Cero			:=0;
set Con_Referencia		:=1;
SET Con_RemPagGen		:=2;
SET Con_RemPagSal		:=3;
SET Con_RemPagGenLis	:=4;
SET Cadena_Vacia		:= '';

-- ASIGNACION DE VARIABLES
SET Var_Sentencia		:= '';

if(Par_NumCon = Con_Referencia)then
	set Var_Referencia	:=(select Remesafolio 
		from PAGOREMESAS where Remesafolio =Par_RemesaFolio limit 1);
        
        select ifnull(Var_Referencia, 0) as Remesafolio;
end if;    

if(Par_NumCon = Con_RemPagGen)then
	select 	PAG.RemesaFolio, PAG.RemesaCatalogoID,	REM.Nombre as NombreRemesadora, 	PAG.Monto ,		PAG.ClienteID, 		
			case when IFNULL(CLI.NombreCompleto,Cadena_Vacia)  =  Cadena_Vacia then PAG.NombreCompleto else CLI.NombreCompleto end as Cliente,
			PAG.UsuarioID, 	 USU.NombreCompleto as Usuario,
			PAG.Direccion,			PAG.NumTelefono, 					PAG.FormaPago,	PAG.NumTransaccion,	Origen AS Origen, 	MON.DescriCorta as moneda,
			PAG.NumeroImpresiones
	from PAGOREMESAS PAG
		INNER JOIN REMESACATALOGO REM ON REM.RemesaCatalogoID = PAG.RemesaCatalogoID
		INNER JOIN USUARIOS USU ON USU.UsuarioID = PAG.UsuarioID 
		INNER JOIN MONEDAS MON ON MON.MonedaId  = PAG.MonedaID 
		LEFT JOIN CLIENTES CLI ON CLI.ClienteID = PAG.ClienteID 
	WHERE PAG.RemesaFolio like Par_RemesaFolio;
end if;    


if(Par_NumCon = Con_RemPagSal)then
	select 	PAG.RemesaFolio, 	PAG.NumTransaccion, 	DEN.DenominacionID,  	DEN.Monto,
			CASE WHEN DEN.Naturaleza = 1 THEN DEN.Cantidad * -1 ELSE DEN.Cantidad END AS Cantidad, CAT.Valor
	from PAGOREMESAS PAG
		INNER JOIN REMESACATALOGO REM ON REM.RemesaCatalogoID = PAG.RemesaCatalogoID
		INNER JOIN DENOMINACIONMOVS DEN ON DEN.NumTransaccion = PAG.NumTransaccion
		INNER JOIN DENOMINACIONES	CAT ON CAT.DenominacionID = DEN.DenominacionID
	WHERE PAG.RemesaFolio like Par_RemesaFolio
	UNION  
	select 	PAG.RemesaFolio, 	PAG.NumTransaccion, 	DEN.DenominacionID,  	DEN.Monto,
			CASE WHEN DEN.Naturaleza = 1 THEN DEN.Cantidad * -1 ELSE DEN.Cantidad END AS Cantidad, CAT.Valor
	from PAGOREMESAS PAG
		INNER JOIN REMESACATALOGO REM ON REM.RemesaCatalogoID = PAG.RemesaCatalogoID
		INNER JOIN `HIS-DENOMMOVS`  DEN ON DEN.NumTransaccion = PAG.NumTransaccion
		INNER JOIN DENOMINACIONES	CAT ON CAT.DenominacionID = DEN.DenominacionID
	WHERE PAG.RemesaFolio like Par_RemesaFolio;

end if;    

if(Par_NumCon = Con_RemPagGenLis)then
	select 	PAG.RemesaFolio, PAG.RemesaCatalogoID,	REM.Nombre as NombreRemesadora, 	PAG.Monto
	from PAGOREMESAS PAG
		INNER JOIN REMESACATALOGO REM ON REM.RemesaCatalogoID = PAG.RemesaCatalogoID
	WHERE PAG.RemesaFolio like CONCAT('%', Par_RemesaFolio, '%') 
	limit 10;
end if;

END TerminaStore$$