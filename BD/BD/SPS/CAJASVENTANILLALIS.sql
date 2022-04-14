-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASVENTANILLALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASVENTANILLALIS`;DELIMITER $$

CREATE PROCEDURE `CAJASVENTANILLALIS`(
# SP para listar las CAJAS De VENTANILLA
	Par_Descripcion		varchar(50),			-- Descripcion
	Par_SucursalID		int,					-- Sucursal ID
	Par_TipoCaja		char(2),				-- Tipo de Caja
	Par_SucursalOrigen	int,					-- Sucursal de Origen
	Par_CajaIDOrigen	int(11),				-- Caja de Origen

	Par_InstitucionID	int,					-- Numero de Institucion
	Par_NumCtaInstit	bigint,					-- Numero de Cuenta
	Par_NumLis			int,					-- Numero de Lista
	Aud_EmpresaID		int,					-- Auditoria
	Aud_Usuario			int,

	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE	Var_Sentencia	varchar(750);
	DECLARE	Var_Union		varchar(750);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		char(1);
	DECLARE	Fecha_Vacia			date;
	DECLARE	Entero_Cero			int;
	DECLARE EstatusOperaA		char(1);
	DECLARE EstatusA			char(1);
	DECLARE EstatusOperaC		char(1);
	DECLARE	Lis_Principal		int;
	DECLARE	Lis_CajaTransfer 	int;
	DECLARE	Lis_CTxTipoCaja 	int;
	DECLARE	Lis_ComboCaja		int;
	DECLARE	Lis_PorSucursal 	int;
	DECLARE Lis_gridCajas   	int;
	DECLARE	TipoCajaCA			char(2);
	DECLARE	TipoCajaCP			char(2);
	DECLARE	TipoCajaBG			char(2);
	DECLARE	TipoGerente			char(2);
	DECLARE Lis_CajasSucursal	int; -- lista por sucursal y por tipo de Caja
	DECLARE LisComboCP			int;

	-- Asignacion de constantes
	set EstatusOperaA		:= 'A';	-- EstatusOpera A de aperturado
	set EstatusA			:= 'A';	-- EstatusOpera A de aperturado
	set EstatusOperaC		:='C';	-- EstatusOpera C de cerrado
	set Lis_CajaTransfer	:= 1;
	set Lis_Principal		:= 2;
	set Lis_ComboCaja 		:= 3;
	set Lis_CTxTipoCaja 	:= 5;	-- el numero 4 lo usan en el dao, consulta por el tipo de caja que esta consultando y el alcance que tiene para observar otras cajas
	set Lis_PorSucursal 	:= 6; -- en consulta las cajas por sucursal
	set Entero_Cero			:= 0;
	set TipoCajaCA 			:='CA'; -- Caja de Atencion al Publico
	set TipoCajaCP 			:='CP'; -- Caja Principal de Sucursal
	set	TipoGerente			:= 'GE';
	set TipoCajaBG 			:='BG'; -- Boveda Central
	set Cadena_Vacia		:='';
	set Lis_CajasSucursal	:=7;	-- Lista por Sucursal y por tipo de Caja
	Set Lis_gridCajas 		:=  8;		-- Lista para grid de Tesoreria
	set LisComboCP			:=9;		-- Lista Combo de Cajas principales

	if(Par_NumLis = Lis_Principal) then
		select CajaID, CASE TipoCaja
					when 'CA' THEN 'Caja de Atencion al Publico'
					when 'CP' THEN 'Caja Principal de Sucursal'
					when 'BG' THEN 'Boveda Central'
				END AS TipoCaja, DescripcionCaja
		from CAJASVENTANILLA
		where DescripcionCaja like concat("%", Par_Descripcion, "%%") order by CajaID limit 0,15;
	end if;

	if (Par_NumLis = Lis_CajaTransfer) then
		if(Par_TipoCaja != '')then
			set Var_Sentencia := 'select CajaID, CASE TipoCaja when "CA" THEN "Caja de Atencion al Publico" when "CP" THEN "Caja Principal de Sucursal" when "BG" THEN "Boveda Central" END AS TipoCaja, DescripcionCaja from CAJASVENTANILLA where ';
			if (Par_TipoCaja = TipoCajaCA)then
				if (Par_SucursalID != Par_SucursalOrigen AND Par_SucursalID != 0)then
					Set Par_SucursalOrigen := 0;
				end if;
				set Var_Sentencia :=  CONCAT(Var_Sentencia, ' SucursalID = ',convert(Par_SucursalOrigen ,char), ' AND TipoCaja != "BG" AND DescripcionCaja like "%',convert(Par_Descripcion,char), '%" limit 0, 15;');
			end if;
			if (Par_TipoCaja = TipoCajaCP) then
				set Var_Union := CONCAT('(', Var_Sentencia);
				if (Par_SucursalID != Entero_Cero)then
					set Var_Sentencia := concat('(', Var_Sentencia,' TipoCaja = "CA" AND SucursalID = ',convert(Par_SucursalOrigen, char), ' and DescripcionCaja like "%',convert(Par_Descripcion,char), '%" limit 0,15 ');
					set Var_Union := concat(Var_Union, ' TipoCaja != "CA" and SucursalID = ',convert(Par_SucursalID,char),' and DescripcionCaja like "%', convert(Par_Descripcion, char),'%" limit 0, 15');
				else
					set Var_Sentencia := concat('(', Var_Sentencia,' TipoCaja = "CA" AND SucursalID = ',convert(Par_SucursalOrigen, char), ' and DescripcionCaja like "%',convert(Par_Descripcion,char), '%" limit 0,15 ');
					set Var_Union := concat(Var_Union, ' TipoCaja != "CA" and DescripcionCaja like "%', convert(Par_Descripcion, char),'%" limit 0, 15');
				end if;
				set Var_Sentencia := concat(Var_Sentencia, ') UNION ', Var_Union, ');');
			end if;

			if (Par_TipoCaja = TipoCajaBG) then
				if (Par_SucursalID != Entero_Cero)then
					set Var_Sentencia :=  CONCAT(Var_Sentencia, ' SucursalID = ',convert(Par_SucursalID, char) , ' AND TipoCaja  != "CA" AND DescripcionCaja like "%', convert(Par_Descripcion, char) , '%" limit 0, 15;');
				else
					set Var_Sentencia :=  CONCAT(Var_Sentencia, ' TipoCaja != "CA" AND DescripcionCaja like "%', convert(Par_Descripcion, char), '%" limit 0, 15;');
				end if;
			end if;
			SET @Sentencia	= Var_Sentencia;
			PREPARE STCAJASVENTANILLALIS FROM @Sentencia;
			EXECUTE STCAJASVENTANILLALIS;
			DEALLOCATE PREPARE STCAJASVENTANILLALIS;
		else
				if(Par_SucursalID > 0)then
					select Caj.CajaID, CASE Caj.TipoCaja when "CA" THEN "Caja de Atencion al Publico"
												when "CP" THEN "Caja Principal de Sucursal" when "BG"
												THEN "Boveda Central" END AS TipoCaja,
						concat(Caj.DescripcionCaja, ' - ', Usu.NombreCompleto) as DescripcionCaja
					from CAJASVENTANILLA Caj
						inner join USUARIOS Usu on Usu.UsuarioID = Caj.UsuarioID
					where  Caj.DescripcionCaja like concat('%', Par_Descripcion, '%')
					and Caj.SucursalID = Par_SucursalID
					limit 15;
				else
					select Caj.CajaID, CASE Caj.TipoCaja when "CA" THEN "Caja de Atencion al Publico"
												when "CP" THEN "Caja Principal de Sucursal" when "BG"
												THEN "Boveda Central" END AS TipoCaja,
						concat(Caj.DescripcionCaja, ' - ', Usu.NombreCompleto) as DescripcionCaja
					from CAJASVENTANILLA Caj
						inner join USUARIOS Usu on Usu.UsuarioID = Caj.UsuarioID
					where  Caj.DescripcionCaja like concat('%', Par_Descripcion, '%')
					limit 15;
				end if;
		end if;
	end if;



	if(Par_NumLis=Lis_ComboCaja)then
		set Var_Sentencia := 'select cv.CajaID, CONCAT(sc.NombreSucurs,"-",cv.DescripcionCaja,"-",us.NombreCompleto ) from CAJASVENTANILLA cv, SUCURSALES sc, USUARIOS us where sc.SucursalID = cv.SucursalID AND us.UsuarioID = cv.UsuarioID AND ';

		if(ifnull(Par_TipoCaja,Cadena_Vacia) =Cadena_Vacia)then
			set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.TipoCaja = "CP" AND ');
		else
			if(Par_TipoCaja = TipoCajaBG )then
				if(Par_SucursalID != 0)then
				set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.TipoCaja = "CP" AND ');
				end if;
			end if;
			if(Par_TipoCaja = TipoGerente )then
				if (select count(CajaID) from CAJASVENTANILLA where SucursalID = Par_SucursalOrigen and  Estatus = 'A' and TipoCaja = 'CP')> 1 then
					set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.TipoCaja = "CP" AND ');
				else
					set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.TipoCaja = "CP" AND cv.EstatusOpera = "C" AND ');
				end if;
			end if;

			if(Par_TipoCaja = TipoCajaCP)then
				set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.TipoCaja = "CA" AND ');
			end if;
			if(Par_TipoCaja = TipoCajaCA)then
			set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.CajaID = ',  convert(Par_SucursalID, char) ,' AND ');
			end if;
			if(Par_Descripcion = EstatusOperaA )then
			set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.EstatusOpera = "A" AND ');
			end if;
			if(Par_Descripcion = EstatusOperaC )then
			set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.EstatusOpera = "C" AND ');
			end if;
		end if;

		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' cv.SucursalID = ',convert(Par_SucursalOrigen, char) , ' AND cv.Estatus = "A";');
		SET @Sentencia	= Var_Sentencia;

		PREPARE STCAJASVENTANILLALIS FROM @Sentencia;
		EXECUTE STCAJASVENTANILLALIS;
		DEALLOCATE PREPARE STCAJASVENTANILLALIS;

	end if;



	if (Par_NumLis = Lis_CTxTipoCaja) then
		if (Par_TipoCaja = TipoCajaCA) then
			select Caj.CajaID,
					CASE 	Caj.TipoCaja
					when "CA" THEN "Caja de Atencion al Publico"
					when "CP" THEN "Caja Principal de Sucursal"
					when "BG" THEN "Boveda Central"
					END AS TipoCaja,
					concat(Caj.DescripcionCaja, ' - ', Usu.NombreCompleto) as DescripcionCaja
			from CAJASVENTANILLA Caj
			inner join USUARIOS Usu on Usu.UsuarioID = Caj.UsuarioID
			where Par_SucursalID  = Caj.SucursalID
			and Caj.CajaID != Par_CajaIDOrigen
			AND Caj.TipoCaja != TipoCajaBG
			AND Caj.EstatusOpera = EstatusOperaA
			AND Caj.Estatus = EstatusA
			AND Caj.DescripcionCaja like concat('%',Par_Descripcion,'%');
		end if;


		if (Par_TipoCaja = TipoCajaCP) then

			(select Caj.CajaID,
					CASE 	Caj.TipoCaja
					when "CA" THEN "Caja de Atencion al Publico"
					when "CP" THEN "Caja Principal de Sucursal"
					when "BG" THEN "Boveda Central"
					END AS TipoCaja,
					concat(Caj.DescripcionCaja, ' - ', Usu.NombreCompleto) as DescripcionCaja
			from CAJASVENTANILLA Caj
			inner join USUARIOS Usu on Usu.UsuarioID = Caj.UsuarioID
			where Par_SucursalOrigen  = Caj.SucursalID
				and Par_SucursalID  = Caj.SucursalID
				and Caj.CajaID != Par_CajaIDOrigen
				AND Caj.TipoCaja = TipoCajaCA
				AND Caj.TipoCaja != TipoCajaCP
				AND Caj.EstatusOpera = EstatusOperaA
				AND Caj.Estatus = EstatusA
				AND Caj.DescripcionCaja like concat('%',Par_Descripcion,'%'))
			UNION
			(select Caj.CajaID,
					CASE 	Caj.TipoCaja
					when "CA" THEN "Caja de Atencion al Publico"
					when "CP" THEN "Caja Principal de Sucursal"
					when "BG" THEN "Boveda Central"
					END AS TipoCaja,
					concat(Caj.DescripcionCaja, ' - ', Usu.NombreCompleto) as DescripcionCaja
			from CAJASVENTANILLA Caj
			inner join USUARIOS Usu on Usu.UsuarioID = Caj.UsuarioID
			where Par_SucursalID  = Caj.SucursalID
				and Caj.CajaID != Par_CajaIDOrigen
				AND (Caj.TipoCaja = TipoCajaBG or Caj.TipoCaja = TipoCajaCP)
				AND Caj.EstatusOpera = EstatusOperaA
				AND Caj.Estatus = EstatusA
				AND Caj.DescripcionCaja like concat('%',Par_Descripcion,'%'));
		end if;
		if (Par_TipoCaja = TipoCajaBG) then
			(select CajaID,
					CASE 	TipoCaja
					when "CA" THEN "Caja de Atencion al Publico"
					when "CP" THEN "Caja Principal de Sucursal"
					when "BG" THEN "Boveda Central"
					END AS TipoCaja,
					DescripcionCaja
			from CAJASVENTANILLA
			where Par_SucursalID  = SucursalID
				AND TipoCaja != TipoCajaCA
				AND TipoCaja != TipoCajaBG
				AND EstatusOpera = EstatusOperaA
				AND Estatus = EstatusA
				AND DescripcionCaja like concat('%',Par_Descripcion,'%'))
			UNION
			(select CajaID,
					CASE 	TipoCaja
					when "CA" THEN "Caja de Atencion al Publico"
					when "CP" THEN "Caja Principal de Sucursal"
					when "BG" THEN "Boveda Central"
					END AS TipoCaja,
					DescripcionCaja
			from CAJASVENTANILLA
			where Par_SucursalID  != SucursalID
				AND TipoCaja != TipoCajaCA
				AND EstatusOpera = EstatusOperaA
				AND Estatus = EstatusA
				AND DescripcionCaja like concat('%',Par_Descripcion,'%'));
		end if;


	end if;

	if(Par_NumLis = Lis_PorSucursal) then
		select Caj.CajaID, CASE Caj.TipoCaja
					when 'CA' THEN 'Caja de Atencion al Publico'
					when 'CP' THEN 'Caja Principal de Sucursal'
					when 'BG' THEN 'Boveda Central'
				END AS TipoCaja, concat(Caj.DescripcionCaja, ' - ', Usu.NombreCompleto) as DescripcionCaja
		from CAJASVENTANILLA Caj
		inner join USUARIOS Usu on Usu.UsuarioID = Caj.UsuarioID
		where Par_SucursalID = Caj.SucursalID
		AND	Caj.DescripcionCaja like concat("%", Par_Descripcion, "%%") order by CajaID limit 0,15;
	end if;

	if(Par_NumLis =Lis_CajasSucursal)then
		select cv.CajaID, CONCAT(sc.NombreSucurs,"-",cv.DescripcionCaja,"-",us.NombreCompleto )
		from CAJASVENTANILLA cv,
			SUCURSALES sc,
			USUARIOS us
			where sc.SucursalID = cv.SucursalID
			AND us.UsuarioID = cv.UsuarioID
			and  cv.Estatus = 'A'
			and sc.SucursalID	= Par_SucursalOrigen;
	end if;

	if (Par_NumLis = Lis_gridCajas) then
		select cv.CajaID, cv.SucursalID, CASE cv.TipoCaja
										when 'CA' THEN 'Caja de Atencion al Publico'
										when 'CP' THEN 'Caja Principal de Sucursal'
										when 'BG' THEN 'Boveda Central'
										END AS TipoCaja, cc.Estatus
		from CAJASVENTANILLA cv
			inner join SUCURSALES sc
				on sc.SucursalID = cv.SucursalID
				and sc.SucursalID	= Par_SucursalID
				left join CAJASCHEQUERA cc
						on cc.CajaID=cv.CajaID
						and cc.SucursalID 		= cv.SucursalID
						and  cc.InstitucionID 	= Par_InstitucionID
						and cc.NumCtaInstit	 	= Par_NumCtaInstit;
	end if;


	if (Par_NumLis = LisComboCP) then

	select Caj.CajaID, concat(convert(Suc.NombreSucurs,char), ' - CP ',convert( Caj.CajaID,char),' - ',Usu.NombreCompleto) as DescripcionCaja
		from CAJASVENTANILLA Caj
			inner join SUCURSALES Suc on Suc.SucursalID = Caj.SucursalID
			inner join USUARIOS Usu on Usu.UsuarioID =Caj.UsuarioID
			and Caj.Estatus = EstatusA
			and Caj.TipoCaja=TipoCajaCP;
	end if;

END TerminaStore$$