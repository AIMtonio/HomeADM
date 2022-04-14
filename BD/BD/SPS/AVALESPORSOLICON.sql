-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESPORSOLICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESPORSOLICON`;DELIMITER $$

CREATE PROCEDURE `AVALESPORSOLICON`(

	Par_SolicitudCreditoID	int,
	Par_NumCon				tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN

-- Declaracion de Variables

DECLARE Mes_Consulta 	int;
DECLARE Ano_Consulta 	int;
DECLARE NumAvales		int;
DECLARE	Var_CantAvales	int;
DECLARE Var_CantFilas	int;
DECLARE Var_Vueltas		int;
DECLARE	Var_NumFila		int;
DECLARE	Var_NumColumna	int;
DECLARE PermisoEntrada	int;

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE Con_AvalDirec	int;
DECLARE	Con_Foranea		int;
DECLARE Var_Consecutivo	int;
DECLARE EsOficial		char(1);
DECLARE Con_AvalesFirma int;

-- Asignacion de Constantes
Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Con_Principal		:= 1;
Set Con_AvalDirec		:= 2;
Set Con_AvalesFirma		:= 3;  -- lista especial para reporte de Credito Individual Sacimex para mostrar 3 columnas de registros
Set EsOficial			:= 'S';
Set @Var_Consecutivo    := 0;

	if(Par_NumCon = Con_Principal) then
		select  AP.AvalID, ifnull(C.ClienteID,0) as ClienteID, ifnull(P.ProspectoID,0) as ProspectoID,
			case when  AP.AvalID <> 0  and   AP.ClienteID = 0 and AP.ProspectoID= 0 then
				A.NombreCompleto
			else	case when  AP.AvalID = 0  and   AP.ClienteID <> 0 and AP.ProspectoID= 0 then
				C.NombreCompleto
			else	case when  AP.AvalID = 0  and   AP.ClienteID = 0 and AP.ProspectoID<> 0 then
				P.NombreCompleto
			else	case when  AP.AvalID <> 0  and   AP.ClienteID <> 0 then
				A.NombreCompleto
			else	case when  AP.AvalID <> 0  and   AP.ProspectoID <> 0 then
				A.NombreCompleto end end end end end as Nombre,
				AP.TipoRelacionID as ParentescoID, TR.Descripcion as NombreParentesco,
				AP.TiempoDeConocido as TiempoDeConocido
		from AVALESPORSOLICI AP
		LEFT OUTER JOIN AVALES A on AP.AvalID= A.AvalID
		LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
		INNER JOIN TIPORELACIONES TR ON AP.TipoRelacionID= TR.TipoRelacionID
		WHERE AP.SolicitudCreditoID=Par_SolicitudCreditoID;
	end if;

	if(Par_NumCon = Con_AvalDirec) then
		set NumAvales := (select count(AP.AvalID) from AVALESPORSOLICI AP
		LEFT OUTER JOIN AVALES A on AP.AvalID= A.AvalID
		LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
		LEFT OUTER JOIN DIRECCLIENTE D ON C.ClienteID=D.ClienteID
		WHERE AP.SolicitudCreditoID=Par_SolicitudCreditoID);

		set NumAvales := ifnull(NumAvales,Entero_Cero);

		select  NumAvales, (select  (@Var_Consecutivo := @Var_Consecutivo + 1) ) as Consec_Aval,AP.AvalID, ifnull(C.ClienteID,0) as ClienteID, ifnull(P.ProspectoID,0) as ProspectoID,
			case when  AP.AvalID <> 0  and   AP.ClienteID = 0 and AP.ProspectoID= 0 then
				A.NombreCompleto
			else	case when  AP.AvalID = 0  and   AP.ClienteID <> 0 and AP.ProspectoID= 0 then
				C.NombreCompleto
			else	case when  AP.AvalID = 0  and   AP.ClienteID = 0 and AP.ProspectoID<> 0 then
				P.NombreCompleto
			else	case when  AP.AvalID <> 0  and   AP.ClienteID <> 0 then
				A.NombreCompleto
			else	case when  AP.AvalID <> 0  and   AP.ProspectoID <> 0 then
				A.NombreCompleto end end end end end as Nombre,

			case when  AP.AvalID <> 0  and   AP.ClienteID = 0 and AP.ProspectoID= 0 then
				A.DireccionCompleta
			else	case when  AP.AvalID = 0  and   AP.ClienteID <> 0 and AP.ProspectoID= 0 then
				D.DireccionCompleta
			else	case when  AP.AvalID = 0  and   AP.ClienteID = 0 and AP.ProspectoID<> 0 then
				concat(P.Calle,' ',P.NumExterior,   case when P.NumInterior  > 0
													then concat(' interior ',P.NumInterior,',')
													else ',' end,
													concat(P.Colonia,','), concat('C.P. ',P.CP,', '),
													concat((select Mun.Nombre  from MUNICIPIOSREPUB Mun
													where Mun.EstadoID=P.EstadoID and Mun.MunicipioID=P.MunicipioID),', ',
														(select Est.Nombre  from ESTADOSREPUB Est
														where Est.EstadoID=P.EstadoID)))
			else	case when  AP.AvalID <> 0  and   AP.ClienteID <> 0 then
				A.DireccionCompleta
			else	case when  AP.AvalID <> 0  and   AP.ProspectoID <> 0 then
				A.DireccionCompleta end end end end end as Direccion,
				AP.TipoRelacionID as ParentescoID, TR.Descripcion as NombreParentesco,
				AP.TiempoDeConocido as TiempoDeConocido
		from AVALESPORSOLICI AP
		LEFT OUTER JOIN AVALES A on AP.AvalID= A.AvalID
		LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
		LEFT OUTER JOIN DIRECCLIENTE D ON C.ClienteID=D.ClienteID and D.Oficial = EsOficial
		INNER JOIN TIPORELACIONES TR ON AP.TipoRelacionID= TR.TipoRelacionID
		WHERE AP.SolicitudCreditoID=Par_SolicitudCreditoID;
	end if;

	if(Par_NumCon = Con_AvalesFirma) then

		drop table if exists tmp_AvalesCarat;
		create temporary table tmp_AvalesCarat(	Consecutivo 	int,
												NombreCompleto	varchar(100),
												Primary Key (Consecutivo));

		drop table if exists tmp_AvalesCaratula;
		create temporary table tmp_AvalesCaratula(	Fila 		int auto_increment,
													ConsecCol1	int,
													NombreCol1	varchar(100),
													ConsecCol2	int,
													NombreCol2	varchar(100),
													Primary Key (Fila));
		insert into tmp_AvalesCarat(
			Consecutivo, NombreCompleto
		)select (select  (@Var_Consecutivo := @Var_Consecutivo + 1) ),
		case when  AP.AvalID <> 0  and   AP.ClienteID = 0 and AP.ProspectoID= 0 then
				A.NombreCompleto
			else	case when  AP.AvalID = 0  and   AP.ClienteID <> 0 and AP.ProspectoID= 0 then
				C.NombreCompleto
			else	case when  AP.AvalID = 0  and   AP.ClienteID = 0 and AP.ProspectoID<> 0 then
				P.NombreCompleto
			else	case when  AP.AvalID <> 0  and   AP.ClienteID <> 0 then
				A.NombreCompleto
			else	case when  AP.AvalID <> 0  and   AP.ProspectoID <> 0 then
				A.NombreCompleto end end end end end as Nombre
		from AVALESPORSOLICI AP
		LEFT OUTER JOIN AVALES A on AP.AvalID= A.AvalID
		LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
		LEFT OUTER JOIN DIRECCLIENTE D ON C.ClienteID=D.ClienteID and D.Oficial = EsOficial
		WHERE AP.SolicitudCreditoID=Par_SolicitudCreditoID;

		set	Var_CantAvales	:= (select count(AP.AvalID) from AVALESPORSOLICI AP
								LEFT OUTER JOIN AVALES A on AP.AvalID= A.AvalID
								LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
								LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
								LEFT OUTER JOIN DIRECCLIENTE D ON C.ClienteID=D.ClienteID
								WHERE AP.SolicitudCreditoID=Par_SolicitudCreditoID);

		set Var_CantFilas	:= round(Var_CantAvales/2, 0);
		set	Var_Vueltas 	:= 1;
		set	Var_NumFila		:= 1;
		set	Var_NumColumna	:= 1;
		set PermisoEntrada	:= 1;

	 	WHILE Var_Vueltas <= Var_CantAvales DO

			if Var_NumColumna = 2 then
				update tmp_AvalesCaratula inner join tmp_AvalesCarat on Consecutivo = Var_Vueltas
				set	ConsecCol2 	= Consecutivo,
					NombreCol2	= NombreCompleto
				where Fila = Var_NumFila;
				set PermisoEntrada :=0;
			end if;

			if Var_NumColumna = 1 then
				insert into tmp_AvalesCaratula (Fila, ConsecCol1, NombreCol1)
				select Var_NumFila, Consecutivo, NombreCompleto
				from tmp_AvalesCarat
				  where Consecutivo = Var_Vueltas;
			end if;

			if Var_NumColumna = 2 and  PermisoEntrada = 0 then
					set	Var_NumColumna	:= 0;
					set	Var_NumFila	= Var_NumFila + 1;
					set PermisoEntrada=1;
			end if;

			set Var_NumColumna = Var_NumColumna +1;
			set Var_Vueltas	= Var_Vueltas + 1;

		END WHILE;
		select * from tmp_AvalesCaratula;
		drop table if exists tmp_AvalesCaratula;

	end if ;

END TerminaStore$$