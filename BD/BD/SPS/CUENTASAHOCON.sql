-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOCON`;

DELIMITER $$
CREATE PROCEDURE `CUENTASAHOCON`(
# =====================================================================================
# ------- STORE PARA CONSULTAR LAS CUENTAS DE AHORRO ---------
# =====================================================================================
	Par_CuentaAhoID		BIGINT(12),				-- Numero de Cuenta
	Par_ClienteID		INT(11),    			-- Numero de Cliente
	Par_Mes				INT(11),				-- Mes de consulta
	Par_Anio			INT(11),				-- Anio de consulta
	Par_TipoCuenta		VARCHAR(15),			-- Tipo de Cuenta

	Par_NumCon			TINYINT UNSIGNED,		-- Numero de Consulta

	Aud_EmpresaID		INT(11),				-- Parametro de Auditoria
	Aud_Usuario			INT(11),				-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal		INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Parametro de Auditoria
	)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE NumErr      		INT(11);
	DECLARE ErrMen      		VARCHAR(400);
	DECLARE Var_SumPenAct		DECIMAL(12,2);
	DECLARE Var_ClienteID 		INT;
	DECLARE Var_CuentaAhoID 	BIGINT(12);
	DECLARE Var_CreditoID	 	BIGINT(20);
	DECLARE Con_Contador		INT(11);
	DECLARE Var_PolizaID		BIGINT(20);
	DECLARE Var_EstatusCli		CHAR(1);
	DECLARE Var_EstatusCta  	CHAR(1);
	DECLARE Var_Contador		BIGINT;
	DECLARE Var_TipoCtaGLAdi	INT;
	DECLARE Var_TipoCtaAho		INT;
    DECLARE Var_TotalPersonas   INT;
    DECLARE Var_ClienteInst		INT(11);
    DECLARE Var_NumCuentas		INT(11);
    DECLARE Var_GrupoID			INT(11);		-- Numero de Grupo
    DECLARE Var_CicloGrupo		INT(11);		-- Numero de Ciclo
	DECLARE Var_SaldoDisponible	 DECIMAL(18,2);
	DECLARE Var_CobraFOGAFI			CHAR(1);	-- Variable par indicar si permite el cobro de garantía financiada
	DECLARE Var_RequiereGarFOGAFI	CHAR(1);	-- Indica si se requiere garantía FOGAFI
	DECLARE Var_RequiereGarantia	CHAR(1);	-- Indica si se requiere el cobro de garantía Liquida(FOGA)

	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Var_Si          	CHAR(1);
	DECLARE Var_No          	CHAR(1);
	DECLARE Estatus_Activa  	CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero     	INT;
	DECLARE Blo_AutoDep     	INT;
	DECLARE Tipo_Bloqueo    	CHAR(1);
	DECLARE Con_Principal   	INT;
	DECLARE Con_Foranea     	INT;
	DECLARE Con_DispEstatus 	INT;
	DECLARE Con_PantRegis   	INT;
	DECLARE Con_Campos      	INT;
	DECLARE Con_SaldoDisp   	INT;
	DECLARE Con_Saldos      	INT;
	DECLARE Con_FirmAS        	INT;
	DECLARE Con_Report      	INT;
	DECLARE Con_CtasCteWS   	INT;
	DECLARE Con_DisponCteWS 	INT;
	DECLARE Con_CuentaPrin  	INT;
	DECLARE Con_CtaPrinAct  	INT;
	DECLARE Con_CtaGLAdi		INT;	-- PARA LA CONSULTA DE GL ADICIONAL
	DECLARE Con_CtaBloqueo   	INT; 	-- Para la  cosnuslta de cuenta bloquear
	DECLARE Con_CtaDesbloq   	INT; 	-- Para la consulta de cuenta a desbloquear
	DECLARE Con_SalDispWS   	INT;
	DECLARE Con_CueAhoWS    	INT;
	DECLARE Con_SaldosWS    	INT;
	DECLARE Con_CtaAsocia		INT;
	DECLARE Var_TipoCuentaID	INT;
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Con_BenefCta		INT;
	DECLARE Esta_Vigente		CHAR(1);
	DECLARE Con_TotalSalCel 	INT;
	DECLARE Con_CtaCteActPade 	INT;
    DECLARE VarNumReg		INT(5); -- Numero de registros
	DECLARE VarFirma1		VARCHAR(70); -- Firma 1
	DECLARE VarFirma2		VARCHAR(70); -- Firma 2
	DECLARE VarFirma3		VARCHAR(70); -- Firma 3
	DECLARE VarFirma4		VARCHAR(70); -- Firma 4
	DECLARE VarFirma5		VARCHAR(70); -- Firma 5
	DECLARE VarFirma6		VARCHAR(70); -- Firma 6
	DECLARE Var_Cadena		VARCHAR(500); -- Cadena con nombres de firmantes
    DECLARE Con_CtaCliente		INT(11);
    DECLARE PersonaFisica	CHAR(1);			-- Tipo Persona: FISICA
	DECLARE PersonaMoral	CHAR(1);			-- Tipo Persona: MORAL
	DECLARE PerActivEmp		CHAR(1);			-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL
    DECLARE Con_CtasCredAuto	INT(11);
    DECLARE Con_SaldoPagoCargoCta	INT(11);
   	DECLARE Var_SaldoBloqXReferencia DECIMAL(18,2);
	DECLARE Con_SaldoPagoFogafi	TINYINT UNSIGNED;
	DECLARE Con_NO			 		CHAR(1);		-- Constante NO
	DECLARE Con_SI			 		CHAR(1);		-- Constante SI
    DECLARE Con_CtaAhoDepositoActiva INT(11);
	DECLARE Est_DepReg	     	INT(11);      		-- Estatus registrado Uno
	DECLARE Est_DepPag	     	INT(11);      		-- Estatus pagado dos

	/* Asignacion de Constantes */
	SET Cadena_Vacia    		:= '';                  -- Cadena Vacia
	SET Var_Si          		:= 'S';                 -- Valor: SI
	SET Var_No          		:= 'N';                 -- Valor: NO
	SET Estatus_Activa  		:= 'A';                 -- Estatus de la Cuenta: Activa
	SET Fecha_Vacia     		:= '1900-01-01';        -- Fecha Vacia
	SET Entero_Cero    			:= 0;                   -- Entero en Cero
	SET Blo_AutoDep     		:= 13;                  -- Tipo de Bloqueo Automatico en cada Deposito
	SET Tipo_Bloqueo    		:= 'B';                 -- Tipo de Movimiento de Bloqueo
	SET Decimal_Cero			:= 0.00;

	SET Con_Principal   		:= 1;                   -- Consulta Principal
	SET Con_Foranea     		:= 2;                   -- Consulta Llave Foranea
	SET Con_PantRegis   		:= 3;                   -- Consulta para Registro o Alta de Cuenta
	SET Con_Campos      		:= 4;                   -- Consulta Cuenta, Tipo de Cuenta
	SET Con_SaldoDisp   		:= 5;                   -- Consulta del Saldo Disponible
	SET Con_Saldos      		:= 6;                   -- Consulta de Saldos (Iniciales, Cargo y Abonos Dia, etc)
	SET Con_FirmAS      		:= 7;                   -- Consulta para Pantalla de FirmAS   de la Cuenta
	SET Con_Report      		:= 8;                   -- Consulta para Reporte de la Cuenta
	SET Con_DispEstatus 		:= 9;                   -- Consulta de Disponible y Estatus
	SET Con_CtasCteWS   		:= 10;                  -- Consulta de lAS   CuentAS   del Cliente para WebService
	SET Con_DisponCteWS 		:= 11;                  -- Consulta de Saldo del Cliente para WebService
	SET Con_CuentaPrin  		:= 14;                  -- Consulta de la Cuenta Principal del Cliente
	SET Con_CtaPrinAct  		:= 15;                  -- Consulta de la Cuenta Principal Activa del Cliente
	SET Con_CtaGLAdi			:= 16;					-- Consulta de la cuenta por cliente de garantia liq adicional
	SET Con_CtaBloqueo  		:= 17;             		-- Consulta para bloquear Cuenta Bloqueo automatico A,I,P.
	SET Con_CtaDesbloq  		:= 18;              	-- Consulta para desbloquear Cuenta Bloqueo automatico V,K,A,B.
	SET Con_SalDispWS   		:= 19;               	-- consulta del saldo disponible para el WS y su descripcion para Banca En Linea
	SET Con_CueAhoWS    		:= 20;					-- consulta el nombre del cliente y su tipo de cuenta
	SET Con_SaldosWS    		:= 21;    				-- Condulta los saldos del cliente para mostrarlos en la pantalla de banca en linea
	SET Con_CtaAsocia			:= 23;					-- Consulta para pantalla de Asociacion Tarjetas
	SET Con_BenefCta			:= 24;					-- Consulta si el cliente tiene una cuenta Activa con beneficiarios
	SET Esta_Vigente			:= 'V';					-- Estatus vigente
	SET Con_TotalSalCel 		:= 25;     				-- consulta para el WS que obtiene el Saldo, Etiqueta y Telefono Celular
	SET Var_Contador			:= 8000000;
	SET Con_CtaCteActPade 		:= 30;					-- Consulta de cuentas activas del cliente y retornar su telefono para el alta en pademobile
	SET Con_CtaCliente			:= 31;					-- Consulta para obtener las cuentas de Clientes pero que no sean cuentas Institucionales
	SET Con_CtasCredAuto		:= 32;					-- Consulta especifica para creditos automaticos, se obtiene la tasa de rendimiento de la cuenta.
	SET Con_SaldoPagoCargoCta	:= 33;					-- Consulta especifica para creditos automaticos, se obtiene la tasa de rendimiento de la cuenta.
	SET Con_SaldoPagoFogafi		:= 34;					-- Consulta especifica para creditos fogafi por barredora
    SET PersonaFisica			:= 'F';					-- Tipo Persona: FISICA
	SET PersonaMoral			:= 'M';					-- Tipo Persona: MORAL
	SET PerActivEmp				:= 'A';					-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL
	SET Con_NO					:= 'N';
	SET Con_SI					:= 'S';
    SET Con_CtaAhoDepositoActiva:= 36;					-- Consulta de cuenta que requiere deposito para activacion
	SET Est_DepReg          	:= 1;
	SET Est_DepPag          	:= 2;

	IF(Par_NumCon = Con_Principal) THEN
		SELECT	CuentaAhoID,	SucursalID,		ClienteID,		Clabe,			MonedaID,
				TipoCuentaID,	FechaReg,		FechaApertura, 	UsuarioApeID,	Etiqueta,
				UsuarioCanID,	FechaCan, 		MotivoCan,		MotivoBlo, 		UsuarioBloID,
				MotivoDesbloq,	FechaDesbloq,	UsuarioDesbID,	Saldo,			SaldoDispon,
				SaldoBloq,		SaldoSBC,		SaldoIniMes,	CargosMes,		AbonosMes,
				Comisiones,		SaldoProm,		TasaInteres,	InteresesGen,	ISR,
				TasaISR,		SaldoIniDia,	CargosDia,		AbonosDia,		Estatus,
				EstadoCta,		InstitucionID,	EsPrincipal,    TelefonoCelular
			FROM CUENTASAHO
			WHERE  	CuentaAhoID = Par_CuentaAhoID;
	END  IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT	`CuentaAhoID`, 		`ClienteID`
			FROM CUENTASAHO
			WHERE  	CuentaAhoID = Par_CuentaAhoID;
	END IF;

	IF(Par_NumCon = Con_PantRegis) THEN
		SELECT	CTA.CuentaAhoID,	 	CTA.SucursalID,		CTA.ClienteID,	 	CTA.Clabe,			CTA.MonedaID,
				CTA.TipoCuentaID,		CTA.FechaReg,		CTA.Etiqueta,		CTA.Estatus,		CTA.EstadoCta,
				CTA.InstitucionID,		CTA.EsPrincipal, 	CTA.MotivoBlo,      CTA.TelefonoCelular,IFNULL(DEP.Estatus,Entero_Cero) AS EstatusDepositoActiva
		FROM CUENTASAHO CTA
			LEFT JOIN DEPOSITOACTIVACTAAHO DEP
				ON CTA.CuentaAhoID = DEP.CuentaAhoID
		WHERE CTA.CuentaAhoID = Par_CuentaAhoID;
	END IF;

	IF(Par_NumCon = Con_Campos) THEN

		SELECT COUNT(CuentaAhoID)
		INTO Var_TotalPersonas
		FROM CUENTASPERSONA
        WHERE CuentaAhoID = Par_CuentaAhoID
			AND EstatusRelacion = Esta_Vigente;

		SELECT	CA.CuentaAhoID,			CA.SucursalID, 														CA.ClienteID ,				CA.Clabe,								CA.MonedaID,
				MO.Descripcion,			CA.TipoCuentaID,													TCTA.Descripcion,			CA.FechaReg,							CA.Etiqueta,
				CA.Estatus,				IFNULL(Var_TotalPersonas,Entero_Cero) AS TotalPersonas, 		FORMAT(Saldo,2) AS Saldo, 	FORMAT(SaldoDispon,2) AS SaldoDispon,	MO.DescriCorta
			FROM 	CUENTASAHO CA
					INNER JOIN MONEDAS MO ON CA.MonedaID= MO.MonedaID
					INNER JOIN TIPOSCUENTAS TCTA ON CA.TipoCuentaID=TCTA.TipoCuentaID
			WHERE	CA.CuentaAhoID 	  = Par_CuentaAhoID;
	END IF;

	IF(Par_NumCon = Con_SaldoDisp) THEN 	 /* Consultar Saldo Disponible */
		SELECT 	CuentaAhoID,						ClienteID,							FORMAT(Saldo,2) AS Saldo, 			FORMAT(SaldoDispon,2) AS SaldoDispon,
				FORMAT(SaldoSBC,2) AS SaldoSBC, 	FORMAT(SaldoBloq,2) AS SaldoBloq,	ca.MonedaID,						DescriCorta,
				Estatus,					        IFNULL(Gat,Decimal_Cero) AS Gat,	FORMAT(SaldoProm,2) AS SaldoProm,	IFNULL(GatReal,Decimal_Cero) AS GatReal
			FROM CUENTASAHO ca,
				MONEDAS		mon
			WHERE	CuentaAhoID	  	= Par_CuentaAhoID
			  AND 	mon.MonedaId 	= ca.MonedaID;

	END IF;

	IF(Par_NumCon = Con_Saldos) THEN

		SELECT 	CASE WHEN MAX(Cli.PagaIVA) = Var_Si THEN SUM(Pen.CantPenAct)+ SUM(Pen.CantPenAct* Suc.IVA) ELSE SUM(Pen.CantPenAct) END AS   CantPenAct
		INTO 	Var_SumPenAct
			FROM COBROSPEND Pen
				INNER JOIN CLIENTES Cli ON Pen.ClienteID 	= Cli.ClienteID
				INNER JOIN SUCURSALES Suc ON Suc.SucursalID	= Cli.SucursalOrigen
			WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
			  AND 	Pen.ClienteID 	= Par_ClienteID
			GROUP BY Cli.ClienteID;

		SELECT	CuentaAhoID,	 					ClienteID ,							MonedaID,								FORMAT(SaldoIniMes,2) AS SaldoIniMes,
				FORMAT(CargosMes,2) AS CargoMes,	FORMAT(AbonosMes,2) AS AbonosMes,	FORMAT(SaldoIniDia,2) AS SaldoIniDia,	FORMAT(CargosDia,2) AS CargosDia,
                FORMAT(AbonosDia,2) AS AbonosDia,	FORMAT(IFNULL(Var_SumPenAct,0),2) AS Var_SumPenAct
			FROM CUENTASAHO
			WHERE  CuentaAhoID	= Par_CuentaAhoID
			  AND 	ClienteID	= Par_ClienteID;

	END IF;

	IF(Par_NumCon = Con_Firmas) THEN


	SELECT COUNT(CPer.NombreCompleto), GROUP_CONCAT(CPer.NombreCompleto) INTO VarNumReg, Var_Cadena
		FROM CUENTASPERSONA CPer
		LEFT OUTER JOIN CUENTASFIRMA CFir ON CPer.PersonaID = CFir.PersonaID AND CPer.CuentaAhoID = CFir.CuentaAhoID
		WHERE CPer.CuentaAhoID = Par_CuentaAhoID
        AND CPer.EsFirmante = Var_Si
        AND CPer.EstatusRelacion  = Esta_Vigente;

	SET VarNumReg := IFNULL(VarNumReg, Entero_Cero);

	IF(VarNumReg = 1)THEN
			SELECT SUBSTRING_INDEX( Var_Cadena , ',', 1 )
				INTO VarFirma1;
		ELSE IF(VarNumReg = 2)THEN
			SELECT 	SUBSTRING_INDEX( Var_Cadena , ',', 1 ),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 2 ),',',-1)
				INTO VarFirma1, VarFirma2;
		ELSE IF(VarNumReg = 3)THEN
			SELECT 	SUBSTRING_INDEX( Var_Cadena , ',', 1 ),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 2 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena, ',', 3 ),',',-1)
				INTO VarFirma1, VarFirma2, VarFirma3;
		ELSE IF(VarNumReg = 4)THEN
			SELECT	SUBSTRING_INDEX( Var_Cadena , ',', 1 ),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 2 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 3 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 4 ),',',-1)
				INTO VarFirma1, VarFirma2, VarFirma3, VarFirma4;
		ELSE IF(VarNumReg = 5) THEN
			SELECT	SUBSTRING_INDEX( Var_Cadena , ',', 1 ),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 2 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 3 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 4 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 5 ),',',-1)
				INTO VarFirma1, VarFirma2, VarFirma3, VarFirma4,VarFirma5;
		ELSE IF(VarNumReg = 6) THEN
			SELECT	SUBSTRING_INDEX( Var_Cadena , ',', 1 ),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 2 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 3 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 4 ),',',-1),
					SUBSTRING_INDEX(SUBSTRING_INDEX( Var_Cadena , ',', 5 ),',',-1),
					SUBSTRING_INDEX( Var_Cadena , ',', -1 )
				INTO VarFirma1, VarFirma2, VarFirma3, VarFirma4,VarFirma5,VarFirma6;
		END IF;
		END IF;
		END IF;
		END IF;
		END IF;
    END IF;

		SELECT	(SELECT LPAD(CONVERT(CA.CuentaAhoID,CHAR),11,0)) AS CuentaAhoID,	(SELECT LPAD(CONVERT(SU.SucursalID,CHAR),3,0)) AS SucursalID,
				(SELECT LPAD(CONVERT(TCTA.TipoCuentaID,CHAR),3,0)) AS TipoCuentaID,	(SELECT LPAD(CONVERT(MO.MonedaId,CHAR),3,0)) AS MonedaId,
				SU.NombreSucurs,													TCTA.Descripcion,
				MO.Descripcion AS   DescripcionMon,									DireccionCompleta,
				CASE 	WHEN CL.TipoPersona = PersonaMoral 	THEN 'MORAL'
						WHEN CL.TipoPersona = PersonaFisica THEN 'FISICA'
						WHEN CL.TipoPersona = PerActivEmp 	THEN 'FISICA ACT. EMP.' END  AS   TipoPersona,
				CL.NombreCompleto AS NombreCompletoCte, FechaSistema AS fecha,
                    IFNULL(VarFirma1,Cadena_Vacia) AS VarFirma1, IFNULL(VarFirma2,Cadena_Vacia)AS VarFirma2, IFNULL(VarFirma3, Cadena_Vacia)AS VarFirma3 ,
                    IFNULL(VarFirma4, Cadena_Vacia) AS VarFirma4,IFNULL(VarFirma5,Cadena_Vacia)AS VarFirma5,IFNULL(VarFirma6,Cadena_Vacia)AS VarFirma6
			FROM CUENTASAHO CA,
				SUCURSALES SU,
				MONEDAS   MO,
				TIPOSCUENTAS TCTA,
				CLIENTES CL,
				DIRECCLIENTE DIR,
				PARAMETROSSIS
			WHERE  	CA.CuentaAhoID 	= Par_CuentaAhoID
			  AND	CA.SucursalID	= SU.SucursalID
			  AND 	CA.MonedaID		= MO.MonedaId
		      AND	CA.TipoCuentaID	= TCTA.TipoCuentaID
			  AND 	CA.ClienteID	= CL.ClienteID
			  AND 	DIR.ClienteID 	= CA.ClienteID
			  AND 	DIR.ClienteID 	= CL.ClienteID
			  AND	DIR.Oficial 	= Var_Si;
	END IF;


	IF(Par_NumCon = Con_Report) THEN
		SELECT	`CuentaAhoID`,		`SucursalID`,		CA.ClienteID,		`Clabe`,			`MonedaID`,
				`TipoCuentaID`,		`FechaReg`,			`FechaApertura`, 	`UsuarioApeID`,		`Etiqueta`,
				`FechaCan`, 		`MotivoCan`,		`MotivoBlo`, 		`UsuarioBloID`, 	`SaldoDispon`,
				`SaldoIniMes`, 		`CargosMes`,		`AbonosMes`, 		`Comisiones`, 		`SaldoProm`,
				`TasaInteres`,		`InteresesGen`,		`ISR`, 				`TasaISR`, 			`SaldoIniDia`,
				`CargosDia`,		`AbonosDia`,		CA.Estatus,		 	CL.NombreCompleto
			FROM CUENTASAHO CA,
				CLIENTES CL
			WHERE 	CuentaAhoID 	= Par_CuentaAhoID
			  AND 	CA.ClienteID	= Par_ClienteID
			  AND 	CL.ClienteID	= CA.ClienteID;
	END IF;

	IF(Par_NumCon = Con_DispEstatus) THEN
		SELECT  ClienteID, 	SaldoDispon, 	MonedaID, 	Estatus
			FROM CUENTASAHO
			WHERE	CuentaAhoID	= Par_CuentaAhoID;
	END IF;

	IF(Par_NumCon = Con_CtasCteWS) THEN
		IF(NOT EXISTS(SELECT ClienteID
				FROM CUENTASAHO
				WHERE	ClienteID	= Par_ClienteID)) THEN
				SET NumErr := '002';
				SET ErrMen := 'El numero de Cliente no existe.';
				SELECT 	Entero_Cero,	Cadena_Vacia, 	Entero_Cero,	NumErr,		ErrMen;
		ELSE
			IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
				SET NumErr := '001';
				SET ErrMen := 'El numero de Cliente esta Vacio.';
				SELECT 	Entero_Cero,	Cadena_Vacia, 	Entero_Cero,	NumErr,		ErrMen;
			ELSE
				SET NumErr := '000';
				SET ErrMen := 'Consulta Exitosa';
				SELECT 	CuentaAhoID,	Etiqueta, 		SaldoDispon ,	NumErr,		ErrMen
					FROM CUENTASAHO
					WHERE  ClienteID = Par_ClienteID;
			END IF;
		END IF;
	END IF;

	IF(Par_NumCon = Con_DisponCteWS) THEN
		IF(NOT EXISTS(SELECT ClienteID
				FROM CUENTASAHO
				WHERE	ClienteID	= Par_ClienteID)) THEN
				SET NumErr := '002';
				SET ErrMen := 'El numero de Cliente no existe.';
				SELECT 	Entero_Cero,	NumErr,		ErrMen;
		ELSE
			IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
				SET NumErr := '001';
				SET ErrMen := 'El numero de Cliente esta Vacio.';
				SELECT 	Entero_Cero,	NumErr,		ErrMen;
			ELSE
				SET 	NumErr := '000';
				SET 	ErrMen := 'Consulta Exitosa';
				SELECT 	SUM(SaldoDispon)  AS SaldoDispon ,	NumErr,		ErrMen
					FROM CUENTASAHO
					WHERE  ClienteID = Par_ClienteID
					GROUP BY ClienteID;
			END IF;
		END IF;
	END IF;


	IF (Par_NumCon = Con_CtaAsocia)THEN
		SELECT	TipoCuentaID	INTO	Var_TipoCuentaID
			FROM CUENTASAHO
            WHERE	CuentaAhoID = Par_CuentaAhoID;

		IF EXISTS(
			SELECT	TipoTarjetaDebID
				FROM TIPOSCUENTATARDEB
				WHERE	TipoTarjetaDebID	= Par_TipoCuenta
				   AND	TipoCuentaID 		= Var_TipoCuentaID) THEN

			SELECT	Cta.CuentaAhoID,	 	Cta.SucursalID,		Cta.ClienteID,	 	Cta.Clabe,		Cta.MonedaID,
					Cta.TipoCuentaID,		Cta.FechaReg,		Cta.Etiqueta,		Cta.Estatus,	Cta.EstadoCta,
					Cta.InstitucionID,		Cta.EsPrincipal
				FROM CUENTASAHO Cta
					INNER JOIN TIPOSCUENTAS Tc ON Tc.TipoCuentaID = Cta.TipoCuentaID
				WHERE	Cta.Estatus = Estatus_Activa
				  AND	CuentaAhoID = Par_CuentaAhoID;
		END IF;
	END IF;

	IF(Par_NumCon = Con_CuentaPrin) THEN
		SELECT	`CuentaAhoID`,	`ClienteID`
			FROM CUENTASAHO
			WHERE  	ClienteID 	= Par_ClienteID
			  AND 	EsPrincipal = Var_Si;
	END IF;

	IF(Par_NumCon = Con_CtaPrinAct) THEN
		SELECT	CuentaAhoID,	ClienteID
			FROM	CUENTASAHO
			WHERE  	ClienteID 	= Par_ClienteID
			  AND 	EsPrincipal = Var_Si
			  AND 	Estatus 	= Estatus_Activa
		LIMIT 1;
	END IF;

	IF(Par_NumCon = Con_CtaCteActPade) THEN
		SELECT	CuentaAhoID,	ClienteID,	TelefonoCelular
			FROM	CUENTASAHO
			WHERE CuentaAhoID   = Par_CuentaAhoID
			  AND	Estatus 	= Estatus_Activa;
	END IF;

	IF(Par_NumCon = Con_CtaGLAdi) THEN
        SELECT TipoCtaGLAdi  INTO Var_TipoCtaGLAdi FROM
        PARAMETROSSIS WHERE EmpresaID = 1;

        SELECT TipoCuentaID INTO Var_TipoCtaAho FROM
        CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID;

        IF Var_TipoCtaGLAdi = Var_TipoCtaAho THEN
			SELECT CuentaAhoID,	ClienteID FROM
            CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID;
		ELSE

			SELECT	CuentaAhoID,	ClienteID
			FROM CUENTASAHO,
				PARAMETROSSIS
			WHERE  	ClienteID 	= Par_ClienteID
			  AND 	Estatus = Estatus_Activa
			  AND 	TipoCuentaID = TipoCtaGLAdi
			LIMIT 1;

        END IF;


	END IF;

	-- Consulta para Bloqueo Automatico Masivo
	IF(Par_NumCon = Con_CtaBloqueo) THEN
		SELECT	COUNT(Cue.CuentaAhoID), SUM(Cue.SaldoDispon)
			FROM 	CUENTASAHO Cue
				INNER JOIN TIPOSCUENTAS AS Tip 	ON	Tip.TipoCuentaID	= Cue.TipoCuentaID
												AND	Tip.EsBloqueoAuto	= Var_Si
			WHERE 	SaldoDispon > Entero_Cero
			  AND 	Cue.Estatus = Estatus_Activa;
	END IF;

	-- Consulta para DesBloqueo Automatico Masivo
	IF(Par_NumCon = Con_CtaDesbloq) THEN
		SELECT	COUNT(DISTINCT(CuentaAhoID)), SUM(MontoBloq)
			FROM BLOQUEOS Blo
			WHERE	TiposBloqID = Blo_AutoDep
			  AND	NatMovimiento = Tipo_Bloqueo
			  AND	IFNULL(FolioBloq, Entero_Cero) = Entero_Cero;
	END IF;

	-- Consulta el Saldo Disponible para
	IF(Par_NumCon = Con_SalDispWS) THEN
		SET Var_ClienteID	:= (SELECT	ClienteID	FROM CLIENTES	WHERE	ClienteID	= Par_ClienteID);
		SET Var_CuentaAhoID := (SELECT	CuentaAhoID	FROM CUENTASAHO	WHERE	CuentaAhoID = Par_CuentaAhoID);
		IF(IFNULL(Var_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
			SET NumErr := '002';
			SET ErrMen := 'La Cuenta no existe';
			SELECT	Entero_Cero AS CuentaAhoID,	Entero_Cero AS SaldoDisp,	Cadena_Vacia AS Etiqueta,
					NumErr,	ErrMen;
		ELSE
			SET NumErr := '000';
			SET ErrMen := 'Consulta Exitosa';
			SELECT	ca.CuentaAhoID,	FORMAT(SaldoDispon,2) AS SaldoDisp, ca.Etiqueta,
					NumErr, ErrMen
				FROM CUENTASAHO ca INNER JOIN TIPOSCUENTAS tc ON ca.TipoCuentaID	= tc.TipoCuentaID
				WHERE	CuentaAhoID	= Par_CuentaAhoID;
		END IF;
	END IF;

	IF(Par_NumCon = Con_CueAhoWS) THEN
		SELECT  Cli.ClienteID, Cli.NombreCompleto, Tc.TipoCuentaID, Tc.Descripcion,Ca.Clabe
			FROM CUENTASAHO Ca
				INNER JOIN CLIENTES Cli ON Ca.ClienteID	= Cli.ClienteID
				INNER JOIN TIPOSCUENTAS Tc ON Ca.TipoCuentaID	= Tc.TipoCuentaID
			WHERE	Ca.CuentaAhoID = Par_CuentaAhoID;
	END IF;



	IF(Par_NumCon = Con_SaldosWS) THEN
		SET NumErr := '000';
		SET ErrMen := 'Consulta Exitosa';

		SELECT	CASE WHEN MAX(Cli.PagaIVA) = Var_Si THEN
				SUM(Pen.CantPenAct) + SUM(Pen.CantPenAct * Suc.IVA)
				ELSE SUM(Pen.CantPenAct)
				END AS CantPenAct
		INTO 	Var_SumPenAct
			FROM COBROSPEND Pen
				INNER JOIN CLIENTES Cli ON Pen.ClienteID 	= Cli.ClienteID
				INNER JOIN SUCURSALES Suc ON Suc.SucursalID	= Cli.SucursalOrigen
			WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
			  AND 	Pen.ClienteID 	= Par_ClienteID
			  GROUP BY Cli.ClienteID;

		SELECT 	CuentaAhoID,	ClienteID,
				FORMAT(Saldo,2) AS Saldo,
				FORMAT(SaldoDispon,2) AS SaldoDisp,
				FORMAT(SaldoSBC,2) AS SaldoSBC,
				FORMAT(SaldoBloq,2) AS SaldoBloqueado,
				ca.MonedaID,mon.Descripcion AS DescriCorta,	Estatus,
				FORMAT(SaldoIniMes,2) AS SaldoIniMes,
				FORMAT(CargosMes,2) AS CargoMes,
				FORMAT(AbonosMes,2) AS AbonosMes,
				FORMAT(SaldoIniDia,2) AS SaldoIniDia,
				FORMAT(CargosDia,2) AS CargosDia,
				FORMAT(AbonosDia,2) AS AbonosDia,
				FORMAT(IFNULL(Var_SumPenAct,0),2) AS Var_SumPenAct,
				tc.Descripcion AS   TipoCuenta

			FROM CUENTASAHO ca
				INNER JOIN TIPOSCUENTAS tc ON ca.TipoCuentaID	= tc.TipoCuentaID,
				MONEDAS		mon
		WHERE	CuentaAhoID		= Par_CuentaAhoID
		  AND	mon.MonedaId 	= ca.MonedaID
		  AND 	ClienteID		= Par_ClienteID;

	END IF;

	-- 24 se usa para validacion en cobro seguro de vida ayuda ventanilla --
	IF(Par_NumCon = Con_BenefCta) THEN
		SELECT	DISTINCT Per.CuentaAhoID	INTO	Var_CuentaAhoID
			FROM CUENTASAHO Cue,
				CUENTASPERSONA Per,
				TIPORELACIONES Tip
			WHERE Cue.ClienteID			= Par_ClienteID
			  AND Cue.Estatus			= Estatus_Activa
			  AND Cue.EsPrincipal		= Var_Si
			  AND Cue.CuentaAhoID		= Per.CuentaAhoID
			  AND Per.EstatusRelacion 	= Esta_Vigente
			  AND Per.EsBeneficiario	= Var_Si
			  AND Per.ParentescoID		= Tip.TipoRelacionID
			LIMIT 1;

		SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID,Entero_Cero);
		SELECT	Var_CuentaAhoID	AS CuentaAhoID;
	END IF;

	-- 25 se usa para el WS se valida que la cuenta este activa y el cliente tambien
	IF(Par_NumCon = Con_TotalSalCel) THEN
		SELECT	cte.Estatus,	cta.Estatus		INTO	Var_EstatusCli,		Var_EstatusCta
			FROM CUENTASAHO cta
				INNER JOIN CLIENTES cte ON cta.ClienteID=cte.ClienteID
			WHERE	cta.CuentaAhoID	= Par_CuentaAhoID;

		  IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET NumErr := '001';
			SET ErrMen := 'El numero de Cuenta esta Vacio.';
			SELECT Cadena_Vacia	AS Etiqueta,	Cadena_Vacia AS SaldoDispon,	Cadena_Vacia AS TelefonoCelular,	NumErr,		ErrMen;
		  ELSE
			IF(NOT EXISTS(SELECT CuentaAhoID
				FROM CUENTASAHO
					WHERE	CuentaAhoID	= Par_CuentaAhoID)) THEN
				SET NumErr := '002';
				SET ErrMen := 'El numero de Cuenta no existe.';
				SELECT	Cadena_Vacia AS	Etiqueta,	Cadena_Vacia AS	SaldoDispon,	Cadena_Vacia AS	TelefonoCelular, NumErr,	ErrMen;
			 ELSE
				IF(Var_EstatusCta = Estatus_Activa AND Var_EstatusCli = Estatus_Activa) THEN
					SET NumErr := '000';
					SET ErrMen := 'Consulta Exitosa.';
					SELECT	Etiqueta,	FORMAT(SaldoDispon,2) AS SaldoDispon,	REEMPLAZACARACTERES('[\-() ]','',TelefonoCelular) AS TelefonoCelular,	NumErr,		ErrMen
						FROM CUENTASAHO
						WHERE	CuentaAhoID = Par_CuentaAhoID;
			   ELSE
					SET NumErr := '003';
					SET ErrMen := 'El estatus de la Cuenta o Cliente es invalido (Bloqueada, Cancelada, Inactiva o Registrada)';
					SELECT	Cadena_Vacia AS	Etiqueta,	Cadena_Vacia AS SaldoDispon,	Cadena_Vacia AS TelefonoCelular,	NumErr,		ErrMen;
				END IF;
			END IF;
		END IF;
	END IF;

	IF(Par_NumCon = Con_CtaCliente) THEN

		SELECT ClienteInstitucion INTO Var_ClienteInst
		FROM PARAMETROSSIS;

        SELECT COUNT(*)
        INTO Var_NumCuentas
		FROM CUENTASAHO
		WHERE TipoCuentaID IN (SELECT TipoCuentaID FROM CUENTASAHO WHERE ClienteID = Var_ClienteInst GROUP BY TipoCuentaID)
			AND CuentaAhoID = Par_CuentaAhoID;

		SELECT COUNT(CuentaAhoID)
		INTO Var_TotalPersonas
		FROM CUENTASPERSONA
        WHERE CuentaAhoID = Par_CuentaAhoID
			AND EstatusRelacion = Esta_Vigente;

		IF(Var_NumCuentas = Entero_Cero) THEN

			SELECT	CA.CuentaAhoID,			CA.SucursalID, 														CA.ClienteID ,				CA.Clabe,								CA.MonedaID,
				MO.Descripcion,			CA.TipoCuentaID,													TCTA.Descripcion,			CA.FechaReg,							CA.Etiqueta,
				CA.Estatus,				IFNULL(Var_TotalPersonas,Entero_Cero) AS TotalPersonas, 		FORMAT(Saldo,2) AS Saldo, 	FORMAT(SaldoDispon,2) AS SaldoDispon,	MO.DescriCorta

			FROM 	CUENTASAHO CA
					INNER JOIN MONEDAS MO ON CA.MonedaID = MO.MonedaID
					INNER JOIN TIPOSCUENTAS TCTA ON CA.TipoCuentaID	  = TCTA.TipoCuentaID
			WHERE	CA.CuentaAhoID 	  = Par_CuentaAhoID;

		ELSE
			SELECT	Entero_Cero AS CuentaAhoID,		1 AS SucursalID,	Cadena_Vacia AS ClienteID,			Cadena_Vacia AS Clabe,		Cadena_Vacia AS MonedaID,
					Cadena_Vacia AS Descripcion,	Cadena_Vacia AS TipoCuentaID,	Cadena_Vacia AS Descripcion,	Cadena_Vacia AS FechaReg,		Cadena_Vacia AS Etiqueta,
                    Cadena_Vacia AS Estatus,		Cadena_Vacia AS TotalPersonas,	Cadena_Vacia AS Saldo,			Cadena_Vacia AS SaldoDispon,	Cadena_Vacia AS DescriCorta;
        END IF;
	END IF;
    # Consulta especifica para creditos automaticos.
    IF(Par_NumCon = Con_CtasCredAuto) THEN
			SELECT	CA.CuentaAhoID,	CA.SucursalID,		CA.ClienteID,		CA.Clabe,			CA.MonedaID,
				CA.TipoCuentaID,	CA.FechaReg,		CA.FechaApertura, 	CA.UsuarioApeID,	CA.Etiqueta,
				CA.UsuarioCanID,	CA.FechaCan, 		CA.MotivoCan,		CA.MotivoBlo, 		CA.UsuarioBloID,
				CA.MotivoDesbloq,	CA.FechaDesbloq,	CA.UsuarioDesbID,	CA.Saldo,			CA.SaldoDispon,
				CA.SaldoBloq,		CA.SaldoSBC,		CA.SaldoIniMes,		CA.CargosMes,		CA.AbonosMes,
				CA.Comisiones,		CA.SaldoProm,		CA.TasaInteres,		CA.InteresesGen,	CA.ISR,
				CA.TasaISR,			CA.SaldoIniDia,		CA.CargosDia,		CA.AbonosDia,		CA.Estatus,
				CA.EstadoCta,		CA.InstitucionID,	CA.EsPrincipal,    	CA.TelefonoCelular, TA.Tasa

			FROM CUENTASAHO CA
            INNER JOIN TASASAHORRO TA
            ON CA.TipoCuentaID = TA.TipoCuentaID
            INNER JOIN CLIENTES CL
            ON CA.ClienteID = CA.ClienteID
			WHERE  	CA.CuentaAhoID = Par_CuentaAhoID
            AND CL.ClienteID  = Par_ClienteID
            AND TA.TipoPersona = CL.TipoPersona
            AND TA.MontoInferior <= CA.Saldo
            AND TA.MontoSuperior >= CA.Saldo;


	END  IF;

	# CONSULTA PARA MOSTRAR EL SALDO DISPONIBLE Y SALDO BLOQ POR REFERENCIA EN PAGO CON CARGO A CTA
	IF(Par_NumCon = Con_SaldoPagoCargoCta) THEN
		SET Var_CreditoID := Aud_NumTransaccion;
		SET Var_SaldoBloqXReferencia := (SELECT SUM(MontoBloq) FROM BLOQUEOS AS BLOQ
											WHERE BLOQ.CuentaAhoID = Par_CuentaAhoID
											AND BLOQ.FolioBloq=0
											AND BLOQ.TiposBloqID = 18
                                            AND BLOQ.NatMovimiento = Tipo_Bloqueo
                                            AND BLOQ.Referencia = Var_CreditoID);

		SET Var_SaldoBloqXReferencia := IFNULL(Var_SaldoBloqXReferencia, Decimal_Cero);

		SELECT 	CuentaAhoID,						ClienteID,							FORMAT(Saldo,2) AS Saldo, 			FORMAT((SaldoDispon+Var_SaldoBloqXReferencia),2) AS SaldoDispon,
				FORMAT(SaldoSBC,2) AS SaldoSBC, 	FORMAT(SaldoBloq,2) AS SaldoBloq,	ca.MonedaID,						DescriCorta,
				Estatus,					        IFNULL(Gat,Decimal_Cero) AS Gat,	FORMAT(SaldoProm,2) AS SaldoProm,	IFNULL(GatReal,Decimal_Cero) AS GatReal
			FROM CUENTASAHO ca,
				MONEDAS		mon
			WHERE	CuentaAhoID	  	= Par_CuentaAhoID
			  AND 	mon.MonedaId 	= ca.MonedaID;

	END IF;

	-- Obtener el monto de credio de un grupo fogafi
	IF(Par_NumCon = Con_SaldoPagoFogafi) THEN
		SET Var_CreditoID := Aud_NumTransaccion;

		-- Obtiene el parámetro que indica si cobra o no garnatia financiada.
		SET Var_CobraFOGAFI := IFNULL(FNPARAMGENERALES('CobraGarantiaFinanciada'),Con_NO);


		SELECT GrupoID, 		CicloGrupo
		INTO 	Var_GrupoID,	Var_CicloGrupo
		FROM CREDITOS
		WHERE CreditoID = Var_CreditoID;


		SELECT	RequiereGarFOGAFI,		RequiereGarantia
		INTO	Var_RequiereGarFOGAFI,	Var_RequiereGarantia
		FROM DETALLEGARLIQUIDA Det
		WHERE Det.CreditoID = Var_CreditoID;

		SET Var_RequiereGarantia  :=IFNULL(Var_RequiereGarantia,  Con_NO);
		SET Var_RequiereGarFOGAFI :=IFNULL(Var_RequiereGarFOGAFI, Con_NO );

		SET Var_GrupoID		:= IFNULL(Var_GrupoID, Entero_Cero);
		SET Var_CicloGrupo	:= IFNULL(Var_CicloGrupo, Entero_Cero);

		IF( Var_GrupoID <> Entero_Cero AND Var_CicloGrupo <> Entero_Cero AND
			Var_CobraFOGAFI = Con_SI AND (Var_RequiereGarFOGAFI = Con_SI OR Var_RequiereGarantia = Con_SI)) THEN
			SET Var_SaldoDisponible	:= (SELECT SUM(IFNULL(SaldoDispon, Entero_Cero))
										FROM CREDITOS Cre
										INNER JOIN CUENTASAHO Cue ON Cre.CuentaID = Cue.CuentaAhoID
										WHERE Cre.GrupoID = Var_GrupoID
										  AND Cre.CicloGrupo = Var_CicloGrupo
										  AND Cre.Estatus <> 'P');
		END IF;

		SELECT	ClienteID,
				CASE WHEN ( Var_GrupoID <> Entero_Cero AND Var_CicloGrupo <> Entero_Cero AND
							Var_CobraFOGAFI = Con_SI AND (Var_RequiereGarFOGAFI = Con_SI OR Var_RequiereGarantia = Con_SI))
							THEN Var_SaldoDisponible
							ELSE IFNULL(SaldoDispon, Entero_Cero)
				END AS 	SaldoDispon,	MonedaID,	Estatus
		FROM CUENTASAHO
		WHERE CuentaAhoID = Par_CuentaAhoID;

	END IF;

	-- 35 -- Consulta de cuenta que requiere deposito para activacion
	IF(Par_NumCon = Con_CtaAhoDepositoActiva) THEN

		SELECT	CA.CuentaAhoID,		CA.ClienteID,		CA.TipoCuentaID,			TCTA.Descripcion AS DescripcionTipoCta,		CA.MonedaID,
        		MO.Descripcion AS DescripcionMoneda,	DE.MontoDepositoActiva,		DE.Estatus,			CL.NombreCompleto
		FROM CUENTASAHO CA,
			DEPOSITOACTIVACTAAHO DE,
			TIPOSCUENTAS TCTA,
		  	MONEDAS MO,
            CLIENTES CL
		WHERE	CA.CuentaAhoID = Par_CuentaAhoID
			AND CA.CuentaAhoID = DE.CuentaAhoID
			AND	CA.TipoCuentaID = TCTA.TipoCuentaID
			AND	CA.MonedaID = MO.MonedaID
            AND CA.ClienteID = CL.ClienteID
            AND DE.Estatus IN(Est_DepReg,Est_DepPag)
			AND DE.TipoRegistroCta = 'N';
	END IF;


END TerminaStore$$