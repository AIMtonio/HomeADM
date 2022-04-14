-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCARATULAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCARATULAREP`;DELIMITER $$

CREATE PROCEDURE `TARDEBCARATULAREP`(




	Par_TarjetaDebID			CHAR(16),

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


	DECLARE	Entero_Cero			INT;
	DECLARE Decimal_Cero		decimal(12,2);
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_vacia		CHAR(1);
	DECLARE Con_Anualidad		INT(11);
	DECLARE Con_Reposicion		INT(11);
	DECLARE	Rep_Principal		INT;
	DECLARE Rep_Foranea			INT;
	DECLARE Var_NomEstado		VARCHAR(40);
	DECLARE Var_NomMunicipio	VARCHAR(40);


DECLARE Var_Sentencia		VARCHAR(9000);
DECLARE Var_ClienteID		INT(11);
DECLARE Var_NombreCliente	VARCHAR(500);
DECLARE Var_TipoTarjeta		VARCHAR(300);
DECLARE Var_Anualidad		DECIMAL(14,2);
DECLARE Var_Reposicion		DECIMAL(14,2);
DECLARE Var_Anio			int;
DECLARE Var_Mes				int;
DECLARE VarDia				int;
DECLARE Var_NomGerente		varchar(50);


SET	Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.00;
SET Estatus_Activo		:= 'A';
SET Cadena_vacia		:= '';
SET Con_Anualidad		:= 1;
SET Con_Reposicion		:= 2;
SET	Rep_Principal		:= 1;
SET Rep_Foranea			:= 2;

IF(Par_NumRep = Rep_Principal) THEN
			SELECT Tar.ClienteID, Cli.NombreCompleto, Tip.Descripcion, 	Esq.MontoComision
				FROM CLIENTES Cli,
					 TARJETADEBITO Tar,
					 TIPOTARJETADEB Tip,
					 TARDEBESQUEMACOM Esq,
					 CUENTASAHO Cue
				WHERE Cli.ClienteID = Tar.ClienteID
						AND Tar.TipoTarjetaDebID = Tip.TipoTarjetaDebID
						AND Tar.TarjetaDebID = Par_TarjetaDebID
						AND Tip.TipoTarjetaDebID = Esq.TipoTarjetaDebID
						AND Tar.CuentaAhoID = Cue.CuentaAhoID
						AND Esq.Estatus = Estatus_Activo
						AND Esq.TarDebComisionID = Con_Anualidad
						AND Esq.TipoCuentaID = Cue.TipoCuentaID
			INTO Var_ClienteID, Var_NombreCliente, Var_TipoTarjeta, Var_Anualidad;

			SELECT 	Esq.MontoComision
				FROM CLIENTES Cli,
					 TARJETADEBITO Tar,
					 TIPOTARJETADEB Tip,
					 TARDEBESQUEMACOM Esq,
					 CUENTASAHO Cue
				WHERE Cli.ClienteID = Tar.ClienteID
						AND Tar.TipoTarjetaDebID = Tip.TipoTarjetaDebID
						AND Tar.TarjetaDebID = Par_TarjetaDebID
						AND Tip.TipoTarjetaDebID = Esq.TipoTarjetaDebID
						AND Tar.CuentaAhoID = Cue.CuentaAhoID
						AND Esq.Estatus = Estatus_Activo
						AND Esq.TarDebComisionID = Con_Reposicion
						AND Esq.TipoCuentaID = Cue.TipoCuentaID
			INTO Var_Reposicion;

	SELECT   LPAD(CONVERT(Var_ClienteID, CHAR), 11, 0)  	AS ClienteID,
			Var_NombreCliente 								AS NombreCliente,
			CONCAT('"',Var_TipoTarjeta,'"')					AS TipoTarjeta,
			ifnull(Var_Anualidad, Decimal_Cero)				AS Anualidad,
			ifnull(Var_Reposicion, Decimal_Cero)			AS Reposicion;

END IF;
IF(Par_NumRep = Rep_Foranea) THEN
	SELECT Esq.MontoComision into Var_Anualidad
		FROM TARJETADEBITO Tar,	TIPOTARJETADEB Tip, TARDEBESQUEMACOM Esq, CUENTASAHO Cue
		WHERE Tar.TipoTarjetaDebID = Tip.TipoTarjetaDebID AND Tar.TarjetaDebID = Par_TarjetaDebID
		AND Tip.TipoTarjetaDebID = Esq.TipoTarjetaDebID AND Tar.CuentaAhoID = Cue.CuentaAhoID
		AND Esq.Estatus = Estatus_Activo AND Esq.TarDebComisionID = Con_Anualidad AND Esq.TipoCuentaID = Cue.TipoCuentaID;

	SELECT Est.Nombre, Mun.Nombre, concat(Suc.TituloGte, ' ', Ger.NombreCompleto) into Var_NomEstado, Var_NomMunicipio, Var_NomGerente
		FROM SUCURSALES Suc
		INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Aud_Usuario AND Usu.SucursalUsuario = Suc.SucursalID
		INNER JOIN USUARIOS Ger ON Suc.NombreGerente = Ger.UsuarioID
		INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Suc.EstadoID  AND Suc.MunicipioID = Mun.MunicipioID;

	SELECT YEAR(FechaSistema), MONTH(FechaSistema), DAY(FechaSistema) into Var_Anio, Var_Mes, VarDia
		FROM PARAMETROSSIS;

	SELECT Dir.DireccionCompleta, convert(concat('"','EL SOCIO','" ', 'acepta pagar la cantidad de $', Var_Anualidad), char) as lblAnual,
		FUNCIONNUMLETRAS(Var_Anualidad) as cantidadLetra, concat('"', 'EL SOCIO', '"') as lblSocio, concat('"', 'CAJA YANGA', '"') as lblCaja,
		Var_NomEstado as NomEstado, Var_NomMunicipio as NomMunicipio, Var_Anio as Anio, Var_Mes as Mes, VarDia as Dia, Var_NomGerente as NombreGerente
		FROM TARJETADEBITO Td
		INNER JOIN CLIENTES Cli ON Td.ClienteID = Cli.ClienteID
		INNER JOIN DIRECCLIENTE Dir ON Cli.ClienteID = Dir.ClienteID AND Dir.Oficial = 'S'
		WHERE Td.TarjetaDebID = Par_TarjetaDebID;
END IF;
END TerminaStore$$