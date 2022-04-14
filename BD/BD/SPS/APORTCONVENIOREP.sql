-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTCONVENIOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTCONVENIOREP`;
DELIMITER $$

CREATE PROCEDURE `APORTCONVENIOREP`(
	-- SP QUE GENERA EL REPORTE DE CONVENIO DE APORTACIONES
	Par_AportacionID		INT(11),			-- Tipo de aportacion
	Par_NumCon				INT(11),			-- Numero de reporte
	Aud_EmpresaID			INT(11),			-- Parametro de auditoria

	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria

	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_NumRegistro		INT(11);		-- Id del cliente
	DECLARE Var_FechaConvenio	DATE;			-- Fecha de autorización de la aportación
	DECLARE Var_Aportante		VARCHAR(300);	-- Nombre completo o razon social del aportante
	DECLARE Var_RfcAportante	VARCHAR(30);	-- RFC del aportante
	DECLARE Var_CalleAport		VARCHAR(50);	-- Calle del aportante
	DECLARE Var_NumAport		VARCHAR(10);	-- Numero de la direccion oficial del aportante
	DECLARE Var_ColoniaAport	VARCHAR(100);	-- Colonia del aportante
	DECLARE Var_CiudadAport		VARCHAR(100);	-- Ciudad del aportante
	DECLARE Var_EstadoAport		VARCHAR(100);	-- Estado del aportante
	DECLARE Var_CpAport			VARCHAR(10);	-- Codigo Postal del aportante
	DECLARE Var_TelAport		VARCHAR(20);	-- Telefono particular del aportante
	DECLARE Var_CelAport		VARCHAR(20);	-- Telefono celular del aportante
	DECLARE Var_CorreoAport		VARCHAR(100);	-- Correo del aportante
	DECLARE Var_NomApo1			VARCHAR(300);	-- Nombre completo del primer apoderado
	DECLARE Var_NomApo2			VARCHAR(300);	-- Nombre completo del segundo apoderado
	DECLARE Var_Representante	VARCHAR(300);	-- Nombre completo del representante legal de la empresa
	DECLARE Var_RepLegalAport	VARCHAR(300);	-- Nombre completo del representante legal del aportante (Persona Moral)
	DECLARE Var_NacAport		VARCHAR(100);	-- Nacionalidad del aportante
	DECLARE Var_IdentiAport		VARCHAR(100);	-- Identificacion del aportante
	DECLARE Var_DiaNumAutoriza	VARCHAR(2);		-- Dia en numero de la fecha de autorizacion de aportacion
	DECLARE Var_DiaLetAutoriza	VARCHAR(50);	-- Dia en letra de la fecha de autorizacion de aportacion
	DECLARE Var_MesAutoriza		VARCHAR(50);	-- Mes en letra de la fecha de autorizacion de aportacion
	DECLARE Var_AnioNumAutoriza	VARCHAR(10);	-- Anio en numero de la fecha de autorizacion de aportacion
	DECLARE Var_AnioLetAutoriza	VARCHAR(50);	-- Anio en letra de la fecha de autorizacion de aportacion
	DECLARE Var_DirecInstit		VARCHAR(500);	-- Direccion de la financiera
	DECLARE Var_TipoPersona		CHAR(2);		-- Tipo persona del aportante F:Fisica, M:Moral
	DECLARE Var_CuentaAhoID		BIGINT(20);		-- Cuenta de ahorro ligada a la aportacion
	DECLARE Var_RelacionadoID	INT(11);		-- ID del relacionado a la cuenta
	DECLARE Var_TipoRecibo		CHAR(2);		-- Tipo de recibo que se va a mostrar C:Capitalizable, I:Irregula o R:Regular
	DECLARE Par_ClienteID		BIGINT(12);		-- ID del cliente
	DECLARE Par_InstitucionID	INT(11);		-- ID de la institucion parametrizada en en la pantalla parametros generales
	DECLARE Var_DiaFecha		CHAR(2);		-- Dia de la fecha del convenio
	DECLARE Var_Titulo			VARCHAR(50);	-- Información del Titolo en la Tabla de amortización
		-- DECLARACION DE CONSTANTES
	DECLARE Fecha_Vacia		DATE;
	DECLARE Entero_Cero		INT(11);
	DECLARE Cons_Nacion		CHAR(1);
	DECLARE Con_Principal	INT(11);
	DECLARE Con_Benef		INT(11);
	DECLARE Con_Amortiza	INT(11);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Cadena_Cero		CHAR(1);
	DECLARE Persona_Moral	CHAR(1);
	DECLARE Cons_Nacional	VARCHAR(30);
	DECLARE Cons_Extranje	VARCHAR(30);
	DECLARE Cons_SI			CHAR(1);
	DECLARE Cons_NO			CHAR(1);
	-- Asignacion de CONSTANTES
	SET	Fecha_Vacia			:= '1900-01-01';-- fecha para valores vacios
	SET	Entero_Cero			:= 0;  			-- Constante Valor Cero
	SET	Cons_Nacion			:= 'N';			-- Constante nacional
	SET	Con_Principal		:= 1;			-- Consulta para datos generales de la aportacion
	SET	Con_Benef			:= 2;			-- Consulta de beneficiarios de la aportacion
	SET	Con_Amortiza		:= 3;
	SET	Cadena_Vacia		:= '';			-- Constante cadena vacia
	SET	Cadena_Cero			:= '0';			-- Constante cadena ceros
	SET	Persona_Moral		:= 'M';			-- Constante para tipo persona moral
	SET	Cons_Nacional		:= 'MEXICANA';	-- Nacionalidad mexicana
	SET	Cons_Extranje		:= 'EXTRANJERA';-- Nacionalidad Extranjera
	SET	Cons_SI				:= 'S';			-- Constante si
	SET	Cons_NO				:= 'N';

	SELECT	InstitucionID
		INTO Par_InstitucionID
	FROM	PARAMETROSSIS
	WHERE	EmpresaID = 1;

	SELECT	ClienteID INTO Par_ClienteID
	FROM APORTACIONES
	WHERE AportacionID = Par_AportacionID;

	SET	Var_NumRegistro	:= Par_ClienteID;

	SET	@capInt	:= (SELECT PagoIntCapitaliza FROM APORTACIONES WHERE AportacionID=Par_AportacionID);
	SET	@tipoPagoInt	:= (SELECT TipoPagoInt FROM APORTACIONES WHERE AportacionID=Par_AportacionID);

	SET	@totAmort	:= (SELECT COUNT(*) FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID);
	SET	@totAmortReg	:= (SELECT COUNT(*) FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID AND TipoPeriodo = 'R');

	SET	@amortIrreg	:= (SELECT TipoPeriodo FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID AND AmortizacionID = 1);

	CASE
		WHEN @capInt = 'S' THEN SET Var_TipoRecibo := 'C';
		WHEN @capInt = 'N' AND @tipoPagoInt = 'V' THEN SET Var_TipoRecibo := 'C';
		WHEN @totAmort = @totAmortReg THEN SET Var_TipoRecibo := 'R';
		WHEN @amortIrreg = 'I' THEN SET Var_TipoRecibo := 'I';
		ELSE SET	Var_TipoRecibo	:= '';
	END CASE;

	IF(Par_NumCon = Con_Principal)THEN
		-- Obteniendo valores a utilizar de la Aportacion
		SELECT	FechaInicio, CuentaAhoID
				INTO Var_FechaConvenio,Var_CuentaAhoID
				FROM APORTACIONES
				WHERE AportacionID	= Par_AportacionID;

		SET	Var_FechaConvenio	:= IFNULL(Var_FechaConvenio,Fecha_Vacia);
		SET	Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID,Entero_Cero);

		SET	Var_DiaNumAutoriza	:= DAY(Var_FechaConvenio);
		SET	Var_DiaNumAutoriza	:= IF(Var_DiaNumAutoriza<10,CONCAT(Cadena_Cero,Var_DiaNumAutoriza),Var_DiaNumAutoriza);

		SET	Var_DiaLetAutoriza	:= FUNCIONNUMEROSLETRAS(Var_DiaNumAutoriza);
		SET	Var_MesAutoriza	:= UPPER(FUNCIONMESNOMBRE(Var_FechaConvenio));
		SET	Var_AnioNumAutoriza	:= YEAR(Var_FechaConvenio);
		SET	Var_AnioLetAutoriza	:= FUNCIONNUMEROSLETRAS(Var_AnioNumAutoriza);

		-- OBTENER EL TIPO DE PERSONA DEL CLIENTE
		SELECT	TipoPersona
				INTO Var_TipoPersona
				FROM	CLIENTES
				WHERE	ClienteID	= Par_ClienteID;

		-- OBTENER DATOS DEL CLIENTE
		SELECT	IF(Var_TipoPersona=Persona_Moral,cli.RazonSocial,cli.NombreCompleto),
				cli.RFCOficial,
				cli.Correo,
				cli.Telefono,
				cli.TelefonoCelular,
				IF(cli.Nacion=Cons_Nacion,Cons_Nacional,Cons_Extranje),
				ide.Descripcion
			INTO Var_Aportante,
				 Var_RfcAportante,
				 Var_CorreoAport,
				 Var_TelAport,
				 Var_CelAport,
				 Var_NacAport,
				 Var_IdentiAport
		FROM	CLIENTES cli
			INNER JOIN IDENTIFICLIENTE ide ON cli.ClienteID = ide.ClienteID
		WHERE	cli.ClienteID	= Par_ClienteID;

		-- OBTENER DIRECCION DEL CLIENTE
		SELECT	dir.Calle,
				dir.NumeroCasa,
				dir.Colonia,
				mun.Nombre,
				est.Nombre,
				dir.CP
			INTO Var_CalleAport,
				Var_NumAport,
				Var_ColoniaAport,
				Var_CiudadAport,
				Var_EstadoAport,
				Var_CpAport
				FROM	DIRECCLIENTE dir
					INNER JOIN ESTADOSREPUB est on dir.EstadoID = est.EstadoID
					INNER JOIN MUNICIPIOSREPUB mun on dir.MunicipioID = mun.MunicipioID and est.EstadoID = mun.EstadoID
				WHERE 	dir.ClienteID	= Par_ClienteID AND dir.Oficial=Cons_SI;

		-- OBTENER LOS DATOS DE RELACIONADOS A LA CUENTA, SI EL APORTANTE ES PERSONA MORAL
		IF(Var_TipoPersona = Persona_Moral)THEN
			-- obtener el id del relacionado, para saber si es un cliente o no
			SET	Var_RelacionadoID	:= (SELECT RelacionadoID
										FROM DIRECTIVOS
										WHERE ClienteID = Par_ClienteID
										AND EsApoderado = Cons_SI
										ORDER BY DirectivoID
										LIMIT 1);
			SET	Var_RelacionadoID	:= IFNULL(Var_RelacionadoID,Entero_Cero);
			-- OBTENER EL NOMBRE COMPLETO DEL PRIMER APODERADO.
			IF(Var_RelacionadoID>0)THEN
				-- Si el apoderado es cliente obtiene el nombre de clientes
				SET	Var_NomApo1	:= (SELECT NombreCompleto
									FROM CLIENTES
									WHERE ClienteID = Var_RelacionadoID);
			ELSE
				-- Si el apoderado no es cliente obtiene el nombre de directivos
			SET	Var_NomApo1	:= (SELECT NombreCompleto
								FROM DIRECTIVOS
								WHERE ClienteID = Par_ClienteID
								AND EsApoderado = Cons_SI
								ORDER BY DirectivoID
								LIMIT 1);
			END IF;
			SET	Var_NomApo1	:= IFNULL(Var_NomApo1,Cadena_Vacia);

			-- ----------------------- SEGUNDO APODERADO ----------------------
			-- obtener el id del relacionado, para saber si es un cliente o no
			SET	Var_RelacionadoID	:= (SELECT RelacionadoID
										FROM DIRECTIVOS
										WHERE ClienteID = Par_ClienteID
										AND EsApoderado = Cons_SI
										ORDER BY DirectivoID
										LIMIT 1,1);
			SET	Var_RelacionadoID	:= IFNULL(Var_RelacionadoID,Entero_Cero);
			-- OBTENER EL NOMBRE COMPLETO DEL SEGUNDO APODERADO.
			IF(Var_RelacionadoID>0)THEN
				-- Si el apoderado es cliente obtiene el nombre de clientes
				SET	Var_NomApo2	:= (SELECT NombreCompleto
									FROM CLIENTES
									WHERE ClienteID = Var_RelacionadoID);
			ELSE
			-- Si el apoderado no es cliente obtiene el nombre de directivos
			SET	Var_NomApo2	:= (SELECT NombreCompleto
								FROM DIRECTIVOS
								WHERE ClienteID = Par_ClienteID
								AND EsApoderado = Cons_SI
								ORDER BY DirectivoID
								LIMIT 1,1);
			END IF;

			-- obtener nombre del representante legal
			SELECT NombreCompleto
				INTO Var_RepLegalAport
			FROM CUENTASPERSONA
			WHERE CuentaAhoID=Var_CuentaAhoID
			AND EsApoderado = Cons_SI
			ORDER BY PersonaID ASC
			LIMIT 1 ;
			SET	Var_RepLegalAport := IFNULL(Var_RepLegalAport,Cadena_Vacia);

		ELSE
			SET	Var_NomApo1	:= IFNULL(Var_NomApo1,Cadena_Vacia);
			SET	Var_NomApo2	:= IFNULL(Var_NomApo2,Cadena_Vacia);
			SET	Var_RepLegalAport	:= IFNULL(Var_RepLegalAport,Cadena_Vacia);
		END IF;

		-- OBTENER EL NOMBRE DEL REPRESENTANTE LEGAL DE LA FINANCIERA
		SET	Var_Representante	:= (SELECT NombreRepresentante FROM PARAMETROSSIS);
		SET	Var_Representante	:= IFNULL(Var_Representante,Cadena_Vacia);

		SET	Var_DirecInstit	:= (SELECT DirFiscal FROM INSTITUCIONES WHERE InstitucionID = Par_InstitucionID);

		SET	Var_DiaFecha	:= IF(DAY(Var_FechaConvenio)<10,CONCAT('0',DAY(Var_FechaConvenio)),DAY(Var_FechaConvenio));
		-- SELECT FINAL
		SELECT	Var_NumRegistro,
				CONCAT(Var_DiaFecha,' de ', FUNCIONMESNOMBRE(Var_FechaConvenio),' de ',
				YEAR(Var_FechaConvenio)) AS Var_FechaConvenio,
				Var_Aportante,
				Var_RfcAportante,
				Var_CalleAport,
				Var_NumAport,
				Var_ColoniaAport,
				Var_CiudadAport,
				Var_EstadoAport,
				Var_CpAport,
				Var_TelAport,
				Var_CelAport,
				Var_CorreoAport,
				Var_NomApo1,
				Var_NomApo2,
				Var_Representante,
				Var_RepLegalAport,
				Var_NacAport,
				Var_IdentiAport,
				Var_DiaNumAutoriza,
				Var_DiaLetAutoriza,
				Var_MesAutoriza,
				Var_AnioNumAutoriza,
				Var_AnioLetAutoriza,
				Var_DirecInstit,
				Var_TipoPersona,
				Var_TipoRecibo;
	END IF; -- FIN CONSULTA PRINCIPAL

	IF(Par_NumCon = Con_Benef)THEN

		-- Obteniendo valores a utilizar de la Aportacion
		SELECT	CuentaAhoID
			INTO Var_CuentaAhoID
		FROM 	APORTACIONES
		WHERE 	AportacionID	= Par_AportacionID;

		SELECT cta.NombreCompleto, tip.Descripcion,
				IF(cta.Porcentaje=NULL,Cadena_Vacia,CONCAT(cta.Porcentaje,'%')) AS Porcentaje
		FROM CUENTASPERSONA cta
		INNER JOIN TIPORELACIONES tip on cta.ParentescoID = tip.TipoRelacionID
		WHERE cta.CuentaAhoID=Var_CuentaAhoID
		AND cta.EsBeneficiario = Cons_SI
		ORDER BY cta.PersonaID ASC;
	END IF;

	IF(Par_NumCon = Con_Amortiza)THEN
		SET	Var_Titulo	:= (SELECT (CASE
										WHEN (TipoPagoInt = 'V') THEN "APORTACIONES AL VENCIMIENTO"
										WHEN (TipoPagoInt = 'E' AND PagoIntCapitaliza='S') THEN "INTERESES  CAPITALIZABLES  MENSUALMENTE  VENCIDOS"
										WHEN (TipoPagoInt = 'E' AND PagoIntCapitaliza='N') THEN "INTERESES  PAGADEROS  MENSUALMENTE  VENCIDOS"
										ELSE ''
									END) AS Titulo FROM APORTACIONES WHERE AportacionID = Par_AportacionID);
		SELECT	Am.FechaPago,	Ap.ClienteID,	Am.AportacionID,	Cl.NombreCompleto,	T.Descripcion,
				Ap.Notas,		Ap.FechaInicio,
				ROUND(Ap.TasaISR,2) AS TasaISR,	ROUND(Ap.TasaFija,2) AS TasaFija,
				CAST(FORMAT(Ap.Monto,2) AS CHAR) AS Monto,
				CASE
					WHEN Ap.PagoIntCapitaliza = Cons_SI THEN CAST(FORMAT(Am.SaldoCap + Am.Interes - Am.InteresRetener,2) AS CHAR)
					WHEN Ap.PagoIntCapitaliza = Cons_NO AND Ap.TipoPagoInt = 'V' THEN CAST(FORMAT(Ap.Monto + Ap.InteresRecibir,2) AS CHAR)
					WHEN Ap.PagoIntCapitaliza = Cons_NO THEN Cadena_Vacia
				END AS SaldoCap,
				CAST(FORMAT(Am.Interes,2) AS CHAR) AS Interes,
				CAST(FORMAT(Am.InteresRetener,2) AS CHAR) AS InteresRetener,
				CAST(FORMAT(Am.Interes-Am.InteresRetener,2) AS CHAR) AS InteresRecibir,
				CAST(FORMAT(Ap.InteresGenerado,2) AS CHAR) AS TotalInteres,
				CAST(FORMAT(Ap.InteresRetener,2) AS CHAR) AS TotalInteresRetener,
				CAST(FORMAT(Ap.InteresRecibir,2) AS CHAR) AS TotalInteresRecibir,
				Var_Titulo AS Titulo
		FROM AMORTIZAAPORT Am
		LEFT JOIN APORTACIONES Ap ON Ap.AportacionID = Am.AportacionID
		LEFT JOIN CLIENTES Cl ON Cl.ClienteID = Ap.ClienteID
		LEFT JOIN TIPOSAPORTACIONES T ON T.TipoAportacionID = Ap.TipoAportacionID
		WHERE Am.AportacionID = Par_AportacionID;
	END IF;


END TerminaStore$$