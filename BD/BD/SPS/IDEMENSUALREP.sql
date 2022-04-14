-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDEMENSUALREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `IDEMENSUALREP`;DELIMITER $$

CREATE PROCEDURE `IDEMENSUALREP`(
-- SP QUE SE USARÁ PARA EL REPORTE DE IDE MENSUAL

	Par_Anio 					INT(11),
    Par_Mes						INT(11),

	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT (11),
	Aud_NumTransaccion			BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Var_PerMoral		CHAR(1);
    DECLARE Var_PerActEm		CHAR(1);
    DECLARE Var_PerFisic		CHAR(1);
    DECLARE Var_PerMoralDes		CHAR(50);
    DECLARE Var_PerActEmDes		CHAR(50);
    DECLARE Var_PerFisicDes		CHAR(50);

    DECLARE Entero_Cero 		INT(11);
    DECLARE Entero_Uno	 		INT(11);
    DECLARE Var_Si				CHAR(1);
    DECLARE Var_No				CHAR(1);
    DECLARE Efectivo			CHAR(15);

    DECLARE	Fecha_Vacia			DATE;

	-- Declacion de Variables

    DECLARE Var_FechaInicio		DATE;			-- Almacena una fecha armada del parmetros anio y mes
	DECLARE Var_FechaFin		DATE;			-- Cierra el rango de fecha para la busqueda

    -- Asignación de constantes

    SET Var_PerMoral			:='M';
    SET Var_PerActEm			:='A';
    SET Var_PerFisic			:='F';
    SET Var_PerMoralDes			:='Persona Moral';
    SET Var_PerActEmDes			:='Persona Fisica Con Actividad Empresarial';
    SET Var_PerFisicDes			:='Persona Fisica ';

	SET Entero_Cero 			:= 0;
    SET Entero_Uno	 			:= 1;
    SET Var_Si					:= 'S';
	SET Var_No					:= 'N';
    SET Efectivo				:= 'Efectivo';

    SET	Fecha_Vacia				:= '1900-01-01';


	-- asignacion de variables
	SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
	SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);


	DROP TABLE IF EXISTS TMPDATOSCLIENTE;
	CREATE TEMPORARY TABLE TMPDATOSCLIENTE(			-- TABLA TEMPORAL PARA LOS DATOS DEL CLIENTE
        RFC					CHAR(13),
        CURP				CHAR(18),
        TipoContribuyente	VARCHAR(50),
		PrimerNombre		VARCHAR(50),
		ApellidoPaterno		VARCHAR(50),
        ApellidoMaterno		VARCHAR(50),
        FechaNacimiento		DATE,
        RazonSocial			VARCHAR(50),
        FechaCorte			DATE,
        Monto				DECIMAL(12,2),
        Excedente			DECIMAL(12,2),
        TipoDeposito		VARCHAR(50),
        ClienteID			INT(11),
        SucursalOrigen		INT(11),
        DireccionCompleta	VARCHAR(500),
        TipoSocio			INT(11),
        Correo				VARCHAR(50),
        TelefonoCelular		VARCHAR(20),
        Telefono			VARCHAR(20),
        Cuentas				VARCHAR(200)
        );

	INSERT INTO TMPDATOSCLIENTE
	SELECT	C.RFC,		C.CURP,
			CASE	WHEN  C.TipoPersona=Var_PerMoral THEN Var_PerMoralDes
					WHEN  C.TipoPersona=Var_PerActEm THEN Var_PerActEmDes
					WHEN  C.TipoPersona=Var_PerFisic THEN Var_PerFisicDes END AS TipoContribuyente,
			CONCAT(C.PrimerNombre,' ',C.SegundoNombre)AS PrimerNombre,				C.ApellidoPaterno,
            C.ApellidoMaterno,			C.FechaNacimiento,			C.RazonSocial,	COB.FechaCorte,		SUM(M.CantidadMov) AS MONTO,
            COB.Cantidad AS Excedente,	Efectivo AS TipoDeposito,	C.ClienteID,	C.SucursalOrigen,	DI.DireccionCompleta,
			CASE	WHEN C.EsMenorEdad=Var_No THEN Entero_Cero
					WHEN C.EsMenorEdad=Var_Si THEN Entero_Uno END AS TipoSocio,
			C.Correo,					C.TelefonoCelular,			C.Telefono,		GROUP_CONCAT(DISTINCT M.CuentasAhoID SEPARATOR ',') AS Cuentas
		FROM CLIENTES C
			LEFT JOIN COBROIDEMENS COB ON C.ClienteID=COB.ClienteID
			LEFT JOIN DIRECCLIENTE DI  ON C.ClienteID=DI.ClienteID
						AND	DI.Oficial		=Var_Si
			LEFT JOIN EFECTIVOMOVS M  ON COB.ClienteID=M.ClienteID
						AND Fecha BETWEEN Var_FechaInicio AND Var_FechaFin
		WHERE COB.FechaCorte  BETWEEN Var_FechaInicio AND Var_FechaFin
        GROUP BY COB.ClienteID, 	C.RFC,				C.CURP,				C.TipoPersona,			C.PrimerNombre,C.SegundoNombre,
				 C.ApellidoPaterno,	C.ApellidoMaterno,	C.FechaNacimiento,	C.RazonSocial,			COB.FechaCorte,
				 COB.Cantidad,		C.ClienteID,		C.SucursalOrigen,	DI.DireccionCompleta,	C.EsMenorEdad,
				 C.Correo,			C.TelefonoCelular,	C.Telefono;

	-- DATOS DEL SUSCRIPTOR
	DROP TABLE IF EXISTS TMPDATOSSUSCRIPTOR;
	CREATE TEMPORARY TABLE TMPDATOSSUSCRIPTOR(
		SocioMenorID			BIGINT,
		TutorID					BIGINT,
		TutNombre				VARCHAR(500),
		TutPrimerApell			VARCHAR(500),
		TutSegundoApell			VARCHAR(500),
		TutFechaNac				DATE,
		TutRFC					VARCHAR(500),
		TutCURP					VARCHAR(500),
		TutSucursal				INT(11),
		TutDireccionCompleta	VARCHAR(500),
		TutCorreo				VARCHAR(500),
		TutTelefono1			VARCHAR(50),
		TutTelefono2			VARCHAR(50)
		);

	INSERT INTO TMPDATOSSUSCRIPTOR
	SELECT	COB.ClienteID,		SM.ClienteTutorID,	SM.NombreTutor,	'' AS PrimerApell,	'' AS SegundoApell,
			Fecha_Vacia AS FechaNac,		'' AS RFC, 			'' AS CURP,		Entero_Cero AS SUC, 			'' AS DireccionCompleta,
            '' AS Correo,		'' AS Telefono1,	'' AS Telefono2
		FROM COBROIDEMENS COB
			LEFT JOIN SOCIOMENOR SM ON COB.ClienteID = SM.SocioMenorID
		WHERE COB.FechaCorte BETWEEN Var_FechaInicio AND Var_FechaFin;

	UPDATE TMPDATOSSUSCRIPTOR T,
		   CLIENTES C	SET
		T.TutNombre			= CONCAT(C.PrimerNombre,' ',C.SegundoNombre),
		T.TutPrimerApell	= C.ApellidoPaterno,
		T.TutSegundoApell	= C.ApellidoMaterno,
		T.TutFechaNac		= C.FechaNacimiento,
		T.TutRFC			= C.RFC,
		T.TutCURP			= C.CURP,
		T.TutSucursal		= C.SucursalOrigen,
		T.TutCorreo			= C.Correo,
		T.TutTelefono1		= C.TelefonoCelular,
		T.TutTelefono2		= C.Telefono
	WHERE T.TutorID	= C.ClienteID;

	UPDATE	TMPDATOSSUSCRIPTOR	T,
			DIRECCLIENTE		D	SET
		T.TutDireccionCompleta	= D.DireccionCompleta
	WHERE	T.TutorID = D.ClienteID
		AND	D.Oficial = Var_Si;

	-- DATOS DEL CLIENTE Y TUTOR
	SELECT	RFC,				CURP,				TipoContribuyente,	PrimerNombre,	ApellidoPaterno,
			ApellidoMaterno,	FechaNacimiento,	RazonSocial,		FechaCorte,		Monto,
			Excedente,			TipoDeposito,		ClienteID,			SucursalOrigen,	DireccionCompleta,
			TipoSocio,			Correo,				TelefonoCelular,	Telefono,		Cuentas,
            SocioMenorID,		TutorID,			TutNombre,			TutPrimerApell,	TutSegundoApell,
			TutFechaNac,		TutRFC,				TutCURP,			TutSucursal,	TutDireccionCompleta,
            TutCorreo,			TutTelefono1,		TutTelefono2
		FROM TMPDATOSCLIENTE CL
			LEFT JOIN TMPDATOSSUSCRIPTOR SUS
				ON CL.ClienteID =SUS.SocioMenorID;


END TerminaStore$$