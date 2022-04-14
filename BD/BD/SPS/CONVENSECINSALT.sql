-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONVENSECINSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONVENSECINSALT`;DELIMITER $$

CREATE PROCEDURE `CONVENSECINSALT`(
	Par_NoTarjeta		CHAR(16),
	Par_NoSocio			INT(11),
	Par_NombreCompleto	VARCHAR(200),
	Par_Fecha			DATE,
	Par_TipoRegistro    VARCHAR(30),
	Par_SucursalID      INT(11),

	Par_Salida			CHAR(1),
    INOUT	Par_NumErr	INT,
    INOUT	Par_ErrMen	VARCHAR(350),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	NumConvenIns 	    BIGINT;
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE	Salida_SI			CHAR(1);
DECLARE	Est_Vigente			CHAR(1);			-- Estatus Vigente
DECLARE	Est_Vencido			CHAR(1);			-- Estatus Vencido
DECLARE	Est_Activo			CHAR(1);			-- Estatus Vencido
DECLARE	Var_NO				CHAR(1);
DECLARE	Var_SI				CHAR(1);
DECLARE Aho_Ord				CHAR(1);            -- Que sea ahorro ordinario
DECLARE Aho_Vista           CHAR(1);            -- Que sea ahorro Vista
DECLARE InsAsamGral         VARCHAR(30);		-- Inscripcion a asamblea general
DECLARE InsAsamSecc         VARCHAR(30);		-- Inscripcion a asamblea seccional
DECLARE TipoMovAbono		INT;				-- tipo de movimiento abono a cuenta
DECLARE TipoBloq			INT;				-- tipo de bloqueo de saldo por abono de garantia liquida
DECLARE NatMovimiento		CHAR(1);			-- Naturaleza del movimiento: bloqueado

-- Declaracion de variables
DECLARE	Var_Control			VARCHAR(200);
DECLARE Var_Consecutivo		INT(11);
DECLARE Var_FechaRegistro	DATE;				-- Fecha del registro
DECLARE	Var_MontoMinimo		DECIMAL(12,2);		-- Monto Minimo A Tener en la cuenta
DECLARE	Var_EsMenorEdad		CHAR(1);			-- Almacena si el cliente Es menor de Edad
DECLARE	Var_AbonosCons		INT(11);			-- Almacena el ahorro constante
DECLARE	Var_ClienteID		INT(11);			-- Almacena el cliente
DECLARE	Var_CtaOrdinaria	INT(11);			-- Almacena el valor del tipo de cuenta ordinaria
DECLARE	Var_CuentaAhoID		BIGINT(12);			-- Almacena el valor de la cuenta ordinaria
DECLARE	Var_Saldo			DECIMAL(12,2);		-- Almacena el valor del saldo de la cuenta
DECLARE	Var_FechaAlta		DATE;				-- Almacena el valor de la fecha de alta
DECLARE	Var_FechaSistema	DATE;				-- Almacena el valor de la fecha del sistema
DECLARE	Var_FechaApertura	DATE;				-- Almacena el valor de la fecha de apertura de la cuenta
DECLARE	Var_Fechahis		DATE;				-- Almacena el valor de la fecha
DECLARE	Var_FechaSalCre		DATE;				-- Almacena el valor de la fecha de saldoscredito
DECLARE	Var_NumAtrasos		INT(11);			-- Almacena el valor de los atrasos del cliente
DECLARE Var_TipoProdCap		CHAR(1);			-- Almacena el tipo de producto de captacion
DECLARE Var_Antigue			INT; 				-- Almacena el valor de la antigüedad del socio
DECLARE Var_MontoAhoMes     DECIMAL(18,2);      -- Almacena el valor del monto de ahorro por mes
DECLARE Var_ImpMin			DECIMAL(18,2);		-- Almacena el valor del importe minimo de saldo
DECLARE Var_MesesEval		INT;				-- Almacena el valor de los meses a evaluar
DECLARE Var_ValCredAtras	CHAR(1);			-- Almacena el valor de si se validaran los dias de mora
DECLARE Var_SucurSocio		INT(11);			-- Almacena el valor de la sucursal del socio
DECLARE Var_SucurAsam 		INT(11);			-- Almacena el valor de la sucursal de la asamblea
DECLARE Var_SucurCorp		INT(11);			-- Almacena el valor de la sucursal matriz
DECLARE Var_FechaSecc		DATE;				-- Almacena la fecha de la asamblea seccional
DECLARE Var_FechaCorp		DATE;				-- Almacena la fecha de la asambles general
DECLARE Var_FechaPreSoc     DATE;				-- Almacena la fecha de registro del socio
DECLARE Var_CantPre			INT(11);
DECLARE Var_CantIns			INT(11);
DECLARE Var_ValGaranLiq		CHAR(1);			-- Almacena el valor de si se validaran los dias de mora
DECLARE Var_FechaLim		DATE;

-- Asignacion de constantes
SET	NumConvenIns		:= 0;  	-- Numero del registro de preinscripcion
SET	Cadena_Vacia		:= ''; 	-- Constante cadena vacia
SET	Fecha_Vacia			:= '1900-01-01';-- Constante fecha vacia
SET	Entero_Cero			:= 0; 	-- Constante entero cero
SET	Decimal_Cero		:= 0.0;	-- COnstante decimal cero
SET Salida_SI			:= 'S';	-- Salida SI
SET	Est_Vigente			:= 'V';	-- estatus Vigente
SET	Est_Vencido			:= 'B';	-- Estatus Vencido
SET	Est_Activo			:= 'A';	-- Estatus Activo
SET	Var_NO				:= 'N';	-- NO
SET	Var_SI				:= 'S';	-- SI
SET Aho_Ord				:= 'A'; -- Ahorro ordinario
SET Aho_Vista 			:= 'V'; -- Ahorro vista
SET InsAsamGral			:= 'IAG'; -- Inscripcion a asamblea general
SET InsAsamSecc			:= 'IAS'; -- Inscriocion a asamblea seccional
SET TipoMovAbono		:= 10;	-- tipo de movimiento abono a cuenta
SET TipoBloq			:= 8;	-- tipo de bloqueo de saldo por abono de garantia liquida
SET NatMovimiento		:= 'B';	-- Naturaleza del movimiento: bloqueado

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := '999';
					SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											 'Disculpe las molestias que esto le ocasiona. Ref: SP-CONVENSECINSALT');
					SET Var_Control = 'sqlException' ;
				END;

IF ISNULL(Par_NoTarjeta)THEN
	SET Par_NumErr := 001;
	SET Par_ErrMen :='El numero de tarjeta esta vacio.';
	SET Var_Control:= 'tipoRegistro' ;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_NoSocio,Entero_Cero)) = Entero_Cero THEN
	SET Par_NumErr := 002;
	SET Par_ErrMen := 'El numero de socio esta Vacio.';
	SET Var_Control :=  'tipoRegistro' ;
	LEAVE ManejoErrores;
END IF;

-- Se valida que el cliente exista y este activo
SELECT 		ClienteID,		FechaAlta,		EsMenorEdad
	INTO	Var_ClienteID,	Var_FechaAlta,	Var_EsMenorEdad
FROM CLIENTES
WHERE ClienteID = Par_NoSocio
AND 	Estatus	= Est_Activo;

IF(IFNULL(Var_ClienteID, Entero_Cero)= Entero_Cero) THEN
	SET Par_NumErr 	:= 003;
	SET Par_ErrMen 	:= 'El socio no Existe o esta inactivo';
	SET Var_Control	:= 'tipoRegistro';
	LEAVE ManejoErrores;
END IF;


IF(IFNULL(Par_NombreCompleto,Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr := 004;
	SET Par_ErrMen := 'El nombre del socio esta Vacio.';
	SET Var_Control :=  'tipoRegistro' ;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_Fecha,Fecha_Vacia)) = Fecha_Vacia THEN
	SET Par_NumErr := 005;
	SET Par_ErrMen := 'La fecha esta Vacia.' ;
	SET Var_Control :=  'tipoRegistro' ;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_TipoRegistro,Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr := 006;
	SET Par_ErrMen := 'El tipo de registro esta Vacio.' ;
	SET Var_Control :=  'tipoRegistro' ;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_SucursalID,Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr := 007;
	SET Par_ErrMen := 'La sucursal esta Vacia.' ;
	SET Var_Control :=  'tipoRegistro' ;
	LEAVE ManejoErrores;
END IF;

-- Validar que el socio solo pueda inscribirse en una sola y unica fecha de seccional para asisitir.

IF(Par_TipoRegistro = InsAsamSecc)THEN

	IF NOT EXISTS (SELECT NoSocio
	   FROM CONVENSECPREINS
	   WHERE NoSocio = Par_NoSocio AND YEAR(FechaAsamblea)=YEAR(Par_Fecha) AND SucursalID = Par_SucursalID)THEN
		SET Par_NumErr	:= 14;
		SET Par_ErrMen	:='El socio no esta preinscrito';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;

	IF EXISTS (SELECT NoSocio
	   FROM CONVENSECINS
	   WHERE NoSocio = Par_NoSocio AND YEAR(FechaAsamblea)=YEAR(Par_Fecha)AND SucursalID = Par_SucursalID)THEN
		SET Par_NumErr	:= 14;
		SET Par_ErrMen	:='El socio ya se encuentra registrado';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;

	SELECT SucursalOrigen
	INTO Var_SucurSocio
	FROM CLIENTES
	WHERE ClienteID = Par_NoSocio;


	SELECT SucursalID, Fecha
	INTO Var_SucurAsam, Var_FechaSecc
	FROM PARAMCONVENSEC
	WHERE SucursalID = Par_SucursalID AND Fecha = Par_Fecha;

	IF(Var_SucurAsam !=Var_SucurSocio)THEN
	SET Par_NumErr	:= 15;
		SET Par_ErrMen	:='El socio no pertenece a la sucursal';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;

	SELECT FechaAsamblea
	INTO Var_FechaPreSoc
	FROM CONVENSECPREINS
	WHERE NoSocio = Par_NoSocio AND SucursalID = Par_SucursalID AND YEAR(FechaAsamblea) = YEAR(Par_Fecha);

	IF(Var_FechaPreSoc !=Var_FechaSecc)THEN
		SET Par_NumErr	:= 15;
		SET Par_ErrMen	:='El socio no fue preinscrito para esta fecha';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;

END IF;

-- ************

-- que sea el personal autorizado para dar de alta preinscripciones a la asamblea general
IF(Par_TipoRegistro = InsAsamGral)THEN

	IF NOT EXISTS (SELECT NoSocio
	   FROM CONVENSECPREINS
	   WHERE NoSocio = Par_NoSocio)THEN
		SET Par_NumErr	:= 14;
		SET Par_ErrMen	:='El socio no esta preinscrito';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;

	IF EXISTS (SELECT NoSocio
	   FROM CONVENSECINS
	   WHERE NoSocio = Par_NoSocio AND YEAR(FechaAsamblea)=YEAR(Par_Fecha)AND SucursalID = Par_SucursalID)THEN
		SET Par_NumErr	:= 14;
		SET Par_ErrMen	:='El socio ya se encuentra registrado';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT UsuarioID
	   FROM ASAMGRALUSUARIOAUT
	   WHERE UsuarioID = Aud_Usuario)THEN
		SET Par_NumErr	:= 14;
		SET Par_ErrMen	:='El Usuario no esta autorizado';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;

	SELECT Fecha
	INTO Var_FechaCorp
	FROM PARAMCONVENSEC
	WHERE SucursalID = Par_SucursalID AND YEAR(Fecha) = YEAR(Par_Fecha);

	SELECT FechaAsamblea
	INTO Var_FechaPreSoc
	FROM CONVENSECPREINS
	WHERE NoSocio = Par_NoSocio AND SucursalID = Par_SucursalID AND YEAR(FechaAsamblea) = YEAR(Par_Fecha);

	IF(Var_FechaPreSoc != Var_FechaCorp)THEN
		SET Par_NumErr	:= 15;
		SET Par_ErrMen	:='El socio no fue preinscrito para esta fecha';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;

	SELECT SucursalMatrizID
	INTO Var_SucurCorp
	FROM PARAMETROSSIS
	WHERE SucursalMatrizID = Par_SucursalID;

	IF(Par_SucursalID != Var_SucurCorp)THEN
		SET Par_NumErr	:= 16;
		SET Par_ErrMen	:='La sucursal no es Corporativo';
		SET Var_Control	:=  'tipoRegistro' ;
		LEAVE ManejoErrores;
	END IF;



END IF;

-- ************

-- ------------------- VALIDACIONES PARA REGISTRAR UN SOCIO EN ASAMBLEA GENERAL Y SECCIONAL-------------

IF(Par_TipoRegistro = InsAsamGral || Par_TipoRegistro = InsAsamSecc)THEN

	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);

	SELECT TipoProdCap, AntigueSocio, MontoAhoMes, ImpMinParSoc,MesesEvalAho,ValidaCredAtras,ValidaGaranLiq
	INTO Var_TipoProdCap,Var_Antigue, Var_MontoAhoMes,Var_ImpMin,Var_MesesEval,Var_ValCredAtras,Var_ValGaranLiq
	FROM PARAMETROSCAJA
	WHERE EmpresaID = Par_EmpresaID;

-- tomando en cuenta que el socio tiene solo 1 cuenta activa de cada tipo de producto ya sea ordinario o vista

	-- ************
	-- * Validar que el socio tenga un monto mínimo en su ahorro.
	-- en caso contrario Emitir mensaje que no cuenta con las 2 partes sociales.

	-- Si el tipo de ahorro es ordinario

	IF(Var_TipoProdCap = Aho_Ord)THEN

		SELECT	MAX(CuentaAhoID),	MAX(Saldo),	FechaApertura
		INTO	Var_CuentaAhoID,	Var_Saldo,	Var_FechaApertura
		FROM CUENTASAHO C INNER JOIN TIPOSCUENTAS T ON C.TipoCuentaID = T.TipoCuentaID
		WHERE	ClienteID		= Par_NoSocio
		AND	ClasificacionConta	= Aho_Ord
		AND C.Estatus = Est_Activo;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero)= Entero_Cero) THEN
			SET Par_NumErr 	:= 009;
			SET Par_ErrMen 	:= 'El socio no tiene una Cuenta de Ahorro Ordinario.';
			SET Var_Control	:= 'tipoRegistro';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_Saldo, Decimal_Cero) < Var_ImpMin) THEN
			SET Par_NumErr	:= 010;
			SET Par_ErrMen	:= 'El socio no cuenta con el ahorro minimo requerido.';
			SET Var_Control	:= 'tipoRegistro';
			LEAVE ManejoErrores;
		END IF;

	END IF;

	-- Si el tipo de ahorro es vista

	IF(Var_TipoProdCap = Aho_Vista)THEN

		SELECT	MAX(CuentaAhoID),	MAX(Saldo),	FechaApertura
		INTO	Var_CuentaAhoID,	Var_Saldo,	Var_FechaApertura
		FROM CUENTASAHO C INNER JOIN TIPOSCUENTAS T ON C.TipoCuentaID = T.TipoCuentaID
		WHERE	ClienteID		= Par_NoSocio
		AND	ClasificacionConta	= Aho_Vista
		AND C.Estatus = Est_Activo;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero)= Entero_Cero) THEN
			SET Par_NumErr 	:= 009;
			SET Par_ErrMen 	:= 'El socio no tiene una Cuenta de Ahorro Vista.';
			SET Var_Control	:= 'tipoRegistro';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_Saldo, Decimal_Cero) < Var_ImpMin) THEN
			SET Par_NumErr	:= 010;
			SET Par_ErrMen	:= 'El socio no cuenta con el ahorro minimo requerido.';
			SET Var_Control	:= 'tipoRegistro';
			LEAVE ManejoErrores;
		END IF;

	END IF;


	-- * Validar que el socio cuente con una antigüedad en la institución mínima de  meses,
	-- en caso contrario emitir mensaje que no cuenta con la antigüedad necesaria.

	SET Var_FechaAlta := IFNULL(Var_FechaAlta, Fecha_Vacia);

	IF( Var_FechaAlta > DATE_ADD(Var_FechaSistema, INTERVAL -(Var_Antigue) MONTH) ) THEN
	SET Par_NumErr	:= 011;
	SET Par_ErrMen	:= 'El socio No cuenta con la Antiguedad Necesaria.';
	SET Var_Control	:= 'tipoRegistro';
	LEAVE ManejoErrores;
	END IF;

	-- ************
	-- 	* Validar que durante los 12 meses anteriores al mes que se está realizando el registro que el socio  cuente
	-- con por lo menos 6 meses de ahorro, puede ser ahorro ordinario o vista, mismos que no necesariamente deberán ser
	-- continuos (monto mínimo por mes, no considerar los retiros).

	SET Var_Fechahis := (SELECT LAST_DAY( DATE_ADD((Var_FechaSistema), INTERVAL -13 MONTH) ) );

	IF (Var_ValGaranLiq = Var_SI) THEN

	-- -------------------SI SE VALIDA GARANTIA LIQUIDA EN EL ABONO A CUENTA------------------------
	-- SE GUARDAN LOS DATOS DE ABONO A CUENTA CON TIPO DE MOVIMIENTO 10.
		DROP TABLE IF EXISTS ABONOSCTA;
		CREATE TEMPORARY TABLE ABONOSCTA(
			CuentaAhoID       BIGINT,
			MontoMov	      DECIMAL(16,2),
			Fecha  			  DATE
		);

		INSERT INTO ABONOSCTA(CuentaAhoID,MontoMov,Fecha)
				SELECT mov.CuentaAhoID,SUM(mov.CantidadMov)AS MontoMes, mov.Fecha
				FROM `HIS-CUENAHOMOV` mov
				WHERE	mov.CuentaAhoID = Var_CuentaAhoID
					AND mov.Fecha	> Var_Fechahis
					AND mov.TipoMovAhoID = TipoMovAbono
				GROUP BY MONTH(mov.Fecha), mov.CuentaAhoID, mov.Fecha;

		SET Var_FechaLim := (SELECT DATE_FORMAT(Var_FechaSistema,'%Y-%m-01'));

		-- SE GUARDAN LOS DATOS DE BLOQUEDO DE CUENTA POR ABONO DE GARANTIA LIQUIDA.
		DROP TABLE IF EXISTS SALDOSBLOQ;
		CREATE TEMPORARY TABLE SALDOSBLOQ(
			CuentaAhoID       BIGINT,
			MontoMov	      DECIMAL(16,2),
			Fecha  			  DATE
		);


		INSERT INTO SALDOSBLOQ(CuentaAhoID,MontoMov,Fecha)
				SELECT b.CuentaAhoID, SUM(b.MontoBloq)AS MontoMes,b.FechaMov
				FROM BLOQUEOS b
				WHERE	b.CuentaAhoID = Var_CuentaAhoID
					AND b.FechaMov	> Var_Fechahis AND b.FechaMov < Var_FechaLim
					AND b.TiposBloqID = TipoBloq
					AND b.NatMovimiento= NatMovimiento
					AND b.FolioBloq = Entero_Cero
				GROUP BY MONTH(b.FechaMov), b.CuentaAhoID, b.FechaMov;


		-- SE GUARDAN LOS ABONOS NETOS DE LA CUENTA.
		DROP TABLE IF EXISTS ABONOSENELMES;
		CREATE TEMPORARY TABLE ABONOSENELMES(
			CuentaAhoID       BIGINT,
			MontoNeto	      DECIMAL(16,2),
			Fecha  			  DATE
		);


		INSERT INTO ABONOSENELMES(CuentaAhoID,MontoNeto,Fecha)
				SELECT b.CuentaAhoID, (b.MontoMov-(IFNULL(s.MontoMov,Entero_Cero)))AS MontoNeto,b.Fecha
				FROM ABONOSCTA b LEFT OUTER JOIN SALDOSBLOQ s ON b.CuentaAhoID=s.CuentaAhoID
				WHERE	b.CuentaAhoID = Var_CuentaAhoID
				GROUP BY MONTH(b.Fecha), b.CuentaAhoID, b.MontoMov, s.MontoMov, b.Fecha;


		SET Var_AbonosCons	:= (SELECT COUNT(MontoNeto)
							FROM ABONOSENELMES
							WHERE	CuentaAhoID = Var_CuentaAhoID
								AND MontoNeto >= Var_MontoAhoMes );

		IF(IFNULL(Var_AbonosCons, Entero_Cero) < Var_MesesEval) THEN
		SET Par_NumErr 	:= 012;
		SET Par_ErrMen 	:= 'El socio no cuenta con los meses de ahorro constante requeridos.';
		SET Var_Control	:= 'tipoRegistro';
		LEAVE ManejoErrores;
		END IF;

	DROP TABLE ABONOSCTA;
	DROP TABLE SALDOSBLOQ;
	DROP TABLE ABONOSENELMES;

	ELSE
	-- -----------NO VALIDA GARANTIA LIQUIDA EN EL OBONOS A CUENTA------------------------
	-- SE GUARDAN LOS DATOS DE ABONO A CUENTA CON TIPO DE MOVIMIENTO 10.
		DROP TABLE IF EXISTS ABONOSCTA;
		CREATE TEMPORARY TABLE ABONOSCTA(
			CuentaAhoID       BIGINT,
			MontoMov	      DECIMAL(16,2),
			Fecha  			  DATE
		);

		INSERT INTO ABONOSCTA(CuentaAhoID,MontoMov,Fecha)
				SELECT mov.CuentaAhoID,SUM(mov.CantidadMov)AS MontoMes, mov.Fecha
				FROM `HIS-CUENAHOMOV` mov
				WHERE	mov.CuentaAhoID = Var_CuentaAhoID
					AND mov.Fecha	> Var_Fechahis
					AND mov.TipoMovAhoID = TipoMovAbono
				GROUP BY MONTH(mov.Fecha),  mov.CuentaAhoID, mov.Fecha;


		SET Var_AbonosCons	:= (SELECT COUNT(MontoMov)
							FROM ABONOSCTA
							WHERE	CuentaAhoID = Var_CuentaAhoID
								AND MontoMov >= Var_MontoAhoMes );

		IF(IFNULL(Var_AbonosCons, Entero_Cero) < Var_MesesEval) THEN
		SET Par_NumErr 	:= 012;
		SET Par_ErrMen 	:= 'El socio no cuenta con los meses de ahorro constante requeridos.';
		SET Var_Control	:= 'tipoRegistro';
		LEAVE ManejoErrores;
		END IF;


		DROP TABLE ABONOSCTA;

	END IF;


	-- ************
	-- * Validar que en la fecha actual de la preinscripción el socio no tenga ni un día de atraso en sus créditos vigentes.
	IF(Var_ValCredAtras = Var_SI)THEN

		SET Var_FechaSalCre	:= (SELECT MAX(FechaCorte) FROM SALDOSCREDITOS);
		SET Var_NumAtrasos	:= (SELECT COUNT(Sal.CreditoID)
								FROM SALDOSCREDITOS Sal
									WHERE Sal.ClienteID = Par_NoSocio
										AND Sal.DiasAtraso > Entero_Cero
										AND Sal.FechaCorte = Var_FechaSalCre
										AND Sal.EstatusCredito = Est_Vigente);


		IF(IFNULL(Var_NumAtrasos, Entero_Cero) > Entero_Cero) THEN
			SET Par_NumErr 	:= 013;
			SET Par_ErrMen 	:= 'El socio tiene dias de atraso en su Credito.';
			SET Var_Control	:= 'tipoRegistro';
			LEAVE ManejoErrores;
		END IF;

	END IF; -- fin del if si se validan los dias de mora

END IF; -- fin de inscripcion o preinscripcion


-- ------------------------- FIN DE LAS VALIDACIONES---------------------------------------------

SET NumConvenIns:= (SELECT IFNULL(MAX(ConvenInsID),Entero_Cero) + 1
FROM CONVENSECINS);

SET Aud_FechaActual := CURRENT_TIMESTAMP();

SELECT FechaSistema INTO Var_FechaRegistro
FROM PARAMETROSSIS;


-- Si el numero de tarjeta viene vacio se setea con un valor vacio
SET Par_NoTarjeta := IFNULL(Par_NoTarjeta, Cadena_Vacia);


INSERT INTO CONVENSECINS (
	ConvenInsID,			NoTarjeta,				NoSocio,			NombreCompleto,			FechaRegistro,
	FechaAsamblea,			TipoRegistro,			SucursalID,			EmpresaID,				Usuario,
	FechaActual,			DireccionIP,			ProgramaID,			Sucursal,				NumTransaccion)

VALUES (
	NumConvenIns,			Par_NoTarjeta,			Par_NoSocio,		Par_NombreCompleto,		Var_FechaRegistro,
	Par_Fecha,				Par_TipoRegistro,		Par_SucursalID,		Par_EmpresaID,	   		Aud_Usuario,
	Aud_FechaActual,	   	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	   		Aud_NumTransaccion);

SET Par_NumErr := 000;
SET Par_ErrMen := CONCAT("Registro Agregado Exitosamente: ", CONVERT(NumConvenIns, CHAR));
SET Var_Control := 'tipoRegistro' ;
SET Var_Consecutivo := NumConvenIns;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
END IF;

END TerminaStore$$