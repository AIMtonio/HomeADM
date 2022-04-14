DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESGENERALREP`;
DELIMITER $$

CREATE	PROCEDURE	`CLIENTESGENERALREP`(
	-- Stored procedure para la implementación del reporte general de clientes
	Par_SucursalID			INT(11),				--	ID de la sucursal
	Par_Estatus				CHAR(1),				--	Estatus del cliente

	Par_EmpresaID			INT(11),				--	Parametros de auditoria
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN
	-- Constantes

	DECLARE	Entero_Cero				INT(11);			--	Entero Cero
	DECLARE	Cadena_Vacia			CHAR(1);			--	Cadena vacía
	DECLARE	Var_TipPerMor			CHAR(1);			--	Tipo Persona física
	DECLARE Est_Inactivo			CHAR(1);			--	Estatus Inactivo
	DECLARE Est_Activo				CHAR(1);			--	Estatus Activo
	DECLARE	Fecha_Vacia				DATE;				--	Fecha vacía '1900-01-01'
	DECLARE	Var_ConSI				CHAR(1);			--	Cosntante SI

	-- Asignacion de constantes

	SET	Entero_Cero					:=	0;				--	Se establece el cero (0)
	SET	Cadena_Vacia				:=	'';				--	Se establece la cadena vacía ('')
	SET	Var_TipPerMor				:=	'M';			--	Se establece el valor F para personas físicas
	SET	Est_Inactivo				:=	'I';			--	Se establece el valor a 'I' para estatus Inactivo
	SET	Est_Activo					:=	'A';			--	Se establece el valor a 'A' para estatus Activo
	SET	Fecha_Vacia					:=	'1900-01-01';	--	Se establece el valor a '1900-01-01'
	SET	Var_ConSI					:=	'S';			--	Cosntante SI

	IF Par_SucursalID != Entero_Cero THEN
		IF Par_Estatus != Cadena_Vacia THEN
			IF Par_Estatus = Est_Inactivo THEN
				SELECT	DISTINCT cli.ClienteID,
					CASE
						WHEN cli.TipoPersona = Var_TipPerMor THEN cli.RazonSocial
						ELSE cli.NombreCompleto
					END as NombreCompleto,
					cli.FechaAlta as FechaRegistro,	pro.NombrePromotor as Promotor,	IFNULL(est.Nombre,Cadena_Vacia) as Estado,	IFNULL(mun.Nombre,Cadena_Vacia) as Municipio,	IFNULL(dir.Colonia,Cadena_Vacia) as Colonia,
					IFNULL(dir.CP,Cadena_Vacia) as CodigoPostal,
					CASE
					WHEN dir.NumInterior = Cadena_Vacia THEN IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumeroCasa),Cadena_Vacia)
						ELSE IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumInterior, ', ', dir.NumeroCasa, ', ', dir.Piso),Cadena_Vacia)
					END	as Domicilio,
					cli.RFCOFicial as RFC,	cli.CURP,	cli.FechaNacimiento,	cli.Telefono,	cli.TelefonoCelular as Celular,
					cli.Correo,	FNCUENTASINTERNASACADENA(cli.ClienteID) as CuentasInternas,	FNCUENTASEXTERNASACADENA(cli.ClienteID) as CuentasExternas
				FROM CLIENTES as cli
				INNER JOIN PROMOTORES as pro on cli.PromotorActual = pro.PromotorID
				LEFT JOIN DIRECCLIENTE as dir on dir.ClienteID = cli.ClienteID  AND dir.Oficial = Var_ConSI
				LEFT JOIN ESTADOSREPUB as est on dir.EstadoID = est.EstadoID
				LEFT JOIN MUNICIPIOSREPUB as mun on dir.MunicipioID = mun.MunicipioID AND dir.EstadoID = mun.EstadoID
				LEFT JOIN LOCALIDADREPUB as loc on dir.MunicipioID = loc.MunicipioID AND dir.EstadoID = loc.EstadoID AND dir.LocalidadID = loc.LocalidadID
				WHERE cli.SucursalOrigen = Par_SucursalID AND cli.Estatus = Est_Inactivo;
			ELSEIF Par_Estatus = Est_Activo THEN
				SELECT DISTINCT	cli.ClienteID,
					CASE
						WHEN cli.TipoPersona = Var_TipPerMor THEN cli.RazonSocial
						ELSE cli.NombreCompleto
					END as NombreCompleto,
					cli.FechaAlta as FechaRegistro,	pro.NombrePromotor as Promotor,	IFNULL(est.Nombre,Cadena_Vacia) as Estado,	IFNULL(mun.Nombre,Cadena_Vacia) as Municipio,	IFNULL(dir.Colonia,Cadena_Vacia) as Colonia,
					IFNULL(dir.CP,Cadena_Vacia) as CodigoPostal,
					CASE
					WHEN dir.NumInterior = Cadena_Vacia THEN IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumeroCasa),Cadena_Vacia)
						ELSE IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumInterior, ', ', dir.NumeroCasa, ', ', dir.Piso),Cadena_Vacia)
					END	as Domicilio,
					cli.RFCOFicial as RFC,	cli.CURP,	cli.FechaNacimiento,	cli.Telefono,	cli.TelefonoCelular as Celular,
					cli.Correo,	FNCUENTASINTERNASACADENA(cli.ClienteID) as CuentasInternas,	FNCUENTASEXTERNASACADENA(cli.ClienteID) as CuentasExternas
				FROM CLIENTES as cli
				INNER JOIN PROMOTORES as pro on cli.PromotorActual = pro.PromotorID
				LEFT JOIN DIRECCLIENTE as dir on dir.ClienteID = cli.ClienteID  AND dir.Oficial = Var_ConSI
				LEFT JOIN ESTADOSREPUB as est on dir.EstadoID = est.EstadoID
				LEFT JOIN MUNICIPIOSREPUB as mun on dir.MunicipioID = mun.MunicipioID AND dir.EstadoID = mun.EstadoID
				LEFT JOIN LOCALIDADREPUB as loc on dir.MunicipioID = loc.MunicipioID AND dir.EstadoID = loc.EstadoID AND dir.LocalidadID = loc.LocalidadID
				WHERE cli.SucursalOrigen = Par_SucursalID AND cli.Estatus = Par_Estatus;
			END IF;
		ELSE
			SELECT DISTINCT	cli.ClienteID,
				CASE
					WHEN cli.TipoPersona = Var_TipPerMor THEN cli.RazonSocial
						ELSE cli.NombreCompleto
				END as NombreCompleto,
				cli.FechaAlta as FechaRegistro,	pro.NombrePromotor as Promotor,	IFNULL(est.Nombre,Cadena_Vacia) as Estado,	IFNULL(mun.Nombre,Cadena_Vacia) as Municipio,	IFNULL(dir.Colonia,Cadena_Vacia) as Colonia,
				IFNULL(dir.CP,Cadena_Vacia) as CodigoPostal,
				CASE
				WHEN dir.NumInterior = Cadena_Vacia THEN IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumeroCasa),Cadena_Vacia)
					ELSE IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumInterior, ', ', dir.NumeroCasa, ', ', dir.Piso),Cadena_Vacia)
				END	as Domicilio,
				cli.RFCOFicial as RFC,	cli.CURP,	cli.FechaNacimiento,	cli.Telefono,	cli.TelefonoCelular as Celular,
				cli.Correo,	FNCUENTASINTERNASACADENA(cli.ClienteID) as CuentasInternas,	FNCUENTASEXTERNASACADENA(cli.ClienteID) as CuentasExternas
			FROM CLIENTES as cli
			INNER JOIN PROMOTORES as pro on cli.PromotorActual = pro.PromotorID
			LEFT JOIN DIRECCLIENTE as dir on dir.ClienteID = cli.ClienteID  AND dir.Oficial = Var_ConSI
			LEFT JOIN ESTADOSREPUB as est on dir.EstadoID = est.EstadoID
			LEFT JOIN MUNICIPIOSREPUB as mun on dir.MunicipioID = mun.MunicipioID AND dir.EstadoID = mun.EstadoID
			LEFT JOIN LOCALIDADREPUB as loc on dir.MunicipioID = loc.MunicipioID AND dir.EstadoID = loc.EstadoID AND dir.LocalidadID = loc.LocalidadID
			WHERE cli.SucursalOrigen = Par_SucursalID;
		END IF;
	ELSE
		IF Par_Estatus != Cadena_Vacia THEN
			IF Par_Estatus = Est_Inactivo THEN
				SELECT DISTINCT	cli.ClienteID,
					CASE
						WHEN cli.TipoPersona = Var_TipPerMor THEN cli.RazonSocial
						ELSE cli.NombreCompleto
					END as NombreCompleto,
						CASE WHEN FechaAlta='0000-00-00' THEN Fecha_Vacia ELSE IFNULL(cli.FechaAlta,Fecha_Vacia)  END  as FechaRegistro,	pro.NombrePromotor as Promotor,	IFNULL(est.Nombre,Cadena_Vacia) as Estado,	IFNULL(mun.Nombre,Cadena_Vacia) as Municipio,	IFNULL(dir.Colonia,Cadena_Vacia) as Colonia,
					IFNULL(dir.CP,Cadena_Vacia) as CodigoPostal,
					CASE
					WHEN dir.NumInterior = Cadena_Vacia THEN IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumeroCasa),Cadena_Vacia)
						ELSE IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumInterior, ', ', dir.NumeroCasa, ', ', dir.Piso),Cadena_Vacia)
					END	as Domicilio,
					cli.RFCOFicial as RFC,	cli.CURP,	IFNULL(cli.FechaNacimiento,Fecha_Vacia) AS FechaNacimiento,	cli.Telefono,	cli.TelefonoCelular as Celular,
					cli.Correo,	FNCUENTASINTERNASACADENA(cli.ClienteID) as CuentasInternas,	FNCUENTASEXTERNASACADENA(cli.ClienteID) as CuentasExternas
				FROM CLIENTES as cli
				INNER JOIN PROMOTORES as pro on cli.PromotorActual = pro.PromotorID
				LEFT JOIN DIRECCLIENTE as dir on dir.ClienteID = cli.ClienteID  AND dir.Oficial = Var_ConSI
				LEFT JOIN ESTADOSREPUB as est on dir.EstadoID = est.EstadoID
				LEFT JOIN MUNICIPIOSREPUB as mun on dir.MunicipioID = mun.MunicipioID AND dir.EstadoID = mun.EstadoID
				LEFT JOIN LOCALIDADREPUB as loc on dir.MunicipioID = loc.MunicipioID AND dir.EstadoID = loc.EstadoID AND dir.LocalidadID = loc.LocalidadID
				WHERE cli.Estatus = Est_Inactivo;
			ELSEIF Par_Estatus = Est_Activo THEN
				SELECT DISTINCT	cli.ClienteID,
					CASE
						WHEN cli.TipoPersona = Var_TipPerMor THEN cli.RazonSocial
						ELSE cli.NombreCompleto
					END as NombreCompleto,
						CASE WHEN FechaAlta='0000-00-00' THEN Fecha_Vacia ELSE IFNULL(cli.FechaAlta,Fecha_Vacia)  END  as FechaRegistro,	pro.NombrePromotor as Promotor,	IFNULL(est.Nombre,Cadena_Vacia) as Estado,	IFNULL(mun.Nombre,Cadena_Vacia) as Municipio,	IFNULL(dir.Colonia,Cadena_Vacia) as Colonia,
					IFNULL(dir.CP,Cadena_Vacia) as CodigoPostal,
					CASE
					WHEN dir.NumInterior = Cadena_Vacia THEN IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumeroCasa),Cadena_Vacia)
						ELSE IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumInterior, ', ', dir.NumeroCasa, ', ', dir.Piso),Cadena_Vacia)
					END	as Domicilio,
					cli.RFCOFicial as RFC,	cli.CURP,	IFNULL(cli.FechaNacimiento,Fecha_Vacia) AS FechaNacimiento,	cli.Telefono,	cli.TelefonoCelular as Celular,
					cli.Correo,	FNCUENTASINTERNASACADENA(cli.ClienteID) as CuentasInternas,	FNCUENTASEXTERNASACADENA(cli.ClienteID) as CuentasExternas
				FROM CLIENTES as cli
				INNER JOIN PROMOTORES as pro on cli.PromotorActual = pro.PromotorID
				LEFT JOIN DIRECCLIENTE as dir on dir.ClienteID = cli.ClienteID  AND dir.Oficial = Var_ConSI
				LEFT JOIN ESTADOSREPUB as est on dir.EstadoID = est.EstadoID
				LEFT JOIN MUNICIPIOSREPUB as mun on dir.MunicipioID = mun.MunicipioID AND dir.EstadoID = mun.EstadoID
				LEFT JOIN LOCALIDADREPUB as loc on dir.MunicipioID = loc.MunicipioID AND dir.EstadoID = loc.EstadoID AND dir.LocalidadID = loc.LocalidadID
				WHERE cli.Estatus = Par_Estatus;
			END IF;
		ELSE
			SELECT DISTINCT	cli.ClienteID,
				CASE
					WHEN cli.TipoPersona = Var_TipPerMor THEN cli.RazonSocial
					ELSE cli.NombreCompleto
				END as NombreCompleto,
				cli.FechaAlta as FechaRegistro,	pro.NombrePromotor as Promotor,	IFNULL(est.Nombre,Cadena_Vacia) as Estado,	IFNULL(mun.Nombre,Cadena_Vacia) as Municipio,	IFNULL(dir.Colonia,Cadena_Vacia) as Colonia,
				IFNULL(dir.CP,Cadena_Vacia) as CodigoPostal,
				CASE
					WHEN dir.NumInterior = Cadena_Vacia THEN IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumeroCasa),Cadena_Vacia)
					ELSE IFNULL(CONCAT(loc.NombreLocalidad, ', ' , dir.Calle, ', ', dir.NumInterior, ', ', dir.NumeroCasa, ', ', dir.Piso),Cadena_Vacia)
				END	as Domicilio,
				cli.RFCOFicial as RFC,	cli.CURP,	cli.FechaNacimiento,	cli.Telefono,	cli.TelefonoCelular as Celular,
				cli.Correo,	FNCUENTASINTERNASACADENA(cli.ClienteID) as CuentasInternas,	FNCUENTASEXTERNASACADENA(cli.ClienteID) as CuentasExternas
			FROM CLIENTES as cli
			INNER JOIN PROMOTORES as pro on cli.PromotorActual = pro.PromotorID
			LEFT JOIN DIRECCLIENTE as dir on dir.ClienteID = cli.ClienteID AND dir.Oficial = Var_ConSI
			LEFT JOIN ESTADOSREPUB as est on dir.EstadoID = est.EstadoID
			LEFT JOIN MUNICIPIOSREPUB as mun on dir.MunicipioID = mun.MunicipioID AND dir.EstadoID = mun.EstadoID
			LEFT JOIN LOCALIDADREPUB as loc on dir.MunicipioID = loc.MunicipioID AND dir.EstadoID = loc.EstadoID AND dir.LocalidadID = loc.LocalidadID;
		END IF;
	END IF;
END	TerminaStore$$
