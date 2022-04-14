-- BAMCUENTASAHOCON

DELIMITER ;

DROP PROCEDURE IF EXISTS BANCUENTASAHOCON;

DELIMITER $$

CREATE PROCEDURE `BANCUENTASAHOCON`(
	-- SP que consulta una cuenta de ahorro o inversion
	Par_CuentaAhoID		BIGINT(12),				-- ID de la cuenta de ahorro que se consultara
    Par_ClienteID		INT(11), 				-- Parametro del ID del cliente
    Par_TarjetaDebID	VARCHAR(16),			-- No. de targeta (OPCIONAL)
	Par_Correo			VARCHAR(100),			-- Buscar por correo (OPCIONAL)
	Par_TelefonoCelular	VARCHAR(20),			-- Telefono celular (OPCIONAL)

	Par_NumCon			TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID		INT(11),				-- Auditoria
	Aud_Usuario			INT(11),				-- Auditoria
	Aud_FechaActual		DATETIME,				-- Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Auditoria
	Aud_Sucursal		INT(11),				-- Auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Var_ConPrincipal		TINYINT UNSIGNED;		-- Consulta principal
	DECLARE Var_ConSaldos			TINYINT UNSIGNED;		-- Consulta de saldos
	DECLARE Var_ConTarjetaDebID		TINYINT UNSIGNED;		-- Consulta cuenta interna por tarjeta de debito
	DECLARE Var_ConCuentaAhoID		TINYINT UNSIGNED;		-- Consulta cuenta interna por cuenta de ahorro
	DECLARE Var_ConCorreo			TINYINT UNSIGNED;		-- Consulta cuenta interna por correo
	DECLARE Var_ConTelCelular		TINYINT UNSIGNED;		-- Consulta cuenta interna por telefono celular
    DECLARE Cadena_Vacia			CHAR(1);				-- Cadena Cadena_Vacia
    DECLARE Entero_Cero				INT(11);				-- Constante de Entero_Cero
    DECLARE Var_TipoCueInterna		CHAR(1);				-- Tipo de cuenta interna
	DECLARE Var_Si          		CHAR(1);				-- Declaracion de variable SI
    DECLARE	Est_TarActiva			INT;					-- Estatus Tarjeta Activa
	DECLARE	Est_CtaActiva			CHAR(1);				-- Estatus Cuenta Activa
	DECLARE	Var_TipoPerMoral		CHAR(1);				-- Persona Moral

	-- DECLARACION DE VARIABLES
	DECLARE	Var_CuentaAhoID			BIGINT(12);				-- Variable para devolver el ID de la cuenta de ahorro
	DECLARE Var_SumPenAct			DECIMAL(12,2);			-- Variable para la suma

	-- ASIGNACION DE CONSTANTES
	SET Var_ConPrincipal			:= 1;					-- Consulta principal
	SET Var_ConSaldos				:= 2;					-- Consulta de saldos
	SET Var_ConTarjetaDebID			:= 3;					-- Consulta cuenta interna por tarjeta de debito
	SET Var_ConCuentaAhoID			:= 4;					-- Consulta cuenta interna por cuenta de ahorro
	SET Var_ConCorreo				:= 5;					-- Consulta cuenta interna por correo
	SET Var_ConTelCelular			:= 6;					-- Consulta cuenta interna por telefono celular
    SET	Cadena_Vacia				:= '';
	SET	Entero_Cero					:= 0;
	SET Var_TipoCueInterna			:='I';					-- Tipo cuenta interna
    SET Var_Si          			:= 'S';
    SET	Est_TarActiva				:= 7;					-- Estatus Tarjeta Activa
	SET	Est_CtaActiva				:= 'A';					-- Estatus Cuenta Activa
	SET	Var_TipoPerMoral			:= 'M';					-- Persona Moral

	-- 1.- Consulta principal
	IF(Par_NumCon = Var_ConPrincipal ) THEN

		SET Var_CuentaAhoID := (SELECT	CuentaAhoID	FROM CUENTASAHO	WHERE	CuentaAhoID = Par_CuentaAhoID);
		IF(IFNULL(Var_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN

			SELECT	Entero_Cero AS CuentaAhoID,	Entero_Cero AS SaldoDisp,	Cadena_Vacia AS Etiqueta;
		ELSE

			SELECT	ca.CuentaAhoID,	ca.SaldoDispon AS SaldoDisp, ca.Etiqueta, ca.Clabe AS Clabe, tc.Descripcion, tc.TipoCuentaID, Cli.NombreCompleto, Cli.ClienteID
				FROM CUENTASAHO ca
				INNER JOIN CLIENTES Cli ON ca.ClienteID	= Cli.ClienteID
				INNER JOIN TIPOSCUENTAS tc ON ca.TipoCuentaID = tc.TipoCuentaID
				WHERE	CuentaAhoID	= Par_CuentaAhoID;
		END IF;

	END IF;

	-- 2.- Consulta de saldos
	IF(Par_NumCon = Var_ConSaldos) THEN

		SELECT	CASE WHEN Cli.PagaIVA = Var_Si THEN
				SUM(Pen.CantPenAct) + SUM(Pen.CantPenAct * Suc.IVA)
				ELSE SUM(Pen.CantPenAct)
				END AS CantPenAct
		INTO 	Var_SumPenAct
			FROM COBROSPEND Pen,
				CLIENTES Cli,
				SUCURSALES Suc
			WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
			AND 	Pen.ClienteID 	= Par_ClienteID
			AND 	Pen.ClienteID 	= Cli.ClienteID
			AND	Suc.SucursalID	= Cli.SucursalOrigen;

		SELECT 	ca.CuentaAhoID,			ca.SucursalID,				cli.ClienteID,				ca.Clabe,								ca.MonedaID,
				ca.Gat,					ca.TipoCuentaID,			ca.FechaReg,				ca.FechaApertura,						ca.UsuarioApeID,
				ca.Etiqueta,			ca.UsuarioCanID,			ca.FechaCan,				ca.MotivoCan,							ca.MotivoBlo,
				ca.FechaBlo,			ca.UsuarioBloID,			ca.MotivoDesbloq,			ca.FechaDesbloq,						ca.UsuarioDesbID,
				ca.Saldo,				ca.SaldoDispon,				ca.SaldoBloq,				ca.SaldoSBC,							ca.SaldoIniMes,
				ca.CargosMes,			ca.AbonosMes,				ca.Comisiones,				ca.SaldoProm,							ca.TasaInteres,
				ca.InteresesGen,		ca.ISR,						ca.TasaISR,					ca.SaldoIniDia,							ca.CargosDia,
				ca.AbonosDia,			ca.Estatus,					ca.EstadoCta,				ca.InstitucionID,						ca.EsPrincipal,
				ca.GatReal,				ca.ISRReal,					ca.TelefonoCelular,			ca.MontoDepInicial,						ca.FechaDepInicial,
				Entero_Cero,			Entero_Cero,				ca.MonedaID,				mon.Descripcion AS DescriCorta,			tc.Descripcion AS   TipoCuenta,
		        cli.NombreCompleto,		Var_SumPenAct,				Suc.NombreSucurs

			FROM CUENTASAHO ca
				INNER JOIN TIPOSCUENTAS tc 	ON ca.TipoCuentaID	= tc.TipoCuentaID
				INNER JOIN SUCURSALES Suc 	ON ca.SucursalID	= Suc.SucursalID
		        INNER JOIN CLIENTES cli 	ON ca.ClienteID 	= cli.ClienteID,
				MONEDAS		mon
		WHERE	CuentaAhoID		= Par_CuentaAhoID
		AND		mon.MonedaId 	= ca.MonedaID
		AND 	ca.ClienteID		= Par_ClienteID;


	END IF;

	-- 3.- Consulta de cuentas internas por tarjeta de debito
	IF(Par_NumCon = Var_ConTarjetaDebID) THEN

		SELECT 	Cue.CuentaAhoID AS CuentaAhorro,

				CASE WHEN Cli.TipoPersona = Var_TipoPerMoral THEN TRIM(Cli.NombreCompleto)
						ELSE CONCAT(Cli.PrimerNombre,
								(CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', Cli.SegundoNombre) ELSE Cadena_Vacia END),
								(CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia)  != Cadena_Vacia THEN CONCAT(' ', Cli.TercerNombre)  ELSE Cadena_Vacia END)
				)END AS Nombre,

				CASE WHEN Cli.TipoPersona = Var_TipoPerMoral THEN Cadena_Vacia
						ELSE CONCAT(Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
				END AS Apellidos

		FROM 	CUENTASAHO Cue, CLIENTES Cli, TARJETADEBITO Tar
		WHERE 	Tar.TarjetaDebID = Par_TarjetaDebID
		AND		Tar.CuentaAhoID = Cue.CuentaAhoID
		AND		Cue.ClienteID = Cli.ClienteID
		AND 	Cue.Estatus = Est_CtaActiva
		AND 	Tar.Estatus = Est_TarActiva;

	END IF;
	-- 4.- Consulta de cuentas internas por cuenta de Ahorro
	IF(Par_NumCon = Var_ConCuentaAhoID) THEN

			SELECT 	Cue.CuentaAhoID AS CuentaAhorro,

					CASE WHEN Cli.TipoPersona = Var_TipoPerMoral THEN TRIM(Cli.NombreCompleto)
						ELSE CONCAT(Cli.PrimerNombre,
									(CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', Cli.SegundoNombre) ELSE Cadena_Vacia END),
									(CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia)  != Cadena_Vacia THEN CONCAT(' ', Cli.TercerNombre)  ELSE Cadena_Vacia END)
					)END AS Nombre,

					CASE WHEN Cli.TipoPersona = Var_TipoPerMoral THEN Cadena_Vacia
						ELSE CONCAT(Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
					END AS Apellidos

			FROM 	CUENTASAHO Cue, CLIENTES Cli
			WHERE 	Cue.CuentaAhoID = Par_CuentaAhoID
			AND		Cue.ClienteID = Cli.ClienteID
			AND 	Cue.Estatus = Est_CtaActiva;
	END IF;
	-- 5.- Consulta de cuentas internas por correo
	IF(Par_NumCon = Var_ConCorreo) THEN

		SELECT 	Cue.CuentaAhoID AS CuentaAhorro,

				CASE WHEN Cli.TipoPersona = Var_TipoPerMoral THEN TRIM(Cli.NombreCompleto)
						ELSE CONCAT(Cli.PrimerNombre,
								(CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', Cli.SegundoNombre) ELSE Cadena_Vacia END),
								(CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia)  != Cadena_Vacia THEN CONCAT(' ', Cli.TercerNombre)  ELSE Cadena_Vacia END)
				)END AS Nombre,

				CASE WHEN Cli.TipoPersona = Var_TipoPerMoral THEN Cadena_Vacia
						ELSE CONCAT(Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
				END AS Apellidos

		FROM 	CUENTASAHO Cue, CLIENTES Cli
		WHERE 	Cli.Correo = Par_Correo
		AND		Cue.ClienteID = Cli.ClienteID
		AND 	Cue.Estatus = Est_CtaActiva;

	END IF;
	-- 6.- Consulta de cuentas internas por telefono celular
	IF(Par_NumCon = Var_ConTelCelular) THEN

		SELECT 	Cue.CuentaAhoID AS CuentaAhorro,

				CASE WHEN Cli.TipoPersona = Var_TipoPerMoral THEN TRIM(Cli.NombreCompleto)
						ELSE CONCAT(Cli.PrimerNombre,
								(CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', Cli.SegundoNombre) ELSE Cadena_Vacia END),
								(CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia)  != Cadena_Vacia THEN CONCAT(' ', Cli.TercerNombre)  ELSE Cadena_Vacia END)
				)END AS Nombre,

				CASE WHEN Cli.TipoPersona = Var_TipoPerMoral THEN Cadena_Vacia
						ELSE CONCAT(Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
				END AS Apellidos

		FROM 	CUENTASAHO Cue, CLIENTES Cli
		WHERE 	Cue.TelefonoCelular = Par_TelefonoCelular
		AND		Cue.ClienteID = Cli.ClienteID
		AND 	Cue.Estatus = Est_CtaActiva;

	END IF;

END TerminaStore$$
