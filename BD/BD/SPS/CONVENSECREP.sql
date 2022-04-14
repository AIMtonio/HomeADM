-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONVENSECREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONVENSECREP`;DELIMITER $$

CREATE PROCEDURE `CONVENSECREP`(
	Par_FechaInicio		DATE,
	Par_FechaFin		DATE,
	Par_TipoRep			VARCHAR(30),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
-- declaracion de variables
DECLARE Var_TipoProdCap		CHAR(1);			-- Almacena el tipo de producto de captacion
DECLARE Var_Antigue			INT; 				-- Almacena el valor de la antigüedad del socio
DECLARE Var_MontoAhoMes     DECIMAL(18,2);      -- Almacena el valor del monto de ahorro por mes
DECLARE Var_ImpMin			DECIMAL(18,2);		-- Almacena el valor del importe minimo de saldo
DECLARE Var_MesesEval		INT;				-- Almacena el valor de los meses a evaluar
DECLARE Var_ValCredAtras	CHAR(1);			-- Almacena el valor de si se validaran los dias de mora
DECLARE	Var_Fechahis		DATE;
DECLARE	Var_FechaSalCre		DATE;
DECLARE Var_ValGaranLiq		CHAR(1);			-- Almacena el valor de si se validaran los dias de mora
DECLARE Var_FechaLim		DATE;

-- declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE PreAsamGral         VARCHAR(30);		-- Preinscripcion a asamblea general
DECLARE PreAsamSecc         VARCHAR(30);		-- Preinscripcion a asamblea seccional
DECLARE InsAsamGral         VARCHAR(30);		-- Inscripcion a asamblea general
DECLARE InsAsamSecc         VARCHAR(30);		-- Inscripcion a asamblea seccional
DECLARE	Des_PreAsamGral		VARCHAR(60);
DECLARE Des_PreAsamSecc    	VARCHAR(60);
DECLARE	Des_InsAsamGral		VARCHAR(60);
DECLARE	Des_InsAsamSecc		VARCHAR(60);
DECLARE	Rep_Preins			INT;
DECLARE	Rep_Insc			INT;
DECLARE	Rep_Especial		INT;
DECLARE Var_SI              CHAR(1);
DECLARE Var_NO              CHAR(1);
DECLARE Est_Activo          CHAR(1);
DECLARE Aho_Ord				CHAR(1);            -- Que sea ahorro ordinario
DECLARE Aho_Vista           CHAR(1);            -- Que sea ahorro Vista
DECLARE Est_Vigente         CHAR(1);
DECLARE TipoMovAbono		INT;				-- tipo de movimiento abono a cuenta
DECLARE TipoBloq			INT;				-- tipo de bloqueo de saldo por abono de garantia liquida
DECLARE NatMovimiento		CHAR(1);			-- Naturaleza del movimiento: bloqueado

-- Asignacion de Constantes
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Rep_Preins			:= 1;	  -- Reporte preinscripcion
SET	Rep_Insc			:= 2;	  -- Reporte Inscripcion
SET	Rep_Especial		:= 3;	  -- Reporte especial
SET PreAsamGral			:= 'PAG'; -- Preinscripcion a asamblea general
SET PreAsamSecc			:= 'PAS'; -- Preinscripcion a asamblea seccional
SET InsAsamGral			:= 'IAG'; -- Inscripcion a asamblea general
SET InsAsamSecc			:= 'IAS'; -- Inscriocion a asamblea seccional
SET Des_PreAsamGral		:= 'PREINSCRIPCION A ASAMBLEA GENERAL';
SET Des_PreAsamSecc 	:= 'PREINSCRIPCION A ASAMBLEA SECCIONAL';
SET Des_InsAsamGral		:= 'REGISTRO A ASAMBLEA GENERAL';
SET Des_InsAsamSecc		:= 'REGISTRO A ASAMBLEA SECCIONAL';
SET Var_Si              := 'S';
SET Var_NO              := 'N';
SET Est_Activo          := 'A';
SET Aho_Ord				:= 'A'; -- Ahorro ordinario
SET Aho_Vista 			:= 'V'; -- Ahorro vista
SET Est_Vigente         := 'V';
SET TipoMovAbono		:= 10;	-- tipo de movimiento abono a cuenta
SET TipoBloq			:= 8;	-- tipo de bloqueo de saldo por abono de garantia liquida
SET NatMovimiento		:= 'B';	-- Naturaleza del movimiento: bloqueado


IF(Par_TipoRep = Rep_Preins) THEN

	SELECT P.NoSocio,P.NombreCompleto,S.NombreSucurs,(CASE
																	WHEN P.TipoRegistro = PreAsamGral THEN Des_PreAsamGral
																	WHEN P.TipoRegistro = PreAsamSecc THEN Des_PreAsamSecc END)AS TipoRegistroDes,P.FechaAsamblea,P.FechaRegistro
	FROM CONVENSECPREINS P INNER JOIN SUCURSALES S ON P.SucursalID = S.SucursalID
	WHERE P.FechaRegistro >= Par_FechaInicio AND P.FechaRegistro<=Par_FechaFin;

END IF;


IF(Par_TipoRep = Rep_Insc) THEN

	SELECT P.NoSocio,P.NombreCompleto,S.NombreSucurs,(CASE
																	WHEN P.TipoRegistro=InsAsamGral THEN Des_InsAsamGral
																	WHEN P.TipoRegistro=InsAsamSecc THEN Des_InsAsamSecc END) AS TipoRegistroDes,P.FechaAsamblea,P.FechaRegistro
	FROM CONVENSECINS P INNER JOIN SUCURSALES S ON P.SucursalID = S.SucursalID
	WHERE P.FechaRegistro >= Par_FechaInicio AND P.FechaRegistro<=Par_FechaFin;

END IF;



IF(Par_TipoRep = Rep_Especial) THEN


	SELECT TipoProdCap, AntigueSocio, MontoAhoMes, ImpMinParSoc,MesesEvalAho,ValidaCredAtras,ValidaGaranLiq
	INTO Var_TipoProdCap,Var_Antigue, Var_MontoAhoMes,Var_ImpMin,Var_MesesEval,Var_ValCredAtras,Var_ValGaranLiq
	FROM PARAMETROSCAJA
	WHERE EmpresaID = Par_EmpresaID;


DROP TABLE IF EXISTS TMVALDOS;
CREATE TEMPORARY TABLE TMVALDOS(
    ClienteID         BIGINT,
    NombreCompleto    VARCHAR(200),
    SucursalOrig      INT(11),
	CuentaAhoID       BIGINT(12)
);

	IF(Var_TipoProdCap = Aho_Ord)THEN

		INSERT INTO TMVALDOS (ClienteID , NombreCompleto, SucursalOrig,CuentaAhoID)
			SELECT	T.ClienteID,T.NombreCompleto,T.SucursalOrigen,C.CuentaAhoID
			FROM CLIENTES T INNER JOIN CUENTASAHO C ON C.ClienteID = T.ClienteID
				INNER JOIN TIPOSCUENTAS TC ON C.TipoCuentaID = TC.TipoCuentaID
			WHERE TC.ClasificacionConta	= Aho_Ord AND C.CuentaAhoID !=Entero_Cero AND
				  C.Saldo >= Var_ImpMin AND T.EsMenorEdad = Var_NO AND T.Estatus = Est_Activo
			  	 AND C.Estatus = Est_Activo AND T.FechaAlta <= DATE_ADD(Par_FechaInicio, INTERVAL -(Var_Antigue) MONTH)
				GROUP BY T.ClienteID, T.NombreCompleto, T.SucursalOrigen, C.CuentaAhoID;

		END IF;

		-- Si el tipo de ahorro es vista

		IF(Var_TipoProdCap = Aho_Vista)THEN
		INSERT INTO TMVALDOS (ClienteID , NombreCompleto, SucursalOrig,CuentaAhoID)
			SELECT	T.ClienteID,T.NombreCompleto,T.SucursalOrigen,C.CuentaAhoID
			FROM CLIENTES T INNER JOIN CUENTASAHO C ON C.ClienteID = T.ClienteID
				INNER JOIN TIPOSCUENTAS TC ON C.TipoCuentaID = TC.TipoCuentaID
			WHERE TC.ClasificacionConta	= Aho_Vista AND C.CuentaAhoID !=Entero_Cero AND
				  C.Saldo >= Var_ImpMin AND T.EsMenorEdad = Var_NO AND T.Estatus = Est_Activo
			  	 AND C.Estatus = Est_Activo AND T.FechaAlta <= DATE_ADD(Par_FechaInicio, INTERVAL -(Var_Antigue) MONTH)
		GROUP BY T.ClienteID, C.CuentaAhoID, T.NombreCompleto, T.SucursalOrigen;
		END IF;

SET Var_Fechahis := (SELECT LAST_DAY( DATE_ADD((Par_FechaInicio), INTERVAL -13 MONTH) ) );

	IF (Var_ValGaranLiq = Var_SI) THEN
	-- -------------------SI SE VALIDA GARANTIA LIQUIDA EN EL ABONO A CUENTA------------------------
	-- SE GUARDAN LOS DATOS DE ABONO A CUENTA CON TIPO DE MOVIMIENTO 10.
		DROP TABLE IF EXISTS ABONOSCTA;            -- 1
		CREATE TEMPORARY TABLE ABONOSCTA(
			CuentaAhoID       BIGINT,
			MontoMes	      DECIMAL(16,2),
			Fecha  			  DATE,
		    ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11)
		);

		INSERT INTO ABONOSCTA(CuentaAhoID,MontoMes,Fecha,ClienteID,NombreCompleto,SucursalOrig)

        SELECT mov.CuentaAhoID,SUM(mov.CantidadMov)AS MontoMes, mov.Fecha,c.ClienteID,c.NombreCompleto,c.SucursalOrig
				FROM `HIS-CUENAHOMOV` mov INNER JOIN TMVALDOS c ON mov.CuentaAhoID=c.CuentaAhoID
				WHERE mov.Fecha	> Var_Fechahis
					AND mov.TipoMovAhoID = TipoMovAbono
				GROUP BY MONTH(mov.Fecha),(c.ClienteID), mov.CuentaAhoID, mov.Fecha, c.NombreCompleto, c.SucursalOrig;

		-- SE GUARDAN LOS DATOS DE BLOQUEDO DE CUENTA POR ABONO DE GARANTIA LIQUIDA.
		DROP TABLE IF EXISTS SALDOSBLOQ;   -- 2
		CREATE TEMPORARY TABLE SALDOSBLOQ(
			CuentaAhoID       BIGINT(12),
			MontoMov	      DECIMAL(16,2),
			Fecha  			  DATE,
		    ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11)
		);

		SET Var_FechaLim := (SELECT DATE_FORMAT(Par_FechaInicio,'%Y-%m-01'));

		INSERT INTO SALDOSBLOQ(CuentaAhoID,MontoMov,Fecha,ClienteID,NombreCompleto,SucursalOrig)

				SELECT b.CuentaAhoID,SUM(b.MontoBloq)AS MontoMov,b.FechaMov,c.ClienteID,c.NombreCompleto,c.SucursalOrig
				FROM BLOQUEOS b INNER JOIN TMVALDOS c ON b.CuentaAhoID=c.CuentaAhoID
				WHERE	b.FechaMov	> Var_Fechahis AND b.FechaMov < Var_FechaLim
					AND b.TiposBloqID = TipoBloq
					AND b.NatMovimiento= NatMovimiento
					AND b.FolioBloq = Entero_Cero
				GROUP BY MONTH(b.FechaMov), (c.ClienteID), b.CuentaAhoID, b.FechaMov, c.ClienteID, c.NombreCompleto, c.SucursalOrig;

		-- SE GUARDAN LOS ABONOS NETOS DE LA CUENTA.
		DROP TABLE IF EXISTS ABONOSENELMES;   -- 3
		CREATE TEMPORARY TABLE ABONOSENELMES(
			CuentaAhoID       BIGINT(12),
			MontoNeto	      DECIMAL(16,2),
			Fecha  			  DATE,
		    ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11)
		);


		INSERT INTO ABONOSENELMES(CuentaAhoID,MontoNeto,Fecha,ClienteID,NombreCompleto,SucursalOrig)
				SELECT b.CuentaAhoID, (b.MontoMes- (IFNULL(s.MontoMov,Entero_Cero)))AS MontoNeto,b.Fecha,b.ClienteID,b.NombreCompleto,b.SucursalOrig
				FROM ABONOSCTA b LEFT OUTER JOIN SALDOSBLOQ s ON  b.CuentaAhoID=s.CuentaAhoID
				GROUP BY MONTH(b.Fecha),(b.ClienteID), b.CuentaAhoID, b.MontoMes, s.MontoMov, b.Fecha, b.ClienteID, b.NombreCompleto, b.SucursalOrig;

		DROP TABLE IF EXISTS TMVALCUATRO;
		CREATE TEMPORARY TABLE TMVALCUATRO(
			ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11),
			CuentaAhoID       BIGINT(12),
			AbonosMes   	  INT(11)
		);

		INSERT INTO TMVALCUATRO (ClienteID , NombreCompleto,SucursalOrig,CuentaAhoID, AbonosMes)
		 SELECT b.ClienteID,b.NombreCompleto,b.SucursalOrig,b.CuentaAhoID,COUNT(b.MontoNeto)AS AbonosMes
			FROM ABONOSENELMES b
			WHERE b.MontoNeto >= Var_MontoAhoMes
			GROUP BY b.CuentaAhoID, b.ClienteID, b.NombreCompleto, b.SucursalOrig;

		DROP TABLE ABONOSCTA;
		DROP TABLE SALDOSBLOQ;
		DROP TABLE ABONOSENELMES;

	ELSE
	-- -----------NO VALIDA GARANTIA LIQUIDA EN EL OBONOS A CUENTA------------------------
	-- SE GUARDAN LOS DATOS DE ABONO A CUENTA CON TIPO DE MOVIMIENTO 10.

		DROP TABLE IF EXISTS ABONOSCTA;
		CREATE TEMPORARY TABLE ABONOSCTA(
			CuentaAhoID       BIGINT(12),
			MontoMov	      DECIMAL(16,2),
			Fecha  			  DATE,
		    ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11)
		);

		INSERT INTO ABONOSCTA(CuentaAhoID,MontoMov,Fecha,ClienteID,NombreCompleto,SucursalOrig)
				SELECT mov.CuentaAhoID,SUM(mov.CantidadMov)AS MontoMes, mov.Fecha,c.ClienteID,c.NombreCompleto,c.SucursalOrig
				FROM `HIS-CUENAHOMOV` mov INNER JOIN TMVALDOS c ON mov.CuentaAhoID=c.CuentaAhoID
				WHERE mov.Fecha	> Var_Fechahis
					AND mov.TipoMovAhoID = TipoMovAbono
				GROUP BY MONTH(mov.Fecha),(c.ClienteID),  mov.CuentaAhoID, mov.Fecha, c.ClienteID, c.NombreCompleto, c.SucursalOrig;

		DROP TABLE IF EXISTS TMVALCUATRO;
		CREATE TEMPORARY TABLE TMVALCUATRO(
			ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11),
			CuentaAhoID       BIGINT(12),
			AbonosMes   	  INT(11)
		);

		INSERT INTO TMVALCUATRO (ClienteID , NombreCompleto,SucursalOrig,CuentaAhoID, AbonosMes)
		 SELECT b.ClienteID,b.NombreCompleto,b.SucursalOrig,b.CuentaAhoID,COUNT(b.MontoMov)AS AbonosMes
			FROM ABONOSCTA b
			WHERE b.MontoMov >= Var_MontoAhoMes
			GROUP BY b.CuentaAhoID, b.ClienteID, b.NombreCompleto, b.SucursalOrig;

			DROP TABLE ABONOSCTA;



	END IF;

		DROP TABLE IF EXISTS TMVALCINCO;
		CREATE TEMPORARY TABLE TMVALCINCO(
			ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11)
		);


	INSERT INTO TMVALCINCO (ClienteID , NombreCompleto, SucursalOrig)

	SELECT TC.ClienteID,TC.NombreCompleto,TC.SucursalOrig
	FROM  TMVALCUATRO TC
	WHERE TC.AbonosMes >= Var_MesesEval;

	IF(Var_ValCredAtras = Var_SI)THEN

		DROP TABLE IF EXISTS TMVALSEIS;
			CREATE TEMPORARY TABLE TMVALSEIS(
			ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11),
			DiasAtraso        INT(11)
			);

			SET Var_FechaSalCre	:= (SELECT MAX(FechaCorte) FROM SALDOSCREDITOS WHERE FechaCorte <= Par_FechaInicio);

			INSERT INTO TMVALSEIS (ClienteID , NombreCompleto, SucursalOrig,DiasAtraso)
				SELECT  T.ClienteID,T.NombreCompleto,T.SucursalOrig,SUM(SAL.DiasAtraso)
				FROM TMVALCINCO T INNER JOIN SALDOSCREDITOS SAL ON T.ClienteID = SAL.ClienteID
				WHERE SAL.FechaCorte = Var_FechaSalCre AND SAL.EstatusCredito= Est_Vigente
				GROUP BY ClienteID, T.NombreCompleto, T.SucursalOrig;



		DROP TABLE IF EXISTS TMVALSIETE;
		CREATE TEMPORARY TABLE TMVALSIETE(
			ClienteID         BIGINT,
			NombreCompleto    VARCHAR(200),
			SucursalOrig      INT(11)
		);


		INSERT INTO TMVALSIETE (ClienteID , NombreCompleto, SucursalOrig)

		SELECT TC.ClienteID,TC.NombreCompleto,TC.SucursalOrig
		FROM  TMVALSEIS TC
		WHERE TC.DiasAtraso = Entero_Cero;

		SELECT TU.ClienteID AS NoSocio, TU.NombreCompleto,S.NombreSucurs
		FROM TMVALSIETE TU INNER JOIN SUCURSALES S ON TU.SucursalOrig = S.SucursalID
		GROUP BY TU.ClienteID, TU.NombreCompleto, S.NombreSucurs;

		DROP TABLE TMVALDOS;
		DROP TABLE TMVALCUATRO;
		DROP TABLE TMVALCINCO;
		DROP TABLE TMVALSEIS;
		DROP TABLE TMVALSIETE;
	ELSE

		SELECT TU.ClienteID AS NoSocio, TU.NombreCompleto,S.NombreSucurs
		FROM TMVALCINCO TU INNER JOIN SUCURSALES S ON TU.SucursalOrig = S.SucursalID
		GROUP BY TU.ClienteID, TU.NombreCompleto, S.NombreSucurs;

		DROP TABLE TMVALDOS;
		DROP TABLE TMVALCUATRO;
		DROP TABLE TMVALCINCO;

	END IF;

END IF;



END TerminaStore$$